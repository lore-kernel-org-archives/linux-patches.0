Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E271224D6;
	Fri,  9 Jan 2026 12:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961099; cv=none; b=aC3hFtCSSzs2LerBdlX8DTs71KuiZqriJ5FilL8wz2C5PJCXwaZpGIkMMll4gky+aDqUYvv0UuT5TSkuLdv2f/4andQsC6YDsu3VtqclLfByPOw69V0dZmN5kwfW4zclwSMj+8LCxp3ayjH9K59Pz2xqTq+Jfxk121Fi6G/ecos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961099; c=relaxed/simple;
	bh=oQRy20LZfaMayIeQdnbEQAlryuzIaZgrS1n2Sw0Ivj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQGxG3tmPGDy1TQxPnVyymLtJ6rbHqov1EAKKWgBKJyCyGoCtzHlWCOYdFwrlnVOZzyI4h+XMBbntUuy6fy2H27NJcwVX1omo/Wf85myhHWE/9WJCEr4FWbKvw/WGWSBjsy/Mx1Mb2brA4WyPsL9zc6fG2y/ujbmA11mCViokSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1VJkQA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1VJkQA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5AFC4CEF1;
	Fri,  9 Jan 2026 12:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961099;
	bh=oQRy20LZfaMayIeQdnbEQAlryuzIaZgrS1n2Sw0Ivj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1VJkQA9S3TFmvmipMm1C/he1ERzzzUjr/WIdyGHTANCOr2xbm7Sbs9RrewBN2tN9
	 my5FwYbVUlZnMwUxLcoQIYKK+z9E7QOgpH2BLQedb1FAIkg/k7Cp7tj/lK51lwwIXa
	 jJHQeW6T4++sMFfVR4868U0E2FbfoTuJiIK3EYeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 633/737] ALSA: wavefront: Clear substream pointers on close
Date: Fri,  9 Jan 2026 12:42:52 +0100
Message-ID: <20260109112157.819518290@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit e11c5c13ce0ab2325d38fe63500be1dd88b81e38 ]

Clear substream pointers in close functions to avoid leaving dangling
pointers, helping to improve code safety and
prevents potential issues.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB7881DF762CAB45EE42F6D812AFC2A@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/wavefront/wavefront_midi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/isa/wavefront/wavefront_midi.c
+++ b/sound/isa/wavefront/wavefront_midi.c
@@ -278,6 +278,7 @@ static int snd_wavefront_midi_input_clos
 	        return -EIO;
 
 	guard(spinlock_irqsave)(&midi->open);
+	midi->substream_input[mpu] = NULL;
 	midi->mode[mpu] &= ~MPU401_MODE_INPUT;
 
 	return 0;
@@ -300,6 +301,7 @@ static int snd_wavefront_midi_output_clo
 	        return -EIO;
 
 	guard(spinlock_irqsave)(&midi->open);
+	midi->substream_output[mpu] = NULL;
 	midi->mode[mpu] &= ~MPU401_MODE_OUTPUT;
 	return 0;
 }


