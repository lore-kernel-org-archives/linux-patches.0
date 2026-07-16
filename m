Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A84941F7CC;
	Thu, 16 Jul 2026 14:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211105; cv=none; b=kGlLjRh8Upu9pS+kBrx99UX+L1a886lKxZZ3RLexpzwumKMNOYeQ991JIdB42kjK62LGtHrFpuN8EFl/0AaHX7XrtA6NItOI8uz16UZJqv47/Z3RTEUHgN9w5ppsAZFtZSs0f9BwtsHVxcY7gkJFeE2hZGGaga3Gbw2YY42rOWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211105; c=relaxed/simple;
	bh=RWeZHTrGCQOjbweOUVSIHNKEDARsZUU97GyibBax9vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVOUVm3epNfd3tqYVsGgcMZ3T/9sXGOMwzwxuH0jrcKZcMVlaPf/7Rry7+Ar3a9BFxIqzBxvOsF/N2Zf6yhjOnQlpJW7uSYnIv4XTIOUuAA3OJBpu+nkk9WTHSy0usY1vu3+M5esZRUK4gG2+hj7BEd34U9HUHrz6eZKFP9nHTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2WMCV7H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2WMCV7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BFD1F000E9;
	Thu, 16 Jul 2026 14:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211104;
	bh=+xXsCwiGyqW7jPXS+92S6qbGrEZogo6iZeTuRJgGKZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2WMCV7HFrr8G69/jlaBVpJTkOTcE7EVwOoQlTsU/KrUzeBbk7o2a8ZFf0skzqzu/
	 GIOT88yzNoFFc7yS1S6dY9MGy92Hlfan9umZSG97QaN/XG6H5kblOoK0MWtoiflCDV
	 z4TfPOPxEEMzGkFgGIXy0+TQKWRF+PYzpbMWmsss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH 6.18 301/480] usb: mtu3: unmap request DMA on queue failure
Date: Thu, 16 Jul 2026 15:30:48 +0200
Message-ID: <20260716133051.328523262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


