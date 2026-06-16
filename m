Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB151C5D72;
	Tue, 16 Jun 2026 16:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628805; cv=none; b=A8YRmCP0o4uPzu1gnja32Xh1hzV8dLoUIwlAOkEu8sdEF3goo/ogNcItDGmazuyQmgeOy2YLRshdSvX2ylkHFiLxbHODo+Gc1u7NUo0c7GwCVHEjDR7IQehusM8XeST3xrqNnUCFNpR/7O/Miu4BUxFjXvZUdtzOM8HwxHB9Azg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628805; c=relaxed/simple;
	bh=Xyd5SxW60b2ZIXr8Hfthy66lH4qzr5L45QTvt5+ow54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBJcu4VZp03an4t2eq0x0fgXJqxIM8L3hqyfpK1AkxJrD6yx7AXNLT+FzyiL7V3b5M4aFGk4egDuOqKT4drKO6egfHDRl6RxjraV/98LBXhGuCRQKRstveh6fEd2118BbaRNUWWiBI0EuahmUYPD9JfqHcx3UcI4WZbnfwVpaP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kzg/gdh3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kzg/gdh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7561F000E9;
	Tue, 16 Jun 2026 16:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628804;
	bh=aXOrtVgApQlGVaqIsqkf3/ndiap7aGn1Gwn5gBAJRi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kzg/gdh3xqRNOHCWvXpSDu37iZNFr7tdf9u4JFxu49nV7ZrQbmoGc8BM9jROfD+C5
	 96eviMWCRpLlufvQvgxkLwCyf1OKWSzZo9H/hyMMim1FI9f+CZD4A9fi2PBJR0sxri
	 5QKO6T5QTuI90oOmiit3pI10laFLlDcz+HizY/hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.6 165/452] usb: gadget: net2280: Fix double free in probe error path
Date: Tue, 16 Jun 2026 20:26:32 +0530
Message-ID: <20260616145126.515901935@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


