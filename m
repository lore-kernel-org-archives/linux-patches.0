Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76629C2E0;
	Mon, 23 Jun 2025 21:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714316; cv=none; b=Kso43NIUTg2Qq1dCxqKVmRt6Ys0HG4DN78y9IwkkH7JUv+15nO8//QcS01HnmI+vNJQh2UTm7KiOr4A6vmyNj/pqZ0vFBLvD3Pv3HBX2t5ZVokrrdNAHmmziAiwtkz+gCwOn7BsCz7ySXDwazDI51HqYax2o1Gf1wcm3mVhM220=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714316; c=relaxed/simple;
	bh=Na1C4K6MP38UGtChRgsaIFfOnJxWG5rMyAuy0thpn2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeRqf8v04UU6fMJbXBfgwDMD8ECSmUFQDCX+r2CfyJlA+eWoO5eRd/TZTDmVzufGm2JcoxuIamThoWQ4Zb2cN9Ez0exrkSaYuhDZRf9m44IOD9kjj9KhK6nPFiwpFDzAoAo1ks3zlmxTtdW3TcDoSdjCtTmD1PCBhgiw/haalHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tvy51gZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tvy51gZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C34BC4CEEA;
	Mon, 23 Jun 2025 21:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714316;
	bh=Na1C4K6MP38UGtChRgsaIFfOnJxWG5rMyAuy0thpn2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tvy51gZUVMJH/Atwrj9JqB2Dv6C/sh9CmQAdpoasQZUtPJ6Xol5gql+E0MHgxOaps
	 tmKap5itPFD2J+BlCrRW0VuLGyESLYkIv15VAYAgVS1VVrEFjXyq1UmY0Bz3WbS1is
	 3EZUb4OE7Wm0MYQAfmKMgVidv2zd4WRwCoh7npbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.12 095/414] ext4: ensure i_size is smaller than maxbytes
Date: Mon, 23 Jun 2025 15:03:52 +0200
Message-ID: <20250623130644.468288773@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit 1a77a028a392fab66dd637cdfac3f888450d00af upstream.

The inode i_size cannot be larger than maxbytes, check it while loading
inode from the disk.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Link: https://patch.msgid.link/20250506012009.3896990-4-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4928,7 +4928,8 @@ struct inode *__ext4_iget(struct super_b
 		ei->i_file_acl |=
 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) << 32;
 	inode->i_size = ext4_isize(sb, raw_inode);
-	if ((size = i_size_read(inode)) < 0) {
+	size = i_size_read(inode);
+	if (size < 0 || size > ext4_get_maxbytes(inode)) {
 		ext4_error_inode(inode, function, line, 0,
 				 "iget: bad i_size value: %lld", size);
 		ret = -EFSCORRUPTED;


