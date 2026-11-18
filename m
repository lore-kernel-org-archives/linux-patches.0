Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049469;
	b=U/WIRgwYCS1EXBDAZ0B+3QOZpnDwGmkCtH4ce+sV/3/cnFtumbYTVSotOnjOwl2FucLo
	 lgel6ycq4/eMBNYnK/NgwllENIxYr0JmO1ZPXz/dWZZ6fyIGbMq42QRMpmOXdTSxaCBkg
	 FYsmhpeo2o85E8mQpnuha1WjbMZHuuLNESOFM4CaW/BeATxnaTCy/iXNraCHfWF/XB/lI
	 XFfYbcYUp7l2YNf5C05+ftf8ugacceFJI26k4JBgSyhrSuT3LGVV9QrNuQsFuBva0JgoY
	 O8Bos991Ozr5QGzLhnxmMmO16+fDbpGFaMDvICzBFTA0vbVhwtXcZk7wNugJd8xNo+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nHr0M8RGVRQU1Be8HDnq+ELuDCzp2F4N8ihMtmd1CsA=;
	b=ZkxUHnHMhyjP6HsdajRw1k9tP0D7jeV2AQF90VPAPOyNPujVm8GrKdcWLGo4vehSjADe
	 4M0771vg14eS5fXM9TgfWtUi5xQFOEVJD60DgWB1JGjdpvc6yGI/mugRnmy4FSNeFKAy0
	 AgIQnZ4nib/nakgKoRUelu4RuchCRjPrceR+Y8EKDXZmQ82IR7F1oqkPlYNBQ4Txsy1wK
	 XPFABIYSQROl2E7H8a+FCRK28tmJSfSYobyfshYO5s7SzcXQD/fFDjiRD0MSJY185NehS
	 +jleKNI15Y2ozDN5regE86QEKcxvKg/Nlx0m+BZgWjZwq+BG+bzrFrpCUshb7bz/9kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N3rt7tg9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C77606A31C;
	Thu, 19 Nov 2026 00:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N3rt7tg9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A529F1F000C5;
	Thu, 19 Nov 2026 00:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049469;
	bh=nHr0M8RGVRQU1Be8HDnq+ELuDCzp2F4N8ihMtmd1CsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N3rt7tg9cKhjVbYD3CL3BK3g9W/sra0mRVNA1ZvX9LVNM43OmTKCvijn7zWSIu88I
	 O6L0KXJ9I7F3J4FnqUxmPPFvRfMOZKTOms0H27m9xSmOYUk5RWEVtZxgjHdW3Awe4S
	 3h6PsL62k6NDwQG1zG0DB6QfKq2ot4p2TWJ+dVcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2321/2857] ALSA: usb-audio: Check mixer matrix size for UAC2/3 at parsing
Date: Wed, 18 Nov 2026 15:55:55 +0100
Message-ID: <20261118150325.107412395@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 22185ffd7b31885d03fdeb20055a8707779a70f9 ]

The matrix of input/output channels specified in a UAC2/3 mixer unit
must fit to the upper limit 256.  Add a sanity check and returns an
error if an invalid size is detected.

Link: https://lore.kernel.org/d46fcac6-bd7e-4fc4-95e1-4e8d39f92ad3@zipdox.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260930155356.348608-2-tiwai@suse.de
Stable-dep-of: c01fb2ed90c0 ("ALSA: usb-audio: Fix invalid UAC2/3 mixer unit matrix evaluation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 9d54998634094..5dfbe4781570c 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2286,6 +2286,16 @@ static int parse_audio_mixer_unit(struct mixer_build *state, int unitid,
 	num_outs = err;
 	input_pins = desc->bNrInPins;
 
+	if (state->mixer->protocol == UAC_VERSION_2 ||
+	    state->mixer->protocol == UAC_VERSION_3) {
+		if (input_pins * num_outs > 256) {
+			usb_audio_err(state->chip,
+				      "invalid channels for MIXER UNIT %d: input=%d, output=%d\n",
+				      unitid, input_pins, num_outs);
+			return -EINVAL;
+		}
+	}
+
 	num_ins = 0;
 	ich = 0;
 	for (pin = 0; pin < input_pins; pin++) {
-- 
2.53.0



