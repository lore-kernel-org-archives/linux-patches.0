Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FF53BFE2F;
	Thu, 15 Jan 2026 17:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498451; cv=none; b=iwjRD2rHxBb8rUxsKFDSdvtVN8wT5oUgeCRJfex4PtoINgZ3ByyE07YrIId6mstcTBf0pefjmSqdE5dzWsF2sRu5u5XACBhdKRY+3MPBbe9N6FPvcxi2Ujk5z6+ssNXcnooMHf6B5NIA9gPf+H9R0yOeoE44AxJG/AJVCkHEdMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498451; c=relaxed/simple;
	bh=kFkO6wQcraXLVmAgn9GjG29YN8OkIqLjekTlRKT8Bsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IC15SOClVLwMV8xDXJGWV/PsFszzfUws+d5YiIP4YKhHjcI+v0aMWN5jcsqDPv2NGl29BGXbNJYI+zIoczaPRDPQP7NzXjjqXx01GUHXC4z5qT2DK9wdNqP/bNidi7qRPQ0OyRg2h5PdrtOabZoXRBbrUv3sJUvRkEHa7DYOcno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jk8ToR44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jk8ToR44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2EEC116D0;
	Thu, 15 Jan 2026 17:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498451;
	bh=kFkO6wQcraXLVmAgn9GjG29YN8OkIqLjekTlRKT8Bsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jk8ToR446pIT6Muuoamf6SCvtYA3pemVErdbi0gzHj7jpIZ2mD+LAtyQVNfgMwRtu
	 mAqH4y4OIbTkuWxv5T/by6auTXO2133x+YYIQL18JxOWUhic3Mb/XaYiCWIJCvLY2p
	 5nf0FSETpr5CHT82EgOlqRGEjQL6J8f7A9aeItWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 437/554] ALSA: wavefront: Fix integer overflow in sample size validation
Date: Thu, 15 Jan 2026 17:48:23 +0100
Message-ID: <20260115164302.080614008@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
@@ -952,9 +952,9 @@ wavefront_send_sample (snd_wavefront_t *
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


