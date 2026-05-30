Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80488223DC6;
	Sat, 30 May 2026 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163153; cv=none; b=Weq7EIXfqRCtW+9b20beXh2bJMk7enDOldp8Wo3+OE2loSlLYKbr4exc2Zbe+fw9mFfbUYFC2HcUUoxe9wIcqGwaa+dtJmRyTOkB1BNMPK69IukrrBjviCxwoL672tFGb4yVrl47CKAjHsQP3DEx2L2O0HKjHPUzVVeAGgo44rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163153; c=relaxed/simple;
	bh=9InC5VP0fGKirA8sU1ideJNA6Gdsyk51PbBvfl+lwi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0ofbK7JBnt2xWYQl1YYFn8Lq4p85/E53uhdo/0lHfNjh6quVeaeA9EGlbNXx2L+NXNAfaL96v/ZLU1y4gUMPzh0Vm3cBHNVXECvDBmoOdQDAmC7HnFpS0mfDa90KurGpCgB11r56xt2SSJZIu+jhD/2NY7MObD04lsR75rrOGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pi991Bv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pi991Bv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E121F00893;
	Sat, 30 May 2026 17:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163152;
	bh=1AdLXkgiQkzcYQO8NItT6OrXVDI/4+Vh6pqnMn5MY2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pi991Bv2mWktIx2XTslf5269iP//kDcfJ5PV3rN5KBczxhNJ99hVYAIPMTdbXraVs
	 QQymRowg1pE6LLuv9cG0WTJg/R6otIQkN7Gp7/Bf2o6lN5O4/H3/VVFIzlGvp3ISCx
	 LRmiTcRvuvqSwJ3DBDUmZDw4z2bqToFJWRgM4hRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kagura <me@mail.kagurach.uk>,
	Cryolitia PukNgae <cryolitia.pukngae@linux.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 173/776] ALSA: usb-audio: apply quirk for MOONDROP JU Jiu
Date: Sat, 30 May 2026 17:58:07 +0200
Message-ID: <20260530160244.969097915@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cryolitia PukNgae <cryolitia.pukngae@linux.dev>

commit 4513d3e0bbc0585b86ccf2631902593ff97e88f5 upstream.

It(ID 31b2:0111 JU Jiu) reports a MIN value -12800 for volume control, but
will mute when setting it less than -10880.

Thanks to my girlfriend Kagura for reporting this issue.

Cc: Kagura <me@mail.kagurach.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
Link: https://patch.msgid.link/20260402-syy-v1-1-068d3bc30ddc@linux.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1220,6 +1220,13 @@ static void volume_control_quirks(struct
 			cval->res = 16;
 		}
 		break;
+	case USB_ID(0x31b2, 0x0111): /* MOONDROP JU Jiu */
+		if (!strcmp(kctl->id.name, "PCM Playback Volume")) {
+			usb_audio_info(chip,
+				       "set volume quirk for MOONDROP JU Jiu\n");
+			cval->min = -10880; /* Mute under it */
+		}
+		break;
 	}
 }
 


