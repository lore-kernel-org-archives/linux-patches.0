Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5FF3F888C;
	Thu, 16 Jul 2026 13:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209890; cv=none; b=Xg77fZtof9Zbf2fJoYlminLWxtjq5a9N/iETkRCL5jIW3UhU245fXIdh/9u4wrURDcAHC5EDNBlk0gni5aoSeilky9+E04+oEQPUb+vGSIDNL58JkoiomI7i2mOgkJ1pLA9hBGadhp5+Iymie+rHzId5SM+zpvv+4es/2+hwfLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209890; c=relaxed/simple;
	bh=rL01Jz+fT48toQ8fRe6AXC4fTC1ZWnKYG6UN4/CPYpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUVzotfy2yZiaiYJ8z7h0M49XSc2bFSAGBbyUKG30UYgi0a9UyIP/L43EaxWQoCPtGg/NKHkE2celFBbMcgn6wIMQ+AyHgwGesQbCA8/6DFPbMyI1VR58HVSG4dn/EGP1UHlp2IKdiwnuFOC5RSWh1QWVB5E3A1k/eQ+xz5eGw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOngEZrk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOngEZrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593FB1F000E9;
	Thu, 16 Jul 2026 13:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209888;
	bh=qfWYROYafpS3uGn3GgPCsJVqRxJmyIgbbt1lrdxo12s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IOngEZrkPvnmpNJVl1a40ziQ3QYjcTIGp+JqmBEu4KdgquN+OrOmaFTviySkv2JPC
	 Qbby4QUQXgC3DDFeyP0BG/xkmujSjeHwkWxGo08chZYnJmmnSbAy/DNP5U2zhZ3KC+
	 58tNFp9n0vpII00ztjT4B7S/KKPuPZdAynSJ9TzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Maoyi Xie <maoyixie.tju@gmail.com>
Subject: [PATCH 7.1 304/518] usb: gadget: composite: fix dead empty check in the USB_DT_OTG handler
Date: Thu, 16 Jul 2026 15:29:32 +0200
Message-ID: <20260716133054.476159796@linuxfoundation.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit f8f680609c2b3ab795ffcd6f21585b6dfc46d395 upstream.

The OTG branch of composite_setup() falls back to the first
configuration when none is selected:

	if (cdev->config)
		config = cdev->config;
	else
		config = list_first_entry(&cdev->configs,
					  struct usb_configuration, list);
	if (!config)
		goto done;
	...
	memcpy(req->buf, config->descriptors[0], value);

list_first_entry() never returns NULL. On an empty list it returns
container_of() of the list head. So the "if (!config)" check is dead.

When cdev->configs is empty, config points at the head inside struct
usb_composite_dev. config->descriptors[0] reads whatever sits at that
offset. The memcpy copies up to w_length bytes of it into the response
buffer.

cdev->configs can be empty in two cases. One is a teardown race on
gadget unbind with a control transfer in flight. The other is a driver
that sets is_otg before it adds a config. A reproducer that holds
cdev->configs empty triggers a KASAN fault in this branch.

Use list_first_entry_or_null() so the existing check does its job.

Fixes: 53e6242db8d6 ("usb: gadget: composite: add USB_DT_OTG request handling")
Cc: stable <stable@kernel.org>
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://patch.msgid.link/20260527150832.2943293-1-maoyixie.tju@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1863,9 +1863,10 @@ composite_setup(struct usb_gadget *gadge
 				if (cdev->config)
 					config = cdev->config;
 				else
-					config = list_first_entry(
+					config = list_first_entry_or_null(
 							&cdev->configs,
-						struct usb_configuration, list);
+							struct usb_configuration,
+							list);
 				if (!config)
 					goto done;
 


