Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C496E2368E0;
	Thu, 12 Dec 2024 16:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020406; cv=none; b=Xqe40rEm5YX6s5UTLRlAPzqE4GPwcjdV2w67h9P1gzsajurRkbpIMcLjbpHbVcn+w+IGro2+7C8mTZ6UrtNJM8OcQJBhbhdMUP4rU7dB2gQQkDBM88hpvN0sFxrrbQK72xfIOQIdwtJrAU1WkYjYUGIiJ+HSr5dEYVbR9NAH1rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020406; c=relaxed/simple;
	bh=e+MsuQxXgF+CJZNzGEDhQ8PE97qON8hSnFA0Adol1t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKrMZ7eBQQ5ADcHPaEmyfRaMXblvAQvRfFXp+7EUs4laVuvC93S2tLDkeLLUTv/j/fkcELwktep3ccPp91UT0f8BIhnhPx702VeBEHMzfaxsB3ZDxQU6uqTTdx5v2HRhGq/cZLhxLTxsHtIjAr9nA51QaRzK3s9dKvghUC56N38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xuRC3WNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xuRC3WNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17117C4CECE;
	Thu, 12 Dec 2024 16:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020406;
	bh=e+MsuQxXgF+CJZNzGEDhQ8PE97qON8hSnFA0Adol1t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xuRC3WNeFdThAFFqWm6odogYa1JeMnLWQNQ8+n1q80vG8ESXmTmYAVY0vhPFBWK/5
	 qZkvtAM3pc+at2UoXWLvMe2arQV5MCcMiUmVcxx5EpvEkvdER/crmabsEHCSv2Y/E2
	 oxY9OE5IUyQR8YPOfyu254QKrLEvhfdpu2MfdVCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 419/772] usb: dwc3: gadget: Fix checking for number of TRBs left
Date: Thu, 12 Dec 2024 15:56:04 +0100
Message-ID: <20241212144407.224671360@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 02a6982b0ccfcdc39e20016f5fc9a1b7826a6ee7 upstream.

The check whether the TRB ring is full or empty in dwc3_calc_trbs_left()
is insufficient. It assumes there are active TRBs if there's any request
in the started_list. However, that's not the case for requests with a
large SG list.

That is, if we have a single usb request that requires more TRBs than
the total TRBs in the TRB ring, the queued TRBs will be available when
all the TRBs in the ring are completed. But the request is only
partially completed and remains in the started_list. With the current
logic, the TRB ring is empty, but dwc3_calc_trbs_left() returns 0.

Fix this by additionally checking for the request->num_trbs for active
TRB count.

Cc: stable@vger.kernel.org
Fixes: 51f1954ad853 ("usb: dwc3: gadget: Fix dwc3_calc_trbs_left()")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/708dc62b56b77da1f704cc2ae9b6ddb1f2dbef1f.1731545781.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1203,11 +1203,14 @@ static u32 dwc3_calc_trbs_left(struct dw
 	 * pending to be processed by the driver.
 	 */
 	if (dep->trb_enqueue == dep->trb_dequeue) {
+		struct dwc3_request *req;
+
 		/*
-		 * If there is any request remained in the started_list at
-		 * this point, that means there is no TRB available.
+		 * If there is any request remained in the started_list with
+		 * active TRBs at this point, then there is no TRB available.
 		 */
-		if (!list_empty(&dep->started_list))
+		req = next_request(&dep->started_list);
+		if (req && req->num_trbs)
 			return 0;
 
 		return DWC3_TRB_NUM - 1;


