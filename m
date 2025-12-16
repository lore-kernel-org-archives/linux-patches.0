Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B89450FE;
	Tue, 16 Dec 2025 12:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888704; cv=none; b=Iu2VtcNSRp8vhN0lvMfor3RF/A/3Dt3x17DlSpup/m+H2rF+cWRh/zauh9wo34in/e6hqBYCwDTM8ehIHzEHc0ugQh70WS7A0ApP5ThJhImOJtUWQAGPrTbe3zGglcTR3hZRzUt0snT+RHe35+8v7Kwm20xxPhpcV86TykmNrtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888704; c=relaxed/simple;
	bh=S1rGGLFElGfstla8/jJk1rup0Jify13dMI8yJkPEnkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmThUXzroOfSn6jclvSdkT5utUSCqP52RB26MozU1ADsHgSM2dz9VuX1VPdPkizICGEiKlv7ubADeQNL8+9YQ/zJNQLNh01QM7rnD+kF8R6oxrWVVQ6EYTCXjAbVDjnHwYih6DbRPPvYFv7AV4jVvaHEhCKfmuIZ9lMRq0mr64c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/Le5kCB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/Le5kCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B09C4CEF1;
	Tue, 16 Dec 2025 12:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888704;
	bh=S1rGGLFElGfstla8/jJk1rup0Jify13dMI8yJkPEnkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/Le5kCBdjiIisNNJFhZH1Vm5px0UKZOw+JHC5bwc3SYOsbP0He/jeIoJTzcnol7f
	 4+B5cb9k6IZVHaTxKB+Afw2M0bSCS8Rr3V32nsDRwIflQUgirg76LJTVLzfc9H0NB1
	 TuhRrp2Mq5qBTGUj+3Bvkl/AmeX5ZNOnX7lPzslo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 614/614] ALSA: wavefront: Fix integer overflow in sample size validation
Date: Tue, 16 Dec 2025 12:16:21 +0100
Message-ID: <20251216111423.644811099@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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


