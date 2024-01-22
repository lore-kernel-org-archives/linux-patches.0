Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271CD6EB67;
	Tue, 23 Jan 2024 02:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975427; cv=none; b=N0UlNByfL4r7rK04Cb4hOKbAMNXZesGKl16LE736rh3YyIpCibc4KJYPALQImEsIhBO/T8gtC9/DbfvMzwmJ4L3KFcwqykWyWRNKAu1DAbVsEH6MjzQAgdxtTIEm8qn1+pjDKt+rfF+JclTn1g2ealF35FcfIIhvc81rwiefQs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975427; c=relaxed/simple;
	bh=lnyEXu7POPAXdrQqSZmGSPMfRwjPI8ddA8bAdwREXOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2ZOUJp9sdLFZpZe0s0enrdWTSexh/mrRYTA/I/RBoVkNwMLlIJvgpM1H3m3pplWkQI0vAJDWDbYROk7MLZprbgeKd5LKb2XQfC5/ZxRlHH1wZ+QZbmTzpEb9k1XvOmdOZthhVgiU+npw/vUeI2umO3TrTsNYt5hQtR4ZzjEYWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjHHWZkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjHHWZkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB742C433C7;
	Tue, 23 Jan 2024 02:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975427;
	bh=lnyEXu7POPAXdrQqSZmGSPMfRwjPI8ddA8bAdwREXOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjHHWZkQJ6kJlCVSj61Bg0b6LsdLe/NcU7UaotUMbOueu1OwJxM1Wtiw0Kp595DU6
	 dWYwp6cWLrvstylPo2GkMF/ZIWG17jlhpzuUEDh0U8oX4Cg6B4cgpsn36YVEYASZe1
	 T5qPOQCkHy4qAbSaiaos3O+XCCaISSb/OsODqHCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uttkarsh Aggarwal <quic_uaggarwa@quicinc.com>
Subject: [PATCH 6.6 359/583] usb: dwc: ep0: Update request status in dwc3_ep0_stall_restart
Date: Mon, 22 Jan 2024 15:56:50 -0800
Message-ID: <20240122235823.007633462@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Uttkarsh Aggarwal <quic_uaggarwa@quicinc.com>

commit e9d40b215e38480fd94c66b06d79045717a59e9c upstream.

Current implementation blocks the running operations when Plug-out and
Plug-In is performed continuously, process gets stuck in
dwc3_thread_interrupt().

Code Flow:

	CPU1

	->Gadget_start
	->dwc3_interrupt
	->dwc3_thread_interrupt
	->dwc3_process_event_buf
	->dwc3_process_event_entry
	->dwc3_endpoint_interrupt
	->dwc3_ep0_interrupt
	->dwc3_ep0_inspect_setup
	->dwc3_ep0_stall_and_restart

By this time if pending_list is not empty, it will get the next request
on the given list and calls dwc3_gadget_giveback which will unmap request
and call its complete() callback to notify upper layers that it has
completed. Currently dwc3_gadget_giveback status is set to -ECONNRESET,
whereas it should be -ESHUTDOWN based on condition if not dwc->connected
is true.

Cc:  <stable@vger.kernel.org>
Fixes: d742220b3577 ("usb: dwc3: ep0: giveback requests on stall_and_restart")
Signed-off-by: Uttkarsh Aggarwal <quic_uaggarwa@quicinc.com>
Link: https://lore.kernel.org/r/20231222094704.20276-1-quic_uaggarwa@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/ep0.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -238,7 +238,10 @@ void dwc3_ep0_stall_and_restart(struct d
 		struct dwc3_request	*req;
 
 		req = next_request(&dep->pending_list);
-		dwc3_gadget_giveback(dep, req, -ECONNRESET);
+		if (!dwc->connected)
+			dwc3_gadget_giveback(dep, req, -ESHUTDOWN);
+		else
+			dwc3_gadget_giveback(dep, req, -ECONNRESET);
 	}
 
 	dwc->eps[0]->trb_enqueue = 0;


