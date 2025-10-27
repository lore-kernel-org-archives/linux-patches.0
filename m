Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAD931BC84;
	Mon, 27 Oct 2025 19:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592247; cv=none; b=B9qHS2YjYfyVlAE8Xq7ElrQHScxUZq+H6sEGAAMGOIggXEEdJZgpaSZP2+ffW27wuM/SaX4yhCpVNjgdfwuMUOrIoWxdnLKOa+RHbPeO1AlYQa3/WpU+SxLY11z0+TA5q83qjKZEvfjMSvi0ipeac5TPb9mifKq1IMsRbpE4zCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592247; c=relaxed/simple;
	bh=kui52LdhR09qE3URSYgppLp2LQon6wAViNJEnqF9RhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pj4yD38r4/Qwk26cOAr8hXKdUNjsh4aKL9ZtS7Pfw4FWWgNYwFMM2Xg+tRjj+y3ECPw23Q4cyE+2AY1VwQ8Pu+lSdd8ad7jCwtUI+1S62NYPy4/iug/6W4NuVI8Fg2tHUN8BlCemVOyre/BuGJTHSWokCTyoumwmJ48/CuVHDew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=typ2ctR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="typ2ctR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5593DC4CEF1;
	Mon, 27 Oct 2025 19:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592247;
	bh=kui52LdhR09qE3URSYgppLp2LQon6wAViNJEnqF9RhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=typ2ctR/qmjirackREX0M5Udqm+5il1x+fWHPKoqNIWsSzDoCplVk3w8NEvxho4DO
	 nKZ/nzyPpsotES3AptH6/ESxel8DMMvlIBGynNT15Mvb/Qor15p9+Y07c9SvtmlUzs
	 3uWqGUwIvKiGxzIfgf9e+ypXqDw+DGeb6TEP4QBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/157] usb: gadget: Store endpoint pointer in usb_request
Date: Mon, 27 Oct 2025 19:34:38 +0100
Message-ID: <20251027183501.734305750@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -194,6 +194,9 @@ struct usb_request *usb_ep_alloc_request
 
 	req = ep->ops->alloc_request(ep, gfp_flags);
 
+	if (req)
+		req->ep = ep;
+
 	trace_usb_ep_alloc_request(ep, req, req ? 0 : -ENOMEM);
 
 	return req;
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -31,6 +31,7 @@ struct usb_ep;
 
 /**
  * struct usb_request - describes one i/o request
+ * @ep: The associated endpoint set by usb_ep_alloc_request().
  * @buf: Buffer used for data.  Always provide this; some controllers
  *	only use PIO, or don't use DMA for some endpoints.
  * @dma: DMA address corresponding to 'buf'.  If you don't set this
@@ -96,6 +97,7 @@ struct usb_ep;
  */
 
 struct usb_request {
+	struct usb_ep		*ep;
 	void			*buf;
 	unsigned		length;
 	dma_addr_t		dma;


