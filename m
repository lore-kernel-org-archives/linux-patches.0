Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3CA31F99C;
	Tue, 21 Jul 2026 15:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648879; cv=none; b=PkaAoJuuJvJ9e4psf0RZSjEXehS8D3HI2mW5Vl1QSuTP/9HlpwhZEHV4UKrio8rWeOeSglPhyTeJJO6I2GTxRfs0K7LeEdrgwpV4TKPsWhRCkTvUMBXPlZ2QFIEW8TczOLzjW/SvOQBBgFDpBb4Bgsoz4Icd1f1GpIkb8weXSuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648879; c=relaxed/simple;
	bh=VpVXlloPMDCxrPTH0Hu8A1BIK9KK0Tqi99cvoJt+cnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zw6TvLl0n9dMJd5ZR0FYJubedTHmX0PrdapNxoSnjgOiiwsTpAJLE+mLxyCwa+yLdDC9/1VubRTVH2R28BG5169DWhpvzygVAaU4S3cpvLsCZJ546TECWDPe+4opmpRXVXIXU6TNtGEF0wyc2TPLie1HW9iOPPOIyRKUcON8krs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tp+US66i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tp+US66i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5311F00A3A;
	Tue, 21 Jul 2026 15:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648878;
	bh=n07zq50tfIEvzjo1Nw6JJyu78bZu/FR+zZc4xJXksJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tp+US66iPMlPeNcdiAQkbIZhMI2DGvu8yfJKH01HeeGDWk2QOAWDwJCRKX/HUgqij
	 SJ7UFkslabTF0x/zAVwbNCxV5ErWUIVFg4/mO6drwhKPHU6uP5voKtfkY7fTwu0yGM
	 o1rSd1Uj18JsR+DdgBh7gBfmdIhWL0RIwna59rG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0322/2077] ALSA: xen-front: Reset event channel state on stream clear
Date: Tue, 21 Jul 2026 16:59:55 +0200
Message-ID: <20260721152600.271027092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 9cd81152373c560b8aa8299b0705c4db82b103b7 ]

xen_snd_front_evtchnl_pair_clear() resets evt_next_id for both
channels. That is correct for the request channel, where evt_next_id is
used to allocate the next request id. It is wrong for the event channel:
incoming events are validated against evt_id, and evt_id is incremented
by evtchnl_interrupt_evt().

This leaves the expected event id from the previous stream instance. A
backend that restarts event ids for a reopened stream can then have valid
current-position events dropped until the stale frontend id catches up.

Reset evt_id for the event channel. Also advance the event-page consumer
to the current producer while clearing the stream, so obsolete events
queued for the previous stream instance are not delivered to the next
ALSA runtime.

Fixes: 1cee559351a7 ("ALSA: xen-front: Implement ALSA virtual sound driver")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260526-alsa-xen-event-channel-fixes-v1-1-91d3a6a50778@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/xen/xen_snd_front_evtchnl.c | 8 ++++++--
 sound/xen/xen_snd_front_evtchnl.h | 4 ++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/xen/xen_snd_front_evtchnl.c b/sound/xen/xen_snd_front_evtchnl.c
index bc03f71bf16e33..09e4c1d0563632 100644
--- a/sound/xen/xen_snd_front_evtchnl.c
+++ b/sound/xen/xen_snd_front_evtchnl.c
@@ -456,7 +456,11 @@ void xen_snd_front_evtchnl_pair_clear(struct xen_snd_front_evtchnl_pair *evt_pai
 	}
 
 	scoped_guard(mutex, &evt_pair->evt.ring_io_lock) {
-		evt_pair->evt.evt_next_id = 0;
+		evt_pair->evt.evt_id = 0;
+		/* Drop obsolete events queued for the previous stream instance. */
+		evt_pair->evt.u.evt.page->in_cons =
+			evt_pair->evt.u.evt.page->in_prod;
+		/* Ensure the consumer index is visible before stream reuse. */
+		virt_wmb();
 	}
 }
-
diff --git a/sound/xen/xen_snd_front_evtchnl.h b/sound/xen/xen_snd_front_evtchnl.h
index 3675fba705647d..8400261ac46601 100644
--- a/sound/xen/xen_snd_front_evtchnl.h
+++ b/sound/xen/xen_snd_front_evtchnl.h
@@ -37,9 +37,9 @@ struct xen_snd_front_evtchnl {
 	/* State of the event channel. */
 	enum xen_snd_front_evtchnl_state state;
 	enum xen_snd_front_evtchnl_type type;
-	/* Either response id or incoming event id. */
+	/* Current response id or next expected incoming event id. */
 	u16 evt_id;
-	/* Next request id or next expected event id. */
+	/* Next request id. */
 	u16 evt_next_id;
 	/* Shared ring access lock. */
 	struct mutex ring_io_lock;
-- 
2.53.0



