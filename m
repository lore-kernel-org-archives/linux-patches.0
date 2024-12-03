Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C66F1F471B;
	Tue,  3 Dec 2024 14:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236807; cv=none; b=e5MQNgD46QSZ+U5cM10LbZGKOWluSQskrbnq9GeVEl8NBMK8WBrx3wEDr3vMOSvRudcK5LP/iBI91j4qqNr86ReXN4SQwvRDVv6G8s9IveMkRuoDAVbShO6PuSP7OV0OBxhliEzsCMwE7uvJYKZJFo5roVRLYUhdny52k8Rfd+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236807; c=relaxed/simple;
	bh=4CyB6gAQzdcoU6Zt77AeRSPY9vYItUE/NWWsBMZl8NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTXxUXef9h6mlwGk4KuYRoZ8Un72r38xtNc2tVt7hAjeyH5SucZD2xmt7lNXGbBHaKftp3ys3C4GcBv0kK0Bk78ruFk4VGCi5D0WvPe9ZRcErAMJ6+GgGjy93HgfO1Mz8SK9sbsl3fw8KrCySvKGfVZ5PfN11xTVN3K9cln+95A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uaUqXivM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uaUqXivM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F5BC4CECF;
	Tue,  3 Dec 2024 14:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236807;
	bh=4CyB6gAQzdcoU6Zt77AeRSPY9vYItUE/NWWsBMZl8NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uaUqXivMPTJaRlF/l5J87RkSVyrp3Vko6U5iUaNFgppoyy3/BrlIUeo/Pmavpzusk
	 7nqlYOY0+1YqKKymASq8TVKOqpTDrIpHJQX+9Gxv/CnuZZeXwQ0tVKBV1dcMFxkdTt
	 yJh18cu64Vj+eT7IsRy0O510nflZ/km8PFmKPW4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 4.19 123/138] usb: dwc3: gadget: Fix checking for number of TRBs left
Date: Tue,  3 Dec 2024 15:32:32 +0100
Message-ID: <20241203141928.273534198@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -903,11 +903,14 @@ static u32 dwc3_calc_trbs_left(struct dw
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


