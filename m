Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7270B19B3FF;
	Tue, 15 Oct 2024 11:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993136; cv=none; b=HF4PNzTNZjjjMK/v61s2Tf84cQaxeuCWfyuDq8oFN84Ufe4z6HkPKh8/bWxCF2XqOI8r1YoB/c83q+lZp9Y21FWcdvVm77ZlJf6fgBGBTpc8ifPnA1Z32C7aWPkcmWb43fZnUqE5icpMjCiSCB91rKSUfYDfkTT/8Q/bwp7uNok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993136; c=relaxed/simple;
	bh=awt0asRVzN+G7Ej/dmJjJuD2eh67B0sTzS/lgSesoPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfaDoeEkE9naZMk7UoLI9waQaVbw5dciyraVZ9+Pq3cfSfC/20AKkFRP218T+9Ub26iXTNe9wN2zeM+z8SGed00xQv8K9jMnaZOrcPBmjo7PQtGaZ3C5IcG4eMN65kFVByxByN5USnyVobJ1emYHfEb5RMu72Ts7yhe+6wvcdZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JS3p+MAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JS3p+MAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E6EC4CEC6;
	Tue, 15 Oct 2024 11:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993136;
	bh=awt0asRVzN+G7Ej/dmJjJuD2eh67B0sTzS/lgSesoPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JS3p+MAE69wbwDzaX9OSKDb2QhJQrVI0EWpB9QhfX4cUnBs22H25B/3dt2JXUo4GC
	 ctl5kepEUWexAaVPmSAqZxSzSZ6fCsETHOwIjbhCBkNHd8Ze6LQzpKamVCCUjq1rdF
	 3wm8Ef2bJOS6cst0AtPYMn86VjxLG2YNEWEMr/oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.15 322/691] usb: cdnsp: Fix incorrect usb_request status
Date: Tue, 15 Oct 2024 13:24:30 +0200
Message-ID: <20241015112453.117968618@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Laszczak <pawell@cadence.com>

commit 1702bec4477cc7d31adb4a760d14d33fac928b7a upstream.

Fix changes incorrect usb_request->status returned during disabling
endpoints. Before fix the status returned during dequeuing requests
while disabling endpoint was ECONNRESET.
Patch change it to ESHUTDOWN.

Patch fixes issue detected during testing UVC gadget.
During stopping streaming the class starts dequeuing usb requests and
controller driver returns the -ECONNRESET status. After completion
requests the class or application "uvc-gadget" try to queue this
request again. Changing this status to ESHUTDOWN cause that UVC assumes
that endpoint is disabled, or device is disconnected and stops
re-queuing usb requests.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
cc: stable@vger.kernel.org
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/PH7PR07MB9538E8CA7A2096AAF6A3718FDD9E2@PH7PR07MB9538.namprd07.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -718,7 +718,8 @@ int cdnsp_remove_request(struct cdnsp_de
 	seg = cdnsp_trb_in_td(pdev, cur_td->start_seg, cur_td->first_trb,
 			      cur_td->last_trb, hw_deq);
 
-	if (seg && (pep->ep_state & EP_ENABLED))
+	if (seg && (pep->ep_state & EP_ENABLED) &&
+	    !(pep->ep_state & EP_DIS_IN_RROGRESS))
 		cdnsp_find_new_dequeue_state(pdev, pep, preq->request.stream_id,
 					     cur_td, &deq_state);
 	else
@@ -736,7 +737,8 @@ int cdnsp_remove_request(struct cdnsp_de
 	 * During disconnecting all endpoint will be disabled so we don't
 	 * have to worry about updating dequeue pointer.
 	 */
-	if (pdev->cdnsp_state & CDNSP_STATE_DISCONNECT_PENDING) {
+	if (pdev->cdnsp_state & CDNSP_STATE_DISCONNECT_PENDING ||
+	    pep->ep_state & EP_DIS_IN_RROGRESS) {
 		status = -ESHUTDOWN;
 		ret = cdnsp_cmd_set_deq(pdev, pep, &deq_state);
 	}


