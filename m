Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7318122AE68;
	Tue, 29 Apr 2025 17:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949573; cv=none; b=oricgqXeBfdBLkyHZKYUgzEVAHDILdJv6geXr+4/rMKg5S08yJ2GBuoxqe77OeyVSuB2/AY7foXSIWwvkmdPC6Ui701EAUupfdIqmLy4X76WMIPyr95J9LTSBhfugDGggCWbmOUMbilzAlnH6GD2a06rdSSvAcSbUaPDSU5eIL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949573; c=relaxed/simple;
	bh=FeSgW7woHjXNcHdOGe2pqrPcPMj+1is7fbNp7j5M6w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Plm3URwICPg84WfeZGeAnlMvSYszZuXTDqV/NyxfjlPudBENIowQwrPWeRJ+pbT52YWzs8ZX1Cg3tSNJEz2w1b+8ExXHAgcB3q9KLdJ1EGaRptAFJ+diC2cZrA6rDVoe6O4u4YI/Z3Rcd56RnxU6kcEwG5hsA9C0DamLAt7hty0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMg2rVIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMg2rVIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8F7C4CEE3;
	Tue, 29 Apr 2025 17:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949573;
	bh=FeSgW7woHjXNcHdOGe2pqrPcPMj+1is7fbNp7j5M6w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMg2rVIhf7C2jpiQxaWPBq6ERpCcVgiQzhVIDhx8V5O3W5UVnfb5xZrQPyB3xT+fx
	 om0Ai1IK0rMzoR6PPNoK4eeX/UMatBXnAKV40vYIaKMIRSpqX8k8RgxyAt51lvUJiU
	 /FqljzPoKAHrjkhuK2zP6QlMTDa310uFqInQRfYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.15 362/373] comedi: jr3_pci: Fix synchronous deletion of timer
Date: Tue, 29 Apr 2025 18:43:59 +0200
Message-ID: <20250429161138.024280132@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 44d9b3f584c59a606b521e7274e658d5b866c699 upstream.

When `jr3_pci_detach()` is called during device removal, it calls
`timer_delete_sync()` to stop the timer, but the timer expiry function
always reschedules the timer, so the synchronization is ineffective.

Call `timer_shutdown_sync()` instead.  It does not matter that the timer
expiry function pointer is cleared, because the device is being removed.

Fixes: 07b509e6584a5 ("Staging: comedi: add jr3_pci driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20250415123901.13483-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/jr3_pci.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/comedi/drivers/jr3_pci.c
+++ b/drivers/comedi/drivers/jr3_pci.c
@@ -88,6 +88,7 @@ struct jr3_pci_poll_delay {
 struct jr3_pci_dev_private {
 	struct timer_list timer;
 	struct comedi_device *dev;
+	bool timer_enable;
 };
 
 union jr3_pci_single_range {
@@ -597,10 +598,11 @@ static void jr3_pci_poll_dev(struct time
 				delay = sub_delay.max;
 		}
 	}
+	if (devpriv->timer_enable) {
+		devpriv->timer.expires = jiffies + msecs_to_jiffies(delay);
+		add_timer(&devpriv->timer);
+	}
 	spin_unlock_irqrestore(&dev->spinlock, flags);
-
-	devpriv->timer.expires = jiffies + msecs_to_jiffies(delay);
-	add_timer(&devpriv->timer);
 }
 
 static struct jr3_pci_subdev_private *
@@ -749,6 +751,7 @@ static int jr3_pci_auto_attach(struct co
 	devpriv->dev = dev;
 	timer_setup(&devpriv->timer, jr3_pci_poll_dev, 0);
 	devpriv->timer.expires = jiffies + msecs_to_jiffies(1000);
+	devpriv->timer_enable = true;
 	add_timer(&devpriv->timer);
 
 	return 0;
@@ -758,8 +761,12 @@ static void jr3_pci_detach(struct comedi
 {
 	struct jr3_pci_dev_private *devpriv = dev->private;
 
-	if (devpriv)
-		del_timer_sync(&devpriv->timer);
+	if (devpriv) {
+		spin_lock_bh(&dev->spinlock);
+		devpriv->timer_enable = false;
+		spin_unlock_bh(&dev->spinlock);
+		timer_delete_sync(&devpriv->timer);
+	}
 
 	comedi_pci_detach(dev);
 }


