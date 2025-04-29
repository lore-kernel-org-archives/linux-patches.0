Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257782AE96;
	Tue, 29 Apr 2025 18:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949997; cv=none; b=KgHKzPW97j8TNaK2IS2+U0XO3RzFJtfYBJmkWRT/i0OSaTH78Vlog87DGL4m+oNx4FvqxxqaEf2+XinBxjOuZqvs1PmA2AGpEVj9Ey+kZql+pr6cm+mYD+ymVI20NH9vYzGEjZHah4MD5ri1lJ4JGVhjmQOLHbM3C3xqQQ6eNnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949997; c=relaxed/simple;
	bh=I+PrLIeUBy0j1cbpuDYmPvhem1jBfWd6/+4hMQJQIMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hpt7WTXYEwpQTCsw6Xio7HXWsgyK2z7LO1pf6TgpoUj4j9kj6Y8EdYHltyUGObBZf7pm4e5ge6QVVaLdyugBU7oYLYG8iDrYg5mvFeZQ54iZYgzY7VgtyuKgJGlkXKKOOdcBDqmvtJSO4x6ZGPaqWVNEdhNz8G6QDQh8IAJdU7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vyMrL1n1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vyMrL1n1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A236DC4CEE3;
	Tue, 29 Apr 2025 18:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949997;
	bh=I+PrLIeUBy0j1cbpuDYmPvhem1jBfWd6/+4hMQJQIMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vyMrL1n1ybGOmlLQjs5Hv1tsQwciwgywkY7ILnZW2qWFmroJ9qk6lFaxSjner1ha4
	 ke9B3Gy3FXBhDXVhK8E/vjY+/IAvF52ZdYMCNdpdd9ykXSAR+YmIlTdF1UXBqgl3XM
	 D62DvtyNVxbVAqghpDFmvGMoChcNpeS4eWQAsVaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.1 093/167] USB: wdm: handle IO errors in wdm_wwan_port_start
Date: Tue, 29 Apr 2025 18:43:21 +0200
Message-ID: <20250429161055.521007593@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


