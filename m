Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802BB400DE1;
	Tue, 21 Jul 2026 20:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665261; cv=none; b=nx2GsjpV3UqOMHfarAFXTdW5aXXlDFTHJMetc7A6Lu+ffr6bm6lW/O150KxnJlqQ6xbyuDNln5+rZ5r773dJQi5MlVicnyVALCjwnhigrqGbpaOQaQSJQqu9OnaMWSXmOy697XicPzVxDku0ypTU7DFCGz5NQa3M/lcru3GPldU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665261; c=relaxed/simple;
	bh=GLbLz79QKz/hloscuXtZjIgVNW6JFp6mHLANBWXzUoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Epv33pU6FfK8unV6ksZfjNjq9KBUg1Hh4/JX6bjREWLgbmaI8VIvqTp6di/oE3I4X7uITje9RYMhHZ6TqQeqQQqwdmztkR1E6Qnb3TWW9yL8hJhgG/ZyQ3n8/NAV/kc10Ua4ZSHKERPhtpjVEzp5khTzeCiZR5UNSQZqimH4ZW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBUGRC+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBUGRC+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2B51F000E9;
	Tue, 21 Jul 2026 20:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665260;
	bh=PF29uCw/c/bdHXVA65RozlMvk3tHdBUO2ea4tnarOlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jBUGRC+wldkbjzKPEAf37RB68824N57jHYQO2zKXvS3jEjfOPw3Y3iOL7ehaXgFT3
	 z4SL4B7bcJa4Lfd2aFuYIj65oHBkeXA2+DFeo6HqXpVwWmSaSxJhwJNtPVBFF2PjUX
	 nE+G//Cm66XEosZ64nlNS0AmN3p36tsLjZQCG0go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 6.6 0238/1266] usb: sl811-hcd: disable controller wakeup on remove
Date: Tue, 21 Jul 2026 17:11:15 +0200
Message-ID: <20260721152447.144286658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


