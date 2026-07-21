Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A120944211F;
	Tue, 21 Jul 2026 21:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671152; cv=none; b=I01fHlbK0PksD+i/nGGntnXHcxeiDmqhrgzp2z7XfeauHo5VxlkOEIJw/O2BVL7zWHyGZWCJkNh0IFxmj68ehCXPRFUOgk5E3V9nrYxvGqq+6AGgblgQO8krMdeah+Pekk1PTPFCcyeK2Gu3tWdZmE+ymzf1yseHBC4LhTthc2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671152; c=relaxed/simple;
	bh=0d3Z2YHzdb7dBDZXh05VyG7m64yzzWyMsDGs0uFnlig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDFNIaq1+w9U41KJ9NBMzj+aZobu47iVcXXYYB5aqsMzJktOyXs5qB+e2FOHgK7j68zBQJ1aq2aPH9pcL51pSFI4QCR/LZcDAne9iKhZQLc1K9voOaT6hMZVjWQbbwt7dTZwMRJHrkIX7VnnKipAhwspvQThY2yP97Jhm772hzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0sQMs3i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0sQMs3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EA41F000E9;
	Tue, 21 Jul 2026 21:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671151;
	bh=1CcrHkn6hwJxrk7/fHejlVN+WEfrr768IjGM0vYZQAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0sQMs3iTBKapzs2CICBU0ALzwMFSC3St9EBeI4gUUj0Fwjom8FUNhPdGHP6/f/52
	 7EFxB7XD0sH8rsU0uHWrwvNUX7YfQwn+plTa2FVwlNqCp24zlaNgmk0MP2nL8i4gXc
	 k5zsDRU4xDpv0HoUJifPrntqMGWiZOBoCql0zXk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 5.15 139/843] usb: sl811-hcd: disable controller wakeup on remove
Date: Tue, 21 Jul 2026 17:16:14 +0200
Message-ID: <20260721152409.140788250@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1590,6 +1590,7 @@ sl811h_remove(struct platform_device *de
 
 	remove_debug_file(sl811);
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 
 	/* some platforms may use IORESOURCE_IO */
 	res = platform_get_resource(dev, IORESOURCE_MEM, 1);


