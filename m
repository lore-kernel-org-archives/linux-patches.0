Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434FD3314DF;
	Tue, 26 Aug 2025 11:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207802; cv=none; b=bBemdEtplYVGD+cJ2MMZZY/bVg/OHoWV5LDPDT8HDIagG1Ym2rWA/59l0c+xzhw1qq741RqIi6U2AO1nHIWgM1V5xK3YtvZ/2fwveJ6HLs8As4Jqa9+S4ySKhLLlZuwLFeX/imEWKWqlYgfZF83QJBPZM2KIbhUZRgiQQ2Yxbck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207802; c=relaxed/simple;
	bh=wgnnoafXolJiea/tqboTCgygllqZi6++G5pzqxsR8wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6YFlQVVQUf2kDp1+GuTHXAW05si09B87evMp+uIwgEmdCnxYqffzGkn38N62u0X8M1cJ9G2B1996ykPQTRbJLlczwZ5/ixQXeknNJNhJaecWG1QFdvUovIVhT+vIDe53NmaT8rP5/wJYD1ZgMZv00/fTxYPYj6orY82dKzLqoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipZ+B7bw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipZ+B7bw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B93EC113CF;
	Tue, 26 Aug 2025 11:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207802;
	bh=wgnnoafXolJiea/tqboTCgygllqZi6++G5pzqxsR8wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipZ+B7bwcFP9BlIKLnFi8rYgYhJecXhGb0f4IRNX+R+5D+eHoqYYYVWguLCbFrcRM
	 Rx3GJmBcDoGL5pylnVqJGjDHmVsYvBneHJ4M7EuBaaYKuEcTP9bT6KeTQMSj2E7P5s
	 AoE6gs2VCPEqQrZAvkxK3OmBny9F9I28waH9ebHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kuen-Han Tsai <khtsai@google.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.16 323/457] usb: dwc3: Ignore late xferNotReady event to prevent halt timeout
Date: Tue, 26 Aug 2025 13:10:07 +0200
Message-ID: <20250826110945.333941371@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuen-Han Tsai <khtsai@google.com>

commit 58577118cc7cec9eb7c1836bf88f865ff2c5e3a3 upstream.

During a device-initiated disconnect, the End Transfer command resets
the event filter, allowing a new xferNotReady event to be generated
before the controller is fully halted. Processing this late event
incorrectly triggers a Start Transfer, which prevents the controller
from halting and results in a DSTS.DEVCTLHLT bit polling timeout.

Ignore the late xferNotReady event if the controller is already in a
disconnected state.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20250807090700.2397190-1-khtsai@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3779,6 +3779,15 @@ static void dwc3_gadget_endpoint_transfe
 static void dwc3_gadget_endpoint_transfer_not_ready(struct dwc3_ep *dep,
 		const struct dwc3_event_depevt *event)
 {
+	/*
+	 * During a device-initiated disconnect, a late xferNotReady event can
+	 * be generated after the End Transfer command resets the event filter,
+	 * but before the controller is halted. Ignore it to prevent a new
+	 * transfer from starting.
+	 */
+	if (!dep->dwc->connected)
+		return;
+
 	dwc3_gadget_endpoint_frame_from_event(dep, event);
 
 	/*


