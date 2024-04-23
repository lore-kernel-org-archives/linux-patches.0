Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F2F20B3E;
	Tue, 23 Apr 2024 21:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908545; cv=none; b=PfDCB9ugRGq9C6Y3QK8jEjAHUgMHYpCKvOdrj+lff6GhjNJ90wWTgs5tqE7jmJia2uxrX3cPkwmE8INOPzsndGuhhIh6kcI35ImlAud0G5xi9O846vwOzYv4n7qAFwjgOI1FgvmlgkKGDCnl7Bfy5dN0NcQsmPnhEZOoqLX1H9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908545; c=relaxed/simple;
	bh=86Hlb7YqojZ+DKgtlAtmMbiOvWM/INW5/w/z8zJu1bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tmJ0YrXRbidqLscFHB02wJ3ol/h98Kz0dwmswGf8r2a8/ezdhJeFEclCY+qFUQ54bznR7YGohHtMmiwlPWuNx/rn85/7Pbi8U3WLwQ5XNFeIdFog99j/7j3/k6hRHirHgaByoPhIH54IgzMG9lJNhga+54tdLDu/pGLQIJcJHUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nX/b/8iw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nX/b/8iw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59541C32782;
	Tue, 23 Apr 2024 21:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908545;
	bh=86Hlb7YqojZ+DKgtlAtmMbiOvWM/INW5/w/z8zJu1bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nX/b/8iwuGtPmncNUlSFl5VcUz7IK8sJbABWxxpkstqTTq4RBTlFvao1QxCxKmt2k
	 A3+EvSIReF0S1PQBuYIkpnIzndZ4XwKAGcs4CyP5ukl7EsTl+95a+vFw3IawKvdRqN
	 A2pZeytfavZLUwzwfGeJNZiPMnm6ZQrL0fNM//Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	": Aleksander Morgado" <aleksandermj@chromium.org>,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH 6.8 115/158] Revert "usb: cdc-wdm: close race between read and workqueue"
Date: Tue, 23 Apr 2024 14:38:57 -0700
Message-ID: <20240423213859.667424757@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 1607830dadeefc407e4956336d9fcd9e9defd810 upstream.

This reverts commit 339f83612f3a569b194680768b22bf113c26a29d.

It has been found to cause problems in a number of Chromebook devices,
so revert the change until it can be brought back in a safe way.

Link: https://lore.kernel.org/r/385a3519-b45d-48c5-a6fd-a3fdb6bec92f@chromium.org
Reported-by:: Aleksander Morgado <aleksandermj@chromium.org>
Fixes: 339f83612f3a ("usb: cdc-wdm: close race between read and workqueue")
Cc: stable <stable@kernel.org>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -485,7 +485,6 @@ out_free_mem:
 static int service_outstanding_interrupt(struct wdm_device *desc)
 {
 	int rv = 0;
-	int used;
 
 	/* submit read urb only if the device is waiting for it */
 	if (!desc->resp_count || !--desc->resp_count)
@@ -500,10 +499,7 @@ static int service_outstanding_interrupt
 		goto out;
 	}
 
-	used = test_and_set_bit(WDM_RESPONDING, &desc->flags);
-	if (used)
-		goto out;
-
+	set_bit(WDM_RESPONDING, &desc->flags);
 	spin_unlock_irq(&desc->iuspin);
 	rv = usb_submit_urb(desc->response, GFP_KERNEL);
 	spin_lock_irq(&desc->iuspin);


