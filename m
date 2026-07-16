Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC14642BE9F;
	Thu, 16 Jul 2026 14:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212244; cv=none; b=ItUNjztlFQdjWIDp71UOeESAGok7rx7Vm9XRVT5IN0oWwSmKwYWI5bkk7jrsnBZlQb6p66hUB4bXS43hRla3U9wGiSmmve02WPR+j3HoL9gTnMUKOs8fJ8ORiHM7Q8OMtRIqDe5YsxhiUjJM6JbNaJYO6LQqf/OSrE0AsqRX+Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212244; c=relaxed/simple;
	bh=daP+afJpHW4UHJQqQ56/zcwwvOO+BMJLhfUVyeTc3jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4bIwAq2PLjs0LAnc7JihN6KgmSOUj+ztWxhsubyYDHMPaZSlWe8S4qO4PR/eIAUnCYJ6FjAh3S9gfbPsYM8qkd/9ZrE8C8Z61LMtv+VF44/RKbH81aEj1yfXBH/Jp4WWyT156OEnNRVWyFTE4d8JJCeAiXfW8enwiUumdThlDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRIbwKH5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRIbwKH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1748F1F00A3A;
	Thu, 16 Jul 2026 14:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212242;
	bh=wrcs9f3QxkDxHP3sE3+7jDML9Wa+wpOOpxz5qu7Ju/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IRIbwKH5NAWWtvJzLfctXYNQYK7iD+M+LCYFA4rYBSYWbR5Y8UPKOV2AlwZLIqMlm
	 8P6Iuc5P1gKLDdVbd7wMqtOKoYfjGoFrDjAf8CPuDVJRMq3obB/5TDb8jkPMOBO0SY
	 affz83UWmY+l/4bbvZ90NpH6itr3qFQLoWSnLds4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH 6.12 236/349] usb: mtu3: unmap request DMA on queue failure
Date: Thu, 16 Jul 2026 15:32:50 +0200
Message-ID: <20260716133038.645054853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


