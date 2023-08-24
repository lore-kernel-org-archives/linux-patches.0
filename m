Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB6A11C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71072C433C8;
	Thu, 24 Aug 2023 15:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889233;
	bh=Sm/ZJ8l1R3DdTYFes552ntbOga/iLMroGccfMcQmpt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhSuxSjJlypgpQG5hTy+DySoQbT8weIgtD2NhwqmU6R39bvP6/a8QDM51L6gPey4M
	 jn3zyndm0pJr1VsQPcJNSJNRVUk6oO8AWjTIqWhH65x9AAhGAO/yMhPOACdvOEefPJ
	 upAFKFawsNpYFaH8iRLhQ28yqari3Jg59X8fS4bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <wcheng@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/135] usb: gadget: udc: core: Introduce check_config to verify USB configuration
Date: Thu, 24 Aug 2023 16:49:58 +0200
Message-ID: <20230824145029.274443774@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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



