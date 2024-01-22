Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3AC12CDB0;
	Tue, 23 Jan 2024 00:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968995; cv=none; b=QbXjyT1PRd+4hwM/Qud9D79VbiE+C65gQnlNuDPx6wnnAykUnjjlZpVId099TJ1tpN/mcJJw7btjgcPJY4nlZB+mRtHasjcu5BV/vHXicmjTOAKFpfwKArDCWrV4uOf7qsMuZu0nG9XxaKzhwXtuYnQUksyahe0vvzLAGjCDPXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968995; c=relaxed/simple;
	bh=LCSFfkzZi7dAOcdfCa1XSXTciN6bedYNz+YSOIB0Q38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r22DJl/yVctq/iEe9eIsSNR8/DQ/pnBCUwcN4jYz5C004x5sj57Fv6e7iez/mQsrvCnAL27iOD9XAkroM598x8BDiJYbtF55hPMQGEo1Kf3N8jrdZWceeJaeykulCxK3Nno1WQf4zrcqAY/bmi78ox6cRF+GlSzrGFmkN7O3X20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNqxou8b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNqxou8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383E5C433F1;
	Tue, 23 Jan 2024 00:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968995;
	bh=LCSFfkzZi7dAOcdfCa1XSXTciN6bedYNz+YSOIB0Q38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNqxou8bjFOLt68767njw2QtWVag38Ey/sggY2BpZdqZu1UirMnjWRtlQKrlUcnuk
	 aHF+59DwuBAV+L5dOm2RrkVJLRW8M6SAt2eaEgtG+WbmoqC0n+x7yAXpeRoGZOBd5y
	 ysNSOKdTiSg+iuXRf0USIYFad4ycPWS7Wl7eOb4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uttkarsh Aggarwal <quic_uaggarwa@quicinc.com>
Subject: [PATCH 5.4 148/194] usb: dwc: ep0: Update request status in dwc3_ep0_stall_restart
Date: Mon, 22 Jan 2024 15:57:58 -0800
Message-ID: <20240122235725.566602375@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -236,7 +236,10 @@ static void dwc3_ep0_stall_and_restart(s
 		struct dwc3_request	*req;
 
 		req = next_request(&dep->pending_list);
-		dwc3_gadget_giveback(dep, req, -ECONNRESET);
+		if (!dwc->connected)
+			dwc3_gadget_giveback(dep, req, -ESHUTDOWN);
+		else
+			dwc3_gadget_giveback(dep, req, -ECONNRESET);
 	}
 
 	dwc->ep0state = EP0_SETUP_PHASE;


