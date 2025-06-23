Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6447B221FC7;
	Mon, 23 Jun 2025 21:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714797; cv=none; b=spjtpPXC0FF0dWggbuDbAmetnv1qPGxQudTUBzt3D9pmGJ0JJthkrXugOJLszSwU4KoTcflqIndre69wNR9mRmHSrYwCl/x4sD9dSL+SZZ0eh1blD1/6nxxfePXacEIS/NGZnshcZuMetsb74YzO6MSkRw4cVazBPtcFUigizDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714797; c=relaxed/simple;
	bh=lzO5t60tP/ZPLbdB4KPUCZ5OFBmWxFddo1EmWOkGTBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e19OTFkpW3ZQfsg08sqrZ62Mh4qF60UnCnVu9qUEBJhVKtHQ1F9yiojABDm+PSm/wMvkPxiyf+25F6Oow51ob46TFqnOOi/af+U+lBYiaH68wnUx5tm4jvCFtk0ydG3teFgJvQG2Jx3M8SRWEY+AP7+C1sAJemvJYI2dL7LlkBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1ZCTd71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1ZCTd71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAE4C4CEEA;
	Mon, 23 Jun 2025 21:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714797;
	bh=lzO5t60tP/ZPLbdB4KPUCZ5OFBmWxFddo1EmWOkGTBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1ZCTd71yePWJxsZs6jl4kfQKNG1S94RiVB8m/BiPXhYwC8W5JVP09E/sHQPGYiV4
	 6GUigQ7900p0zKAcyLhsVH7k9EvSjsgReHZN6h3BW7KKUi7XWPaKoiyNYarTPb96IU
	 r+LAcEyyytqkfo6XMLy3i8HPkb40NQY9SLQKE0Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.15 230/411] ext4: ensure i_size is smaller than maxbytes
Date: Mon, 23 Jun 2025 15:06:14 +0200
Message-ID: <20250623130639.449807147@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4785,7 +4785,8 @@ struct inode *__ext4_iget(struct super_b
 		ei->i_file_acl |=
 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) << 32;
 	inode->i_size = ext4_isize(sb, raw_inode);
-	if ((size = i_size_read(inode)) < 0) {
+	size = i_size_read(inode);
+	if (size < 0 || size > ext4_get_maxbytes(inode)) {
 		ext4_error_inode(inode, function, line, 0,
 				 "iget: bad i_size value: %lld", size);
 		ret = -EFSCORRUPTED;


