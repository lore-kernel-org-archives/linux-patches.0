Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04528352F95;
	Tue, 16 Dec 2025 11:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885777; cv=none; b=CoiVxvH6/5js84yKQkKqAQRKmn6Bq24jlbtsw4Kt4GSzizhPTLtLf9BC1vHd8oYdRNZyefRXX00SiajaNcamDgdoki8i/3s5K73ItTaiBmmX3vCAIKnLb3MbNVBWNx1FY+sXg5NdkDVh5n1sJ/ZWa3SUADtROgvgDok6oJ9ylL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885777; c=relaxed/simple;
	bh=5r1eKUKehnGIc+B8/xyonBSR5RjKqsn3ZKesrBnP/tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YmbrFfaGFZUn6hIwSZth0WNlEuB6MaKg72igUNOSNZlApCcyieS4waAZb29rL7qjiEa/FNV6URSd6vjRnhjPjnvABmDTCEogDKb1AP46zKS0yWtu9qe+qBex7Fxw2AeWnDugaBC/fLgI4mEmlwzuwopoX8bjCGBPlFAdXDNVqWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJlBoohV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJlBoohV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B48AC16AAE;
	Tue, 16 Dec 2025 11:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885776;
	bh=5r1eKUKehnGIc+B8/xyonBSR5RjKqsn3ZKesrBnP/tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJlBoohVhwwGr5zb+Bbp1dKulPQEaPtvz6Z7PxbfEb/wsUjAmqOiojKTNbeFmEW6y
	 lXjUob2uAXHPHbFCD3CxSnlYTG2RQPDtNdJq614lTVH/79NgKpQS0sjeF8rBHsI8oJ
	 kkFtqlMzw5zGpTKVdj1xCqxS8jAMsZc8EE828/zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 240/507] ps3disk: use memcpy_{from,to}_bvec index
Date: Tue, 16 Dec 2025 12:11:21 +0100
Message-ID: <20251216111354.193239626@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



