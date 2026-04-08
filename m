Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB114385513;
	Wed,  8 Apr 2026 18:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672296; cv=none; b=sOgvtPL8o2LcKppAlltoQsaF4FPtni2ryINRpb2u6xCCEhhK/WYaWr5iJxZ6/Hwhi8NlbEw7QHu150EZ03tGJBwKHFqA/g0atwFAdBd9KeZb6DjoS3BQFkkd5mT2AypIBPr4th4gkV7drFCFdRLQKiiz22rgL0lbDCUwAq7V5Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672296; c=relaxed/simple;
	bh=vpgbBsdSy4bmTEDB7h3wT4YeQvjNLVApJ2j8qgIpQlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDXnCgfClLcd+z8RAmaDZWG/Gdiz+xrVTlERUeROv84TeJV1JaEVimwEbRs2dwQaJJmmbL30ySKpMclbIJYM7n3V1UFBkyqhBHnIzenHt1TTCG1SKu4uPPNopP0WvwgAgN7/YW9TgawJokSljbseivyY/wwFSK6IDjC4/L2Ql4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wh9hxZwV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wh9hxZwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E63C19421;
	Wed,  8 Apr 2026 18:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672296;
	bh=vpgbBsdSy4bmTEDB7h3wT4YeQvjNLVApJ2j8qgIpQlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wh9hxZwV76N0RMt9Lj9VAOC8zm1DXerHRm9CkXmSoE5kamibmIV/PfcejRPojCdM2
	 6UOKhghI6s4TUT8OYegFkf534C8sFqCoxjOgg8BkfsPYrILeoMMN4vumWmt7+P/sUg
	 ytcvqE0dESR8J6Ta5r/vLBIE5qecquIYYEngNrJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yongchao Wu <yongchao.wu@autochips.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.1 232/312] usb: cdns3: gadget: fix NULL pointer dereference in ep_queue
Date: Wed,  8 Apr 2026 20:02:29 +0200
Message-ID: <20260408175942.420411439@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Yongchao Wu <yongchao.wu@autochips.com>

commit 7f6f127b9bc34bed35f56faf7ecb1561d6b39000 upstream.

When the gadget endpoint is disabled or not yet configured, the ep->desc
pointer can be NULL. This leads to a NULL pointer dereference when
__cdns3_gadget_ep_queue() is called, causing a kernel crash.

Add a check to return -ESHUTDOWN if ep->desc is NULL, which is the
standard return code for unconfigured endpoints.

This prevents potential crashes when ep_queue is called on endpoints
that are not ready.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Yongchao Wu <yongchao.wu@autochips.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260331000407.613298-1-yongchao.wu@autochips.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2586,6 +2586,9 @@ static int __cdns3_gadget_ep_queue(struc
 	struct cdns3_request *priv_req;
 	int ret = 0;
 
+	if (!ep->desc)
+		return -ESHUTDOWN;
+
 	request->actual = 0;
 	request->status = -EINPROGRESS;
 	priv_req = to_cdns3_request(request);


