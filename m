Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046691;
	b=jkWnoMfWrKnC5Vh98m1jiFTv8nIU04QsJw1uvPGPw5k7yYHXbUldVpv0W+xe4NlQXd/J
	 wq7a5OMhX0FB2Yoo1kAJSOmmCJbNew9ZlXYAJgA6HYkk7JZRf17/sFug0Eypc2AOCmf+e
	 T9iO2XpfgIz+4TEx34XSAZPDoINu3xb8kUqAOOxlKbM9rQvV144xkyTqL2QXS+CHaQPqW
	 AzsYNIqUBPZLiZ6IGkHdfgXll16QnJ9XBdmdX+mBi3mjf8Ath66822ioZvU8a/aUQUm2s
	 9qV+LKrhtU7T3mhDTLkRtOBESAbhtnhmfv82B3ZR0DcaiygH0PPVVGWcL1vDA3t/0sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ClEcycCw78gRxymsmpHpA7RFvQt9UGdDZrzukEEfIy4=;
	b=Ea61CRcXuUdmFBAXR041APE2UhINQo967kypnGooxzaeFzgNCeNKGmE7gzY9abw5MNBz
	 IOH9UqI/4Xbt8iCmIOdXv9B3Fi8Ce+Vrw535uVMQjWu94DgwX/MRsz93lHRYJrWpUgYhv
	 OQMZcoP0LnbnlGUgLbtrGyzqLkeyLvbwiyoMpDsj1sIASFfqfqo0b+hmh6nhtRbXpnoX8
	 29O1IjUSrAwR6O9k8CXFpYak+mjqPzMnLmOEScWsalVe9C3ISimKrR7+cYqRuRyz6W3m9
	 CdtxBAvRNEwNjHH0Vl43PWg3hdIei+xmaUNgaiGhzV5w6ToZR+00/TrnJBa908uh7Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kaWyltvJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12210606A31C;
	Thu, 19 Nov 2026 00:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kaWyltvJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0DE1F000C4;
	Thu, 19 Nov 2026 00:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046690;
	bh=ClEcycCw78gRxymsmpHpA7RFvQt9UGdDZrzukEEfIy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kaWyltvJitrCz4N6AmbIAQjbgCvSv+2f4zQbQTbbmRIdGLCwT+bl3xjnXitzBXlnB
	 81SrmIM9RipOFlNcv/wK+LOuU4htqDIfvO9LmcRewh291M0IpHcMULazItqlj7vRAH
	 Gn+uzMeACwJQzje0tnpjQnB+mHs8gNJKwAu0fN28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1370/2857] ALSA: usb-audio: Protect Roland control activation
Date: Wed, 18 Nov 2026 15:40:04 +0100
Message-ID: <20261118150250.718285895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 19b42c1fff7f220a6346c614d79ce1bda6d95b40 ]

The USB MIDI driver changes the Roland MIDI Input Mode control's access
flags directly from the rawmidi open and close paths.  These changes are
not protected by the ALSA control core and the corresponding notifications
can race with control access.

Use snd_ctl_activate_id() so that the control core updates the access flags
and sends the notification under its lock.  Release the USB MIDI mutex
before calling it because the control write path holds controls_rwsem while
roland_load_put() takes the USB MIDI mutex.

Keep the state transition and alternate-setting change under the USB MIDI
mutex; rawmidi's open mutex serializes the enclosing open and close paths.

Fixes: 96f61d9ade82 ("sound: usb-audio: allow switching altsetting on Roland USB MIDI devices")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260929141726.2166899-1-runyu.xiao@seu.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: used explicit mutex and rwsem lock/unlock calls instead of scoped guards ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/midi.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index b883d50509b75..e0020956a100f 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1152,7 +1152,9 @@ static int substream_open(struct snd_rawmidi_substream *substream, int dir,
 			  int open)
 {
 	struct snd_usb_midi *umidi = substream->rmidi->private_data;
-	struct snd_kcontrol *ctl;
+	struct snd_ctl_elem_id ctl_id;
+	bool activate_ctl = false;
+	bool active;
 
 	down_read(&umidi->disc_rwsem);
 	if (umidi->disconnected) {
@@ -1164,11 +1166,9 @@ static int substream_open(struct snd_rawmidi_substream *substream, int dir,
 	if (open) {
 		if (!umidi->opened[0] && !umidi->opened[1]) {
 			if (umidi->roland_load_ctl) {
-				ctl = umidi->roland_load_ctl;
-				ctl->vd[0].access |=
-					SNDRV_CTL_ELEM_ACCESS_INACTIVE;
-				snd_ctl_notify(umidi->card,
-				       SNDRV_CTL_EVENT_MASK_INFO, &ctl->id);
+				ctl_id = umidi->roland_load_ctl->id;
+				activate_ctl = true;
+				active = false;
 				update_roland_altsetting(umidi);
 			}
 		}
@@ -1181,15 +1181,15 @@ static int substream_open(struct snd_rawmidi_substream *substream, int dir,
 			snd_usbmidi_input_stop(&umidi->list);
 		if (!umidi->opened[0] && !umidi->opened[1]) {
 			if (umidi->roland_load_ctl) {
-				ctl = umidi->roland_load_ctl;
-				ctl->vd[0].access &=
-					~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
-				snd_ctl_notify(umidi->card,
-				       SNDRV_CTL_EVENT_MASK_INFO, &ctl->id);
+				ctl_id = umidi->roland_load_ctl->id;
+				activate_ctl = true;
+				active = true;
 			}
 		}
 	}
 	mutex_unlock(&umidi->mutex);
+	if (activate_ctl)
+		snd_ctl_activate_id(umidi->card, &ctl_id, active);
 	up_read(&umidi->disc_rwsem);
 	return 0;
 }
-- 
2.53.0



