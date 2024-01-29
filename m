Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68F515D5B8;
	Mon, 29 Jan 2024 17:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548184; cv=none; b=XQfKOLFX7+ytvzvSieWBN+rUXmgIsuPIM1VV+yL+ZYsOFaYBfR7hJlkpXz6t8FFpxm6S8dUGiAdSuro1jwwGpyKRvQPB43TJahBLs9brNC4D9BHalVk+c5VLTSFTK11PnFRxMB+fyobL/s+5SjIoPnN49x7CTfIvWufaKaWP1KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548184; c=relaxed/simple;
	bh=497iyW7Us0Pbt6F1NdTHw6vOiB8O3LxipqKiuqZjlIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8Rb6h9p6N1tohBPOvC+KSne3i7Me3VcKF2nQk5T4AZsOWT87AvK1U+p56md8Pw4QlY4EILsqHAiv3KPAVLph7TO9L2XaGeJJo9sy9xkb4vGm3J02O3xso4qT1HQ8iZ1PP9CAGN3bop66iPNWUhhFPf88rv/ig05Azdg2FtM+jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lpNplrFq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lpNplrFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFD2C433F1;
	Mon, 29 Jan 2024 17:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548184;
	bh=497iyW7Us0Pbt6F1NdTHw6vOiB8O3LxipqKiuqZjlIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lpNplrFqlR+eSGnk8cq/1I9C9HdED48pBzJZuiAzyPZMorko334FV3/bYQHl31bJ2
	 h31JAhRB/plJN+5b97wRmJcpnJYVbS3bMe4sOV7C2xIcrLE6W6mt5YJEnVWkUe47aC
	 W+EoqdzTtT9ayDWioP+9t08C1qu/I93HDZOExBV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/185] usb: dwc3: gadget: Handle EP0 request dequeuing properly
Date: Mon, 29 Jan 2024 09:03:23 -0800
Message-ID: <20240129165958.712827183@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Wesley Cheng <quic_wcheng@quicinc.com>

[ Upstream commit 730e12fbec53ab59dd807d981a204258a4cfb29a ]

Current EP0 dequeue path will share the same as other EPs.  However, there
are some special considerations that need to be made for EP0 transfers:

  - EP0 transfers never transition into the started_list
  - EP0 only has one active request at a time

In case there is a vendor specific control message for a function over USB
FFS, then there is no guarantee on the timeline which the DATA/STATUS stage
is responded to.  While this occurs, any attempt to end transfers on
non-control EPs will end up having the DWC3_EP_DELAY_STOP flag set, and
defer issuing of the end transfer command.  If the USB FFS application
decides to timeout the control transfer, or if USB FFS AIO path exits, the
USB FFS driver will issue a call to usb_ep_dequeue() for the ep0 request.

In case of the AIO exit path, the AIO FS blocks until all pending USB
requests utilizing the AIO path is completed.  However, since the dequeue
of ep0 req does not happen properly, all non-control EPs with the
DWC3_EP_DELAY_STOP flag set will not be handled, and the AIO exit path will
be stuck waiting for the USB FFS data endpoints to receive a completion
callback.

Fix is to utilize dwc3_ep0_reset_state() in the dequeue API to ensure EP0
is brought back to the SETUP state, and ensures that any deferred end
transfer commands are handled.  This also will end any active transfers
on EP0, compared to the previous implementation which directly called
giveback only.

Fixes: fcd2def66392 ("usb: dwc3: gadget: Refactor dwc3_gadget_ep_dequeue")
Cc: stable <stable@kernel.org>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20231206201814.32664-1-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 5617a75b0d74..c4703f6b2089 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2093,7 +2093,17 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 
 	list_for_each_entry(r, &dep->pending_list, list) {
 		if (r == req) {
-			dwc3_gadget_giveback(dep, req, -ECONNRESET);
+			/*
+			 * Explicitly check for EP0/1 as dequeue for those
+			 * EPs need to be handled differently.  Control EP
+			 * only deals with one USB req, and giveback will
+			 * occur during dwc3_ep0_stall_and_restart().  EP0
+			 * requests are never added to started_list.
+			 */
+			if (dep->number > 1)
+				dwc3_gadget_giveback(dep, req, -ECONNRESET);
+			else
+				dwc3_ep0_reset_state(dwc);
 			goto out;
 		}
 	}
-- 
2.43.0



