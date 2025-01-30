Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E70E1E6DCF;
	Thu, 30 Jan 2025 14:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247124; cv=none; b=PvTu2i1dKPCdMPoDAQLTgCV+mFflbCnuuq8ZBm8No/aTSxTlSKEOIT9BXx/KdyxkkVCoADNwr8Ft6u9gVB1P1JiaIFvfGQRXLoVFHwZqc/up7lwSCie8skUa7or9fVwWS4ZCaeWwAzscO2T3eKOfQQrYKpcrNpXlnLuh1hi4GJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247124; c=relaxed/simple;
	bh=l/EdMW0D0BtjD4hjy0IF3JnuRn/nlnavImiYdqDMkNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3lTNIp6NQ/PnGUgsYR90C/jvm3bNbezu1tCke/jghmd8l6XZSz9Kem9W2y8DuQPr3ouxHNGSJvxrQekP1Wz9qNAVIu/r2+3w4xuhTDgd3ZEIC7qqp3FPBEwSgnB5tZZRN/HQz/zc1swqgQdemB+0wlUr40x1kMi+JKcuwSnu9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWX716sj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWX716sj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2806DC4CED2;
	Thu, 30 Jan 2025 14:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247124;
	bh=l/EdMW0D0BtjD4hjy0IF3JnuRn/nlnavImiYdqDMkNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWX716sjU45vOpYJkRvkixPNTB24yxV+vcse1NYVxDG+kAfaw2obpxXaM1GgT0tGt
	 7Os/RRZ0ZjCzmDs/SxgmeQH03Ut1lcl0nNSwWsc9Bi8GcYSNJPIvTvkexqlGyEgvAw
	 2meqkC7gLRIvg8A7C9Bv/VLdi9hFrMq6r1/hXv7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/133] nvmet: propagate npwg topology
Date: Thu, 30 Jan 2025 15:01:19 +0100
Message-ID: <20250130140146.143582150@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit b579d6fdc3a9149bb4d2b3133cc0767130ed13e6 ]

Ensure we propagate npwg to the target as well instead
of assuming its the same logical blocks per physical block.

This ensures devices with large IUs information properly
propagated on the target.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-bdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 6a9626ff07135..58dd91d2d71c8 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -36,7 +36,7 @@ void nvmet_bdev_set_limits(struct block_device *bdev, struct nvme_id_ns *id)
 	 */
 	id->nsfeat |= 1 << 4;
 	/* NPWG = Namespace Preferred Write Granularity. 0's based */
-	id->npwg = lpp0b;
+	id->npwg = to0based(bdev_io_min(bdev) / bdev_logical_block_size(bdev));
 	/* NPWA = Namespace Preferred Write Alignment. 0's based */
 	id->npwa = id->npwg;
 	/* NPDG = Namespace Preferred Deallocate Granularity. 0's based */
-- 
2.39.5



