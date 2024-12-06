Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D9F154449;
	Fri,  6 Dec 2024 15:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498314; cv=none; b=KwLRFqeA7NiR2aw6JbKMLF1wXl98/qdFRWJUI/UoQlt6JV87OsdsYPNwFdyckmPzIp3vRJQFJhWN+Ckjfdb0R2gmUhXuCsOmzTABNVYAy/Eq78+PyMFXh09rTxRVaNeu4ol7ul2GGUKBKThyCeMZvQv81S6eVt0+6fAIGeTGnN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498314; c=relaxed/simple;
	bh=EcK/7XbxWfuJONagY9r80tBRlLaS2u1fpJqw/fxyXWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQcMdeXcC0N3aPm9Rkg7fKgumdRAWfr/HLmUJ2E0DDQQSnw3mY0wNHeoUVcn7WnXIDrbgHGxeKCIx5UHqcv9ebDh1TBcTyLn+AVvbOrNGUx3Kg/kWiHbtIj4C6gRLQ5vZ6yTlNsLG4MFC8Q/pciwzZ4cp93dccWd2FhWLhERncc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrVxl6Gj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrVxl6Gj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D02C4CED1;
	Fri,  6 Dec 2024 15:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498314;
	bh=EcK/7XbxWfuJONagY9r80tBRlLaS2u1fpJqw/fxyXWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xrVxl6GjwAJRNLMyq1+qetEDfV7ZvI9cSzSf0X4qW3MKprPn8lkgVW4AV/Bbk0wRz
	 aeFFS7uBOkIDxkfks7W2UrWtQJJ7H3fdHaQhwI1BEap4zITiKB99CRtk3SMuDvHkMD
	 ENope9I0p9nCDXITqWKvUtN80HoXbM92pFTnDdow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 547/676] usb: dwc3: gadget: Fix looping of queued SG entries
Date: Fri,  6 Dec 2024 15:36:06 +0100
Message-ID: <20241206143714.724074755@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit b7fc65f5141c24785dc8c19249ca4efcf71b3524 upstream.

The dwc3_request->num_queued_sgs is decremented on completion. If a
partially completed request is handled, then the
dwc3_request->num_queued_sgs no longer reflects the total number of
num_queued_sgs (it would be cleared).

Correctly check the number of request SG entries remained to be prepare
and queued. Failure to do this may cause null pointer dereference when
accessing non-existent SG entry.

Cc: stable@vger.kernel.org
Fixes: c96e6725db9d ("usb: dwc3: gadget: Correct the logic for queuing sgs")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/d07a7c4aa0fcf746cdca0515150dbe5c52000af7.1731545781.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1436,8 +1436,8 @@ static int dwc3_prepare_trbs_sg(struct d
 	struct scatterlist *s;
 	int		i;
 	unsigned int length = req->request.length;
-	unsigned int remaining = req->request.num_mapped_sgs
-		- req->num_queued_sgs;
+	unsigned int remaining = req->num_pending_sgs;
+	unsigned int num_queued_sgs = req->request.num_mapped_sgs - remaining;
 	unsigned int num_trbs = req->num_trbs;
 	bool needs_extra_trb = dwc3_needs_extra_trb(dep, req);
 
@@ -1445,7 +1445,7 @@ static int dwc3_prepare_trbs_sg(struct d
 	 * If we resume preparing the request, then get the remaining length of
 	 * the request and resume where we left off.
 	 */
-	for_each_sg(req->request.sg, s, req->num_queued_sgs, i)
+	for_each_sg(req->request.sg, s, num_queued_sgs, i)
 		length -= sg_dma_len(s);
 
 	for_each_sg(sg, s, remaining, i) {


