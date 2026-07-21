Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9701643D503;
	Tue, 21 Jul 2026 21:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671160; cv=none; b=k+Tx3Iis15J4ongYDQtTldJKRcLVQh0vOrFgCdyt7PIF4s6i/+wV8PfYewXWgnPmJlnuVqqJamBqrqfPksrs4oQwC901ENqtrUei4EGqOHo2sgycoSeg8tjMfi3XmorjGYNyCwmjrhF7ABunncxFLViy+iYwO2ANK3P9cm03uNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671160; c=relaxed/simple;
	bh=JiAXpi3+JPEwRWGwjrWEVRpOy3OQrBz0GfIjSfXZfGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+MMiAkDuTGlhyjq//k//nDAJ1oRjKGdjjokkYXG7ieWliIBAt1ncFxgvvUo/Kv6uKoKC8tQj/gdbSSym1CZpL+NWu9bOK2wOI/SMth5gRfHHLAPNLR8FKUrvwhlsKLInCsQ4dNPlVWbfqLeEaIt1jI5AGiT+anC3XKs6TdxVeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FiSsjLU4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FiSsjLU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EB21F000E9;
	Tue, 21 Jul 2026 21:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671159;
	bh=pPxaVqeWN+aON9tkkjSbZJrUYhqlJZL6iNATkB4ZA04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FiSsjLU4ebpw0Uh0DlhHY++j8MB7/zdM3E4C9ed4d/J1gpkKzNKF/+EGHPHePVVqo
	 HGAtwGQFIzfSPgWKw56K+3bd6iTwu55kREAQPshN4g2747JHtBkP/rgir0fuTIzvWc
	 OjKCgAf6aFaplmEeX8FTzP9y0kEAAhq4YRJx8oL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH 5.15 142/843] usb: mtu3: unmap request DMA on queue failure
Date: Tue, 21 Jul 2026 17:16:17 +0200
Message-ID: <20260721152409.207410401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
 


