Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C722756458;
	Thu, 13 Jun 2024 12:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281615; cv=none; b=ri4JJ8juxbTkf3/kz1OT5UhyncjiGrx/C+QXyNIUxbM7p13ONW9JMNT82gp77SRS8j6tRPlF0qW1ARJeIqD31WJ2YVzLSvZPxq1u7mgftX1J8FeadQVHZHmO9baeVEqRUuLFlgSlYNAlOTLjmHsm0iGBWns2TpANnjkVT+IGTxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281615; c=relaxed/simple;
	bh=9P1y8Bkt8VuIxHRPcFDzx3/tkc8cNKu+lKaxwabtXsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tY/puMKJM4+rQchtC02HJuZgEwDq9GQI2yco+KQPnbXZFPnA4Zbs1dAaEu4gxHYDzsR7660V+StKLSzDrRNf6+U5LVLkfSPx71lMKjwwgqKul2UvcvTOPR6/lJ8QnhuuxS0J3VTab8Ol3a1WhQiAd3ycLwMcHcZjodDjZNY1BGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iouHKXNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iouHKXNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510C0C2BBFC;
	Thu, 13 Jun 2024 12:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281615;
	bh=9P1y8Bkt8VuIxHRPcFDzx3/tkc8cNKu+lKaxwabtXsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iouHKXNo79hOQs/WBlVFVA6XPUnPv4AwQS6XV6pqoO6+30bdEtrfLBqAdrbkdvpDO
	 1QoySoYzwFVH1wxZI8Tv5wXbQFRz1ZSbqZ9/Cyzdv2Im/QFiKLUUFVQL5wUAkNmeHb
	 g89anjWZ8xDNtx5CESzvnAEP7q4ymNRLO0BACM/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <yuchao0@huawei.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 315/317] f2fs: compress: fix compression chksum
Date: Thu, 13 Jun 2024 13:35:33 +0200
Message-ID: <20240613113259.739346431@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <yuchao0@huawei.com>

commit 75e91c888989cf2df5c78b251b07de1f5052e30e upstream.

This patch addresses minor issues in compression chksum.

Fixes: b28f047b28c5 ("f2fs: compress: support chksum")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/compress.c | 3 +--
 fs/f2fs/compress.h | 0
 fs/f2fs/compress.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)
 create mode 100644 fs/f2fs/compress.h

--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -783,7 +783,7 @@ void f2fs_decompress_pages(struct bio *b
 
 	ret = cops->decompress_pages(dic);
 
-	if (!ret && fi->i_compress_flag & 1 << COMPRESS_CHKSUM) {
+	if (!ret && (fi->i_compress_flag & 1 << COMPRESS_CHKSUM)) {
 		u32 provided = le32_to_cpu(dic->cbuf->chksum);
 		u32 calculated = f2fs_crc32(sbi, dic->cbuf->cdata, dic->clen);
 
@@ -796,7 +796,6 @@ void f2fs_decompress_pages(struct bio *b
 					provided, calculated);
 			}
 			set_sbi_flag(sbi, SBI_NEED_FSCK);
-			WARN_ON_ONCE(1);
 		}
 	}
 


