Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8F6BA45;
	Fri,  9 Oct 2026 14:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556631; cv=none; b=YUrJ7fzzf6BFvaKFm++71UjiCKsW9OSKtuXBWZJQQXaJaCQQQ38fxpJsNjWBudV9FHNwiv1/A4HjK2xdAczL5LdkMxxluTZmLSj1ushUeCuar1PRu9MeKNSA3YEx5bMFCNE8MS3sxEh3OSIwInI8BCelbTRUdmSJU+lz+zdvmWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556631; c=relaxed/simple;
	bh=6ZNWLGYLXqCHkhlhIOA+Q5KiMtyvon4+qnbdyQZ9ZSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuZ6sjteol+m6ecX77fAJpGti9bCTbTJLMJvaLcMVCszYUQwNs8vnfWLeJCwj/6kePdzH9j7tWYBZzGNiYZSd1NPQJ+nDAqmoz9AOhDDi/KTS5wq64RdtJqYrYpN3ZlZO4nyQcm+M1E7Qfuqn6w/tdk10AphPzoSgRwWjsEVfqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILPaW/Y+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILPaW/Y+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A041F000FF;
	Fri,  9 Oct 2026 14:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556630;
	bh=bV5RnU0asS+mydyRkKTPJ/nbdm5UDfy+v2GEXSW47mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILPaW/Y+L26m7hTkz9lZCQk0FCzrIluEgoVX3nHYZaj+/4B5RAbh6Z2+gFjraeO26
	 mVCH5akuWGQHCPEG2pf5CatUiNj+jC3zEsPOEFTokm7QTR0WI1+1x9VAUK2+sbsd0L
	 DvBLNadrei2SdV6nEuEE1TXV6HM2JkXUaq7BXe/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 7.2 212/428] usb: ohci-s3c2410: disable controller wakeup on removal
Date: Fri,  9 Oct 2026 16:09:09 +0200
Message-ID: <20261009140950.784219059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 8dd8451c527e2a723bca20da5a6d724b8592551f upstream.

Probe enables controller wakeup after the OHCI core marks controllers with
RemoteWakeupConnected as wakeup-capable. Removal does not undo this, so the
wakeup source can remain attached after driver unbind.

Disable controller wakeup after removing the HCD.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: a6eeeb9f45b5 ("USB: Update USB default wakeup settings")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260915012011.61874-3-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-s3c2410.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/ohci-s3c2410.c
+++ b/drivers/usb/host/ohci-s3c2410.c
@@ -335,6 +335,7 @@ ohci_hcd_s3c2410_remove(struct platform_
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 	s3c2410_stop_hc(dev);
 	usb_put_hcd(hcd);
 }


