Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E11B4D90D6;
	Tue, 21 Jul 2026 17:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656130; cv=none; b=tjMs5lIb9qTE4lQr1jJrogFfxBwL0kZjAakujCn3Lyzmi8lpzULBwBdlWkP8MkAXvEnfaKSxNxMcElCjklYao2H3dXFGqn9bBazLNanSI/3OLU1yd0Xm8m41MHidlfbYPGwM5siRTbWsRyKEGxPRTCAJ4pqfs3O0MbOXlVPzwgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656130; c=relaxed/simple;
	bh=mGrbzMTjOnug2O5l35g1JHSwSUdwCcos6FeI1tPjTa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCQ944cIc7ScJO/HEHL1Oe1mLLM1U1V5QbcbKYMfwJHmOeN1ZhA0G8SPOspWme9CoqOn2zu+piNTpwgJf8j98d0pbuH66ArwsInqrzYNf0JXYe31UEWciwHtbAaoiJpJ8PnpfJlasnm+J7Q9nRMEgMTxG36lzTNBqS6gOtHM3a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqOXe8OM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqOXe8OM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413E71F00A3A;
	Tue, 21 Jul 2026 17:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656127;
	bh=qNHSGnTLglv5I3tufM1s4BxMkIeAgXprq6jmMbQ1w5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iqOXe8OMN24xb2+YjJC61bXV/EYRgYVbvzRQTaXIiN/CJbTPKH8F5pWoFayTLhf8y
	 YcBjIyWPxS/ljMvQ4Z4+AgQ/9pwBr6+tV8lHHEOvTgF45d/MepzLA8d+/HYTTHOC+/
	 Yh3MaFH4bxoj3LN3TG+FXn2HBNUlq4Y+kvgO5nBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0269/1611] EDAC/igen6: Fix call trace due to missing release()
Date: Tue, 21 Jul 2026 17:06:25 +0200
Message-ID: <20260721152521.101635314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit ab1f9d466c7d83ab0d2a529e07984e53b5960dcd ]

When unloading the igen6_edac driver, there is a call trace:

  Device '(null)' does not have a release() function, it is broken and must be fixed.
  See Documentation/core-api/kobject.rst.
  WARNING: drivers/base/core.c:2567 at device_release+0x84/0x90, CPU#5: rmmod/127209
  ...
  RIP: 0010:device_release+0x84/0x90
  Call Trace:
   <TASK>
   kobject_put+0x8c/0x220
   put_device+0x17/0x30
   igen6_unregister_mcis+0xa2/0xe0 [igen6_edac]
   igen6_remove+0x82/0xb0 [igen6_edac]
   ...

Fix the call trace by providing empty release() functions for the
memory controller devices.

Fixes: 10590a9d4f23 ("EDAC/igen6: Add EDAC driver for Intel client SoCs using IBECC")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260403054029.3950383-2-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index 463bbcd484c3c0..42eadece2d71b5 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -1255,6 +1255,11 @@ static bool igen6_imc_absent(void __iomem *window)
 	return readl(window + MAD_INTER_CHANNEL_OFFSET) == ~0;
 }
 
+static void imc_release(struct device *dev)
+{
+	/* Nothing to do, the 'imc' owns the 'dev' and will also release it. */
+}
+
 static int igen6_register_mci(int mc, void __iomem *window, struct pci_dev *pdev)
 {
 	struct edac_mc_layer layers[2];
@@ -1293,6 +1298,7 @@ static int igen6_register_mci(int mc, void __iomem *window, struct pci_dev *pdev
 	mci->pvt_info = &igen6_pvt->imc[mc];
 
 	imc = mci->pvt_info;
+	imc->dev.release = imc_release;
 	device_initialize(&imc->dev);
 	/*
 	 * EDAC core uses mci->pdev(pointer of structure device) as
-- 
2.53.0



