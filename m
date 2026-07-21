Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2226143634C;
	Tue, 21 Jul 2026 20:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665269; cv=none; b=R1dHt45O2oKIBLr8Y7HxZtq5qXlv39vfUjn8QlmT74wkpeS3Dc5cmgR17fg6nH/XfJOSz4kKjsRBNc+BFBOAeslxeXKnJ06kVgpOM4pLHdbVDA6IsbgUv/Zqj2opd7xgIuOk1B444DpmpnqZpcRBcp9/L2Mog7K3W0i5qGmamtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665269; c=relaxed/simple;
	bh=3z2NyQwYFtCs9sFgUA5HPAZWwOktl8yTEI5A60AGRsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUR97scWk6ejl3PXZjhGd//RCOrOLz7ASMWP9zlODD4jLYC/Stq/Cwpow44LzH2aVvMJCaLuxdivtr9iKDaBu7QOxobjwQobVS28gncAnthskHuz/GbB55XDtxHK7gx2vac7rSuMt6Hnxeg/togFmj30pP34kCIz5/tCCcN5LXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9f+pr9A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9f+pr9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6AC1F00A3A;
	Tue, 21 Jul 2026 20:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665268;
	bh=ZRr6JpW2HTbxxq9f3QH/zJbJW/Nj1Gki8vhYcNq/G4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N9f+pr9AjBbI5T3M2YwpBgBRj3pPyPAi+yPMsK8KDHH7jERlTeqJHteoWw4P30bEO
	 dfLrSKMNanEOWzoGSX1DhNavhzmmTKyDTBzcMhYvE4FpD8Xl6Id0jMLlaWXdJ5MxsU
	 vkZyzEeb55NUgu+0Kfs62OBG/xYcwecIxl8sJc6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH 6.6 0241/1266] usb: mtu3: unmap request DMA on queue failure
Date: Tue, 21 Jul 2026 17:11:18 +0200
Message-ID: <20260721152447.209948539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -304,6 +304,7 @@ static int mtu3_gadget_queue(struct usb_
 
 	if (mtu3_prepare_transfer(mep)) {
 		ret = -EAGAIN;
+		usb_gadget_unmap_request(&mtu->g, req, mep->is_in);
 		goto error;
 	}
 


