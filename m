Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACAA36A35E;
	Thu, 16 Jul 2026 13:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209209; cv=none; b=qV32lHgCw3BN2JIRvfPe4fPMtQH+HwtJQn7jJ88+hx6Y00qHqve+w/sGtRBysFYOglpAwYG6qJK4bwc2Lsv93ox2JriNvk4b/8DalwWLBIWHZotSNEeNu89zJOKpeGXGOZ/3aEItkFF/uXOEVjOCyjzKM1+ZPT3Gmb4YnmFb7lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209209; c=relaxed/simple;
	bh=mJX5wvTlliU+5AK8odpndehHqRwZwjJr+AaE1cK2sXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEjVHlFFj1yu3sRIX7ymhVJSIgEAaLfqEvra/p7HIKU+oGIZE1G0CdAeSJaqCY/tqq4wddcPo0GjdUff5YU/CIBLs2F13mhG06REJd9vJtkg6NxJA9gtqQl5Wibb4VPehNRNJjfc7LvFILMUzMf0yBLyN9G//jmwP9HjsUapb5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOnXJt9x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOnXJt9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C511F000E9;
	Thu, 16 Jul 2026 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209208;
	bh=NkrIkAB70VpTEAIIE7VKOnCYJIcGkARD9Pi4LUsZtwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YOnXJt9xA6WJ0jk8rUHGMOKmrtGXzVolKK2i7dQir0wYR0rFeXcUhWwJHdKNqkN+N
	 QVifyjMX33Rcl02fgW2xkk5DMG60PSEYOfJuc75pG8C+IpeoCKEgQ8jWy1VLI2h5Cr
	 8sWfTl0hMEP9Up9ifHcPYTsGJY5TOFtSCQW+BLxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gordon Chen <chengordon326@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 098/518] ALSA: usb-audio: add IFB_SILENCE_ON_EMPTY quirk for Behringer Flow 8
Date: Thu, 16 Jul 2026 15:26:06 +0200
Message-ID: <20260716133050.009483936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gordon Chen <chengordon326@gmail.com>

commit a23812004228d4b041a858b927db787a7ff80f50 upstream.

The Behringer Flow 8 (1397:050c) is an 8-channel USB mixer that
declares OUT EP 0x01 with implicit feedback from capture EP 0x81 via
its UAC2 endpoint companion descriptor. After 5-35 minutes of
continuous playback, the device occasionally returns a capture URB in
which every iso_frame_desc has a non-zero status (-EXDEV bursts,
visible as rate-limited "frame N active: -18" lines in dmesg from
pcm.c).

In that case snd_usb_handle_sync_urb() at endpoint.c counts bytes==0
and falls into the early "skip empty packets" return originally added
for M-Audio Fast Track Ultra. As a result the playback EP loses its
sole IFB-driven feeder and the OUT ring starves permanently: hw_ptr
stops advancing while substream state remains RUNNING. Only USB
re-enumeration recovers.

Three independent ftrace captures (taken at the moment of stall via a
userspace watchdog) consistently show:

  - 60-70 capture URB completions in the 70ms window before the marker
  - 0 retire_playback_urb / queue_pending_output_urbs /
    snd_usb_endpoint_implicit_feedback_sink calls
  - every usb_submit_urb in the window comes from
    snd_complete_urb+0x64e (capture self-resubmit), none from the
    queue_pending_output_urbs path

Add a new opt-in quirk QUIRK_FLAG_IFB_SILENCE_ON_EMPTY: when set, the
early return is skipped and we fall through to enqueue a packet_info
whose packet_size[i] are all 0 (the existing loop already maps
status!=0 packets to size 0). prepare_outbound_urb then emits a
silence packet, the OUT ring keeps moving, and the device rides
through the glitch.

The default behaviour (early return) is preserved for all existing
devices including M-Audio Fast Track Ultra. Only Flow 8 opts in here.

