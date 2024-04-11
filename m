Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8204B146D79;
	Thu, 11 Apr 2024 10:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831927; cv=none; b=qe5MRcoNQqUlYEKaSCQq8SO5GWppxXLBl2AayI9XQQMVaqrY8vvlLkV0gcrwlzSYNGEAQuvwZYBBtqTxC1AAYxgCnBDzoRdKWRag5Y1EKB5xpJFubFEzAmYCgonKHxsnq/elpHcHfAG5JPqV/5eTTSCaKc+PPt5RcOYQeUF3yjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831927; c=relaxed/simple;
	bh=Veum3n/AR0Pd/k1GZzxTybdNESjBmz7GWcQY6pLFfZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rULCvAUwr0pa9nbfZ3GaPIMWuryXRe2qUqxpifL8S9HdUUHIeY5VtKK0h0dKjwVMz7HXhu6FbUgEXnm8vVaH/YG/LRKxlKzihEwWQYakwDpIrTuvspcHQK+sh87iEcMT1Zs6Uw9lfoCdj7duL2Jj0W9MAH4OfbOt2DpojIIDHMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGtHfXej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGtHfXej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019B6C433F1;
	Thu, 11 Apr 2024 10:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831927;
	bh=Veum3n/AR0Pd/k1GZzxTybdNESjBmz7GWcQY6pLFfZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PGtHfXejeUihDb45fkNsYCS9wbOoWKPqRLK0kVB8Oql3prOT/rJSwZJGtOGSZuEjK
	 SoFkIWUS/ODdWmJ51civylKZHwuPkN8UkUvvDRjPkhXESCxq1Pt2RVJBcxUweiYqQX
	 g1Kv1xtsAhh0NU7T48+mlg8sHIq0zGSaxtEFOUsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	yuan linyu <yuanlinyu@hihonor.com>
Subject: [PATCH 5.10 172/294] usb: udc: remove warning when queue disabled ep
Date: Thu, 11 Apr 2024 11:55:35 +0200
Message-ID: <20240411095440.810896569@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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


