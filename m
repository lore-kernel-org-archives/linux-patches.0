Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC30A4E77FC;
	Thu, 17 Sep 2026 16:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661348; cv=none; b=XlxG5gWpilI1fhZKgT+8LelVsL2HJP9voCtLQL58QiH8/y7aaWbf6k14Z94nvVoBTtNy0fpknWCTcxioYhagPrZQ2rTEWVsSaLUcl5DpS2Z5HZoBgX+HQ1usN2VDLe1N7wfgVcuX8AC4qitGRxFPykdzlth8jriC9oM2PpYfQrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661348; c=relaxed/simple;
	bh=S3/xteLrembrORn7QrIeTs97Q08AS3FqFvAhKFgpAks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgVQhTWh0QbstaGOpYV/MgHTJMU07URg/TUvGkMtrUZAYz3pW2o7ZnW3FqRjv/djPIozuCLVNXMPbP2US4mgCFbozwvejY8Xg8U6fM7tKaaR2w2mD2TUMNfe7bCM2mRHqBqyVNuxMLTrID6IBrITkQhem4wSajd080nPSVKmLJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcBxcwoq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcBxcwoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F81C1F00893;
	Thu, 17 Sep 2026 16:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661347;
	bh=75JNGgzafA5iDK3HIzz+rdvONL1NXzXlHJxRkyBrRR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcBxcwoqQUZCn5+bZYhG6lY0tgogX/DwJ+k2rUKDUjVlsR0v7yp0ru26G4dbz1k2z
	 1Wr6hTmb4scuc8FkpJUIKJr1snTebGYosZQg6Lbpb7LSA5ob7B5Adrpik+8dS5ITp6
	 Y2EgitwuBVtq3stju73/iT+1PnXTdHTrIWEN1shg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0164/1250] thunderbolt: Verify Router Ready bit is set after router enumeration
Date: Thu, 17 Sep 2026 15:59:19 +0100
Message-ID: <20260917151556.534680658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gil Fine <gil.fine@linux.intel.com>

[ Upstream commit 062023c4364ffdc72978ed2de1d1435e5d4eee43 ]

The USB4 Connection Manager guide specifies that after enumerating a
router, the Connection Manager shall verify that the Router Ready bit
(ROUTER_CS_6.RR) has been set to ensure hardware configuration has completed.
Currently, this step is missing from the enumeration sequence.

Add this check to follow the Connection Manager guide more closely.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/tb_regs.h | 1 +
 drivers/thunderbolt/usb4.c    | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/tb_regs.h b/drivers/thunderbolt/tb_regs.h
index 97404d8d878bf..7f2dcb309e928 100644
--- a/drivers/thunderbolt/tb_regs.h
+++ b/drivers/thunderbolt/tb_regs.h
@@ -216,6 +216,7 @@ struct tb_regs_switch_header {
 #define ROUTER_CS_6_WOPS			BIT(2)
 #define ROUTER_CS_6_WOUS			BIT(3)
 #define ROUTER_CS_6_HCI				BIT(18)
+#define ROUTER_CS_6_RR				BIT(24)
 #define ROUTER_CS_6_CR				BIT(25)
 #define ROUTER_CS_7				0x07
 #define ROUTER_CS_9				0x09
diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index 9430bed07c468..6383fd43203d7 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -294,7 +294,12 @@ int usb4_switch_setup(struct tb_switch *sw)
 	/* TBT3 supported by the CM */
 	val &= ~ROUTER_CS_5_CNS;
 
-	return tb_sw_write(sw, &val, TB_CFG_SWITCH, ROUTER_CS_5, 1);
+	ret = tb_sw_write(sw, &val, TB_CFG_SWITCH, ROUTER_CS_5, 1);
+	if (ret)
+		return ret;
+
+	return tb_switch_wait_for_bit(sw, ROUTER_CS_6, ROUTER_CS_6_RR,
+				      ROUTER_CS_6_RR, 500);
 }
 
 /**
-- 
2.53.0



