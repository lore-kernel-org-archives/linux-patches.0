Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAA2399CE9;
	Fri,  9 Oct 2026 14:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556061; cv=none; b=IwC4PBnPqssgV2oU03NXelp2+I+Su0bR3TJ8I4EWKVf7TXC8QIXDIZtxUc2YXjhW0sMWUwkIj5U2YfFvt2BlOip29odIA8e1u2K9AhzWDg1x3E32Ujs+xt/UdRKB7ms0i+QVfOoFgA6lkv7TEHu24pEJgi7R93aXHdzQvK4ldxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556061; c=relaxed/simple;
	bh=FGp7o0ZvFbIlLMgtDF0z14pTZsN3lJ7WnbcnMDjQrDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVEp8NOhte3MhF5UjZFK4cyn/nD2zvTBtce4NFNe83yI9y8bklfQlVyWfbIZJLNeGbz0SfAFgYsuBqZzkFoZLeIGTweTKF3Fd+W3F97Q3ST7ooz1gup0s6gFzYaoBuJ0gpdc1VLotEmVsBMcwTgJYqHdYyGjid4zFUy+qtYGRW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjkDFXRK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjkDFXRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C371F000FF;
	Fri,  9 Oct 2026 14:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556060;
	bh=KU4QLGUoGLZ9KcY54hFtRh9ihtBAiTu+daV+KjE6cVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjkDFXRKsHt85RxHZtR+gVTBFfuLY8iFSbM0HuD/Sjxf/tBtGbsuk2DYNTHHWEpYO
	 Oukz/qBAAVuPOb1KRQRMYpp1hAL0Xk9jaI7x58EbGVE6YTX89O9hBgBbSMf9qFa8Pe
	 aW69oRLC6rbPi/RtNTGOYcACByOWVJNr6Daz3z4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.18 168/403] usb: ohci-spear: disable controller wakeup on removal
Date: Fri,  9 Oct 2026 16:08:49 +0200
Message-ID: <20261009140956.032270061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit b1b0f8bdbbc891a4ee7f3b1a878c633e02b7bbeb upstream.

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
Link: https://patch.msgid.link/20260915012011.61874-4-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-spear.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/ohci-spear.c
+++ b/drivers/usb/host/ohci-spear.c
@@ -103,6 +103,7 @@ static void spear_ohci_hcd_drv_remove(st
 	struct spear_ohci *sohci_p = to_spear_ohci(hcd);
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 	clk_disable_unprepare(sohci_p->clk);
 
 	usb_put_hcd(hcd);


