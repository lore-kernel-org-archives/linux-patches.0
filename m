Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4723FF1AE;
	Thu, 16 Jul 2026 13:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209887; cv=none; b=HiZzt/DuRw1jTJ8WXHSJdLJwEHYXtc7Q81qn3B8G8e9ndPJgM1pQf0XdSs87asEY9UZO5EI2Jzi/i+7yDWa/67N+ih/pGmBhT/8W0ohx4qwG0pMp3nFzjWZdgDgyaov+jjuovpxqNlvLG+n6NiEUvngsSeA1Q/nglvcQzDIoTw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209887; c=relaxed/simple;
	bh=VfEIaxe55/X/sKY1uGORlpwFkrs93hIfFjKatm9Wc4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSqN+2kHEMTsQziYK/8YRmJg1Z2+/6fR2e+fqiI/4oaNRybK+oa6GgqHVq4n8wmoHn9slSitxMO3spCWxWP9af8tZT03HjjCpR4zI6EyF+72PaOqmfr4pB5Nc7m2f0XSCa0ZdjZ67jg7lNQP71o3lEfqD8GZkfXIz6rll4ctAmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oa464pMs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oa464pMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35841F000E9;
	Thu, 16 Jul 2026 13:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209886;
	bh=+h8rTlK6LDFAA1NfD7FXrFNioZA6TIgqOv0k1DhOyOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oa464pMsZ5wod4DkAKKMiXV8BtkMoapE+V/KygyX26C1ydhgHUP+DZywsH6QSoRdK
	 gn5yPK8dE3569KVVMtI0uoMoj1WIIX4gOUYXEzicB4TCIh2reb/PW1Dklk+IiaSAlH
	 tk0wJPn/xA2pXK+TKo2QZMrhvyGdzNaTiEvlnFbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 7.1 313/518] usb: sl811-hcd: disable controller wakeup on remove
Date: Thu, 16 Jul 2026 15:29:41 +0200
Message-ID: <20260716133054.672817578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 4e8ba83ac4d311992e6a4c21de5dd705010df06e upstream.

sl811h_probe() enables the HCD controller device as a wakeup source after
usb_add_hcd() succeeds, but sl811h_remove() removes the HCD and releases
the driver resources without disabling that wakeup source.

Disable controller wakeup after usb_remove_hcd() and before usb_put_hcd()
so the wakeup source object is detached while the controller device pointer
is still available.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 3c9740a117d4 ("usb: hcd: move controller wakeup setting initialization to individual driver")
Cc: stable <stable@kernel.org>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260701121625.96815-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/sl811-hcd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -1591,6 +1591,7 @@ sl811h_remove(struct platform_device *de
 
 	remove_debug_file(sl811);
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 
 	/* some platforms may use IORESOURCE_IO */
 	res = platform_get_resource(dev, IORESOURCE_MEM, 1);


