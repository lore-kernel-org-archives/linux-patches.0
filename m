Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84D72676CA;
	Tue,  8 Apr 2025 12:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113801; cv=none; b=KCp+xg6vJhYrKK4pkAoEuGeWyW/i0xmYSlvsJJMRnQA+fNtY/EKcGlaDoxtvmU9XCLv/+GpxB6VHWOOXx+F6Q1qgM2bz7CQkv0pvpR/4HSPUkrKwlRpfXLaYzDauOVfg0RD0vqT2LWWcRtZ/XATNgQtmNTGm8XbLjIfMC8ZkA/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113801; c=relaxed/simple;
	bh=wJx1/DBSmjo6dyO1q+y9gIatSn8K96OMRGBtgbzXxiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnyXDm6wQ3UWJ/3jLiZR05YDSTOJadWVBTCqOIhH++uzuFTyi1p3g9/mqAlq6OLpeoEaXSm6RSXGRovZrmnu3Bd7sWLsYXlgGAbsPLU3e+6Zo0GwiC4gvXrt75+AtlFBw/BiMSBmMJF8Fuo54658mi+8wNq+KwMKWEwkUzQbukc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6W38t6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6W38t6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFC2C4CEE5;
	Tue,  8 Apr 2025 12:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113801;
	bh=wJx1/DBSmjo6dyO1q+y9gIatSn8K96OMRGBtgbzXxiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6W38t6muvAapsuFjzEWKlweurP4Dzxdco9Xu6KGB+yxKH6SdE5Mrohs6em55znic
	 41PN3d+xSGCqWqylbznRX0aeUWYB0+W5uTAe/+KnW412aq4d8itulMXm+fnu1PUJy2
	 sp8OToOGwY6GL5hU7awTqF4aVpWv/6jQjoz/juuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Lindholm <linmag7@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/154] scsi: qla1280: Fix kernel oops when debug level > 2
Date: Tue,  8 Apr 2025 12:49:26 +0200
Message-ID: <20250408104816.076875469@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit 5233e3235dec3065ccc632729675575dbe3c6b8a ]

A null dereference or oops exception will eventually occur when qla1280.c
driver is compiled with DEBUG_QLA1280 enabled and ql_debug_level > 2.  I
think its clear from the code that the intention here is sg_dma_len(s) not
length of sg_next(s) when printing the debug info.

Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20250125095033.26188-1-linmag7@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla1280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 832af42130467..a13db27b04ede 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2871,7 +2871,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 			dprintk(3, "S/G Segment phys_addr=%x %x, len=0x%x\n",
 				cpu_to_le32(upper_32_bits(dma_handle)),
 				cpu_to_le32(lower_32_bits(dma_handle)),
-				cpu_to_le32(sg_dma_len(sg_next(s))));
+				cpu_to_le32(sg_dma_len(s)));
 			remseg--;
 		}
 		dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
-- 
2.39.5



