Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBC52E7390;
	Sun,  7 Jun 2026 10:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829383; cv=none; b=XldHWjo+K4L4yN5JvbBTHjRDl8c2osaXzD4AkMe91pA6gjTI3ftauAo+UydNVpc8dWh8LP0Devz4eSpD1HUifG8CBrwtyVzXTsPFvKPc4AnTfdHk8oIE1FI4ugti1Y7WdoofhoLroLjGzK9W3vQl221sbvxWFe6nmT9Uw50eB1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829383; c=relaxed/simple;
	bh=QTqthjTLXLnyhvfiSifj9snNfnZ6azXR5MkssYXam28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzVgxAwlWPAwTydADCC2COXkWmiuRnsNmoNOW/qpCjqADD7e8t0IosLzTLC5KNNhFk3ezRHUVdmrfBcnQiz7UBy9nuUPJvHRR1S5bShKvBzK9HtvFyt43XFK3zGGnzTbXK+QOsReaa5WVHFhjc6PqwZg9ZvoPeQz+ucHnO/TOlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANsedkTH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANsedkTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E951F00893;
	Sun,  7 Jun 2026 10:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829382;
	bh=/X9Jcpv26XutaUb7YNbfndMZ9IbQABy93oXkhVb7qbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ANsedkTHPI8MU1ILD/15bZFpCrk2X8oxFRB1VDhq6smFM9RFlZT9T1zrtHbrm4vFS
	 WYhmuwf78VIjRY1pYYYhBamtmJefWbVbp/brHMy5re+GCgBQFvnbIW40A72Mzy/+p9
	 lpQAjxIcIDvavINakwUNSnq8UxxcPhgFWvVlmmD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 7.0 274/332] usb: gadget: net2280: Fix double free in probe error path
Date: Sun,  7 Jun 2026 12:00:43 +0200
Message-ID: <20260607095738.112142154@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit c8547c74988e0b5f4cbb1b895e2a57aae084f070 upstream.

usb_initialize_gadget() installs gadget_release() as the release
callback for the embedded gadget device.  The struct net2280 instance is
therefore released through gadget_release() when the gadget device's last
reference is dropped.

The probe error path calls net2280_remove(), which tears down the
partially initialized device and drops the gadget reference with
usb_put_gadget().  Calling kfree(dev) afterwards can free the same object
again.

Drop the explicit kfree() and let the gadget device release callback
handle the final free.  This issue was found by a static analysis tool
I am developing.

Fixes: f770fbec4165 ("USB: UDC: net2280: Fix memory leaks")
Cc: stable <stable@kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260427153651.337846-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/net2280.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -3790,10 +3790,8 @@ static int net2280_probe(struct pci_dev
 	return 0;
 
 done:
-	if (dev) {
+	if (dev)
 		net2280_remove(pdev);
-		kfree(dev);
-	}
 	return retval;
 }
 


