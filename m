Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1540432FA3D;
	Fri,  9 Jan 2026 11:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959735; cv=none; b=qCYJIfq9Hc8ReHYzox049UeWVYAiKPYgNQbhtItlYdcObuNW8nO/ZYtPzb1xaijDv+HDqLVJY95m09Lx13wTzrpwKsfGyQxpWqUrBcFiEYjohOPkYVIuHhM9t2pDgbkCdxDPDfLmXIowVXBXf2cMupovR5TlfScYyrsGp1IrDtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959735; c=relaxed/simple;
	bh=06BStZZTO3EhlDkOGQX1+4kKNIMDaWwANj9JfqRrqng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NWgzWzoaKAnA0bgBMCQFWgRHE2QNVaolMGH+dNaDk2BPbqNtRBHaqmUrOos3WAmWRnmj/ZHYg1OzIZ3IkU4sHttF5oEpplEzmmNkVLmekwB6oGKmwLgIZd6uk3HLftbwmRiA8rFXofFKQuvVFrbr4YWmQKyaoOXCRh+jVcpvIw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHXUok54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHXUok54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705F6C4CEF1;
	Fri,  9 Jan 2026 11:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959734;
	bh=06BStZZTO3EhlDkOGQX1+4kKNIMDaWwANj9JfqRrqng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHXUok54PtWkZP+mjtGydg04tNTcFBu6h2nib3Le3IvjXxZR2iEokNV5Y2kcw/Ojq
	 yxwlCdezhizRH6Av0IwcwrFpu58ATIBpL+pqYI58H/s37dBqRgJu+Ts/kKasxlO7s/
	 9I1G5GSCRZkxSKMo8SPR6wAXVQ/Mjl/zWOFFydrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/737] ps3disk: use memcpy_{from,to}_bvec index
Date: Fri,  9 Jan 2026 12:34:56 +0100
Message-ID: <20260109112139.902161899@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 36d7b36c60c76..79d3779e1c7ad 100644
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



