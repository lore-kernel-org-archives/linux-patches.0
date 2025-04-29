Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46F824A07D;
	Tue, 29 Apr 2025 17:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947431; cv=none; b=B59wQYxsQe/E4J87w47VPOG0Z41dJDW1ZcVs16l1gv0aXbOw8TfD6YYRTaDvYzw3lv7tiex3RrFMG96Jdt/O5dfromypRUxO4Wd8IqttWe/4ImqegdDxCUlwY8/VbvmlgQWpFnKKM7n4YLQZ5orPLSXdfsa4Ql+JpSRFDLeOxPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947431; c=relaxed/simple;
	bh=EVxNLEjGgFzhSOc8fWNddBjmhIfGRRtpoPBPzixVAgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hljIBXoWilpFsOS00FpVu9k9YNFWkHHa1kU+27Biv6DPnih53S6C5O5PavGMnkI1IxhXPPkbMHbMlAQsY2tn3fNx9eagsY581cF3ghPe+d9azpGroBrB/u2pC0xvrLrBJLNd76nL3sKN86Q7IYw5mVpZM1CyV5vl1oP6/AJqR80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sR9VBLbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sR9VBLbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32008C4CEE3;
	Tue, 29 Apr 2025 17:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947431;
	bh=EVxNLEjGgFzhSOc8fWNddBjmhIfGRRtpoPBPzixVAgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sR9VBLbvf0FFBadCLz8qZgSVQIkyefdQQVZddUPxBftwcaOWo3TWWX7PQe4uWG1PO
	 lN443UuGDquYAYOqlOPMzRBBvpRM883VBddMi3u+rcPZPNRabtnLy/oaFLCpBnhUj4
	 WNj8Xey0TRXzmf0zTNfoxEJkz7hHoQDR3s6DmYX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.10 278/286] comedi: jr3_pci: Fix synchronous deletion of timer
Date: Tue, 29 Apr 2025 18:43:02 +0200
Message-ID: <20250429161119.348885172@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/staging/comedi/drivers/jr3_pci.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -88,6 +88,7 @@ struct jr3_pci_poll_delay {
 struct jr3_pci_dev_private {
 	struct timer_list timer;
 	struct comedi_device *dev;
+	bool timer_enable;
 };
 
 union jr3_pci_single_range {
@@ -612,10 +613,11 @@ static void jr3_pci_poll_dev(struct time
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
@@ -764,6 +766,7 @@ static int jr3_pci_auto_attach(struct co
 	devpriv->dev = dev;
 	timer_setup(&devpriv->timer, jr3_pci_poll_dev, 0);
 	devpriv->timer.expires = jiffies + msecs_to_jiffies(1000);
+	devpriv->timer_enable = true;
 	add_timer(&devpriv->timer);
 
 	return 0;
@@ -773,8 +776,12 @@ static void jr3_pci_detach(struct comedi
 {
 	struct jr3_pci_dev_private *devpriv = dev->private;
 
-	if (devpriv)
+	if (devpriv) {
+		spin_lock_bh(&dev->spinlock);
+		devpriv->timer_enable = false;
+		spin_unlock_bh(&dev->spinlock);
 		del_timer_sync(&devpriv->timer);
+	}
 
 	comedi_pci_detach(dev);
 }


