Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A082D663D;
	Thu, 15 Jan 2026 17:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499801; cv=none; b=qVC8tFq3dG26tXIFnG7iPMJ9ruI0KQo3ASX8Y42Z87xt9L2cBDj6l0u2rNfrORxArzBPGPqhaSnXlDAOsq4qLjS/Z1mQw0IYi2IM61NvTtmxQocRVJjlSSRepM/hjIaHVSrGj9FVOKNF7M6J8ehd2XgZSA4YFOsQdyjKEAk4fYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499801; c=relaxed/simple;
	bh=rySuo5EHHQQKDtaHih9VjWmQS4vyXjKJcIhlpOQncSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1BxZgnOfgHslU6LpouNw+Se5Eulutd/0AlZrRKQ5Scu1dZS6T59b0CIX2oOvh6D65kSXvGjVc7UV/25+mCHz+UoywmixTti2cDnPcNv5HY4lVgjqUyrxNuOloA/eiz0zcfLSz6yPZuXFFk8dD0kRxLmClanCibC7CKVPlazzmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmGlf9ZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmGlf9ZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77460C116D0;
	Thu, 15 Jan 2026 17:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499800;
	bh=rySuo5EHHQQKDtaHih9VjWmQS4vyXjKJcIhlpOQncSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jmGlf9ZM4IH+tgYAPcLzIcHlfKpTv23XcoDeiAQgELlIGhbmuRhwyM6U552C36EQW
	 bZ8kgAYf+nFombI9y5EWZxyJsl8zwSpJP6D4j7SpKQKbxQEUnA0dep/Wn9QCUlNpxl
	 A1sZiqQZzsnTWFB88SeF6AbPhtkZmNbe+ksPkqwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 355/451] ALSA: wavefront: Fix integer overflow in sample size validation
Date: Thu, 15 Jan 2026 17:49:16 +0100
Message-ID: <20260115164243.743309191@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/wavefront/wavefront_synth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/isa/wavefront/wavefront_synth.c
+++ b/sound/isa/wavefront/wavefront_synth.c
@@ -944,9 +944,9 @@ wavefront_send_sample (snd_wavefront_t *
 	if (header->size) {
 		dev->freemem = wavefront_freemem (dev);
 
-		if (dev->freemem < (int)header->size) {
+		if (dev->freemem < 0 || dev->freemem < header->size) {
 			snd_printk ("insufficient memory to "
-				    "load %d byte sample.\n",
+				    "load %u byte sample.\n",
 				    header->size);
 			return -ENOMEM;
 		}


