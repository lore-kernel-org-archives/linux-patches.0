Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00DA346FBE;
	Wed,  3 Dec 2025 16:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780885; cv=none; b=O21/B7uppgJGSqY/C/ijVJHlLsu3I6DDa++3JwReC0w863QALqIfNPZTEZSIGoUEfjYtJ1/W1dqj7Yp5axPlkEbr1CaV4P3kbC94xJhflc4soGekHESUBp31qvH3QSlnAziAvWf//DIo/A3L3OJyrI1037UnKI9r4WJPJpuOqgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780885; c=relaxed/simple;
	bh=djtYYWl2awtDmg8LaGjPFnB9e9CRJ3Vs5apCIkd7AQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUUhxiRbZLWmiILhQJUBz+eL9JFD40e6cCIlAYfXKkhWrr+vQKZDPxw8HU3lCbZW5mh6xAGh8Oz1w4n55UxuzfYiDC8Hhf9BrAieF4oZbr1QI3sDteEMA3V/4DsrwkHkHqzAtcGnUozL0S9fEOrXK0QR5k84tbO6bQafvw5rJgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCZ4XAdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCZ4XAdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05465C4CEF5;
	Wed,  3 Dec 2025 16:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780885;
	bh=djtYYWl2awtDmg8LaGjPFnB9e9CRJ3Vs5apCIkd7AQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCZ4XAdxBi2iUgD7HRUxElKrBE4AUEFA6Xg2wGuePG/7SRSceFsasqn3dEhSBKVGI
	 td0tfyUFAlJy7Gmp4Se7bvzps+8ra372Q1Wad2MwQ1TVsYuuiP7LOSd0xMUnfPQG+Y
	 lbc1OnCCT01L6Jk0Z/nasKQeU+4FuWy7qJdl2GKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/132] usb: udc: Add trace event for usb_gadget_set_state
Date: Wed,  3 Dec 2025 16:29:57 +0100
Message-ID: <20251203152347.683996507@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuen-Han Tsai <khtsai@google.com>

[ Upstream commit 7bf1158514e410310aec975e630cec99d4e4092f ]

While the userspace program can be notified of gadget state changes,
timing issue can lead to missed transitions when reading the state
value.

Introduce a trace event for usb_gadget_set_state to reliably track state
transitions.

Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://lore.kernel.org/r/20250818082722.2952867-1-khtsai@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: baeb66fbd420 ("usb: gadget: udc: fix use-after-free in usb_gadget_state_work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c  |    1 +
 drivers/usb/gadget/udc/trace.h |    5 +++++
 2 files changed, 6 insertions(+)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1128,6 +1128,7 @@ void usb_gadget_set_state(struct usb_gad
 {
 	gadget->state = state;
 	schedule_work(&gadget->work);
+	trace_usb_gadget_set_state(gadget, 0);
 }
 EXPORT_SYMBOL_GPL(usb_gadget_set_state);
 
--- a/drivers/usb/gadget/udc/trace.h
+++ b/drivers/usb/gadget/udc/trace.h
@@ -81,6 +81,11 @@ DECLARE_EVENT_CLASS(udc_log_gadget,
 		__entry->ret)
 );
 
+DEFINE_EVENT(udc_log_gadget, usb_gadget_set_state,
+	TP_PROTO(struct usb_gadget *g, int ret),
+	TP_ARGS(g, ret)
+);
+
 DEFINE_EVENT(udc_log_gadget, usb_gadget_frame_number,
 	TP_PROTO(struct usb_gadget *g, int ret),
 	TP_ARGS(g, ret)


