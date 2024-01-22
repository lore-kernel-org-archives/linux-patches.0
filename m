Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F3312FF86;
	Tue, 23 Jan 2024 00:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969062; cv=none; b=K4KhmjBIcqXLrpKq6DbZvyXhZsSmy7alVWiX5e+17ckoszmd6FIcRlV1kQRvsA0BjC74KJ6urVcqt8nwS4Mce+plV03rr4dy4mXuZZhSRPO4S5Hlz41Ze0SixVKRrcN7Mq03+8ZOkKYi/7Dl740yO6rW8l3G5T1l7dEnQ8SQlvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969062; c=relaxed/simple;
	bh=EMzseC5oaKX1Uix1RrDm43qeFINNgHDLPi34Wm+RWCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMceuJfmw+p/uvvu4NcKizbX7ZJQvZqEnxtKXcatkCL+e+Kkf6pMPs+krpt1xBEAa9puQW/Ey7VnUgnT9upKq9O7BcenEKIKBmEIiAYd8Z7VRFzIc52Y8kUAm2mqh1L00Ji0IDr/vxrAgag3EwhDZUiuN45JBkiOA942DKO7/qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHWLN0Sx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHWLN0Sx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AA5C433C7;
	Tue, 23 Jan 2024 00:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969062;
	bh=EMzseC5oaKX1Uix1RrDm43qeFINNgHDLPi34Wm+RWCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHWLN0SxTw6uPUT7Ya/pirRjcZ77Ycb312vGGTWIvv6RylgrEztJE49Yv6vXA+Cwp
	 jFqEhrhb8SjC7c6TFZYzjVFzWVPjvro9NVdmLtBVnYw4qulnL04iI2tOmIdPLeP/62
	 RzvI8DHU1Xy9rjTaYHNNANAW7B0Qpw2wZPRdtBas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 155/194] ALSA: oxygen: Fix right channel of capture volume mixer
Date: Mon, 22 Jan 2024 15:58:05 -0800
Message-ID: <20240122235725.840308983@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit a03cfad512ac24a35184d7d87ec0d5489e1cb763 upstream.

There was a typo in oxygen mixer code that didn't update the right
channel value properly for the capture volume.  Let's fix it.

This trivial fix was originally reported on Bugzilla.

Fixes: a3601560496d ("[ALSA] oxygen: add front panel controls")
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=156561
Link: https://lore.kernel.org/r/20240112111023.6208-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/oxygen/oxygen_mixer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/oxygen/oxygen_mixer.c
+++ b/sound/pci/oxygen/oxygen_mixer.c
@@ -718,7 +718,7 @@ static int ac97_fp_rec_volume_put(struct
 	oldreg = oxygen_read_ac97(chip, 1, AC97_REC_GAIN);
 	newreg = oldreg & ~0x0707;
 	newreg = newreg | (value->value.integer.value[0] & 7);
-	newreg = newreg | ((value->value.integer.value[0] & 7) << 8);
+	newreg = newreg | ((value->value.integer.value[1] & 7) << 8);
 	change = newreg != oldreg;
 	if (change)
 		oxygen_write_ac97(chip, 1, AC97_REC_GAIN, newreg);


