Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A8C2505D6;
	Thu,  3 Apr 2025 15:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693819; cv=none; b=XfXdCCeQQ+FzztmQbiOw5ZKTWG585AKTr+d5oInAlvn2RD/0yunHrhg3ideqaJvnLCqW3dv8eNXZbSfiuEEG3Y11aKiadfE6sDrCk9aVPvEtD4ycWKvIKUFA7UdnQ+E4JTY0a5vPueQsAseGdL5f7F7ft861i6AfHhcSKxefwBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693819; c=relaxed/simple;
	bh=g7X/m/b6uBrwsPQY8W20gjRLbd7pDeapJ39zVVDXlks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0mocLgAXb9TIXxTogTaKG1+o15sR4N+lLsDuQZmObBRK+avgo/N6L5PRCyy7YAiCb33qQGDvQFr0Rx44NxnRjXN6i1eVPz5PQ8BSEDK35+WQvyGRCiEKna0D3yEJJzSLSdvedc76oIvYdIeAhOGEAoKh4MzghIU54T86g90/l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5gRQI5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5gRQI5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D353C4CEE8;
	Thu,  3 Apr 2025 15:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693819;
	bh=g7X/m/b6uBrwsPQY8W20gjRLbd7pDeapJ39zVVDXlks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y5gRQI5SZqJ5ZY/VrQMNalTx9UulLfCJEA7rTEa1QeOxNwEISY36zbChIxYqgkUZ4
	 H24fya5OriR88FKI9NI2MxPuk4073CKM5E06jL1ryf6D0eLNhPJr4cZhFxYTv5JqIJ
	 5UAAjy+GMsnlT1uP6lW7JMd36q2DFtFX0qFRW768=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.14 16/21] usb: xhci: Dont skip on Stopped - Length Invalid
Date: Thu,  3 Apr 2025 16:20:20 +0100
Message-ID: <20250403151621.594981179@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151621.130541515@linuxfoundation.org>
References: <20250403151621.130541515@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2865,6 +2865,10 @@ static int handle_tx_event(struct xhci_h
 		if (!ep_seg) {
 
 			if (ep->skip && usb_endpoint_xfer_isoc(&td->urb->ep->desc)) {
+				/* this event is unlikely to match any TD, don't skip them all */
+				if (trb_comp_code == COMP_STOPPED_LENGTH_INVALID)
+					return 0;
+
 				skip_isoc_td(xhci, td, ep, status);
 				if (!list_empty(&ep_ring->td_list))
 					continue;


