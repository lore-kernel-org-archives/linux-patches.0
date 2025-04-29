Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1266D2AE96;
	Tue, 29 Apr 2025 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949535; cv=none; b=phi19uKeH/4KQr1Nx7FEuj6/YQRJcEhf3NU3FM3fSDF2L5yubcRxO4q2JMhMN4rt4FeYWkyRdFgsP9GUPGYzM1LJwRV6zVW4GBNR2GSKrNvKBN878Ih/zd7S5sG4qaGCGipTqOuBmlLGx2fa5oKf+FEe0kXA7wSouXQZZl+p4wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949535; c=relaxed/simple;
	bh=D6Jr4aYGpBQ/Hvs7+N3FEur9gfFoiebulJuuji49jys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKuyftOSf6Ph1u5o3ixbY0unnRWzPssktYPzlGDXHOfFYXenPKPKV9UdPuypI176z3Q9oTIfDt8Wkoh09IlC2NUtu/tfnP/vT0JEB/JY3yjYrMp1ttVWR5tIEWBfoGdYanu74QlOKj1SMZIO1gOJEb22YtGoQyGZ3UKicDrCps8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiYLLBIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiYLLBIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A21C4CEE3;
	Tue, 29 Apr 2025 17:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949534;
	bh=D6Jr4aYGpBQ/Hvs7+N3FEur9gfFoiebulJuuji49jys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SiYLLBIinLrkT+zXfgwDvfDoRMQZAJvHV4gD6/vYAHR6UyrPFC+SWwCEb9xGo3ILK
	 lWammM+SoIAU3gh3VjGGSfsNbEgoCF/eRa79B1YqZmUKUKynVVurT9LKw+xS0s1LPy
	 CPtqLIBcH/KpNj5xUpdgqOQJM+4xE3FP7zKObTT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.15 319/373] USB: wdm: handle IO errors in wdm_wwan_port_start
Date: Tue, 29 Apr 2025 18:43:16 +0200
Message-ID: <20250429161136.240438401@linuxfoundation.org>
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


