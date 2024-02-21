Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3C63C2F;
	Wed, 21 Feb 2024 13:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522779; cv=none; b=XwCBXuS8Tz1x0X3Na1sKXz5zbltMar/c5Pf66yRdq2w1D/xwTqMNpVLLfTFXT26iALXIJpqoy74RDnlAh+ArNcIQBZa9vLX+iBhXGxBwI0dAjL3fKGpMWUphW/QwFj0hmQwmuZRCHPudWIHosYohNqftFeEStVHpr65jDdCoKBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522779; c=relaxed/simple;
	bh=pCN7JT37eNeqcmtebZflPCGDRsRC8U8HjT3HmImNT8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jE+WsSAzGaW5B0NZsyIaujpoQTtZd7PDaItxu8A2tBnSIYFAj/O2G+U+GWe09s9wev6uD8BqPWkWs0wPAM5X+UHOKxFufT7hEGvad4AsLyWyY1DToT6q9tmEKw38V+LEIsicextbcxf9BjN2m17FDotiydjnu2GaNTcbYPq53YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7PR7yT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7PR7yT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D2EC43390;
	Wed, 21 Feb 2024 13:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522779;
	bh=pCN7JT37eNeqcmtebZflPCGDRsRC8U8HjT3HmImNT8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7PR7yT+SGJkTJM2JSJa0lMH1KeLJht+gDeDfc8oAMgWKGN1anmnQLV4CtoHvr5EF
	 5ub6EJXiA+E22311WpNeB8U93Idrc9Or0xTspLjM2XOnLTMrCSvfbKeg4FDG6aK254
	 H5mB7LUTnvn8i9Y9VnfD3kIgj9DlJHBg0LcYrdJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 255/476] fs/kernfs/dir: obey S_ISGID
Date: Wed, 21 Feb 2024 14:05:06 +0100
Message-ID: <20240221130017.275677601@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6a1cb2a182b6..36430bdf9381 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -654,6 +654,18 @@ struct kernfs_node *kernfs_new_node(struct kernfs_node *parent,
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



