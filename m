Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F91324DFF3;
	Mon, 23 Jun 2025 13:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684756; cv=none; b=uKyaJNxSp6GJzx83Ov0UPFWwaUnJAafUbJaFkSQ4lTe8876HP4Dky1p7CRIl5geB83qIh7FyrwzHWia1P6tes4Hg/8V3NHpHXz1j5p+1AvmFqAdWeITR+W8oYFtORMFWFgdeKMhVjcb/6AIjfO1OhnO2wAIwrYBnm/ZMd/C9/14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684756; c=relaxed/simple;
	bh=NueB2x7xpuNZcAlImugODigh8PWteU5465/o2XGIxnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0pTmKZ/SBiNwiV3hdS7vi6Xb0fJxmGGoct0tcddRO7dWA/ampYdG4l7+aWghIFWeVeRl+4e52fWHrBbkcD5pGxfS4g32VAgiwWH4QxySTani+xXbcYNFHqnGu8d4eLlC+igOovfvxQEQ0i1jq7zWg6uLUbEhdLV4CJlJBI9Qts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwtVAAK/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwtVAAK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E803EC4CEEA;
	Mon, 23 Jun 2025 13:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684756;
	bh=NueB2x7xpuNZcAlImugODigh8PWteU5465/o2XGIxnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwtVAAK/ezQ9203XZWEkqBaQ0px78h92a3+1auCsKgc8RuJMqEMTT1OnaR1pKp7rN
	 fdsZFRqposnKKjffSGDiD4DjIIADx9yjhM8YWbFGie1bTAtAQ86qCmHv8cQQmYcy/+
	 3ubNLtO+t0MPRNkDONte4t+bV+esoVP65dXJG+7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.15 117/592] ext4: ensure i_size is smaller than maxbytes
Date: Mon, 23 Jun 2025 15:01:15 +0200
Message-ID: <20250623130703.055553996@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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
@@ -4922,7 +4922,8 @@ struct inode *__ext4_iget(struct super_b
 		ei->i_file_acl |=
 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) << 32;
 	inode->i_size = ext4_isize(sb, raw_inode);
-	if ((size = i_size_read(inode)) < 0) {
+	size = i_size_read(inode);
+	if (size < 0 || size > ext4_get_maxbytes(inode)) {
 		ext4_error_inode(inode, function, line, 0,
 				 "iget: bad i_size value: %lld", size);
 		ret = -EFSCORRUPTED;


