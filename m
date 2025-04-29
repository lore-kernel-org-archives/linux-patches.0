Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07C97E110;
	Tue, 29 Apr 2025 17:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947930; cv=none; b=FpBZ2S+9YBvu/oSPBeddzmchGNRgcUJ/YgSZaIW1uKYxtur+vPoC6TNkNaoA3PP1LfDQXaotoCvSGC2/EmM9xgfjUus4VQ+NdsAGftwbf/79SIeFSlcsOxvl/aOW/fcQTxX17KUWm+l5zqvL7HvFEh6c7e3GQ54EUYQsfhIEbk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947930; c=relaxed/simple;
	bh=2UhnSiXH3pIGkFp69ztW4pSWM03+hO8LS5ujWQ4B/Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FS4CDDe8Ti962B8LtrsJMZ9uf3YK9tRzrsBwKnj0HxFztZS0DFJwQBfSq59g1QeV2VHeTh71SdkU5/zBLadBYrP4CB3y7JFdqVfyRqXSev0nsF2rSJ/FBVJ93grMnmjNP9hYlN7+MI9hropuLP5VfwDtY4megQXbsZ/LltQYePM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndvlOcsA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndvlOcsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438ECC4CEE3;
	Tue, 29 Apr 2025 17:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947930;
	bh=2UhnSiXH3pIGkFp69ztW4pSWM03+hO8LS5ujWQ4B/Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndvlOcsA3IOz4bGtKZYMlBsmXrfdH4K5pc1SlYzSl2GFItsVrvrgO5eeJ9G1zy3rM
	 yo2l4idXlQAo8LYohukJ/dNbm+643W7RA5guCQslO66FqmY+Ys7D5Qrqij97aA6DJr
	 +AZ4WdELj/ckmXfq6YRi2Sn1OwxnKEDEn4cSKrHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.12 148/280] USB: wdm: handle IO errors in wdm_wwan_port_start
Date: Tue, 29 Apr 2025 18:41:29 +0200
Message-ID: <20250429161121.178907017@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 9697f5efcf5fdea65b8390b5eb81bebe746ceedc upstream.

In case submitting the URB fails we must undo
what we've done so far.

Fixes: cac6fb015f71 ("usb: class: cdc-wdm: WWAN framework integration")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250401084749.175246-2-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -829,6 +829,7 @@ static struct usb_class_driver wdm_class
 static int wdm_wwan_port_start(struct wwan_port *port)
 {
 	struct wdm_device *desc = wwan_port_get_drvdata(port);
+	int rv;
 
 	/* The interface is both exposed via the WWAN framework and as a
 	 * legacy usbmisc chardev. If chardev is already open, just fail
@@ -848,7 +849,15 @@ static int wdm_wwan_port_start(struct ww
 	wwan_port_txon(port);
 
 	/* Start getting events */
-	return usb_submit_urb(desc->validity, GFP_KERNEL);
+	rv = usb_submit_urb(desc->validity, GFP_KERNEL);
+	if (rv < 0) {
+		wwan_port_txoff(port);
+		desc->manage_power(desc->intf, 0);
+		/* this must be last lest we race with chardev open */
+		clear_bit(WDM_WWAN_IN_USE, &desc->flags);
+	}
+
+	return rv;
 }
 
 static void wdm_wwan_port_stop(struct wwan_port *port)


