Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283535172F8;
	Wed, 30 Sep 2026 17:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787728; cv=none; b=rJ+wJTx+++UGCv+hF7KfyScmZIfLL/JgiuOFVpunCBW9VrxxLfr4aT1p7xpcNgB3SLIF5Iv+DIwUbkzorp1dSIoPZU072gUvgLkYBGh+Ki6cacdxDTyskmYgY2Z1yB85tItdhEssLnhCvWtprwInQsUU8dF5wvcBQZLomnfg0sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787728; c=relaxed/simple;
	bh=U58z/9DYSlNBV6nTJJ7oXqtQrC/0uCDW6RH1C1B6iRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKlIplDWf1eC+GSTN9EifsG5Bp5Cmff2JKsI3h9kZf/NC9LNfJCk5bfZqDPWZG2VI+tC2mTPIRr/MhA4TluMRjA/dW03XLdRNndSlu8I+rGlOPlYdXBtj8x6VAFwzBjJDWRz65uKPl/sCwmt560q6B+xBT8rEL39wx54E6hhiCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zL+YAC0j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zL+YAC0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C64D1F000FF;
	Wed, 30 Sep 2026 17:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787726;
	bh=DAchrCvg+l5c8WR8bXOMXlX2d5lladB4rrR0v2Gj+xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zL+YAC0j1JUBTO/FpIoji6drk95OWTqMYABMHxTtRDzVshsu7GiBOmQdrUM4nGOUY
	 eacjDCb6eMoW3KOioBHktOXyMb+ivt4yuFAZjJ0ANX67cLia6z6NIfUT8epFGGx5wV
	 9sIqtm4lR3DAWggT7OleE1AfIt/0Fj3daLITWR98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 331/457] net: airoha: npu: cancel wdt_work after releasing the WDT IRQ
Date: Wed, 30 Sep 2026 17:27:16 +0200
Message-ID: <20260930152353.161220023@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 4bdee8060d1e4581624e68fbd369b1afb14df4bc upstream.

airoha_npu_remove() calls cancel_work_sync() on each core's wdt_work,
but the watchdog IRQ that queues it is requested with devm_request_irq()
and is freed only after .remove() returns.  airoha_npu_wdt_handler() can
therefore schedule_work() again once the cancel has returned.  struct
airoha_npu, which contains the work, is devm_kzalloc()'d and is freed in
that same unwind, so the late work dereferences freed memory.

Register the work with devm_work_autocancel() before devm_request_irq()
and drop .remove().  Devres runs in reverse order, so the IRQ is freed
before cancel_work_sync(), including when probe fails.  A cancel left in
.remove() cannot get that order.  Initializing the work first also stops
a pending watchdog interrupt from queuing an uninitialized work item.
Probe currently calls INIT_WORK() only after devm_request_irq().

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 23290c7bc190 ("net: airoha: Introduce Airoha NPU support")
Cc: stable@vger.kernel.org # 6.15+
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922000914.542068-1-mhun512@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/airoha/airoha_npu.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/airoha/airoha_npu.c
+++ b/drivers/net/ethernet/airoha/airoha_npu.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/devcoredump.h>
+#include <linux/devm-helpers.h>
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
 #include <linux/of_net.h>
@@ -749,12 +750,15 @@ static int airoha_npu_probe(struct platf
 		if (irq < 0)
 			return irq;
 
+		err = devm_work_autocancel(dev, &core->wdt_work,
+					   airoha_npu_wdt_work);
+		if (err)
+			return err;
+
 		err = devm_request_irq(dev, irq, airoha_npu_wdt_handler,
 				       IRQF_SHARED, "airoha-npu-wdt", core);
 		if (err)
 			return err;
-
-		INIT_WORK(&core->wdt_work, airoha_npu_wdt_work);
 	}
 
 	/* wlan IRQ lines */
@@ -801,18 +805,8 @@ static int airoha_npu_probe(struct platf
 	return 0;
 }
 
-static void airoha_npu_remove(struct platform_device *pdev)
-{
-	struct airoha_npu *npu = platform_get_drvdata(pdev);
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(npu->cores); i++)
-		cancel_work_sync(&npu->cores[i].wdt_work);
-}
-
 static struct platform_driver airoha_npu_driver = {
 	.probe = airoha_npu_probe,
-	.remove = airoha_npu_remove,
 	.driver = {
 		.name = "airoha-npu",
 		.of_match_table = of_airoha_npu_match,


