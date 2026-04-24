Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F473B38AE;
	Fri, 24 Apr 2026 13:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038042; cv=none; b=r5bvqCSSWFp/OlP1GrvJvJ+ZRqlr36BNRw1gTPTKctow5/0LKcBy1YqQ56SOcxDGF87/ssfRmgHx4Nt4BmqnqjH6TLHqk2y5kFpkNybMEN7WMEL3tLTnkXFZ+ZbabVplamjQ/7/Ybn+4boEk8X+nO/pt0DuWv7qAiPQ93G9vTdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038042; c=relaxed/simple;
	bh=t6iLwhWBfjxh3Eqw0pACchc6yvbk0e8l7eBtHEaIzfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKIS+Z9F/puMLaPHkuX0L4s+agVRNEBeiJu0+QnGD/pmJQcmSbYiJZ2V6ysg93Z7KVLDUvVHG/uW6EBZeicgXNLPZzLMsTs1iACXGuCo20/qQu8dUkDIz+ioloWOlb1BlP4wBzte3u2ZC2Sqv8V+VnDFqQaCRLpMXSq9qC8fxbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZzbNPVF+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZzbNPVF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F517C19425;
	Fri, 24 Apr 2026 13:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038042;
	bh=t6iLwhWBfjxh3Eqw0pACchc6yvbk0e8l7eBtHEaIzfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZzbNPVF+RIK3QD1cXfyxpgpmvHXW9ycq9TyUUTwBKKpx3aWdjom8EBbjXpkA7gB64
	 UucvjKde6uJJh1DhaZcPAwg/Ub0wkR6ElwP962AqGxp5sIamdqgudNsAmkBAwqNUYL
	 mUehFNAoIYBP2k/phOqPgYi8zpYkBHwN+/x+o0iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kagura <me@mail.kagurach.uk>,
	Cryolitia PukNgae <cryolitia.pukngae@linux.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 157/166] ALSA: usb-audio: apply quirk for MOONDROP JU Jiu
Date: Fri, 24 Apr 2026 15:31:11 +0200
Message-ID: <20260424132605.990922819@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1198,6 +1198,13 @@ static void volume_control_quirks(struct
 			cval->min = -14208; /* Mute under it */
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
 


