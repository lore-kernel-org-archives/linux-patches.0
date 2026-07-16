Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6BE4302E6;
	Thu, 16 Jul 2026 14:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212195; cv=none; b=sdr8CxmE77ObkZL6q617ABo+fWQsur6R/7AyJo3OmFsbZyeCBiZIl2uuqIH3hxjRXke0APHM1oBmke+DSNq6m0H3Bjf0JL19IEWrq/cKxJJwSRcMSYIA0hxAX8Fo+4nGn+sr1sal5vAKAxuZeb6Ye85uN0H9HYJcq+hjSvx6dgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212195; c=relaxed/simple;
	bh=x73epqNC3tKVTm3FBAbQVKm0blQ5NUw66+xKsgqu8sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+uE8RxAuXDm3aj/Wi/CXaNYTK/GK7H1MfyjuE8igO+i2IluNtIXDEJfBwE41F6xSrG9+SS21uvfj8BZKorqMezcFeUNOxBuaMuTw8dxvtvxF2r/alziYyauIy3dN0RhFDpdMC1r9YSmTE49+/xYgY7E5k74DIxEr4hVgdF1OoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0n7yB2xO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0n7yB2xO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A801F000E9;
	Thu, 16 Jul 2026 14:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212194;
	bh=RNQ5WmgfTDoOiu5YF+YZ15jfelCmtrfbjFL8ec+ax9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0n7yB2xOUW6AaQwmEt1+7N9P0imPg1RrAIVMvpf5XrJqKq4qUaPazLNHLy9bu3m9J
	 jTVc/Wa0dC074Rq6s//0lrrPOknuKeokqEGEKwo2xFYOut1zjWHZ08igtoqigj95dT
	 ZuDaeJMlkQC0MS08swF7dD9V7if1djMqvPRk9pGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 6.12 233/349] usb: sl811-hcd: disable controller wakeup on remove
Date: Thu, 16 Jul 2026 15:32:47 +0200
Message-ID: <20260716133038.579243557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


