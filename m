Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C000133CFD;
	Fri, 24 Nov 2023 19:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9N/nkX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA9BC433C8;
	Fri, 24 Nov 2023 19:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852588;
	bh=amyljbAvqpa/r55bC2seaX3bdSTyAtHjS1WlYcDVeeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9N/nkX86kaVCj3BwIfPPl7uNDCRl0rnDAtmkwbRejupOj2Q4DkcyEfWYdO/RiSxB
	 5nAFgQEU7Te0FFaWv+1dkMqUib9o0nYUd0K3Xu128YF365suU2VsyxoofMx0XD4om1
	 dXrYXirRHPtGEnHD90MQlYojkPRIm7ByIJ2ny/u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hardik Gajjar <hgajjar@de.adit-jv.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/193] usb: gadget: f_ncm: Always set current gadget in ncm_bind()
Date: Fri, 24 Nov 2023 17:52:51 +0000
Message-ID: <20231124171949.020114354@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hardik Gajjar <hgajjar@de.adit-jv.com>

[ Upstream commit a04224da1f3424b2c607b12a3bd1f0e302fb8231 ]

Previously, gadget assignment to the net device occurred exclusively
during the initial binding attempt.

Nevertheless, the gadget pointer could change during bind/unbind
cycles due to various conditions, including the unloading/loading
of the UDC device driver or the detachment/reconnection of an
OTG-capable USB hub device.

This patch relocates the gether_set_gadget() function out from
ncm_opts->bound condition check, ensuring that the correct gadget
is assigned during each bind request.

The provided logs demonstrate the consistency of ncm_opts throughout
the power cycle, while the gadget may change.

* OTG hub connected during boot up and assignment of gadget and
  ncm_opts pointer

[    2.366301] usb 2-1.5: New USB device found, idVendor=2996, idProduct=0105
[    2.366304] usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.366306] usb 2-1.5: Product: H2H Bridge
[    2.366308] usb 2-1.5: Manufacturer: Aptiv
[    2.366309] usb 2-1.5: SerialNumber: 13FEB2021
[    2.427989] usb 2-1.5: New USB device found, VID=2996, PID=0105
[    2.428959] dabridge 2-1.5:1.0: dabridge 2-4 total endpoints=5, 0000000093a8d681
[    2.429710] dabridge 2-1.5:1.0: P(0105) D(22.06.22) F(17.3.16) H(1.1) high-speed
[    2.429714] dabridge 2-1.5:1.0: Hub 2-2 P(0151) V(06.87)
[    2.429956] dabridge 2-1.5:1.0: All downstream ports in host mode

[    2.430093] gadget 000000003c414d59 ------> gadget pointer

* NCM opts and associated gadget pointer during First ncm_bind

[   34.763929] NCM opts 00000000aa304ac9
[   34.763930] NCM gadget 000000003c414d59

* OTG capable hub disconnecte or assume driver unload.

[   97.203114] usb 2-1: USB disconnect, device number 2
[   97.203118] usb 2-1.1: USB disconnect, device number 3
[   97.209217] usb 2-1.5: USB disconnect, device number 4
[   97.230990] dabr_udc deleted

* Reconnect the OTG hub or load driver assaign new gadget pointer.

[  111.534035] usb 2-1.1: New USB device found, idVendor=2996, idProduct=0120, bcdDevice= 6.87
[  111.534038] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  111.534040] usb 2-1.1: Product: Vendor
[  111.534041] usb 2-1.1: Manufacturer: Aptiv
[  111.534042] usb 2-1.1: SerialNumber: Superior
[  111.535175] usb 2-1.1: New USB device found, VID=2996, PID=0120
[  111.610995] usb 2-1.5: new high-speed USB device number 8 using xhci-hcd
[  111.630052] usb 2-1.5: New USB device found, idVendor=2996, idProduct=0105, bcdDevice=21.02
[  111.630055] usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  111.630057] usb 2-1.5: Product: H2H Bridge
[  111.630058] usb 2-1.5: Manufacturer: Aptiv
[  111.630059] usb 2-1.5: SerialNumber: 13FEB2021
[  111.687464] usb 2-1.5: New USB device found, VID=2996, PID=0105
[  111.690375] dabridge 2-1.5:1.0: dabridge 2-8 total endpoints=5, 000000000d87c961
[  111.691172] dabridge 2-1.5:1.0: P(0105) D(22.06.22) F(17.3.16) H(1.1) high-speed
[  111.691176] dabridge 2-1.5:1.0: Hub 2-6 P(0151) V(06.87)
[  111.691646] dabridge 2-1.5:1.0: All downstream ports in host mode

[  111.692298] gadget 00000000dc72f7a9 --------> new gadget ptr on connect

* NCM opts and associated gadget pointer during second ncm_bind

[  113.271786] NCM opts 00000000aa304ac9 -----> same opts ptr used during first bind
[  113.271788] NCM gadget 00000000dc72f7a9 ----> however new gaget ptr, that will not set
                                                 in net_device due to ncm_opts->bound = true

Signed-off-by: Hardik Gajjar <hgajjar@de.adit-jv.com>
Link: https://lore.kernel.org/r/20231020153324.82794-1-hgajjar@de.adit-jv.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_ncm.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/gadget/function/f_ncm.c b/drivers/usb/gadget/function/f_ncm.c
index 00aea45a04e95..d42cd1d036bdf 100644
--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1435,7 +1435,7 @@ static int ncm_bind(struct usb_configuration *c, struct usb_function *f)
 	struct usb_composite_dev *cdev = c->cdev;
 	struct f_ncm		*ncm = func_to_ncm(f);
 	struct usb_string	*us;
-	int			status;
+	int			status = 0;
 	struct usb_ep		*ep;
 	struct f_ncm_opts	*ncm_opts;
 
@@ -1453,22 +1453,17 @@ static int ncm_bind(struct usb_configuration *c, struct usb_function *f)
 		f->os_desc_table[0].os_desc = &ncm_opts->ncm_os_desc;
 	}
 
-	/*
-	 * in drivers/usb/gadget/configfs.c:configfs_composite_bind()
-	 * configurations are bound in sequence with list_for_each_entry,
-	 * in each configuration its functions are bound in sequence
-	 * with list_for_each_entry, so we assume no race condition
-	 * with regard to ncm_opts->bound access
-	 */
-	if (!ncm_opts->bound) {
-		mutex_lock(&ncm_opts->lock);
-		gether_set_gadget(ncm_opts->net, cdev->gadget);
+	mutex_lock(&ncm_opts->lock);
+	gether_set_gadget(ncm_opts->net, cdev->gadget);
+	if (!ncm_opts->bound)
 		status = gether_register_netdev(ncm_opts->net);
-		mutex_unlock(&ncm_opts->lock);
-		if (status)
-			goto fail;
-		ncm_opts->bound = true;
-	}
+	mutex_unlock(&ncm_opts->lock);
+
+	if (status)
+		goto fail;
+
+	ncm_opts->bound = true;
+
 	us = usb_gstrings_attach(cdev, ncm_strings,
 				 ARRAY_SIZE(ncm_string_defs));
 	if (IS_ERR(us)) {
-- 
2.42.0



