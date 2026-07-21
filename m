Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BB3346A0C;
	Tue, 21 Jul 2026 20:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666376; cv=none; b=iDAahcsipqT1hGoFwaEd+dv7nqUnQ8cY6pOZEQiHxxdmaDLxRJCW1IBWNWDkWtZy1ltkjCQNHAcb5jTo+SCM7rf4fM7JZv/2A3JGQUXQ5CD/sxpnVGrMmvvkvCIqab5UvzVw1nN+HAxq47m104AIsWGQSTvPiH+ljmE4UB9T6WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666376; c=relaxed/simple;
	bh=8jDkUEG6N3WBCDWfua+nKm1kbctY/5BlJxymCDTZbvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UtxY5Z9lIvuFe4589VDuuT0U39auu0sa8UKpcoYEZ3lek0l9WZPIQ/ZP3q+kp4fhrHrvJEwCOonUxc3ftdcaQ63/wk50ccY3v9TfxkX5dVDHfTBCc3ZXiSKJj1TocGbSo5NjOCRUc9JRE+cjoTEnmJq+jwWAxdXDWT6My68fdqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcZXAcZv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcZXAcZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536691F000E9;
	Tue, 21 Jul 2026 20:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666374;
	bh=W1trJSxxzVo3fF7HxUPJnmdxWPWaUL4j/L20CRrMe20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcZXAcZv3Pe/mei6raC+YdsDaQTwWhLU9fFQXJWG6iwa69laK91QiS+sRkTVkWG94
	 n42x1qiGH88K9GrcFx06E5m+Jg3NB9yieq5q1PMi8+hJ8RDH6Ya6wxSs/YrBSdcmOB
	 UPzceYWNyrBk6jtGLzepX/xm7IXLX9PR3XnvGo9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0660/1266] PCI: mediatek: Fix operator precedence in PCIE_FTS_NUM_L0 macro
Date: Tue, 21 Jul 2026 17:18:17 +0200
Message-ID: <20260721152456.627047206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 82e575e4d3877a..bc2847fe12d1cb 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -7,6 +7,7 @@
  *	   Honghui Zhang <honghui.zhang@mediatek.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/iopoll.h>
@@ -60,7 +61,7 @@
 /* MediaTek specific configuration registers */
 #define PCIE_FTS_NUM		0x70c
 #define PCIE_FTS_NUM_MASK	GENMASK(15, 8)
-#define PCIE_FTS_NUM_L0(x)	((x) & 0xff << 8)
+#define PCIE_FTS_NUM_L0(x)	FIELD_PREP(PCIE_FTS_NUM_MASK, x)
 
 #define PCIE_FC_CREDIT		0x73c
 #define PCIE_FC_CREDIT_MASK	(GENMASK(31, 31) | GENMASK(28, 16))
-- 
2.53.0



