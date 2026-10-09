Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1D031E85E;
	Fri,  9 Oct 2026 14:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556626; cv=none; b=fcjxuDQXHhiuuEX2J3uWa3NG4iMpUHO2ps/WUG3KTUxG468tqierIOm9usbay2FsdmKG0CDxbdc1WkkfzNZx63UWL6au3aW1oUijXAS3Y1//CT0VSgk649tUBC5PewexmJnsgJu2a+qkAT1OzCs8JFknoLdTwt6aBXrDEUccig4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556626; c=relaxed/simple;
	bh=Earr8pPTseHTDS0SdahOIZscf93AJcZAVE+mUeTLJFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMoC9LwTU4+7fjgmoipxQwelzYN5oQqO0wRGwucYofPp4IWbveE4SeAZo+Wj9KADHMjXa3K+cYztweQ8DmLoE0SUi1cwEhNDYIMFskTca21sgcoa+zWiEGl2hOYTLvQvJkJcofoPqjPU1wCdjwvbF4X52O6TQAsJvW5goFoz85k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8HrxGh/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8HrxGh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8CA1F000FF;
	Fri,  9 Oct 2026 14:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556625;
	bh=PxPqohjXgEf/LMNSfMfx9ZVbZuJT8LVgPqT1mOpSTZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E8HrxGh/aBbee91JrpHRM2XjEVMeHpGkWLrwytdACuhIaV0ylfHBy5tgx8RJNvXMO
	 gTGq2Ix0TrGlOIR9kMHnWLTOZHcs92aCYgrvXGXpPvz2Fo9jIhp2Uu6L4n9+wiE1Qg
	 4GnrVmTXPvekYPVMexzIq4yLcjxTDUNWzJcHqSp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 7.2 211/428] usb: ohci-da8xx: disable controller wakeup on cleanup
Date: Fri,  9 Oct 2026 16:09:08 +0200
Message-ID: <20261009140950.762292963@linuxfoundation.org>
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

commit 901197dd4c7dcffbf97426487d4c047555c98554 upstream.

The OHCI core marks controllers with RemoteWakeupConnected as
wakeup-capable. Probe enables wakeup, but neither removal nor a later
notifier registration failure disables it, leaving the wakeup source
attached.

Disable controller wakeup after removing the HCD on both paths.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: a6eeeb9f45b5 ("USB: Update USB default wakeup settings")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260915012011.61874-2-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-da8xx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/ohci-da8xx.c
+++ b/drivers/usb/host/ohci-da8xx.c
@@ -447,6 +447,7 @@ static int ohci_da8xx_probe(struct platf
 
 err_remove_hcd:
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 err:
 	usb_put_hcd(hcd);
 	return error;
@@ -457,6 +458,7 @@ static void ohci_da8xx_remove(struct pla
 	struct usb_hcd	*hcd = platform_get_drvdata(pdev);
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 	usb_put_hcd(hcd);
 }
 


