Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8BD1E5B71;
	Mon, 23 Jun 2025 21:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713806; cv=none; b=WQWByXulY/l5PCZY6fXlDBHjRKmaBI10er2TRQTBFsG9dYYr4p0YUd+YgrJ0vO896mbR4jYnWyhVDB60uDeHWysdrRVZpd35rP70/iNNf4azYHMNY2MdRXb6iLDdkjs5iSC46qKqu1xgcesF9E5iSLvjpu44nxS1jgs1uMI/TrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713806; c=relaxed/simple;
	bh=60WXOnePn0R5sMHXq0mfY5YzwClIIYbt/9avyCRiTI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYMg5babR6bPpp/2UYd/SGlqSjvRR98/oZn5nm1SC556E+aYY90FdyrFNf1eIvwTwQoMdZKDVw04gdFSQhz0NlbmW3hwLTnZYJTiZe6sX+b4bAblmS57dyEfU7E8ye7F9brm50XxcolcLsACk/ybQ9OtSrZvIoIabXNy55xCWX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNkleaFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNkleaFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A13C4CEEA;
	Mon, 23 Jun 2025 21:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713805;
	bh=60WXOnePn0R5sMHXq0mfY5YzwClIIYbt/9avyCRiTI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNkleaFFCBAGGNTQGKjZwol0G8pk75/4penW7yw/YDLh68nR4523+/GFWn91xtSdS
	 JGYJ/xg1n9RKNUu81m1r6zGRZYKW/C2A+AsMgCga+rHV2tcUXIlQba7ZqnFTupJJdT
	 OF8lz2rPi4sdtIsfekBA8R/cckc19+veXEZR6o9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.10 187/355] ext4: ensure i_size is smaller than maxbytes
Date: Mon, 23 Jun 2025 15:06:28 +0200
Message-ID: <20250623130632.304865916@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4868,7 +4868,8 @@ struct inode *__ext4_iget(struct super_b
 		ei->i_file_acl |=
 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) << 32;
 	inode->i_size = ext4_isize(sb, raw_inode);
-	if ((size = i_size_read(inode)) < 0) {
+	size = i_size_read(inode);
+	if (size < 0 || size > ext4_get_maxbytes(inode)) {
 		ext4_error_inode(inode, function, line, 0,
 				 "iget: bad i_size value: %lld", size);
 		ret = -EFSCORRUPTED;


