Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EF7341645;
	Tue, 16 Dec 2025 11:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884340; cv=none; b=uUSxwUxidlzOes3zI2bJOOxDhbIyndqfZN+TTB/9xYTCcBykuA3DybzA6Aqqu7n01ji6FkRIodJsHRaVGhfQkMgI5uZInQjhJ0dyNmiKqc+SAfy627kM6tP/SyQrZ9t0CPW5bV0uCOZcnlETvoGHn9EmL9G5xpPTLzKzoNvTP/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884340; c=relaxed/simple;
	bh=xYrmLVJJGFuBTMJd4ezGGWnQyrQfDj988KFx33Nz4TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NTdKFAXEqLBJTXaiDAnugcpYtQuBn/u3FrHnk7/erGCN4hbwlkDvMDqAaXp3zYN/S6jvsodg/6aoJfCKqqTz7FkmiFQfXfQr9R6GJwdnAukDQDyIWkHVZYTBfh2mmIoaQATamXGQeks7WuWbUUIxSTN2EFJ6dRM2mw6SHyJU2to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0begbL+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0begbL+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFAAC4CEF1;
	Tue, 16 Dec 2025 11:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884339;
	bh=xYrmLVJJGFuBTMJd4ezGGWnQyrQfDj988KFx33Nz4TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0begbL+A7yEy1gAwzbiOXqqucLe7lQc/4664M74fNarNWWpRBgxm16IfwAtmwuVgY
	 2bqIyI5wTRLiBGRqzSPOyAo0ic9KbAclqNdYqmr42h+edgg1mfrTHnJ9tt79+biJAm
	 THNUlQBYiTAM6vKPM2tH3p4176pJ/AVZrBcpBZN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 163/354] ps3disk: use memcpy_{from,to}_bvec index
Date: Tue, 16 Dec 2025 12:12:10 +0100
Message-ID: <20251216111326.819737731@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 226ffc743238e..b5b00021fe37d 100644
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



