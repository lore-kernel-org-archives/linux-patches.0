Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10BB26ED41;
	Fri,  9 Jan 2026 12:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961094; cv=none; b=QnqaU/EqaNslVo24MbkCYbiTyFmWDrhb0J6H75liDgii04bReM4sPXrO0owL/YMhorExVD40Fq6cXHqs1cl1f36ww1fgViFGetnwEcll0fEG35wzBGeyZpXQ5TGzw8uX1StfPlUUHTuKm4SHeEhhn8aXQ4LJcr5kSV/kxXZoyQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961094; c=relaxed/simple;
	bh=mYesOmU0PZfBxrGjep/PL6EK72dSNc4wpB3Bs0a6Q6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHYKjVBY6X7xLFpJ/yUE4/DkvormnRSG90Ic1bTPOBjfXE6EPavDEmXSX5BycO0q455ANplZSESyJG4VvsJi0xm8vFAVO57tCIMF43hL5WFgmFsrdwK5zI7LZJvAjNHR3acIBdqyWMvMH5jkpOYKPtAFDHABTBsNbQefNFcEt2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVaKR/NZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVaKR/NZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DA1C4CEF1;
	Fri,  9 Jan 2026 12:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961093;
	bh=mYesOmU0PZfBxrGjep/PL6EK72dSNc4wpB3Bs0a6Q6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVaKR/NZ1GwZAoDBwU3gGxgomYYVX52iNBOXYu3/51SZX89YYTmfJ8+tQCWMNk/tF
	 9Yu5aF1efRao4HozlXHkyYeSwNdmva7tk8puleGj1l5yeaVSfaKU5HXOtamyJqCPl0
	 wXvnyi1QnM//8WC/wKfrhC5MwFcy2vnnv9QlzyVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 631/737] ALSA: wavefront: Fix integer overflow in sample size validation
Date: Fri,  9 Jan 2026 12:42:50 +0100
Message-ID: <20260109112157.743080475@linuxfoundation.org>
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

[ Upstream commit 0c4a13ba88594fd4a27292853e736c6b4349823d ]

The wavefront_send_sample() function has an integer overflow issue
when validating sample size. The header->size field is u32 but gets
cast to int for comparison with dev->freemem

Fix by using unsigned comparison to avoid integer overflow.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB7881B47789D1B060CE8BF4C3AFC2A@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/wavefront/wavefront_synth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/isa/wavefront/wavefront_synth.c
+++ b/sound/isa/wavefront/wavefront_synth.c
@@ -950,9 +950,9 @@ wavefront_send_sample (snd_wavefront_t *
 	if (header->size) {
 		dev->freemem = wavefront_freemem (dev);
 
-		if (dev->freemem < (int)header->size) {
+		if (dev->freemem < 0 || dev->freemem < header->size) {
 			dev_err(dev->card->dev,
-				"insufficient memory to load %d byte sample.\n",
+				"insufficient memory to load %u byte sample.\n",
 				header->size);
 			return -ENOMEM;
 		}


