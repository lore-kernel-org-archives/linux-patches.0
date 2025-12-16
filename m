Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A622434A77D;
	Tue, 16 Dec 2025 12:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887619; cv=none; b=i0wQScjriNjIfDsu+mcm1jDUBlkHKVht1AeQ6rX1hLamezMXghFlJ2WmGkYo4IdVvBZky2K8KRBB9XWNze9w/ZFpgfJ790/N6BCGBhDrcObdf4EGLnN6yunCgH6APozELJf1cWVxYt29cGjVxfaHHseISzdUapb5jTe4SMTci/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887619; c=relaxed/simple;
	bh=RQTI+uUAurHlv88I7cRSzyM2lMwWwzNiLnNVT3xsNZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QXT2gJJSTESDLSkJKZLukI6jmyebsBfxOkg9kT1zDvI8a1/DDvFw87bvulxvGA5jOOBsekhdJfbgnbvrc9gXy+CZIUo/REe9EjAWceALWeObmO4NqrwOv5byysR2KGiUpkrxfYP8JcWlPGGfirzrniSMGKfS2OmKLPi1e4BJiuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uumknY8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uumknY8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49DBC4CEF1;
	Tue, 16 Dec 2025 12:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887619;
	bh=RQTI+uUAurHlv88I7cRSzyM2lMwWwzNiLnNVT3xsNZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uumknY8XRk4SlJnoM8XXB3viz6js8lKyrsp01NBMUnaMGRqqxRhzljeQ9nnWBTH4p
	 TMcmN01t0SUz59SARxaJ3dCwM/kDiccdZBasCY/rsaTL9IkMVCNNCS3rthMBVqQL1R
	 crcYVfGJSQ2UYox0Ed6orzk9STd5Ya3MChZVyJJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 287/614] ps3disk: use memcpy_{from,to}_bvec index
Date: Tue, 16 Dec 2025 12:10:54 +0100
Message-ID: <20251216111411.769451313@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rene Rebe <rene@exactco.de>

[ Upstream commit 79bd8c9814a273fa7ba43399e1c07adec3fc95db ]

With 6e0a48552b8c (ps3disk: use memcpy_{from,to}_bvec) converting
ps3disk to new bvec helpers, incrementing the offset was accidently
lost, corrupting consecutive buffers. Restore index for non-corrupted
data transfers.

Fixes: 6e0a48552b8c (ps3disk: use memcpy_{from,to}_bvec)
Signed-off-by: René Rebe <rene@exactco.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ps3disk.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index dc9e4a14b8854..8892f218a8147 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -85,10 +85,14 @@ static void ps3disk_scatter_gather(struct ps3_storage_device *dev,
 	struct bio_vec bvec;
 
 	rq_for_each_segment(bvec, req, iter) {
+		dev_dbg(&dev->sbd.core, "%s:%u: %u sectors from %llu\n",
+			__func__, __LINE__, bio_sectors(iter.bio),
+			iter.bio->bi_iter.bi_sector);
 		if (gather)
 			memcpy_from_bvec(dev->bounce_buf + offset, &bvec);
 		else
 			memcpy_to_bvec(&bvec, dev->bounce_buf + offset);
+		offset += bvec.bv_len;
 	}
 }
 
-- 
2.51.0



