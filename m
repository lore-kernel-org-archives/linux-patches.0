Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD02317145;
	Sat, 12 Sep 2026 15:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227435; cv=none; b=RJpvRlAf4CeIzSxTfYGxMcbQpwqBJmKVsO1/mVMGBTo7s9RL0sib36YLOUYh8dO/c+wAVPMoFU5xvOBeJOfB53An+JYCeOlVpHJ44FwepeZmNQykRRy1onL42egwOwFc6vrBwqfHDKb+6dmAYQfMblF8sW8gs7pfr4hgCe/zeMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227435; c=relaxed/simple;
	bh=uSHnOLNBqsOR0nw/HJ5p2TT6WBqlYjls6yX29SAJdCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPgOAp8pcXYDV9DYVIjxookMqCntmMa2jrV1gJMKhs7q2t/mPyt7b8jv56HPoL0I6bV95K8bgMCXq3MyMyhQSe1FHDH7Of7Leyqwg/Z6r64RJFT55meeSVUescaR3lxoFZBlyRtXf/clA0/gfDITAIjB+Z9sURaXCHFasxpMR7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHM0Z3t7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHM0Z3t7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001151F000FF;
	Sat, 12 Sep 2026 15:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227434;
	bh=B0QaWqKvyo/mhbwC76ANggThjBbwP8Keh4nKa/1unr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHM0Z3t7a+KLXwbH0UGVPiL16G44zuPk70TnFQgrk1F7fCWdXPIli21Sar9VFSxup
	 tYtUDdD+Vq5grOSteWu5TLDqfxdvqv4T/h9X+JG7YZIFCA7AC27jET2jP0p2RvTcQy
	 YOushoSDf+0ToACBNjyxYITrTXmbN7u8L55mCLcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sre@kernel.org>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.1 0179/1191] power: supply: twl4030_charger: cancel workers via devm
Date: Sat, 12 Sep 2026 08:48:27 +0200
Message-ID: <20260912065552.235619836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 6eba34732524067da2aad5ddfdfbc641ded10e9e upstream.

bci is devm-allocated. Two workers (bci->work and bci->current_worker)
dereference it. twl4030_bci_remove() disables charging and masks
interrupts. It cancels neither worker. A worker pending at remove() can
run after devm frees bci.

The USB transceiver comes from devm_usb_get_phy_by_node(). devm
unregisters its notifier only after remove() returns. A cancel_work_sync()
in remove() can then race a notifier reschedule. devm_work_autocancel()
and devm_delayed_work_autocancel() avoid that. They cancel the workers
during devm release, before bci is freed.

The current_worker is registered first, since devm will cancel in
reverse order and bci->work can reschedule current_worker.

Suggested-by: Sebastian Reichel <sre@kernel.org>
Fixes: d6ccc442b1210 ("twl4030_charger: Make the driver atomic notifier safe")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20260702172128.2001753-1-maoyixie.tju@gmail.com
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://patch.msgid.link/20260725072540.3092504-1-maoyixie.tju@gmail.com
[Move comment about order into the commit message]
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/twl4030_charger.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/power/supply/twl4030_charger.c
+++ b/drivers/power/supply/twl4030_charger.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
+#include <linux/devm-helpers.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/twl.h>
 #include <linux/power_supply.h>
@@ -1004,8 +1005,15 @@ static int twl4030_bci_probe(struct plat
 
 	platform_set_drvdata(pdev, bci);
 
-	INIT_WORK(&bci->work, twl4030_bci_usb_work);
-	INIT_DELAYED_WORK(&bci->current_worker, twl4030_current_worker);
+	ret = devm_delayed_work_autocancel(&pdev->dev, &bci->current_worker,
+					   twl4030_current_worker);
+	if (ret)
+		return ret;
+
+	ret = devm_work_autocancel(&pdev->dev, &bci->work,
+				   twl4030_bci_usb_work);
+	if (ret)
+		return ret;
 
 	bci->channel_vac = devm_iio_channel_get(&pdev->dev, "vac");
 	if (IS_ERR(bci->channel_vac)) {


