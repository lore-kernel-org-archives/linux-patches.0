Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A568146E004;
	Tue, 21 Jul 2026 18:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660028; cv=none; b=QMvX42M4rEyPQCxsTNhEeFJqBFcawoQwO67jJQjBazddbw20jEISjrILZ+ZLDoODBqq60yKa+YSMzUBMTv/uUfXasXua1tEfYOgNyrfxQmcnRFclyW0FMLye0gaDLOxCIOV61jVEevYrwK56T2Qp6JA0KqJ5YghgoRz3VMTfOvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660028; c=relaxed/simple;
	bh=MZUamJN+mE7R1B6LPR6rjsEkxxUcbEAzUSfRtrc9eYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iftkGduQ/GwaU1Hkl0Kh8sOhquG0TVjiYQBqQWF/NjRZ2nZjpWpNhmBuUufYZlbEug4z6cKfwUjDTKfiUYvPLxrBi8WTJWXNg2GfQ29BqSNv+e6LMkm+NKSzTFWQytFc816ipxgCusL54QpPhiShv8DI5MBuxpU8p0t65FnMLv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IfG7L99Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IfG7L99Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1769E1F000E9;
	Tue, 21 Jul 2026 18:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660027;
	bh=T00cVvxcqFjcWYyZuVhIofHzrH3PgSaA0PFgSIoH77Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IfG7L99Q5wxnA4veQ5SM1xlHTyhaF9mQN6ajW4TfqmiPrfwUqQo1mrN67oJooXqYw
	 zem7Sjnp8AgJDBYESRTOmu36gUcRdFkO4BZz7xqNO9MQhIjZqvP5NsVY5TAaCSccJN
	 aTBWXAEUrnlKXb44WSDG7ReF7TaSW6I2iDx0sNIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Bystrin <dev.mbstr@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0822/2077] mfd: rsmu: Fix page register setup
Date: Tue, 21 Jul 2026 17:08:15 +0200
Message-ID: <20260721152612.176638746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Bystrin <dev.mbstr@gmail.com>

[ Upstream commit 6bc38f26ed07197b11a2b588edf1f43bfbc81d76 ]

Fix writes to page register in 8A3400x family (Clock Matrix).

All calls to rsmu_write_page_register() (both in i2c and spi) have
resulted in early return, because all addresses in
include/linux/mfd/idt8a340_reg.h are less than RSMU_CM_SCSR_BASE.

There were 2 separate patch series which have to be merged in one time:
mfd and ptp. The latter have been merged, the former[1] have not.

Link: https://lore.kernel.org/netdev/LV3P220MB1202F8E2FCCFBA2519B4966EA0192@LV3P220MB1202.NAMP220.PROD.OUTLOOK.COM/
Fixes: 67d6c76fc815 ("mfd: rsmu: Support 32-bit address space")
Signed-off-by: Matthew Bystrin <dev.mbstr@gmail.com>
Link: https://patch.msgid.link/20260429072047.1111427-2-dev.mbstr@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/rsmu_i2c.c | 6 +-----
 drivers/mfd/rsmu_spi.c | 5 +----
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/rsmu_i2c.c b/drivers/mfd/rsmu_i2c.c
index cba64f107a2fd1..9e5fc8259eec2e 100644
--- a/drivers/mfd/rsmu_i2c.c
+++ b/drivers/mfd/rsmu_i2c.c
@@ -134,14 +134,10 @@ static int rsmu_i2c_write_device(struct rsmu_ddata *rsmu, u8 reg, u8 *buf, u8 by
 static int rsmu_write_page_register(struct rsmu_ddata *rsmu, u32 reg,
 				    rsmu_rw_device rsmu_write_device)
 {
-	u32 page = reg & RSMU_CM_PAGE_MASK;
+	u32 page = (reg | RSMU_CM_SCSR_BASE) & RSMU_CM_PAGE_MASK;
 	u8 buf[4];
 	int err;
 
-	/* Do not modify offset register for none-scsr registers */
-	if (reg < RSMU_CM_SCSR_BASE)
-		return 0;
-
 	/* Simply return if we are on the same page */
 	if (rsmu->page == page)
 		return 0;
diff --git a/drivers/mfd/rsmu_spi.c b/drivers/mfd/rsmu_spi.c
index 39d9be1e141fb6..c931d8cea0a1a9 100644
--- a/drivers/mfd/rsmu_spi.c
+++ b/drivers/mfd/rsmu_spi.c
@@ -101,11 +101,8 @@ static int rsmu_write_page_register(struct rsmu_ddata *rsmu, u32 reg)
 
 	switch (rsmu->type) {
 	case RSMU_CM:
-		/* Do not modify page register for none-scsr registers */
-		if (reg < RSMU_CM_SCSR_BASE)
-			return 0;
 		page_reg = RSMU_CM_PAGE_ADDR;
-		page = reg & RSMU_PAGE_MASK;
+		page = (reg | RSMU_CM_SCSR_BASE) & RSMU_PAGE_MASK;
 		buf[0] = (u8)(page & 0xFF);
 		buf[1] = (u8)((page >> 8) & 0xFF);
 		buf[2] = (u8)((page >> 16) & 0xFF);
-- 
2.53.0



