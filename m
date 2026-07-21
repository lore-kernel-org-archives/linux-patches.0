Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C03F3E121A;
	Tue, 21 Jul 2026 22:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673820; cv=none; b=irdvgDfVSgmM10FYUVjyW2UeT2EfqNDPsqIocUDhLSNAGixbz5TeGIpBv8hT8yDhxwHjqfJotZ1Qq4+paeMBYdrGYRTK/iHBMOHtuGQWkpAI/skeoLVItbWscMgZMdHwuy8I5NIjPcbxFl50OxLVzMpn2TxPtBIn8Lq2ra0n2xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673820; c=relaxed/simple;
	bh=lf960qbAkHMKC+S8NHRRbUuXnzBsDVxr8bFNGddQgw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h2Io9kQvhK6aV6T1hieckrbn2jka609Ya4KcQPiXEU+EEh3FgSXVZrHI2ZL+EA3W4jrd4xmHaQxrs6W6E+bQrPd/uRAr385gOJC8uvb2zBRiFgPyQXrw78bHPxL87mzmoVKqwVn+qhkpguD3e4kPlU/ehmUcJf6aF+pLkoI3IRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYq2lmzY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYq2lmzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FB01F000E9;
	Tue, 21 Jul 2026 22:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673819;
	bh=HNOKzPL3/pA/RxHfYDAKTS5DVVQavE4myNzItjriSHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bYq2lmzYEW3Z6U3x2QlUu9EkBegpBk1jPQdLUorDmhSgYBoO5g50s8ClAe5mYNTAE
	 maAiUuUoscK5nkc4Hf81G/lbh1Ka37hxM/Mouhky8YRy0o2vydiHDkCjrpC7GVnHsp
	 q3MgKI8weUMDptaOP0c+HIvXlNPeFKPjNpOQhiHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 305/699] PCI: mediatek: Fix operator precedence in PCIE_FTS_NUM_L0 macro
Date: Tue, 21 Jul 2026 17:21:04 +0200
Message-ID: <20260721152402.576078282@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bab962ec7ab468..c33335f3f8e249 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -7,6 +7,7 @@
  *	   Honghui Zhang <honghui.zhang@mediatek.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/iopoll.h>
@@ -58,7 +59,7 @@
 /* MediaTek specific configuration registers */
 #define PCIE_FTS_NUM		0x70c
 #define PCIE_FTS_NUM_MASK	GENMASK(15, 8)
-#define PCIE_FTS_NUM_L0(x)	((x) & 0xff << 8)
+#define PCIE_FTS_NUM_L0(x)	FIELD_PREP(PCIE_FTS_NUM_MASK, x)
 
 #define PCIE_FC_CREDIT		0x73c
 #define PCIE_FC_CREDIT_MASK	(GENMASK(31, 31) | GENMASK(28, 16))
-- 
2.53.0



