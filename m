Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3F719B5BE;
	Thu, 25 Jul 2024 14:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918451; cv=none; b=UXFwwQTPN/RvEZZCPlFpXjz2YlEUAAgNgBP/ulhOsKKM1CfRJw4Pisc6bq/nQ2aEt8QDqrvKA5EQJ1WONq6+5LGDMs354u6W/O8O1VTL/R9UwgubE0ICR0eVug+sn/eo9bSTD+UQh/tYA5LzsA64WhcCwa7W58TrA6O+2amBChY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918451; c=relaxed/simple;
	bh=OjCDkc1jzmGEAM9go17T82EYP6ET3zt3iwA1z3iGplw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llwZCJe59m4ZL1jWfM+7kUtapjRLU5xA0/vfGnTPX41ifN4Y+d/pyLrd+TC5PqsPMHYyJof+zj8KIX7LoGmPNh5j+XcSjzIfx4GbisJc70LXCNwYuwxWBjxFrdbjJ0EUZQ9BpyEkwp3nmYcNvXUVkI4OPEOjsWa3RRLg9to04kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vu4C++HZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vu4C++HZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71CDC116B1;
	Thu, 25 Jul 2024 14:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918451;
	bh=OjCDkc1jzmGEAM9go17T82EYP6ET3zt3iwA1z3iGplw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vu4C++HZusKN2xZ0AhO9mWceN2E4hG3QnAnJn8SCmkTXdpkm1ZVg//3/xc5O/iYm4
	 3Dy4P8d3bAlzm2zT73tUFduLHi9JM+s1exWgjY/TQpCW1x3tBGlif+sGJ1HhIsxnCt
	 sAx8v6+oNYX1438GaEtdN0zDvB9Hm4N0G4SH4Wik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/33] fs: better handle deep ancestor chains in is_subdir()
Date: Thu, 25 Jul 2024 16:36:46 +0200
Message-ID: <20240725142729.390475028@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 4d96eb591f5d9..93671238abce1 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3003,28 +3003,25 @@ EXPORT_SYMBOL(d_splice_alias);
   
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



