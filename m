Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2098535A948;
	Fri,  9 Jan 2026 12:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961309; cv=none; b=pq4See2hxbFizPYz2QqMM4ViZjhx5nEuyrHHoltq+z8w7d9l1jv9Uk9u2wsnBtYIAqEoGd7XctUtI4HnkZPaMRxs6IZvhSGiiuJaCHy/LN6rqJzQ0N0m+M6v/lkUvLIqFUiFmCB7cQiJUszTy2+mUTdQsMIWuKucoW09Op3eX3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961309; c=relaxed/simple;
	bh=SA+iJc+3ee93QYk010eDkeYsV9QR1srbhxXr+Olwt50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WCkFJmV/tQ2ecjTaxx0zczfSwMIiBvxKNQtCyeL6mTwm5vZesrdq9AscL71NxzeBA8aYqkK6ewdtLdJ4+McioRg7qL8sITulSBAn+PwxF6b58R4KpZrZ55LnUG1ETHSeE7q0uf/bgZP16uylBGcOfVXLvLKrjFliIJT/d+Wq5W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ik+/+l4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ik+/+l4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0851FC4CEF1;
	Fri,  9 Jan 2026 12:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961308;
	bh=SA+iJc+3ee93QYk010eDkeYsV9QR1srbhxXr+Olwt50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ik+/+l4HbnAQTPYHpHftMulAohDmYX/yXWeSVp/ojbCCs1Imp/po1OlygBAbRqjZt
	 4Gob1ez8KwMzq8ylWQ11REIPDfC4Dq4VQNjIxTUu45DRA59SXWak4PG5BEve3X614f
	 ukcOad4L3qOv/UaRdBMFOXPvqitVSRzcDX1MAIbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	=?UTF-8?q?David=20Nystr=C3=B6m?= <david.nystrom@est.tech>
Subject: [PATCH 6.6 676/737] ext4: introduce ITAIL helper
Date: Fri,  9 Jan 2026 12:43:35 +0100
Message-ID: <20260109112159.480755324@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 69f3a3039b0d0003de008659cafd5a1eaaa0a7a4 ]

Introduce ITAIL helper to get the bound of xattr in inode.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250208063141.1539283-2-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: David Nyström <david.nystrom@est.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |   10 +++++-----
 fs/ext4/xattr.h |    3 +++
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -653,7 +653,7 @@ ext4_xattr_ibody_get(struct inode *inode
 		return error;
 	raw_inode = ext4_raw_inode(&iloc);
 	header = IHDR(inode, raw_inode);
-	end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
+	end = ITAIL(inode, raw_inode);
 	error = xattr_check_inode(inode, header, end);
 	if (error)
 		goto cleanup;
@@ -797,7 +797,7 @@ ext4_xattr_ibody_list(struct dentry *den
 		return error;
 	raw_inode = ext4_raw_inode(&iloc);
 	header = IHDR(inode, raw_inode);
-	end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
+	end = ITAIL(inode, raw_inode);
 	error = xattr_check_inode(inode, header, end);
 	if (error)
 		goto cleanup;
@@ -883,7 +883,7 @@ int ext4_get_inode_usage(struct inode *i
 			goto out;
 		raw_inode = ext4_raw_inode(&iloc);
 		header = IHDR(inode, raw_inode);
-		end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
+		end = ITAIL(inode, raw_inode);
 		ret = xattr_check_inode(inode, header, end);
 		if (ret)
 			goto out;
@@ -2248,7 +2248,7 @@ int ext4_xattr_ibody_find(struct inode *
 	header = IHDR(inode, raw_inode);
 	is->s.base = is->s.first = IFIRST(header);
 	is->s.here = is->s.first;
-	is->s.end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
+	is->s.end = ITAIL(inode, raw_inode);
 	if (ext4_test_inode_state(inode, EXT4_STATE_XATTR)) {
 		error = xattr_check_inode(inode, header, is->s.end);
 		if (error)
@@ -2799,7 +2799,7 @@ retry:
 	 */
 
 	base = IFIRST(header);
-	end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
+	end = ITAIL(inode, raw_inode);
 	min_offs = end - base;
 	total_ino = sizeof(struct ext4_xattr_ibody_header) + sizeof(u32);
 
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -68,6 +68,9 @@ struct ext4_xattr_entry {
 		((void *)raw_inode + \
 		EXT4_GOOD_OLD_INODE_SIZE + \
 		EXT4_I(inode)->i_extra_isize))
+#define ITAIL(inode, raw_inode) \
+	((void *)(raw_inode) + \
+	 EXT4_SB((inode)->i_sb)->s_inode_size)
 #define IFIRST(hdr) ((struct ext4_xattr_entry *)((hdr)+1))
 
 /*


