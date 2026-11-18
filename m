Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031419;
	b=XGBDucDTUkEkzr6adacjtuld9B+rP9Btk6KmHTRQ6aAz6iurGs+0dqmrtXvxtrxNhFTx
	 I4qZMiX+ghv5rHSSG0vVdrmLGGxZwXxR4W7JNoMWxtYPMYzEHlSwG63qAjotZZcblgQ4z
	 RZu2x9qm2gZeDTQcXiSykyLAwvrjkZKjFLYWGt4iyMRx+HpHI1hHtn9RcmHU8xn0bMvdP
	 ijSq55vafeMKiLBEVaBvZ81DUSONq4V/IOIMhZsDvpGV82rXgdVm26hpGNxfpAtJDX5xf
	 GLRKkRNm5ernnmmH46x1D6D5W0RjFZn/Lq1DVQFa+0PvdvAXShzMMHmNrPQiwLNeDNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gi5kQAsdxUA4yMiWumF26yYgGVwp4N/KH7/xg80Gojs=;
	b=EIYduZvGwI7qU8A3cFMrtSHxbnz5hbbfLrusLPLWLRNketG1pllipGAKQ9IyE1K9nHMG
	 +vVWgYW5W6Gy/O9IdEsbPDTDak37PJmCLLGbAd4cwcG6K9vQheaEtTW8wmWLIyVEipn9w
	 ZmbBwbjlSU2d32iL30Eg/BmrkYCZtcdJDlJCcTODCE47UUpx4fRWrLGPRs3pMT6hLvqre
	 Go3pTdxYqi5ML0wX/mOM7RCm43G7fWxp9NpV2oQlJnhTzFVM2KaoVPBjBSS5uFZ2kKVU9
	 FLYonPJmpE1Mu5xptdBSjHdu0CYst8edbknEEBFszYsweXOnKl7kGy0GrRfwmTNzF7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u6zXfiW7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51B6606A320;
	Wed, 18 Nov 2026 19:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u6zXfiW7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA081F000C4;
	Wed, 18 Nov 2026 19:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031419;
	bh=Gi5kQAsdxUA4yMiWumF26yYgGVwp4N/KH7/xg80Gojs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u6zXfiW7VhJPd8poByWl1NTobKAtFbv5Zo39srafDo8+lTAZqk/m7qe2pAt7+6UAf
	 ESspMM85i93DD5DxM5ZWPEAC9KN8MKYQJeaXHcvedwORWO2Y+9xEKXI8ZL3YGPVdlT
	 o0I7sFA82Hj9KQSs+TA7k8eOkI0Nj56fAeo/4OKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1015/1756] ALSA: caiaq: Fix races at MIDI URB and trigger accesses
Date: Wed, 18 Nov 2026 15:52:22 +0100
Message-ID: <20261118150050.542207919@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 52b1213e2a086f2828500ab9c8bac45b213429bb ]

URB completion and rawmidi trigger callbacks can race with each other,
which may put the state inconsistent, causing double submissions, etc.

Guard both with a new spinlock for avoiding the races.

Fixes: f3f80a9205da ("ALSA: caiaq - Fix Oops with MIDI")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261008192553.300025-7-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/caiaq/device.c | 1 +
 sound/usb/caiaq/device.h | 3 ++-
 sound/usb/caiaq/midi.c   | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/usb/caiaq/device.c b/sound/usb/caiaq/device.c
index 993858d18b680..5e89047c9d9cc 100644
--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -448,6 +448,7 @@ static int create_card(struct usb_device *usb_dev,
 	cdev->chip.usb_id = USB_ID(le16_to_cpu(usb_dev->descriptor.idVendor),
 				  le16_to_cpu(usb_dev->descriptor.idProduct));
 	spin_lock_init(&cdev->spinlock);
+	spin_lock_init(&cdev->midi_lock);
 	mutex_init(&cdev->ep1_out_mutex);
 
 	*cardp = card;
diff --git a/sound/usb/caiaq/device.h b/sound/usb/caiaq/device.h
index 822d872c8ad1a..7b15cbffdec1f 100644
--- a/sound/usb/caiaq/device.h
+++ b/sound/usb/caiaq/device.h
@@ -74,7 +74,8 @@ struct snd_usb_caiaqdev {
 	unsigned char midi_out_buf[EP1_BUFSIZE];
 
 	struct caiaq_device_spec spec;
-	spinlock_t spinlock;
+	spinlock_t spinlock;	/* for PCM audio */
+	spinlock_t midi_lock;	/* midi_x_stream, midi_out_active */
 	wait_queue_head_t ep1_wait_queue;
 	wait_queue_head_t prepare_wait_queue;
 	int spec_received, audio_parm_answer;
diff --git a/sound/usb/caiaq/midi.c b/sound/usb/caiaq/midi.c
index 18529484c8dcc..b7d7d24937a74 100644
--- a/sound/usb/caiaq/midi.c
+++ b/sound/usb/caiaq/midi.c
@@ -79,6 +79,7 @@ static void snd_usb_caiaq_midi_output_trigger(struct snd_rawmidi_substream *subs
 {
 	struct snd_usb_caiaqdev *cdev = substream->rmidi->private_data;
 
+	guard(spinlock_irqsave)(&cdev->midi_lock);
 	if (up) {
 		cdev->midi_out_substream = substream;
 		if (!cdev->midi_out_active)
@@ -151,6 +152,7 @@ void snd_usb_caiaq_midi_output_done(struct urb* urb)
 {
 	struct snd_usb_caiaqdev *cdev = urb->context;
 
+	guard(spinlock_irqsave)(&cdev->midi_lock);
 	cdev->midi_out_active = 0;
 	if (urb->status != 0)
 		return;
-- 
2.53.0



