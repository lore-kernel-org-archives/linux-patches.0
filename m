Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC87B3C7E19;
	Thu, 17 Sep 2026 17:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667495; cv=none; b=k5CcBblsEFiTnKDManjhIQMn3Tc1Yr2QjWpJGhsgCJb5P9LvRtEVk2s33HcsKpXRQ4yB6qksSXx/xtKWweNJgBY26YY9luFF0aW8zTDRiZv7y3j+MrapPT55hmYxC4LVAbcVzU6AmgmRi1qNdeCGcTWlHB4d0c0Sb70qtcINZ/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667495; c=relaxed/simple;
	bh=uRA3W+hyKuCsfxJSWacQ8N2mILoJxhIzwm6dsQv469w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFLxLLGcXd5ZeINGZdjgbMJWrBxEejh4GT37SEnkuQpQ2EHLLk44OGyi+kUkiCNiReUBAW4h0XSVZduJXMnheYcJXbxX6n9yYQueLNRIhFnv4J9Z1J3S6hQ3OS2aN7/8WMahUuvsYwRQJ2Jja638/VOiGf+zvYOVqNyzkAjx5b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PgOE954X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PgOE954X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE221F000FF;
	Thu, 17 Sep 2026 17:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667494;
	bh=SVZMiGVzWzPQ9DRGtqiBlAuM+oYL3wb767ZIoLsLEaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PgOE954XOHG3Iwj4oVM87lUyaGk3mEkbQJigsUIQ/NrrPymRW8lXJq0BMJRifzmnI
	 m/K17p+PNME2ogmLYxhxCL/k9Tt9yd8oNObPoQFh7HRg8OOl3TRf0gpITLceK2+cq3
	 cumR/BvR6uopFd5Baxl1I5u9wvWOsNu1EOixffV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0112/1102] thunderbolt: Verify Router Ready bit is set after router enumeration
Date: Thu, 17 Sep 2026 16:00:55 +0100
Message-ID: <20260917151542.315518004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4e43b47f9f119..65d2797f2b01a 100644
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
index 9fb81ce1e5eab..4fc0731078487 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -291,7 +291,12 @@ int usb4_switch_setup(struct tb_switch *sw)
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



