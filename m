Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C22F221FDC;
	Mon, 23 Jun 2025 21:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713383; cv=none; b=sC4PEzfcxHefX6EXFfVuTSa22aHU/N4Gtl+t2BTQvUvDgFysjYSVKHmoYCxRqcD37QpuQad4x6bTyAsx6JSRmowW14b9K/AmQAwagmKY0knZtU4Y96BKwspEzNta4x/IjRhHOshcMKrY9oaVf3EZhp//BbeKxaPBmV+UhIh30/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713383; c=relaxed/simple;
	bh=pxJMxhLxYTSzgSFO4LKvgO1VNDkysLnysbuWt5tfhyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXUSqhjUYVlUGviGPwK6BLPRcleTbQBVvbW3ksJSSzA2nqZJVY8kDasr68CPkzOp/l8bZxjd8XUfqMKMt4ZxU7L1nd6fGqluuQann7KdRbpNhYUcFL5gy0Zy5hXbBHCRMiY1niFhfpCFPB4x0B8CSRnbkLCPt5m0FcK1Eu2h1R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YyK9ddor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YyK9ddor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BFFC4CEEA;
	Mon, 23 Jun 2025 21:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713382;
	bh=pxJMxhLxYTSzgSFO4LKvgO1VNDkysLnysbuWt5tfhyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YyK9ddor0EG6X/CsmwBeEt0NAdT9tFjtikq1c73ylU5WlikUXW/QGUF2knqyyr0UI
	 OFaUzI5xZOE3JDTDSZrSItJjgGxENc+ER3FgbxicQpq7bRma5cn+2S2zpkb48nOc9m
	 iid33++tksbhuFTKRtjKTGSvKWSbJTkfHR3O5fU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 063/290] ext4: ensure i_size is smaller than maxbytes
Date: Mon, 23 Jun 2025 15:05:24 +0200
Message-ID: <20250623130628.900335405@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4939,7 +4939,8 @@ struct inode *__ext4_iget(struct super_b
 		ei->i_file_acl |=
 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) << 32;
 	inode->i_size = ext4_isize(sb, raw_inode);
-	if ((size = i_size_read(inode)) < 0) {
+	size = i_size_read(inode);
+	if (size < 0 || size > ext4_get_maxbytes(inode)) {
 		ext4_error_inode(inode, function, line, 0,
 				 "iget: bad i_size value: %lld", size);
 		ret = -EFSCORRUPTED;


