Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CCD24E000;
	Thu,  3 Apr 2025 15:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693875; cv=none; b=uJYbSQ7dr6lL/941EJzTq6e5Q98UPbjCg9MSR7itrsupkCWBVBzI8b1GX2+jFkp3aT41OBJCxDG+3ZnWYO4nPo2vRloZuob7PnUMN2jNCDloyeBJt2N8l+7IN8FuC2EPIosd+dxAgI+QZpB9tvPbWFbyan27ECl4y8hLDM4QfEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693875; c=relaxed/simple;
	bh=JJ7orOaJQUoRb7ShQMl6MywuG4ZDw6xRElOpfaxJY14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YU5zPSZWIwrjXTH8i15S2+DQjl1HBCnR0OCwQy2V54E7mZlpNWsA9Przn2DGpT+ounaJmu2ZjgS62cIHglG/1ctghn24KpkJOMg4gRrbUsqiSDqhoSJHdV+M3j2LJv/jTwYiR6iu6eJzbAl5fAqi92Yv/9Y856Ossm9zb6rudCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFAJqxke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFAJqxke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F270FC4CEE3;
	Thu,  3 Apr 2025 15:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693875;
	bh=JJ7orOaJQUoRb7ShQMl6MywuG4ZDw6xRElOpfaxJY14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFAJqxkey+7YeZV/18yQ9yRANmwcUqoq3+fG4u3BuihezdqUaWI0VtlhCo4CJsRlo
	 +eVYbxz6WZ0gPcNliT3/ZlHkSzIkpfTb8jc3SXT82YYcWQqJg9eKWcy7Pe7WUfvhgt
	 EcJXgEk9dhN2OpoYNGZYvLAYmRga43h3UYoFK3ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 16/22] usb: xhci: Dont skip on Stopped - Length Invalid
Date: Thu,  3 Apr 2025 16:20:26 +0100
Message-ID: <20250403151622.505793580@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.055059925@linuxfoundation.org>
References: <20250403151622.055059925@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

commit 58d0a3fab5f4fdc112c16a4c6d382f62097afd1c upstream.

Up until commit d56b0b2ab142 ("usb: xhci: ensure skipped isoc TDs are
returned when isoc ring is stopped") in v6.11, the driver didn't skip
missed isochronous TDs when handling Stoppend and Stopped - Length
Invalid events. Instead, it erroneously cleared the skip flag, which
would cause the ring to get stuck, as future events won't match the
missed TD which is never removed from the queue until it's cancelled.

This buggy logic seems to have been in place substantially unchanged
since the 3.x series over 10 years ago, which probably speaks first
and foremost about relative rarity of this case in normal usage, but
by the spec I see no reason why it shouldn't be possible.

After d56b0b2ab142, TDs are immediately skipped when handling those
Stopped events. This poses a potential problem in case of Stopped -
Length Invalid, which occurs either on completed TDs (likely already
given back) or Link and No-Op TRBs. Such event won't be recognized
as matching any TD (unless it's the rare Link TRB inside a TD) and
will result in skipping all pending TDs, giving them back possibly
before they are done, risking isoc data loss and maybe UAF by HW.

As a compromise, don't skip and don't clear the skip flag on this
kind of event. Then the next event will skip missed TDs. A downside
of not handling Stopped - Length Invalid on a Link inside a TD is
that if the TD is cancelled, its actual length will not be updated
to account for TRBs (silently) completed before the TD was stopped.

I had no luck producing this sequence of completion events so there
is no compelling demonstration of any resulting disaster. It may be
a very rare, obscure condition. The sole motivation for this patch
is that if such unlikely event does occur, I'd rather risk reporting
a cancelled partially done isoc frame as empty than gamble with UAF.

This will be fixed more properly by looking at Stopped event's TRB
pointer when making skipping decisions, but such rework is unlikely
to be backported to v6.12, which will stay around for a few years.

Fixes: d56b0b2ab142 ("usb: xhci: ensure skipped isoc TDs are returned when isoc ring is stopped")
Cc: stable@vger.kernel.org
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250306144954.3507700-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2866,6 +2866,10 @@ static int handle_tx_event(struct xhci_h
 		if (!ep_seg) {
 
 			if (ep->skip && usb_endpoint_xfer_isoc(&td->urb->ep->desc)) {
+				/* this event is unlikely to match any TD, don't skip them all */
+				if (trb_comp_code == COMP_STOPPED_LENGTH_INVALID)
+					return 0;
+
 				skip_isoc_td(xhci, td, ep, status);
 				if (!list_empty(&ep_ring->td_list))
 					continue;


