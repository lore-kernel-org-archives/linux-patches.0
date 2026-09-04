Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C063ECBCF;
	Fri,  4 Sep 2026 06:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502643; cv=none; b=QU33gL9qib9IiE3iRBGtelItrFSol+RKPdOsXHuNwfsFmFSQc7cWKn31gJRfXna122PLN7vaCcu+gYs0xl11F3NnRcrVJBPrpr8r/rGPpzC6TWjRSfxQaZ/RlU9+otdIT1q+oSI+RcYXv429qfc5Elwvvjf3yf3eQWxwXgqGdkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502643; c=relaxed/simple;
	bh=+DGrQnnhA5VaPWJWOI8PA1aZ42S07nV4Gea00CQC7Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=By0Ru21WFWAEUuJWrYRCQ7xqH3SSwl+EipdHeYgMojQSq7ct566eMJqWCcWxjGbYAtxDyVb/l/gh080aeBBfvtLUiSF4rPPNnSfE3mWMPfnm/v8CfunRAfLgfY2N4F7Fu25MBah5JaprSd7I34lgHJ0+1NhbhtTAoP3Gqtj3lsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQFNBwaH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQFNBwaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611791F00A3D;
	Fri,  4 Sep 2026 06:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502641;
	bh=PXC1qhxhnq/vYHVIZ95g3rxyKMzPFEMW5FBUSC9nYHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQFNBwaHwRScK2tPabWdaNYU5hdnU+8FJ6GVAnxqUSQuYiPN097Moat0aJsOwfePC
	 pc2ZpR5TETyb8FPqz8d4MsWwx4A9yLsdyBBtwA8TJoikeLscTMHS9X7B/h/WG0xazL
	 NDmytS/cFnk3hKbPTkf0vTAZ2WtVbCeogzURu9cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sre@kernel.org>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.12 280/403] power: supply: twl4030_charger: cancel workers via devm
Date: Fri,  4 Sep 2026 07:01:23 +0200
Message-ID: <20260904045741.227601503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -14,6 +14,7 @@
 #include <linux/err.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/devm-helpers.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/twl.h>
 #include <linux/power_supply.h>
@@ -1003,8 +1004,15 @@ static int twl4030_bci_probe(struct plat
 
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


