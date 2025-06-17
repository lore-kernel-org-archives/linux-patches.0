Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693422FA623;
	Tue, 17 Jun 2025 16:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179105; cv=none; b=afKjPfaKz4c4f+UtTaMhks54PgyQHb3IWWdjgfYxn9MYvvuEuR92xq1yan1DGbfrSnjZG3Y0laK9UcsbX6Ys7EcigZvk3LE7H5QiKp6i1rnCPQLpEqTp9S8aE7wf4kUyxa0fsA90K0JiPl++hmydJcoC7YvQT+QakB576bhOyhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179105; c=relaxed/simple;
	bh=nlofB6hSviRw9q5Lx32Qt96KQL/wMwoMf+TiNGPnH7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/G2IeFZ3iQg+Vw+y9ZIvPJxg2m8a6rMZt/je/RrhhqogaAb8ibQIno8ee22bSFYd+3/it1BaCMt79td3HO4sZ96JJ4N58HVHZJt+u/Ea1BI+m/FgnmUUNBn+ZqSnGlgBqk3RIFY5J9/Vad6iNT6rcwhLdG3nO4xl31FQVReI3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=waOwjsqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="waOwjsqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCABC4CEE3;
	Tue, 17 Jun 2025 16:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179105;
	bh=nlofB6hSviRw9q5Lx32Qt96KQL/wMwoMf+TiNGPnH7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=waOwjsqIcSUJAYviW/wNyQnNwWbYGAKhd5HxmnYl9x/Mr32cWntAJ1iNW4+0p8gOY
	 BMRzrb3Jxwb8PlCO+RqFEGaNAk66Dg7s21qoeNUb0Fo6p+ZZJ22Z9wgbOOss8Yz/sB
	 dHQJWTjTdM/RdI1MCrnbAvRwBZWlQ2IE5HqtBncw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 650/780] path_overmount(): avoid false negatives
Date: Tue, 17 Jun 2025 17:25:58 +0200
Message-ID: <20250617152517.949213556@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 5f31c549382bcddbbd754c72c5433b19420d485d ]

Holding namespace_sem is enough to make sure that result remains valid.
It is *not* enough to avoid false negatives from __lookup_mnt().  Mounts
can be unhashed outside of namespace_sem (stuck children getting detached
on final mntput() of lazy-umounted mount) and having an unrelated mount
removed from the hash chain while we traverse it may end up with false
negative from __lookup_mnt().  We need to sample and recheck the seqlock
component of mount_lock...

Bug predates the introduction of path_overmount() - it had come from
the code in finish_automount() that got abstracted into that helper.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Fixes: 26df6034fdb2 ("fix automount/automount race properly")
Fixes: 6ac392815628 ("fs: allow to mount beneath top mount")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 216807f772cd2..cb5126b06dcb9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3477,18 +3477,25 @@ static int do_set_group(struct path *from_path, struct path *to_path)
  * Check if path is overmounted, i.e., if there's a mount on top of
  * @path->mnt with @path->dentry as mountpoint.
  *
- * Context: This function expects namespace_lock() to be held.
+ * Context: namespace_sem must be held at least shared.
+ * MUST NOT be called under lock_mount_hash() (there one should just
+ * call __lookup_mnt() and check if it returns NULL).
  * Return: If path is overmounted true is returned, false if not.
  */
 static inline bool path_overmounted(const struct path *path)
 {
+	unsigned seq = read_seqbegin(&mount_lock);
+	bool no_child;
+
 	rcu_read_lock();
-	if (unlikely(__lookup_mnt(path->mnt, path->dentry))) {
-		rcu_read_unlock();
-		return true;
-	}
+	no_child = !__lookup_mnt(path->mnt, path->dentry);
 	rcu_read_unlock();
-	return false;
+	if (need_seqretry(&mount_lock, seq)) {
+		read_seqlock_excl(&mount_lock);
+		no_child = !__lookup_mnt(path->mnt, path->dentry);
+		read_sequnlock_excl(&mount_lock);
+	}
+	return unlikely(!no_child);
 }
 
 /**
-- 
2.39.5



