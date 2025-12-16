Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC4B3596EC;
	Tue, 16 Dec 2025 12:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886673; cv=none; b=uEjOVT/9dcJTNF0Cu9ZfK0kkKrYmdBsGS3rCiqxww4J7kDmBv5KledrKXt3BufJQSNmDniuCKlulAkg42/Bn4Z+syTMs/27pYxEGUchFN8a9PlwgARYwZ91NomKA+ik4qz6J4Dp6BHTJ9bVPsntfYLP/lrxC8HcWIkoD2tOB3oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886673; c=relaxed/simple;
	bh=tmjnlk1t9lXJ2dRRqndlMqMIzehKHxWfk0+5534ldSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsShRiAHw0z/VlgtsqPc1ZnJyMxRXfdkHPvn9ZpHaax4mJFcsniTsqsVWcfXQ9+Dg44umUmVIkdQbQKbMAx/etWTP4McN/pQnNhmfVk5zK9H+UbHrI3hsP/YUDkA98oQ+uGLCE1tr1oDpHYtKZ16Yv+/wSBF33qarBKOz5+SsVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A0G2i4xj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A0G2i4xj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D27C4CEF1;
	Tue, 16 Dec 2025 12:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886673;
	bh=tmjnlk1t9lXJ2dRRqndlMqMIzehKHxWfk0+5534ldSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0G2i4xjO8GV36k7rJpM4vDfKNN6PYBwBEyqr6tFxF5fXJsqVvsIrHqcDA4e0yOE0
	 9NFnMnccdCIY6dgFXLljEtjB5kkDtbeggkRotFL2Oa8mSNRjqgoZaFQfI3kj9cLJH+
	 QyQDkN1mXJIZJPQwEnsCDhNuYeR4uPx+41qMN4jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.17 507/507] ALSA: wavefront: Fix integer overflow in sample size validation
Date: Tue, 16 Dec 2025 12:15:48 +0100
Message-ID: <20251216111403.805402009@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit 0c4a13ba88594fd4a27292853e736c6b4349823d upstream.

The wavefront_send_sample() function has an integer overflow issue
when validating sample size. The header->size field is u32 but gets
cast to int for comparison with dev->freemem

Fix by using unsigned comparison to avoid integer overflow.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB7881B47789D1B060CE8BF4C3AFC2A@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
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


