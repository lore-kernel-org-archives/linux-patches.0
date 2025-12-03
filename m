Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEFA35B150;
	Wed,  3 Dec 2025 16:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780494; cv=none; b=tFI7NHiAGenmIrYBv3U9ifLWRbJicSQqQeAW0OK6VYr19OVK/OVRLiOltsOY+ExRfaV8NG3uXgYO1rkJUIWc/DYSX3AgEmwJACt/gJ+/SMW2sFpULdC9yR72Ty/9V0GpH8/jJAObO5cmFlzlKoueaLuJ8D0F+WtHDZFTmhzO+qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780494; c=relaxed/simple;
	bh=KJlwpIJelMoHScP1xkS2uSn2m03yNB7kvMs/iQiegTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLVxR/IU3uMasurgGpON1v+Mv/I4ssz+qhGjVYc+MpZ3UeZcuBlillY+4H8xySBHBIqMbbf8gDp3YW8sfrbB00jC+0O4GYuNXwxoPZDQwM25/OdEcHEUP+cejL0ExUfp1KzbRZj2+yU9WnKkxtnnu8dSQlPlx/3wf1bWL1PA1uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1I69B8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1I69B8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A47FC4CEF5;
	Wed,  3 Dec 2025 16:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780493;
	bh=KJlwpIJelMoHScP1xkS2uSn2m03yNB7kvMs/iQiegTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1I69B8dkGaB3MLM8DX+QV0W/5U0+SebfLUVPN/lg6TXuGrdZlc2nL+vqmw+vqCN6
	 OUdQfIKsDJdT0hW2six9LihK/beTtX7NHXmyuPzMqX6D1C1BlvrPiABPZG0pliqzf4
	 dHVQ/kgPkU6J0HtK4W1Do4Ob+9lFb5CNWIfl9pb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 564/568] usb: udc: Add trace event for usb_gadget_set_state
Date: Wed,  3 Dec 2025 16:29:26 +0100
Message-ID: <20251203152501.402211131@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1123,6 +1123,7 @@ void usb_gadget_set_state(struct usb_gad
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