Cc: stable@vger.kernel.org
Signed-off-by: Gordon Chen <chengordon326@gmail.com>
Link: https://patch.msgid.link/20260526072906.90106-1-chengordon326@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |   10 +++++++++-
 sound/usb/quirks.c   |    3 +++
 sound/usb/usbaudio.h |    8 ++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1780,8 +1780,16 @@ static void snd_usb_handle_sync_urb(stru
 		/*
 		 * skip empty packets. At least M-Audio's Fast Track Ultra stops
 		 * streaming once it received a 0-byte OUT URB
+		 *
+		 * However, on devices where bytes==0 means every sync-source
+		 * packet errored (e.g. Behringer Flow 8 returning -EXDEV bursts
+		 * for entire capture URBs), an unconditional return starves the
+		 * IFB-fed OUT ring permanently. Such devices set
+		 * QUIRK_FLAG_IFB_SILENCE_ON_EMPTY to fall through and enqueue a
+		 * packet_info with size 0 packets, so playback emits silence
+		 * and the OUT ring keeps moving.
 		 */
-		if (bytes == 0)
+		if (bytes == 0 && !(ep->chip->quirk_flags & QUIRK_FLAG_IFB_SILENCE_ON_EMPTY))
 			return;
 
 		spin_lock_irqsave(&ep->lock, flags);
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2365,6 +2365,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_PLAYBACK_FIRST | QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x1397, 0x0509, /* Behringer UMC404HD */
 		   QUIRK_FLAG_PLAYBACK_FIRST | QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x1397, 0x050c, /* Behringer Flow 8 */
+		   QUIRK_FLAG_IFB_SILENCE_ON_EMPTY),
 	DEVICE_FLG(0x13e5, 0x0001, /* Serato Phono */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x152a, 0x880a, /* NeuralDSP Quad Cortex */
@@ -2606,6 +2608,7 @@ static const char *const snd_usb_audio_q
 	QUIRK_STRING_ENTRY(SKIP_IFACE_SETUP),
 	QUIRK_STRING_ENTRY(MIXER_PLAYBACK_LINEAR_VOL),
 	QUIRK_STRING_ENTRY(MIXER_CAPTURE_LINEAR_VOL),
+	QUIRK_STRING_ENTRY(IFB_SILENCE_ON_EMPTY),
 	NULL
 };
 
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -236,6 +236,12 @@ extern bool snd_usb_skip_validation;
  * QUIRK_FLAG_MIXER_CAPTURE_LINEAR_VOL
  *  Similar to QUIRK_FLAG_MIXER_PLAYBACK_LINEAR_VOL, but for capture streams.
  *  Overrides QUIRK_FLAG_MIXER_CAPTURE_MIN_MUTE
+ * QUIRK_FLAG_IFB_SILENCE_ON_EMPTY
+ *  In implicit feedback mode, when an entire capture URB returns with
+ *  all iso_frame_desc[i].status != 0 (bytes==0), do not silently return
+ *  from snd_usb_handle_sync_urb. Instead fall through and enqueue a
+ *  packet_info containing only size-0 packets, so the OUT ring keeps
+ *  moving (emits silence). Needed by Behringer Flow 8 (1397:050c).
  */
 
 enum {
@@ -268,6 +274,7 @@ enum {
 	QUIRK_TYPE_SKIP_IFACE_SETUP		= 26,
 	QUIRK_TYPE_MIXER_PLAYBACK_LINEAR_VOL	= 27,
 	QUIRK_TYPE_MIXER_CAPTURE_LINEAR_VOL	= 28,
+	QUIRK_TYPE_IFB_SILENCE_ON_EMPTY		= 29,
 /* Please also edit snd_usb_audio_quirk_flag_names */
 };
 
@@ -302,5 +309,6 @@ enum {
 #define QUIRK_FLAG_SKIP_IFACE_SETUP		QUIRK_FLAG(SKIP_IFACE_SETUP)
 #define QUIRK_FLAG_MIXER_PLAYBACK_LINEAR_VOL	QUIRK_FLAG(MIXER_PLAYBACK_LINEAR_VOL)
 #define QUIRK_FLAG_MIXER_CAPTURE_LINEAR_VOL	QUIRK_FLAG(MIXER_CAPTURE_LINEAR_VOL)
+#define QUIRK_FLAG_IFB_SILENCE_ON_EMPTY		QUIRK_FLAG(IFB_SILENCE_ON_EMPTY)
 
 #endif /* __USBAUDIO_H */


