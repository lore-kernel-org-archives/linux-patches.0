Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ABB3D6664;
	Fri,  4 Sep 2026 05:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499699; cv=none; b=tm9or5jbE/Zu2bZmbS0E3yl3m3d/RzicHgcJBXzaCfy2LdCayERfXEtQihwiiF+PiNA2tlDLmFuGTbwTpueJM3/O92R3jxSBJk42T9Rs4uCaHltFQ7kBEHWOqLxJ9Du1+6uuKh8e9G+CDuiRbZG05/HXZBSiKxa0+6r5Hlx/rDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499699; c=relaxed/simple;
	bh=KsTe2rZpOpXtC7iCaTlvXbx0ASozxMrTmZ2ED7r1EYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjndvvYg1gqesfKerhsy8URgr1z2lI4ffjOMtKPxn836KGi9Z7ldb+5K5xJxJDIaNb5DZmo0DSyHNanxU9YJkn1BVzJWXu+IOPCowjiy3+CNFLae4ci8/AVmaRk5vS9j+CXyLoIaMFsDHK3xnMzzJBdDQM+CcsoyFYmnUOzsLg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9X+PFUv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9X+PFUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EEA1F00A3D;
	Fri,  4 Sep 2026 05:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499697;
	bh=jY4y/GNAjTQHjf9oTMrTWG33uSqfchREf+a7VleVAJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T9X+PFUvHXlv3rdJXO/XX8tmqVFqyE4plr9D4SnqY7OFsQE0id3vWZz6v5gYfqawm
	 mChs0e6opHhh1zZW+XzVM8GzYOZM+gF6/6Iaucg6OCxEAvd+QPu6OcAHTc92/Jr1b+
	 +aFYvJwDCsHsROLXeKfX3rNJx0pqvnfnM/MQzHF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sre@kernel.org>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 7.2 510/713] power: supply: twl4030_charger: cancel workers via devm
Date: Fri,  4 Sep 2026 06:57:58 +0200
Message-ID: <20260904045815.252724340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -1002,8 +1003,15 @@ static int twl4030_bci_probe(struct plat
 
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


