Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322B744AB99;
	Tue, 21 Jul 2026 21:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668453; cv=none; b=E2UxXFE+NEwHuQhFYyyBbP9w1Q+6OWFa8xoSA/QLKk4TrKs4nvEO49tifTStwsyfiJEtTx1s5aJbSzwSTEx6uSR726AaIIcntQlhuoB6kkq63SPLt7AyVp/XBJi4e/6eQf0hJsRFIjkd+zrlsHBymhS+8IGVt2X/sncESZIsMbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668453; c=relaxed/simple;
	bh=U5ZFD+L+XcTJM663skpmY8TFK6O3ou/86SXxraqy0m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpT3fwH4dQbNzqhJR9HnEJYUX1TANay8a7VkNi0BnojA6NmwKuWNB9gpArQIsQYAgG+g/npl38lKJHEnR6v7Z4vmNBebziEkrl7h9+mY4GtgDRX98+UJ/uDWDyrmBdr54G2PPpBoV4b+yHiIjgCh00Nrj+15hRcSyHGWVzV8fFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xguUtQGz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xguUtQGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9743E1F000E9;
	Tue, 21 Jul 2026 21:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668452;
	bh=/zPYQAOZdDpWSTXs2EvK+VfYo5WRKtJhrpmGVp7/N5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xguUtQGz6wC7RIaeARAJAyR3/qziMv1ynyX34g0SiTM3RToMTXAT1Wi73Ttmqvdv5
	 MEFvN5EMvK4rn1GcsSG0qVTDAJP5TN4hQyJEraq6Vt0ymNuLSFpLlpEx7E96jcIKKA
	 omdu3vhNSPlPADwwT2mZaw/PQSfDjNG1YE6Njugo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH 6.1 0180/1067] usb: mtu3: unmap request DMA on queue failure
Date: Tue, 21 Jul 2026 17:13:01 +0200
Message-ID: <20260721152428.617486049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 0bddda5a11665c210339de76d27ebbd1a2e0b43c upstream.

mtu3_gadget_queue() maps the request before checking whether
the QMU GPD ring can accept another transfer. the request is
returned with -EAGAIN before it is linked on the endpoint
request list if mtu3_prepare_transfer() fails.

Normal completion and dequeue paths unmap requests from
mtu3_req_complete(), but this error path never reaches that
helper, so the DMA mapping is left active. Unmap the request
before returning from the failed queue path.

Fixes: df2069acb005 ("usb: Add MediaTek USB3 DRD driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20260623093325.2105323-1-haoxiang_li2024@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/mtu3/mtu3_gadget.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/mtu3/mtu3_gadget.c
+++ b/drivers/usb/mtu3/mtu3_gadget.c
@@ -305,6 +305,7 @@ static int mtu3_gadget_queue(struct usb_
 
 	if (mtu3_prepare_transfer(mep)) {
 		ret = -EAGAIN;
+		usb_gadget_unmap_request(&mtu->g, req, mep->is_in);
 		goto error;
 	}
 


