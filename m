Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C551A12B7E;
	Sat,  3 Feb 2024 04:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933671; cv=none; b=j2hvc567Ntlm6hTDhWML4Q/sg4qGPh3kJ/yGAm62lrssA+pD88S1MX+FORYtKO3fJ/8T3Z3F6WR0YUPbTwsgqWHx6GvcQVfGvuANlPSnAyJ1HHPKFoxSWm/kpYWL8QTY1gxRDk/Pj2Ej6aq8Mr2QJoAeLkshI0qi9UjYCeFxPIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933671; c=relaxed/simple;
	bh=Kp0TmxYu1RK+XAL5/qRbg4oUZjFHO2OTqtAW94+HW2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnUjJs4uVERvDYujn7O3bYswzJaU2T1IIBFj4fWrcqvoxGNbxoGaOG70543OtnT60MUWBzWBvbDMD8IX6ymn1EjX38Dkgw/KMxQt8ySluLpk3KutHw0jm0Q1fANqh5XejnD0XorOTDuxnp/6hjrTJh1fHU7U6BY6CjFMXadgmSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvQA1b9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvQA1b9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA3DC43390;
	Sat,  3 Feb 2024 04:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933671;
	bh=Kp0TmxYu1RK+XAL5/qRbg4oUZjFHO2OTqtAW94+HW2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvQA1b9HUZ2AHEhziSVZ++ln+rJlW0v3c7GBf3958Zolm0PARcjpd0OH9A9qQ5mCC
	 d6DPPraXIMCSYSAyhg0DGnnz1NQ3WNUvhPwQ165ktTobZTFuAmT5wMNj7dDB3fIFIl
	 llQbUwV3HzdRDSyRMTysXUsU9m1ALyuh7NqDkqpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 238/322] fs/kernfs/dir: obey S_ISGID
Date: Fri,  2 Feb 2024 20:05:35 -0800
Message-ID: <20240203035406.876423822@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 5133bee62f0ea5d4c316d503cc0040cac5637601 ]

Handling of S_ISGID is usually done by inode_init_owner() in all other
filesystems, but kernfs doesn't use that function.  In kernfs, struct
kernfs_node is the primary data structure, and struct inode is only
created from it on demand.  Therefore, inode_init_owner() can't be
used and we need to imitate its behavior.

S_ISGID support is useful for the cgroup filesystem; it allows
subtrees managed by an unprivileged process to retain a certain owner
gid, which then enables sharing access to the subtree with another
unprivileged process.

--
v1 -> v2: minor coding style fix (comment)

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20231208093310.297233-2-max.kellermann@ionos.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/dir.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 8b2bd65d70e7..62d39ecf0a46 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -676,6 +676,18 @@ struct kernfs_node *kernfs_new_node(struct kernfs_node *parent,
 {
 	struct kernfs_node *kn;
 
+	if (parent->mode & S_ISGID) {
+		/* this code block imitates inode_init_owner() for
+		 * kernfs
+		 */
+
+		if (parent->iattr)
+			gid = parent->iattr->ia_gid;
+
+		if (flags & KERNFS_DIR)
+			mode |= S_ISGID;
+	}
+
 	kn = __kernfs_new_node(kernfs_root(parent), parent,
 			       name, mode, uid, gid, flags);
 	if (kn) {
-- 
2.43.0



