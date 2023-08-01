Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C04E1F955
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568DCC433C8;
	Tue,  1 Aug 2023 09:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881992;
	bh=VT/91pgKjNCt/BsoG3IcvlM8apZHOO/cvtmaGhHIg+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1C08aXojS9Y2GycXu0cDBq/u+rawHBuQ74JHgMPDVA7iICqUK3YfToO4/BKxBJowp
	 sYvyWiqKuVDdVZeA9cU0l18fClRC2xqYNVHW0a7kdNC5jVxxP88Uk8xrjBqmoCHqkd
	 NNtp5Fn5eILuxLozGAWTZ5/ch9JFp607nByhIkII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ravi Gunasekaran <r-gunasekaran@ti.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 5.15 102/155] usb: gadget: call usb_gadget_check_config() to verify UDC capability
Date: Tue,  1 Aug 2023 11:20:14 +0200
Message-ID: <20230801091913.871481175@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frank Li <Frank.Li@nxp.com>

commit f4fc01af5b640bc39bd9403b5fd855345a2ad5f8 upstream.

The legacy gadget driver omitted calling usb_gadget_check_config()
to ensure that the USB device controller (UDC) has adequate resources,
including sufficient endpoint numbers and types, to support the given
configuration.

Previously, usb_add_config() was solely invoked by the legacy gadget
driver. Adds the necessary usb_gadget_check_config() after the bind()
operation to fix the issue.

Fixes: dce49449e04f ("usb: cdns3: allocate TX FIFO size according to composite EP number")
Cc: stable <stable@kernel.org>
Reported-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20230707230015.494999-1-Frank.Li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1033,6 +1033,10 @@ int usb_add_config(struct usb_composite_
 		goto done;
 
 	status = bind(config);
+
+	if (status == 0)
+		status = usb_gadget_check_config(cdev->gadget);
+
 	if (status < 0) {
 		while (!list_empty(&config->functions)) {
 			struct usb_function		*f;


