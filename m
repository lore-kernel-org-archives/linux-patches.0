Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C88229B05;
	Tue, 29 Apr 2025 17:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946158; cv=none; b=eBRMTRWXJPsSRrlCr8sCi2VuVAaczNXiHjM7sISSHi4sHW6dbV4fv6qQ5sWLChXOKKPTzptjj3cps1Xo9Ww3ZWmuVE0O6Vg9FgvpvVqDzCWo2gB3Z+JvNqR0cRPNGR9o6S+GQDgYnXK+KX4qL3iKMWNCB2itx+GbyJoxQ63Ie1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946158; c=relaxed/simple;
	bh=IyGqhyrVj/0iXG12+0ADfoufjHPLSABZ+CZHMN+mYgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5O7bVYe6w9Mcc7cQHkIkgz8pgzxPbWWv/TXxo9Hdk8g5w5OzZCGRTzjrnpejlvKXgT1jP7o7EUuiN58N4ctJ2yavU6cqH5OsDVWRjaqKLti4jOZY2upnqFr1syiDA+ov99ZXootf15HgCgB/b0WUW1d7UjuHnBU7G63S4aSHns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBKNUbv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBKNUbv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80488C4CEE3;
	Tue, 29 Apr 2025 17:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946157;
	bh=IyGqhyrVj/0iXG12+0ADfoufjHPLSABZ+CZHMN+mYgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBKNUbv0qr2ICuH5/Yheiuu9kgtGQ6DbHOZC33zzqBRGAknC7+G3seGrL+AYugvF/
	 XIGwruR7dyPzVoMfW/Kn8usM5/vfbeG7R/6RR89ejpQ8kdJSyupgDV/eYWoVjXIYIS
	 PUZKm3tk4QDboyE3Y0R3s5SUoVSNu1CD/+SO2Dzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.14 174/311] USB: wdm: close race between wdm_open and wdm_wwan_port_stop
Date: Tue, 29 Apr 2025 18:40:11 +0200
Message-ID: <20250429161128.158707359@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit c1846ed4eb527bdfe6b3b7dd2c78e2af4bf98f4f upstream.

Clearing WDM_WWAN_IN_USE must be the last action or
we can open a chardev whose URBs are still poisoned

Fixes: cac6fb015f71 ("usb: class: cdc-wdm: WWAN framework integration")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250401084749.175246-3-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -726,7 +726,7 @@ static int wdm_open(struct inode *inode,
 		rv = -EBUSY;
 		goto out;
 	}
-
+	smp_rmb(); /* ordered against wdm_wwan_port_stop() */
 	rv = usb_autopm_get_interface(desc->intf);
 	if (rv < 0) {
 		dev_err(&desc->intf->dev, "Error autopm - %d\n", rv);
@@ -868,8 +868,10 @@ static void wdm_wwan_port_stop(struct ww
 	poison_urbs(desc);
 	desc->manage_power(desc->intf, 0);
 	clear_bit(WDM_READ, &desc->flags);
-	clear_bit(WDM_WWAN_IN_USE, &desc->flags);
 	unpoison_urbs(desc);
+	smp_wmb(); /* ordered against wdm_open() */
+	/* this must be last lest we open a poisoned device */
+	clear_bit(WDM_WWAN_IN_USE, &desc->flags);
 }
 
 static void wdm_wwan_port_tx_complete(struct urb *urb)


