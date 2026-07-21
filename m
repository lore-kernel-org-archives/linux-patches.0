Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E1C47044A;
	Tue, 21 Jul 2026 19:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660533; cv=none; b=oE39eIM4ntfmls7an5gUea6dhl6XXbFixbUqPSalafi4ZNo646JOtN3uwQaCGiC3BCEJxOh6qZB4h42pPTNH6MdFgmoMqpxY1kupwh+A2aGyIewxNvDQV1SStPWOY0/Wtt/99joaaSnr60xqj1neHfYy1u+VB6gyyCxEujlBlKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660533; c=relaxed/simple;
	bh=eJp5fa+EKKnfTG6OFGC3BsLGQcF5GSnUTecNkRZsivs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gaeyOXzN+bcth79JTBg/aWsPmufgIKdDdh0osEB9fnwcUj8xTonCc4pwK4elfmpvSWNTvj/KYtfqxdkKm2chtIcXwG3abmHXycH5Fg5UhSXj5PuiXcasXOvVJDLs0bwIlDLLRbnF838LR03tW+A5nkbV7CtqHqODyIy+1qiQQD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7Z90vBg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7Z90vBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDEA1F00A3D;
	Tue, 21 Jul 2026 19:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660531;
	bh=Tof0EGmtW8MrpbIYQjkJIQIpE9ESmDIJDLWT7oVnL6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7Z90vBg8DaDvqklLXFK2YrBUKelfygu6xyIl1LFdps8jV+GDw1qnAGcId5Mg8krk
	 Jlqfk0KfcLzo84mkDLZuCSkQwcXYUqB7GPBMda2jk6DCPpuT31/W3shA9q/uVweg1E
	 xkugggU3WwUkYODoxLkH2T9zD4OxSTPLLZDPD/fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0972/2077] PCI: mediatek: Fix operator precedence in PCIE_FTS_NUM_L0 macro
Date: Tue, 21 Jul 2026 17:10:45 +0200
Message-ID: <20260721152615.746246977@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 282305d7e9c0e27fd8b4df34b7cd5506a1eccdd6 ]

The original PCIE_FTS_NUM_L0(x) macro was buggy due to improper operator
precedence, where ((x) & 0xff << 8) was evaluated as ((x) & 0xff00).

Instead of just fixing the parentheses, use the standard FIELD_PREP()
macro. This makes the code more robust by automatically handling masks
and shifts, while also adding compile-time type and range checking to
ensure the value fits within PCIE_FTS_NUM_MASK.

Fixes: 637cfacae96f ("PCI: mediatek: Add MediaTek PCIe host controller support")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
[mani: added the bitfield header include spotted by Sashiko]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Link: https://patch.msgid.link/20260515005552.2343-1-lirongqing@baidu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-mediatek.c b/drivers/pci/controller/pcie-mediatek.c
index 907ae4285ecb1b..f34d91e495bc11 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -7,6 +7,7 @@
  *	   Honghui Zhang <honghui.zhang@mediatek.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/iopoll.h>
@@ -61,7 +62,7 @@
 /* MediaTek specific configuration registers */
 #define PCIE_FTS_NUM		0x70c
 #define PCIE_FTS_NUM_MASK	GENMASK(15, 8)
-#define PCIE_FTS_NUM_L0(x)	((x) & 0xff << 8)
+#define PCIE_FTS_NUM_L0(x)	FIELD_PREP(PCIE_FTS_NUM_MASK, x)
 
 #define PCIE_FC_CREDIT		0x73c
 #define PCIE_FC_CREDIT_MASK	(GENMASK(31, 31) | GENMASK(28, 16))
-- 
2.53.0



