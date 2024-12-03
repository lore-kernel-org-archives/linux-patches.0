Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4071F7558;
	Tue,  3 Dec 2024 15:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241296; cv=none; b=m1KAHOyKBzBjo9eF3yaa6J+/uu+XtGSfelAIDJw202d0tFQVR5VxVNE/7F/zCTiR3pI1PVj+jKCJpOjXQMzW6y/spmG6WFzShrWkbYrT5cukWHGgEyv/mfqFKJMKYFB3anIaKZjyEwPpevQK3EwOdOhJn8CGMMtuOavG+VNr5Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241296; c=relaxed/simple;
	bh=dMTEtH/DULoRtGHxpfACQ7u5CYicdhMBiQcC+7gYVtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOHZXJ91U3YK/GEzORv+LuX9tqFVczHEF+p9WH762Hzgj5RG8UGoof8yblxa0DVg3FU6lvm28SvgGDAP7l28c/c2EdSvWjOSvl5j/OqpT8PxMNcmYqjNss6n8tDDniBRX+x+BytAFNesolrKsATS9FMGsstYLDX36hZY7s0Plsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFVqo7hh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFVqo7hh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF668C4CEE1;
	Tue,  3 Dec 2024 15:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241296;
	bh=dMTEtH/DULoRtGHxpfACQ7u5CYicdhMBiQcC+7gYVtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFVqo7hhFcneos3UjndcOtRjFTYeL0Kzf6fOOsivGxeBQh1eX3Bq1XdqNZtv0S5Ok
	 roQ8iWlX7OBO+IH0vhEbDezfNEtuTKZvqd2dyujyCDOcyfteq7TFPHAWCNAwJLE1Xa
	 s3McfWb9k2k7kqc71xM4woS0eLzxXvfV6NjRIvsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongzhen Luo <hongzhen@linux.alibaba.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 348/826] erofs: fix blksize < PAGE_SIZE for file-backed mounts
Date: Tue,  3 Dec 2024 15:41:15 +0100
Message-ID: <20241203144757.339554107@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongzhen Luo <hongzhen@linux.alibaba.com>

[ Upstream commit bae0854160939a64a092516ff1b2f221402b843b ]

Adjust sb->s_blocksize{,_bits} directly for file-backed
mounts when the fs block size is smaller than PAGE_SIZE.

Previously, EROFS used sb_set_blocksize(), which caused
a panic if bdev-backed mounts is not used.

Fixes: fb176750266a ("erofs: add file-backed mount support")
Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241015103836.3757438-1-hongzhen@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index bed3dbe5b7cb8..2dd7d819572f4 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -631,7 +631,11 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 			errorfc(fc, "unsupported blksize for fscache mode");
 			return -EINVAL;
 		}
-		if (!sb_set_blocksize(sb, 1 << sbi->blkszbits)) {
+
+		if (erofs_is_fileio_mode(sbi)) {
+			sb->s_blocksize = 1 << sbi->blkszbits;
+			sb->s_blocksize_bits = sbi->blkszbits;
+		} else if (!sb_set_blocksize(sb, 1 << sbi->blkszbits)) {
 			errorfc(fc, "failed to set erofs blksize");
 			return -EINVAL;
 		}
-- 
2.43.0



