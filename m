Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BB033E347;
	Fri, 24 Apr 2026 13:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037621; cv=none; b=Igtv4nhGYxrtW7NoR4cP22Y5raJaUTmgpEgJ0mIDuAuRHw0RVZQrWkDFV8kvhXrOLURqBpf0P3ntOK2FnkOvbAW2bN3ZKiLKOwab7HPVUL4DcmQ0qkufbYQCRxVMNOnBPUpLaru9fWlivEIDv+h5cKQOvIUBAW9qGSM5rOXv0YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037621; c=relaxed/simple;
	bh=+unyWY038wpEmidr+khSaqZ5YuiiOXtN5FFhwz+6hbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrK7UO1Oc/LWzUrw4x9Y9N040l72MZFR5dyLPvRxJKQamOjmmwbt7APEzoLvN1b4GUedsVbDXrbKWFbLd1yjUEqYfBLu0lGuAkTfl6ksGgy+rHpfJK0xAVb8RQahaWsZ+x7K0UAJyYRyiCEjEbSr8Lm9VrSwfkKyBofTzFfOAwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CATvDhZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CATvDhZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC38C2BCB2;
	Fri, 24 Apr 2026 13:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037621;
	bh=+unyWY038wpEmidr+khSaqZ5YuiiOXtN5FFhwz+6hbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CATvDhZhlkLDC6Emb51K11aZ3Qfntv98G2jpthCN9wXmRwMZqU0YCXBHaUycLgByA
	 9kWtC5jwcISIQTskaqu9hRzbCUmdgsoJL322RlXW1+pWspnmdlMFpsc69yWJ7CCngg
	 M/eN6I+UYpZmhW8S91FOJZi2R1garnqVAqcG1RDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kagura <me@mail.kagurach.uk>,
	Cryolitia PukNgae <cryolitia.pukngae@linux.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 34/42] ALSA: usb-audio: apply quirk for MOONDROP JU Jiu
Date: Fri, 24 Apr 2026 15:30:59 +0200
Message-ID: <20260424132427.606794925@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1204,6 +1204,13 @@ static void volume_control_quirks(struct
 			cval->min = -11264; /* Mute under it */
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
 


