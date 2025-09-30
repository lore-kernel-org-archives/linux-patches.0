Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F07223DD6;
	Tue, 30 Sep 2025 15:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245294; cv=none; b=ddGji0T4UTktUtfeNuyUTx9q+fjuIFV5MLT++3/p209M8IB98ZRa4TLYss13EYUt3UiNvIJ1hetcyqKOyhEHUXv3GSO6nFaaCVpjiG5Kz1cr9pyLv14eduCiqdJOnYxEMPXSFwCUnj2QIbsYbkMHfpPvpikjD6fMdFYth9gQofU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245294; c=relaxed/simple;
	bh=UGsTRQf7U+wVW3/rMo/HGBEK3A4fLPgtwH7V/BUsXXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dq20Hv9QFH1WBnRja2oxoqWckf7zQYuehj093P6ACuos4XtrJZLnc8yVvRw0RbsBK8n01pfuxPwtxYmdXA2klUnLTOiuhGw/zPDB9mijn/tf+6BX/lU1pjDI91D1R39ccckgMKfbCkQPD0301KQL8d9iF9yZCygkmlIVc8r1UO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AiQHtqQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AiQHtqQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8FDC4CEF0;
	Tue, 30 Sep 2025 15:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245294;
	bh=UGsTRQf7U+wVW3/rMo/HGBEK3A4fLPgtwH7V/BUsXXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AiQHtqQjTiwiqEP5uYeRyd0/VkXjksmwBL3raTm33uMDJo/aVgMKgoxq0/ar1WolO
	 XR9akiujp1kdROmfwOGMyvHNXvGphUtH2E5AWZdVbHILt11P+ApLoCJGfOy7iUoSob
	 o+TMMH83P0BWREJ6AsnUXO/6p02TAEpjFkkwSIsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Koschel <jakobkoschel@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/151] usb: gadget: dummy_hcd: remove usage of list iterator past the loop body
Date: Tue, 30 Sep 2025 16:47:03 +0200
Message-ID: <20250930143831.300363109@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

From: Jakob Koschel <jakobkoschel@gmail.com>

[ Upstream commit 7975f080d3557725160a878b1a64339043ba3d91 ]

To move the list iterator variable into the list_for_each_entry_*()
macro in the future it should be avoided to use the list iterator
variable after the loop body.

To *never* use the list iterator variable after the loop it was
concluded to use a separate iterator variable [1].

Link: https://lore.kernel.org/all/YhdfEIwI4EdtHdym@kroah.com/
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Link: https://lore.kernel.org/r/20220308171818.384491-26-jakobkoschel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 8d63c83d8eb9 ("USB: gadget: dummy-hcd: Fix locking bug in RT-enabled kernels")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -751,7 +751,7 @@ static int dummy_dequeue(struct usb_ep *
 	struct dummy		*dum;
 	int			retval = -EINVAL;
 	unsigned long		flags;
-	struct dummy_request	*req = NULL;
+	struct dummy_request	*req = NULL, *iter;
 
 	if (!_ep || !_req)
 		return retval;
@@ -763,13 +763,14 @@ static int dummy_dequeue(struct usb_ep *
 
 	local_irq_save(flags);
 	spin_lock(&dum->lock);
-	list_for_each_entry(req, &ep->queue, queue) {
-		if (&req->req == _req) {
-			list_del_init(&req->queue);
-			_req->status = -ECONNRESET;
-			retval = 0;
-			break;
-		}
+	list_for_each_entry(iter, &ep->queue, queue) {
+		if (&iter->req != _req)
+			continue;
+		list_del_init(&iter->queue);
+		_req->status = -ECONNRESET;
+		req = iter;
+		retval = 0;
+		break;
 	}
 	spin_unlock(&dum->lock);
 


