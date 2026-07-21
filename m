Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9364244AB9F;
	Tue, 21 Jul 2026 22:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673286; cv=none; b=Wsdkxc+p6y+pbs0/GEfVlRrhz+7IXXUkCSS8+XUKDW95BYNZ22eC0OvxmEkW9xD+v3oCKV8CHuZH5t3xIBzupaK3TLINGq+SCs0M5qBkbosF/qlCYHCkNskiJbZfCyQ+6RyANW4U7DwaXD8zYbWIy5X/2zen65RBNNIAqgeNHf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673286; c=relaxed/simple;
	bh=rLFzjgHvYTHCiMWahKOVHFhbzI++zkdW4Es06GvPrec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzbTyyrHjxa8OH2DShsDo6lfZKFrCOF9Q+u/0N6hpv4L1UiJv4Yjj1EABcdD+Al26SPuCsShK8/HSFbeQjBWeSnMzOzOyyMLpJ/llN0TPFOeT+auxhKbAabJoRbHacR9p2V9d6gTQpcILLJZ5nvSIFlAN4uQw1czh3ULLuAvmzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMwjaZck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMwjaZck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045761F000E9;
	Tue, 21 Jul 2026 22:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673285;
	bh=QNvBdKGAOA/b5XPq/FMRJYIXQVq6cUFMdohWaymK8pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xMwjaZckfUORl2gOlC/987lRT63CQklWcEWpHrb65/xFIvr+lVKI2Ty0nX079yb52
	 gMf2KEcgn7M6RgcvsAQy1C0cUpUzlN4No0OSGYlYQt1NFJN+CaJK8Wxkem/2wZCM2i
	 RaRLRVampaRllBjQ2JIi+8zjCnRi30R0AiGuLJRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 5.10 105/699] usb: sl811-hcd: disable controller wakeup on remove
Date: Tue, 21 Jul 2026 17:17:44 +0200
Message-ID: <20260721152358.069628072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


