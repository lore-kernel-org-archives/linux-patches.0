Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF1C3D6CD6;
	Fri, 24 Apr 2026 13:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038259; cv=none; b=n66ur37wcr8LtawgDZ2Viep965V8NCVFyb20H0TcHg6B7Z4VZ1y/LR9fJX9EUESrvWqC8Ezzp2IEstk5bUbAgQ/YaZuDnB/CoUm+BbT/VZq9mcwfuI8JUARAWoZ0NIongenHycGqzw3HzyXs5eBBEimW5VVbar3wVci5ocK/BXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038259; c=relaxed/simple;
	bh=u8DN5R2Vbr0wUqNKsuGoNsg36cFBAiyfCmrPFxba2Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suvHlTwNLIwFZVtIm2RoOrkMonNeeta8rv3PDB7ldsew6xTt6Cnp3rTgCIX6xY29zh2Z/CZBamoIw/qSBBzPt3vU6yL5RXH+5uGeENC8nfj7aE9F+B15OQ8d4R6R0FSZtRbVE4pVHdLkLTll8zmTvze0EYLnaT2whIKh1ZYjyUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBIiWHAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBIiWHAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B7BC2BCB5;
	Fri, 24 Apr 2026 13:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038259;
	bh=u8DN5R2Vbr0wUqNKsuGoNsg36cFBAiyfCmrPFxba2Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBIiWHAHMf56/E5x3j43c6FEigyUWr7KY7/nPqr68KhdE61OU9SZl7vr0WaNfQ0+P
	 Y4xsURV5ItOSZ0iJWGYuADB28Owy5sKiTwKJInlHffl92+p9NgpQB2NvtwQY7O7cHf
	 P06mrKGHHCv74GQRwa7xKXni8qVu7P4gLf3xmHho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kagura <me@mail.kagurach.uk>,
	Cryolitia PukNgae <cryolitia.pukngae@linux.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 29/35] ALSA: usb-audio: apply quirk for MOONDROP JU Jiu
Date: Fri, 24 Apr 2026 15:31:36 +0200
Message-ID: <20260424132417.893616450@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
References: <20260424132411.427029259@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


