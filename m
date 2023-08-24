Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF79D14A82
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1046C433C7;
	Thu, 24 Aug 2023 17:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897485;
	bh=Wt9NNdV1UnrR9/casUh0yoYAx8UcY3rxk+QDPlC339g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ArJRMETjonVI3wqT9Ag7RylcH9sEkLNCK0xUYHhfl52S2ngoBgywcTKNYEvrM5/qX
	 WqtogwtSmJhN+HPSy0A62aPTJFIbaiX+Q5A5ki1Vosz2LMmbM1GV6riwftIIT7BBXX
	 VYc0JDxFhfCbfmkl41OW1QZtsRHeZO0jIFFM6SK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <wcheng@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/135] usb: gadget: udc: core: Introduce check_config to verify USB configuration
Date: Thu, 24 Aug 2023 19:08:47 +0200
Message-ID: <20230824170619.558675218@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

From: Wesley Cheng <wcheng@codeaurora.org>

[ Upstream commit ce7d0008c2356626f69f37ef1afce8fbc83fe142 ]

Some UDCs may have constraints on how many high bandwidth endpoints it can
support in a certain configuration.  This API allows for the composite
driver to pass down the total number of endpoints to the UDC so it can verify
it has the required resources to support the configuration.

Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1625908395-5498-2-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: dbe678f6192f ("usb: cdns3: fix NCM gadget RX speed 20x slow than expection at iMX8QM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/core.c | 19 +++++++++++++++++++
 include/linux/usb/gadget.h    |  4 ++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 3a3b5a03dda75..14d9d1ee16fc4 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1004,6 +1004,25 @@ int usb_gadget_ep_match_desc(struct usb_gadget *gadget,
 }
 EXPORT_SYMBOL_GPL(usb_gadget_ep_match_desc);
 
+/**
+ * usb_gadget_check_config - checks if the UDC can support the binded
+ *	configuration
+ * @gadget: controller to check the USB configuration
+ *
+ * Ensure that a UDC is able to support the requested resources by a
+ * configuration, and that there are no resource limitations, such as
+ * internal memory allocated to all requested endpoints.
+ *
+ * Returns zero on success, else a negative errno.
+ */
+int usb_gadget_check_config(struct usb_gadget *gadget)
+{
+	if (gadget->ops->check_config)
+		return gadget->ops->check_config(gadget);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(usb_gadget_check_config);
+
 /* ------------------------------------------------------------------------- */
 
 static void usb_gadget_state_work(struct work_struct *work)
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index e7351d64f11fa..11df3d5b40c6b 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -326,6 +326,7 @@ struct usb_gadget_ops {
 	struct usb_ep *(*match_ep)(struct usb_gadget *,
 			struct usb_endpoint_descriptor *,
 			struct usb_ss_ep_comp_descriptor *);
+	int	(*check_config)(struct usb_gadget *gadget);
 };
 
 /**
@@ -596,6 +597,7 @@ int usb_gadget_connect(struct usb_gadget *gadget);
 int usb_gadget_disconnect(struct usb_gadget *gadget);
 int usb_gadget_deactivate(struct usb_gadget *gadget);
 int usb_gadget_activate(struct usb_gadget *gadget);
+int usb_gadget_check_config(struct usb_gadget *gadget);
 #else
 static inline int usb_gadget_frame_number(struct usb_gadget *gadget)
 { return 0; }
@@ -619,6 +621,8 @@ static inline int usb_gadget_deactivate(struct usb_gadget *gadget)
 { return 0; }
 static inline int usb_gadget_activate(struct usb_gadget *gadget)
 { return 0; }
+static inline int usb_gadget_check_config(struct usb_gadget *gadget)
+{ return 0; }
 #endif /* CONFIG_USB_GADGET */
 
 /*-------------------------------------------------------------------------*/
-- 
2.40.1



