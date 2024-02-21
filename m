Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBFD69317;
	Wed, 21 Feb 2024 14:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525415; cv=none; b=Bq/2iX0Ce1FpbaErAl+5bZ2VfXSiYQ7K3vZtkhrHRPjtIcD/3x1Ms+yTuqG5rdF4gDYx9k2d/bWQjF3wyuNHnuVF6876iLZv4tEoUMREuCf263wbPNJryKHKKOTI6eC2N2OCEFfa9QFjAytn/uINfnhxP2of/ZWxEkz9HUuw+nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525415; c=relaxed/simple;
	bh=rtaJL8zl/dj5TjDAj+CYLPeTeyFu1fJQMwOXrNwzQDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgXEI8Fz5wbZzkttXF9AhXd2qPZuSLNDQL7JXz7I7F6WDJc34xHhdxuZfJ5NX2zLdzEzTnNx9klpOOgtB0Wzn3f6Nd8iYEoe3dUMfoOP0QJxxdvvKpL2JZH3WAnVujhHDxeRsKHeIt1SddgDTMDbCJI28FztLb66iDvc8PmKl+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvbILqbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvbILqbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF8EC433C7;
	Wed, 21 Feb 2024 14:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525414;
	bh=rtaJL8zl/dj5TjDAj+CYLPeTeyFu1fJQMwOXrNwzQDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvbILqbcNJBaFURmgk/Ea30vlXTRyv4Wl1FG2o/cJKrw3jM6WI+M6fSN6G6mDdOMl
	 dXPhdqJNB2hJUol2XCC+aNHxfmrIjfun6X2QJH6pwPfJ0fEcpZA8L0fawAKTh1FPDn
	 k1Row9xcx0LNoVafDS3p0S6+4IFXxzPsBY6CR7wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 149/267] fs/kernfs/dir: obey S_ISGID
Date: Wed, 21 Feb 2024 14:08:10 +0100
Message-ID: <20240221125944.738976932@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d2068566c0b8..d3a602ea795b 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -702,6 +702,18 @@ struct kernfs_node *kernfs_new_node(struct kernfs_node *parent,
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



