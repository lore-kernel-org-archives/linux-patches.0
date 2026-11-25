Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626149;
	b=OUUN0YV/8pF2P5Cm3Jn7G2UapxXt1ns1Jqi12rWXve3yzpDkiSiOXovYmCx11CtRURBA
	 bRTpNPJyWXEj3tik1Zr9+zEbmP1GAcn0SPIDjBQLIDzRjFI5Jb0BmK0wakxn5mej2+uW0
	 oP2O9ZVGpomrnqsaA9cJnES6CezUrWWm1/9Mzzyf4YeuIH526NqsiYeZu/nzNh/4UACc3
	 Aeb1sONxG6vLgjvlqjaP4NFqxLRCL4RfK5v3Z8Mjw+qF4CSPzCv1deHwjubH8tu+Lb9t5
	 1BlQlM8F7c8TiLz94f38ATDQTYGklGfScxbSEiEITxkxng7o4iIEXpqxROkJZOI/8Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ThcF9M7idBkiF4p3fq1gEwwbGus9zT2NVx5n4L/ejug=;
	b=b+Gnh3Fx9jeBbVim8UANmOrsQ1e3IKbyZanPXzqIhl23ho2lJOLFINiagPgVNBfUEwyy
	 ZKoxErnpYS4pCDersY+mN3dKeAA3tcKa6P3Hc/N1Rke8A53Cx+8Exc/Y6WDyVADEDTfCr
	 6+DeXcNnnZO6bX6+iR/Urv2hH+sv9UIx/IxvBdLf8All3XUFsztk88kOWEAlU2L7EbfB6
	 +J3k3CP/C/P8xy8ScNtN4HDrwz0zEVzxxVzfPwiXzQkghJ6AHuVQW5IIWebGmKV9uUdfd
	 5wWYEdfBEDTLHilxCkea05sZfWsJMoiTwVF3XMkLwUchUVxKEkG29pfKJ56wP/RPgbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BaCu36gc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7FF606A31E;
	Wed, 25 Nov 2026 17:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BaCu36gc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9A61F000CA;
	Wed, 25 Nov 2026 17:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626149;
	bh=ThcF9M7idBkiF4p3fq1gEwwbGus9zT2NVx5n4L/ejug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BaCu36gc59OL6Vyo/FyUd4Ww/IKE7UCferF0NQdVuKCBMpUSAzMaQ/fbC2qwLrq3b
	 FqGB5aP+Zy5TMYqeuekRaAINjwEE8+Vyf/s8/J3ibcof2WXz30n2MQUCYM+5MMhdTC
	 cAuyOmjGSSh+4CvwZI4zULMcMJ05Y9CmORhMVQ+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 746/816] usb: xhci: disable the correct slot on alloc_dev failure
Date: Wed, 25 Nov 2026 15:38:14 +0100
Message-ID: <20261125143906.444071533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit 2f2fe3201029ffc215b46ac40a0a9587715bc43a upstream.

xhci_alloc_dev() stores the Slot ID returned by the Enable Slot command
in the local slot_id variable.  udev->slot_id is updated only after
xhci_alloc_virt_device() succeeds.

If endpoint resource reservation or virtual device allocation fails
before that update, the error path passes udev->slot_id to
xhci_disable_and_free_slot().  During initial enumeration this is slot 0.
When reallocating a device whose virtual device is missing or belongs to
another usb_device, udev->slot_id may contain a stale Slot ID.
The newly enabled slot can therefore remain active, or the wrong slot can
be disabled.

Pass slot_id, which identifies the slot enabled by this invocation.
xhci_disable_and_free_slot() already handles a missing xhci->devs entry.

Fixes: 3ffbba9511b4 ("USB: xhci: Allocate and address USB devices")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Reviewed-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20261105175106.241182-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4090,7 +4090,7 @@ int xhci_alloc_dev(struct usb_hcd *hcd,
 	return 1;
 
 disable_slot:
-	xhci_disable_and_free_slot(xhci, udev->slot_id);
+	xhci_disable_and_free_slot(xhci, slot_id);
 
 	return 0;
 }


