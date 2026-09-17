Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E3C4F4CE9;
	Thu, 17 Sep 2026 16:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661269; cv=none; b=hQ8/EeWq1d89shk2rG3yBIMn9WKqqnEULyX8/m6AZ1arCBi9MLZ+ho+ZjeBvo5JQeYnd+TxYwKzvB27By4MLhckFEqiVCXXdTimmj/8OFmZUK1rH1/jTOqJYEB09T357TFKR/MqXmSN4SoagPh1Wu+Mp+i98XU0zbZyrI+7VtfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661269; c=relaxed/simple;
	bh=A0hDUunD3nJbo75Ja8bqVRbOve9YDGVPdnNvBrtggbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MQ7rR58txrekYy8qIsoeOf6JI3KYFZdOXANhEBvhe7ESSTkUOy37mX5io7ve8viAkbCNW1vQwL09y0S0f+zxuF709b9HS4M+d7chmDaQzkUQNpoUtCpVJr2dvsz743aLFlQkvBhggWKhprri8XJHks2oGBTDWZiZrxhFCb78wqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/vrexTi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/vrexTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DF61F000FF;
	Thu, 17 Sep 2026 16:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661267;
	bh=JEjJtbKgp94ZzdqCmMtCj9sgqiuprRXMs/gz0Qhb0ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V/vrexTi4feAfXm9cgdlj9JsUt7IJainyvX0JY6t2DWPi45QH2vu/bblvsYIsknD+
	 XFPP6InSiztcrRdqIFWrtAYhidWH1Y34Wc8Pm2f5oc6/Z6E/hPPYT1v63RqfEZNizi
	 4pVDO4k65npfRXuZz/C1YpVlBqjhkYZGn9hqztSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0139/1250] ALSA: usx2y: Drain pending US-428 pipe-4 output commands
Date: Thu, 17 Sep 2026 15:58:54 +0100
Message-ID: <20260917151555.819732598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 18977c0dd722f52217027ff75de2811c53cce2cc ]

The US-428 pipe-4 output path submits at most one pending p4out
entry from the shared-memory ring per input interrupt. If userspace
queues more than one command before the interrupt handler runs, later
commands remain pending until later input interrupts, even when async
pipe-4 URBs are available.

Drain pending entries while idle async URBs are available. Copy each
command into the existing per-URB async buffer before submission, so the
submitted transfer does not depend on a userspace-mapped ring slot
remaining unchanged after p4out_sent is advanced.

Also update p4out_sent only after usb_submit_urb() succeeds, so a
failed submission is not reported as sent.

This keeps the shared-memory ABI unchanged and fixes only the local
queue-draining behavior.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260519-alsa-usx2y-p4out-drain-v1-1-8f0a4550bae2@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/usbusx2y.c | 39 ++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c
index f34e78910200a..4190227c5a2a5 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -180,7 +180,7 @@ static void i_usx2y_in04_int(struct urb *urb)
 	struct usx2ydev		*usx2y = urb->context;
 	struct us428ctls_sharedmem	*us428ctls = usx2y->us428ctls_sharedmem;
 	struct us428_p4out *p4out;
-	int i, j, n, diff, send;
+	int i, j, n, diff, send, len;
 
 	usx2y->in04_int_calls++;
 
@@ -222,24 +222,31 @@ static void i_usx2y_in04_int(struct urb *urb)
 			} while (!err && usx2y->us04->submitted < usx2y->us04->len);
 		}
 	} else {
-		if (us428ctls && us428ctls->p4out_last >= 0 && us428ctls->p4out_last < N_US428_P4OUT_BUFS) {
-			if (us428ctls->p4out_last != us428ctls->p4out_sent) {
-				send = us428ctls->p4out_sent + 1;
-				if (send >= N_US428_P4OUT_BUFS)
-					send = 0;
-				for (j = 0; j < URBS_ASYNC_SEQ && !err; ++j) {
-					if (!usx2y->as04.urb[j]->status) {
-						p4out = us428ctls->p4out + send;	// FIXME if more than 1 p4out is new, 1 gets lost.
-						usb_fill_bulk_urb(usx2y->as04.urb[j], usx2y->dev,
-								  usb_sndbulkpipe(usx2y->dev, 0x04), &p4out->val.vol,
-								  p4out->type == ELT_LIGHT ? sizeof(struct us428_lights) : 5,
-								  i_usx2y_out04_int, usx2y);
-						err = usb_submit_urb(usx2y->as04.urb[j], GFP_ATOMIC);
+		while (us428ctls &&
+		       us428ctls->p4out_last >= 0 &&
+		       us428ctls->p4out_last < N_US428_P4OUT_BUFS &&
+		       us428ctls->p4out_last != us428ctls->p4out_sent) {
+			for (j = 0; j < URBS_ASYNC_SEQ && !err; ++j) {
+				if (!usx2y->as04.urb[j]->status) {
+					send = us428ctls->p4out_sent + 1;
+					if (send >= N_US428_P4OUT_BUFS)
+						send = 0;
+
+					p4out = us428ctls->p4out + send;
+					len = p4out->type == ELT_LIGHT ?
+						sizeof(struct us428_lights) : 5;
+					memcpy(usx2y->as04.urb[j]->transfer_buffer,
+					       &p4out->val.vol, len);
+					usx2y->as04.urb[j]->transfer_buffer_length = len;
+					err = usb_submit_urb(usx2y->as04.urb[j], GFP_ATOMIC);
+					if (!err)
 						us428ctls->p4out_sent = send;
-						break;
-					}
+
+					break;
 				}
 			}
+			if (j >= URBS_ASYNC_SEQ || err)
+				break;
 		}
 	}
 
-- 
2.53.0



