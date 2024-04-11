Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4AA145B05;
	Thu, 11 Apr 2024 10:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829788; cv=none; b=nQcjRS7KsiFeBYBQWgZdJqk6ssKY0JyR2P9yru6yLGMan5a500z96p2sBxVu0w54eSVVgIO0/7O+A7Sx2Y5yKe03Fzp6ibACjOCNPE7t3QofXf1+KNeS/sXwW08rgkfMRQXeHeLN5dv6OuHr7ZoICWRdzVcWWKlD1+bZ4+QsjUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829788; c=relaxed/simple;
	bh=MGj5TR4E1pTqcowLUvx3fQAzTfkx+hn4GfE8ncuXnNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqbStiPOjCCRl6F1hWtmGp/U6h56Mn04v4ryRb5PPXUDNFdE+AiR6fla0dpFzv4AuILZNnpM2QwaDwaTbFtD/VfcdU7zAlDsA8M6gj+7bd+bFGJxPWH1yIdQIN2lpd+/Zat6woIXWT8cGTM2IPIQtPC4ccS/0q3Zz5e3/X6QX3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGIhRW8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGIhRW8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0651C433F1;
	Thu, 11 Apr 2024 10:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829788;
	bh=MGj5TR4E1pTqcowLUvx3fQAzTfkx+hn4GfE8ncuXnNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PGIhRW8i9RqI6DXuz59BWdRQ3HTMKV+NoV1db0nuqY6OXguu5v8GpxMkbSc3fLM7w
	 FE8T1gK7OnHZh24JeTTFVaukMsaPKb0UVb+hFaPSjG1Yz1iBHcv51+spUmnHZE1wVF
	 hVekU+tNpi10pCs5Or6yAbf+ExCPRxDu2zaft2Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	yuan linyu <yuanlinyu@hihonor.com>
Subject: [PATCH 4.19 105/175] usb: udc: remove warning when queue disabled ep
Date: Thu, 11 Apr 2024 11:55:28 +0200
Message-ID: <20240411095422.730357804@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yuan linyu <yuanlinyu@hihonor.com>

commit 2a587a035214fa1b5ef598aea0b81848c5b72e5e upstream.

It is possible trigger below warning message from mass storage function,

WARNING: CPU: 6 PID: 3839 at drivers/usb/gadget/udc/core.c:294 usb_ep_queue+0x7c/0x104
pc : usb_ep_queue+0x7c/0x104
lr : fsg_main_thread+0x494/0x1b3c

Root cause is mass storage function try to queue request from main thread,
but other thread may already disable ep when function disable.

As there is no function failure in the driver, in order to avoid effort
to fix warning, change WARN_ON_ONCE() in usb_ep_queue() to pr_debug().

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable@vger.kernel.org
Signed-off-by: yuan linyu <yuanlinyu@hihonor.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20240315020144.2715575-1-yuanlinyu@hihonor.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -273,7 +273,9 @@ int usb_ep_queue(struct usb_ep *ep,
 {
 	int ret = 0;
 
-	if (WARN_ON_ONCE(!ep->enabled && ep->address)) {
+	if (!ep->enabled && ep->address) {
+		pr_debug("USB gadget: queue request to disabled ep 0x%x (%s)\n",
+				 ep->address, ep->name);
 		ret = -ESHUTDOWN;
 		goto out;
 	}


