Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DC72D542A;
	Mon, 27 Oct 2025 19:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592101; cv=none; b=mJeqQq87UblhL9TwuTbJtKe2IOeENlFxNZQPjEnZDzGa0QfFXXKH/By1Tas7BjbK5DR1u4WvOWZGapEJvS8L2RtW42cUAbOE4ucR6Lb6REVelHDzpmg3tof8IfoTLoPfxd8XkotjOUycIpW0k4FR9CzSGB5uVJt+99gpnhS+1i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592101; c=relaxed/simple;
	bh=Q89GGbakGKsXFnNqmaVXtC3SFZ+X2LHIQ7QgXbaS4P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UvEHoYba9AXV1r9I/HAnB2NPjLDwlsaH6+KUHLAjUe0QGRmD2F06GpzzwhoEIKnJRUXZSj2C4r7bOkxBbF2UqvV1NA7xV6EZzRLL9YglRaRb3j4IB0dZaPTLNOk42E049Ypmd8UltV1z+et+VePd06NZIj9VHB24cfkcIfcmkvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHVwV7P/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHVwV7P/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E87C4CEF1;
	Mon, 27 Oct 2025 19:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592100;
	bh=Q89GGbakGKsXFnNqmaVXtC3SFZ+X2LHIQ7QgXbaS4P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHVwV7P/52TzpCIa1GpYhRAEimlcuwLDhRUELdFi0BaRQOHah7A4JmFPpGct6igah
	 XThFh9XIMyEZ+z2l0Z+7qDENzmuGXyeOFE1yWfHbTu6X15bSrETHix38X/eTcHXpzR
	 XITANWqkZpGWL0rAJ4uLq+M6nBpb+lp7xw2rkWLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/123] usb: gadget: Store endpoint pointer in usb_request
Date: Mon, 27 Oct 2025 19:36:37 +0100
Message-ID: <20251027183449.518612427@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

From: Kuen-Han Tsai <khtsai@google.com>

[ Upstream commit bfb1d99d969fe3b892db30848aeebfa19d21f57f ]

Gadget function drivers often have goto-based error handling in their
bind paths, which can be bug-prone. Refactoring these paths to use
__free() scope-based cleanup is desirable, but currently blocked.

The blocker is that usb_ep_free_request(ep, req) requires two
parameters, while the __free() mechanism can only pass a pointer to the
request itself.

Store an endpoint pointer in the struct usb_request. The pointer is
populated centrally in usb_ep_alloc_request() on every successful
allocation, making the request object self-contained.

Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://lore.kernel.org/r/20250916-ready-v1-1-4997bf277548@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20250916-ready-v1-1-4997bf277548@google.com
Stable-dep-of: 75a5b8d4ddd4 ("usb: gadget: f_ncm: Refactor bind path to use __free()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c |    3 +++
 include/linux/usb/gadget.h    |    2 ++
 2 files changed, 5 insertions(+)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -177,6 +177,9 @@ struct usb_request *usb_ep_alloc_request
 
 	req = ep->ops->alloc_request(ep, gfp_flags);
 
+	if (req)
+		req->ep = ep;
+
 	trace_usb_ep_alloc_request(ep, req, req ? 0 : -ENOMEM);
 
 	return req;
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -33,6 +33,7 @@ struct usb_ep;
 
 /**
  * struct usb_request - describes one i/o request
+ * @ep: The associated endpoint set by usb_ep_alloc_request().
  * @buf: Buffer used for data.  Always provide this; some controllers
  *	only use PIO, or don't use DMA for some endpoints.
  * @dma: DMA address corresponding to 'buf'.  If you don't set this
@@ -98,6 +99,7 @@ struct usb_ep;
  */
 
 struct usb_request {
+	struct usb_ep		*ep;
 	void			*buf;
 	unsigned		length;
 	dma_addr_t		dma;


