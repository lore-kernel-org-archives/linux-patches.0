Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42453429017;
	Thu, 16 Jul 2026 13:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209786; cv=none; b=rfqwniufWlYK4WmDZSZ0+FylgWRXw9kgYWvPE+ONg/rq5Aq3xd2qjSIGGtVAoBe58QtmqV47N7zza6avokMBHWc/mwcf2EE8z4+YgslkZ5+4wUPl/UO+RI9JjdngfsJhRKK6QTtMse1yJ7aSp/tEzeAVp/fQ57wxgZd6yQBZf2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209786; c=relaxed/simple;
	bh=/gJcTlkIYu548HU903aQ3ajT0+TBw33sQpvb2o0dbsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vApS9Oe3E9rfg2Y1k6nQ2e7omIaFwXjwR6yZEfkInB869szpnHMheze6qEmelrCCCOsbUQbWPYACV19mVFvx5JglwzMYRuJVjixch60rsb2nO5u/cDfXZQV1fL7K/XbADpch0vLwXN9wAe2EfqY98pQkHNdLRmMN4DSdNeyEmMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEqg53/2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEqg53/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0341F00A3D;
	Thu, 16 Jul 2026 13:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209781;
	bh=zLwerKEJWj8ZwfuV5tfzehZ3ddV7aWlYBEDlNqCVYOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YEqg53/2/Kj228rk43Bd6pNa4LIHuoGDkxZqykxFIccpP+F5QZBrw1+WQ8A2AFAr4
	 UOwiJy6XUpmaAXE1tbuFaCBHCqb/h2CN3+VvoAslsxswkdkb14kZjAyxdFNZWLyQtp
	 /lQp6n3/BGfA7KukJvBkzFjhDC/pXm83aSKymjO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH 7.1 317/518] usb: mtu3: unmap request DMA on queue failure
Date: Thu, 16 Jul 2026 15:29:45 +0200
Message-ID: <20260716133054.758367400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 


