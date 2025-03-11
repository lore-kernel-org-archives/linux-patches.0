Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F521CAA8F;
	Tue, 11 Mar 2025 15:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707260; cv=none; b=l1/Wg02f2iH2UYTTU6n62FZ1fLk32g717xh6pBYnishHZ6MWRmByaMUjvOo/X6B7xEzBWn+DeThDxp0FAJNbzfkx3HILHMFEfBIZEcg6ab6qk+Syc+QS4fW7f7LrzjUO2wYNquDtrImyu+Wb2h2r2JkOxdrAYtGaL2YzMdgSekY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707260; c=relaxed/simple;
	bh=3Lq2HoCL9hHJ0zvKJJJiCN+69uqaAh6OTpov0+ACMuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqzLY3SexylNbqgHV6zRQgnzdrIVxkLq+e4gbcsDJm6ww0Opu24WVRanEjiTDm8l96+Ozmamdu39JYkdoRat/KpJq0n2vvLg27i9XLJk9VxrboNCzrGQS0DY3DTwzM0b2Eb8HDF+/4xMDgxo5qioVvkm8/ezKHsaIIdRUemVvJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9B0as9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9B0as9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9EAC4CEE9;
	Tue, 11 Mar 2025 15:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707260;
	bh=3Lq2HoCL9hHJ0zvKJJJiCN+69uqaAh6OTpov0+ACMuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9B0as9zeqabTVrJSGchEcMFoz54Jyd+B7W33IYciKrp2B9GnYSiF4rQPv5X0UMus
	 yGyqpYWFBjUPZHltw7Ca6By4GmSPdBQL32ARPJV3d0HfdzQKW2mQJyYyJIaIWnMI1X
	 z4SseysrVaAPsZYYCH24XJIFMsxQQRE5R2oFSWlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Felipe Balbi <balbi@kernel.org>,
	Davidlohr Bueso <dbueso@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 329/462] usb/gadget: f_midi: Replace tasklet with work
Date: Tue, 11 Mar 2025 15:59:55 +0100
Message-ID: <20250311145811.359393078@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit 8653d71ce3763aedcf3d2331f59beda3fecd79e4 ]

Currently a tasklet is used to transmit input substream buffer
data. However, tasklets have long been deprecated as being too
heavy on the system by running in irq context - and this is not
a performance critical path. If a higher priority process wants
to run, it must wait for the tasklet to finish before doing so.

Deferring work to a workqueue and executing in process context
should be fine considering the callback already does
f_midi_do_transmit() under the transmit_lock and thus changes in
semantics are ok regarding concurrency - tasklets being serialized
against itself.

Cc: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Link: https://lore.kernel.org/r/20210111042855.73289-1-dave@stgolabs.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4ab37fcb4283 ("USB: gadget: f_midi: f_midi_complete to call queue_work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_midi.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/function/f_midi.c b/drivers/usb/gadget/function/f_midi.c
index 71aeaa2302edd..01c5736d381ef 100644
--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -87,7 +87,7 @@ struct f_midi {
 	struct snd_rawmidi_substream *out_substream[MAX_PORTS];
 
 	unsigned long		out_triggered;
-	struct tasklet_struct	tasklet;
+	struct work_struct	work;
 	unsigned int in_ports;
 	unsigned int out_ports;
 	int index;
@@ -698,9 +698,11 @@ static void f_midi_transmit(struct f_midi *midi)
 	f_midi_drop_out_substreams(midi);
 }
 
-static void f_midi_in_tasklet(struct tasklet_struct *t)
+static void f_midi_in_work(struct work_struct *work)
 {
-	struct f_midi *midi = from_tasklet(midi, t, tasklet);
+	struct f_midi *midi;
+
+	midi = container_of(work, struct f_midi, work);
 	f_midi_transmit(midi);
 }
 
@@ -737,7 +739,7 @@ static void f_midi_in_trigger(struct snd_rawmidi_substream *substream, int up)
 	VDBG(midi, "%s() %d\n", __func__, up);
 	midi->in_ports_array[substream->number].active = up;
 	if (up)
-		tasklet_hi_schedule(&midi->tasklet);
+		queue_work(system_highpri_wq, &midi->work);
 }
 
 static int f_midi_out_open(struct snd_rawmidi_substream *substream)
@@ -875,7 +877,7 @@ static int f_midi_bind(struct usb_configuration *c, struct usb_function *f)
 	int status, n, jack = 1, i = 0, endpoint_descriptor_index = 0;
 
 	midi->gadget = cdev->gadget;
-	tasklet_setup(&midi->tasklet, f_midi_in_tasklet);
+	INIT_WORK(&midi->work, f_midi_in_work);
 	status = f_midi_register_card(midi);
 	if (status < 0)
 		goto fail_register;
-- 
2.39.5



