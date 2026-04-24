Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9476386C0A;
	Fri, 24 Apr 2026 13:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038164; cv=none; b=YwbMWU6r5AnjSWiseWyF7vXbGJrLnpXDqpgeL/2cs9p4Gr60wWLD2CYA17g/Qj2jfqPCHNq6jZb1h/XyQJrwqFQV00nqwFXDhr+b+DlR3WxWTo6QyLVoP2x2i+9B7qaa3lW/2y5zKpQgIvW+nLNWxRyiFoqLVl/O9+F90qcoNHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038164; c=relaxed/simple;
	bh=vVuHF5xNjqHI1bnwMwwlE+Jj8oKWubcKz5cdm+3DgvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmxSGIUGG3CkgDlDJWt+CKz0rC1YF+HhvUyHKyVABLjCxOJ8SrYiyBkY82+0nzCOkQLtUGu6RqVWbm8u1wkkdQX1834VBT0Z/Bzkgpa4HFDazBDtZRJjMQP/jxHRTK7yHUeOwFAwQkx+hoKPYJxSpHn/LEgeXyWajdr2KMhXFtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbW3z8te; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbW3z8te"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8083AC19425;
	Fri, 24 Apr 2026 13:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038163;
	bh=vVuHF5xNjqHI1bnwMwwlE+Jj8oKWubcKz5cdm+3DgvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbW3z8te0PYUCJDs7GLh5eNKG41EF3kemqiJnBanQcRkjdneWlbWcTAmIjaaAA8GM
	 u8ydVfh56jnIbPkmXQfbBjPOH4ZYdOmWZeRZDYxexfFCe1fB3T1zFzcCN8VSRl1deO
	 dyn/B6NmtpOFumnWF1LTFPuZFLempDf0nTzK+nM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kagura <me@mail.kagurach.uk>,
	Cryolitia PukNgae <cryolitia.pukngae@linux.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 48/55] ALSA: usb-audio: apply quirk for MOONDROP JU Jiu
Date: Fri, 24 Apr 2026 15:31:27 +0200
Message-ID: <20260424132440.044390109@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


