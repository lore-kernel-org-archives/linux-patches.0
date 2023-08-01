Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02AB200A5
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526AAC433C9;
	Tue,  1 Aug 2023 09:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882591;
	bh=aKcpZcOKnYcKBFVYwtqfV5KdSDbTbMIuH6bbFviXzsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FY0KBgRil3sCeo27PvgqtxeSxLpi2XM6G+W9DIMeGRL0ZmHWMJ/22/i8iw1Ih0Tex
	 cBiNfyDhIFfd0Y9N5c40512g/PaG7ZaUDIVllTkxlGJeP3/0ZFppewlh4rj01NsY4s
	 xMooVZB1XLN3Pl1Z6Jz9gjwgZwbrv7yZlHnkLPB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Tso <kyletso@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 161/228] usb: typec: Set port->pd before adding device for typec_port
Date: Tue,  1 Aug 2023 11:20:19 +0200
Message-ID: <20230801091928.696879824@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kyle Tso <kyletso@google.com>

commit b33ebb2415e7e0a55ee3d049c2890d3a3e3805b6 upstream.

When calling device_add in the registration of typec_port, it will do
the NULL check on usb_power_delivery handle in typec_port for the
visibility of the device attributes. It is always NULL because port->pd
is set in typec_port_set_usb_power_delivery which is later than the
device_add call.

Set port->pd before device_add and only link the device after that.

Fixes: a7cff92f0635 ("usb: typec: USB Power Delivery helpers for ports and partners")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Tso <kyletso@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230623151036.3955013-2-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -2259,6 +2259,8 @@ struct typec_port *typec_register_port(s
 		return ERR_PTR(ret);
 	}
 
+	port->pd = cap->pd;
+
 	ret = device_add(&port->dev);
 	if (ret) {
 		dev_err(parent, "failed to register port (%d)\n", ret);
@@ -2266,7 +2268,7 @@ struct typec_port *typec_register_port(s
 		return ERR_PTR(ret);
 	}
 
-	ret = typec_port_set_usb_power_delivery(port, cap->pd);
+	ret = usb_power_delivery_link_device(port->pd, &port->dev);
 	if (ret) {
 		dev_err(&port->dev, "failed to link pd\n");
 		device_unregister(&port->dev);


