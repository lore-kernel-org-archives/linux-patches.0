Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA863B3C18;
	Wed, 30 Sep 2026 18:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794053; cv=none; b=t6HcEtWIRmDuGe3Ic6/BEHGtXH0VnxchNn+0uM3ZkRyyAB1SkPLTNL0JHVRUh1Twvq5lFh3G+prag+6RZil64iRBipb67TBEXLOrhadXVD4JS85fV/H9VgU65OvNyBiiIerY7YXhCxe+sftcXtTxeUraJZPcn6ZZ3xA/k1X0Fdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794053; c=relaxed/simple;
	bh=9KY/H6OUN0UxCyEf+FrX2bL0Nj+fg2+wm2ClHZxXgeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxJ2zEm1B1E9qauquCDhnc/oLpzd6jWsU61BykY6mtFiuv6BN8PJv9rprML+7fftVND21uTBRuKH1FbjGy5tnFZ5bqyXuykMBNy2anKV/AHA6oMTvEpydqXWDS2sPRsYQ7Pv5dwgLXXrfLXeXJ10npDIWX1IPoHdPbCchwbOVEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVfAG2dA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVfAG2dA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688621F000FF;
	Wed, 30 Sep 2026 18:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794051;
	bh=y+iIgga/nTDed/iLlU1wNY80bxgBBg9HJYdc5mN38y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVfAG2dAr5pVayCGUoO59AZ++jXinIr0To6UUtCtPj871t+JNN/R6cYjCdpVe4t/5
	 Gy6P3sXl9O6PUreXgsX6dgrDb9izbkuYGhwQFIgG42vpWqpR+i+PQJw1BU/C9WugsS
	 ssqCk32fLMHG1lfgfCbagMKkRYtSroxMcxZDQcQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0075/1193] thunderbolt: Verify Router Ready bit is set after router enumeration
Date: Wed, 30 Sep 2026 17:12:39 +0200
Message-ID: <20260930152435.927109954@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4419e274d2b4c..9b053cce3256f 100644
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
index 254415920f57f..9bddba6d01a2f 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -293,7 +293,12 @@ int usb4_switch_setup(struct tb_switch *sw)
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



