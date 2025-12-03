Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6353385A8;
	Wed,  3 Dec 2025 15:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777326; cv=none; b=cHYE/4H2SjQzIsoRJermVms9yLdfGjY9qSgm2NXIYo0h1vOrG7bxO4usPxv36Cp5db2b1Maqw3By72NN3mbZZUtyJCDIqrlsahYhcXMhTbljlzYgfYJDV5e2+O+MrR9PIuAH8GQ2Y++3yI3X++vjwzmqDTDEWPJbTST+NmLRa/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777326; c=relaxed/simple;
	bh=k53DMgrWfvaIEk+/prx0/1Y/uhQuhgdC9HKaKDt5VM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7fougm3JayZf/epEaVBOfGvXOcFXnHq5uGOFkK66xZ3TAjr5AvxZIJaZr1rmJZBEyO6tyTIUDKLk7KyiJi11p0v/v9qppEUaL4KkPZqzGnLiE6Vny7jil1iddwT59Z2WfVV7n/2WuV8mGHwWFS4aw4tYV/PvVY62x7RqdWbaa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkJJa+P5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkJJa+P5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC09C4CEF5;
	Wed,  3 Dec 2025 15:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777326;
	bh=k53DMgrWfvaIEk+/prx0/1Y/uhQuhgdC9HKaKDt5VM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkJJa+P5BM+1UnyUdTy3FLLwz6ZvxW5OE/80AXlzqiXzPHmtqPywVb1U4OZaW5Iml
	 XwBZKe98yXnoNipENDTrT9c5/bsJTjrzRZ85HLUS57oDxnfeCyuNXxtF5zRYbxf5NL
	 N0bFahkotMC7fj15GmdMeEQTjrBV4edK2BJ+5Y50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 143/146] usb: udc: Add trace event for usb_gadget_set_state
Date: Wed,  3 Dec 2025 16:28:41 +0100
Message-ID: <20251203152351.708837110@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


