Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F76A17541;
	Sat,  3 Feb 2024 04:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933928; cv=none; b=F8TtMaDD64bOEMHA/s1uIS/lWK7i1/jMFwMWAbiL5oxRfolngt6ImQdqQp+8cnGGZ09NHNV55HsjmNwbg0JjCPiYG1CUzqmfM8tmFaK5cKNKIjsXqMGXn0SNuaglBl1vxh+wLFZGQ+MJkI719/kPwL5B5y7XODtvlyoARcLoP2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933928; c=relaxed/simple;
	bh=t9gynKT+wbSWhHdNRBUSE+45tVHYs4R3atAmu1T6oOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nj5fFHjU+f6QP0b9CcCBvqwT9BBwwiTw/6WHjbkDGcBeigfiydo2+mFcEquuFZpj7Q5Y5jRw+1nYHu35kD57RkTigbvmxYIZ7gZTL1uaxV8+GhwRmeOAd0joytdtzNKeVlB6o4vqk72Ic3tbujnP5zS5iQgHkpecv8GH0ilZo3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTbzIJ/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTbzIJ/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A64C43399;
	Sat,  3 Feb 2024 04:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933927;
	bh=t9gynKT+wbSWhHdNRBUSE+45tVHYs4R3atAmu1T6oOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTbzIJ/0DYAB5tYNI+bKM6pNfFm5QE07EG377wA/Q1Fcnqh4JGJa0QuVtPb5lKkSi
	 2fTKsNlb1ybJnIFeuRmx1mqq+9VWreXFazGH/I/LwRYtc5+zQxkCkq0Mo7PwGAud/D
	 OEh4ja44jDyrO5MySxSEytUWAcCq3AxKnZkpSqrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 260/353] fs/kernfs/dir: obey S_ISGID
Date: Fri,  2 Feb 2024 20:06:18 -0800
Message-ID: <20240203035411.975576365@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



