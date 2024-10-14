Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D9A1798C;
	Mon, 14 Oct 2024 15:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918397; cv=none; b=DD+WqVzqAJguzPvx+IbGmQmYy83N51fEqS+qIRgyMkU4sAO+hFI8oRHIia4+zw3q+2YtfJkZCbjaGKg3VjwNslclT9s7NCe5fZLfs0D6Z/dYE2fK6dadO0JhnE/slTXL61klvPCPidQnYyv6gAx85qh/FwUqV4u7ZALMaT1Fq+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918397; c=relaxed/simple;
	bh=QeSmgzq9YhCx2QYTV8gQWRzlIFJtbUiMXU6hspciSkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9f25GgYkjcDTXApbkqYJU+olTz2U7Lyr77EAoIGarrZ/ohm/wwbcuDE3+JHCUYA2p7c3lxPCeR/cow3gy6MzV9Ij6S1ERWC75CneYaNGs0dhVy5cHQ3w5lQGLul3jCOGEK4xnE8DQ0qmfSml6eXDJwx+J7QmqhDZiD7cUE8Upg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVMQDby3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVMQDby3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C3AC4CEC3;
	Mon, 14 Oct 2024 15:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918396;
	bh=QeSmgzq9YhCx2QYTV8gQWRzlIFJtbUiMXU6hspciSkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVMQDby3scQ9ZADPQ3+/C53maTnJGUw9c6be8+cnVTpLMW9JhcFsOHWFHYgkupORn
	 AhPD0Z53dD0choQy3fh7THGUHIzNYYhA29HgD4uAg2EVoQ0rqZBShKRrzkRJEwZjF6
	 Mtv06oCe+E72wPo+K/4YcWOUvHezUtsbjAVYVqeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.1 310/798] usb: cdnsp: Fix incorrect usb_request status
Date: Mon, 14 Oct 2024 16:14:24 +0200
Message-ID: <20241014141230.126532045@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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


