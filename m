Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC1E1586CB;
	Tue, 23 Jul 2024 18:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759359; cv=none; b=TSE0kDxQ0jAEVchbV7RU06o9x0tOaa+Ytr3W51MHO7qcFx7E2uPSJLrV+rX6N5OsWf4txZZxmKVfp73KTmxrYTAXVZ5N6G62VqlF1n16bwnP16jNNeKQVURJaPLNjSj97pD7JLzUhYBukzdA/pDd070o6xy+SuvtAD/wXXvLCDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759359; c=relaxed/simple;
	bh=N7n8MZe5gwronhiL6z+oCY74Q7dIFalB028CQwQnitY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BeuB5ZwjbNszkrgRV/9rrcNVcCGFg1/e5MvLH145fKkr7ywBOaEiU23oVB04CrXXpf6e0YPGS6fuX2rzbe59Cc/bgstjK086vscaOSudxh4KwCSr/ZbVqANDY7PUMoUG4cSoHv9EAtnQ6OMyK6jy4dXXoLb7Fn8Z2F0pndbQXGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dq8/FrZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dq8/FrZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE7CC4AF0A;
	Tue, 23 Jul 2024 18:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759359;
	bh=N7n8MZe5gwronhiL6z+oCY74Q7dIFalB028CQwQnitY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dq8/FrZVfK6UPtUA0ngJDzqZcLtS9mvEajYJ7GD9v4I6zx7ho7ZnZMzSsJXfbbk6h
	 OuxtlDSywkQn9PPSQLflitn2QIskubmEI2bfuK+oeoDEFhFy2zIOi6V2Wy65J7GHEW
	 j4tenI1ZA942jWHSu9doYCLA2GqaSPMiIkcMoaRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/105] fs: better handle deep ancestor chains in is_subdir()
Date: Tue, 23 Jul 2024 20:24:05 +0200
Message-ID: <20240723180406.635154480@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 391b59b045004d5b985d033263ccba3e941a7740 ]

Jan reported that 'cd ..' may take a long time in deep directory
hierarchies under a bind-mount. If concurrent renames happen it is
possible to livelock in is_subdir() because it will keep retrying.

Change is_subdir() from simply retrying over and over to retry once and
then acquire the rename lock to handle deep ancestor chains better. The
list of alternatives to this approach were less then pleasant. Change
the scope of rcu lock to cover the whole walk while at it.

A big thanks to Jan and Linus. Both Jan and Linus had proposed
effectively the same thing just that one version ended up being slightly
more elegant.

Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 04f32dc8d1ad8..49461353ac37b 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3209,28 +3209,25 @@ EXPORT_SYMBOL(d_splice_alias);
   
 bool is_subdir(struct dentry *new_dentry, struct dentry *old_dentry)
 {
-	bool result;
+	bool subdir;
 	unsigned seq;
 
 	if (new_dentry == old_dentry)
 		return true;
 
-	do {
-		/* for restarting inner loop in case of seq retry */
-		seq = read_seqbegin(&rename_lock);
-		/*
-		 * Need rcu_readlock to protect against the d_parent trashing
-		 * due to d_move
-		 */
-		rcu_read_lock();
-		if (d_ancestor(old_dentry, new_dentry))
-			result = true;
-		else
-			result = false;
-		rcu_read_unlock();
-	} while (read_seqretry(&rename_lock, seq));
-
-	return result;
+	/* Access d_parent under rcu as d_move() may change it. */
+	rcu_read_lock();
+	seq = read_seqbegin(&rename_lock);
+	subdir = d_ancestor(old_dentry, new_dentry);
+	 /* Try lockless once... */
+	if (read_seqretry(&rename_lock, seq)) {
+		/* ...else acquire lock for progress even on deep chains. */
+		read_seqlock_excl(&rename_lock);
+		subdir = d_ancestor(old_dentry, new_dentry);
+		read_sequnlock_excl(&rename_lock);
+	}
+	rcu_read_unlock();
+	return subdir;
 }
 EXPORT_SYMBOL(is_subdir);
 
-- 
2.43.0



