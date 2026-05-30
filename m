Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4127A2741B5;
	Sat, 30 May 2026 16:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780157857; cv=none; b=dlZEbQREjoOKXLrUyBzyuchsQ8gLTEIsvQcfAMUqHCH3oPZqCnwP/fh+7T8uIXp815gbxSEZ57bPx6nyYVHls9eOkcQauMR5VAfzBxz4ynMuFJ68capOSL8RLr3oOVmckB0obWXx4nNhEDtEyKtgIgixJ5iogSd7bmLM+GksQMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780157857; c=relaxed/simple;
	bh=6+khTNlr3hPosFBSl57GN/nC5F7AQK0LIA0tDgPIs8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mZ21XavZV0y7lSR1gNQcZuVlzapUQg9Y0eFI8CypqeVVLHVz3ml5KDFoyBMHCIFsG/sKCfZlzf1XJGy9otHclkxnH4K3TvDnj5T0Qd+pE3QJICKdahxg/CwIRh/sElj1Wfge7AwMrx+kqnx7dkIOPT52N+VQPvHss483yy/XJVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uyj5U9kh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uyj5U9kh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E49D1F00893;
	Sat, 30 May 2026 16:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780157854;
	bh=+5jSij1T1GWtSyjsJ4MbySOYt34GS+WoWHwKVObJex0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uyj5U9khQEJxm0x8/xM5qOWB+5XHdjpRv896rwT9L0mcPhIzXbgG/7PwPzN6RYHGG
	 9G5mYT2RLyoZRv0bzc0QADRdRuUAdIxj6hFaMiETggquu+LRSphcOrcar6YOdhghBw
	 3Y0UXTgAZ/XhVqUyKMF3JDeqwKFtd/ykQas9J8H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/969] ASoC: SOF: topology: reject invalid vendor array size in token parser
Date: Sat, 30 May 2026 17:52:10 +0200
Message-ID: <20260530160300.660153932@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 215e5fe75881a7e2425df04aeeed47a903d5cd5d ]

sof_parse_token_sets() accepts array->size values that can be invalid
for a vendor tuple array header. In particular, a zero size does not
advance the parser state and can lead to non-progress parsing on
malformed topology data.

Validate array->size against the minimum header size and reject values
smaller than sizeof(*array) before parsing. This preserves behavior for
valid topologies and hardens malformed-input handling.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260319-sof-topology-array-size-fix-v1-1-f9191b16b1b7@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 374c8b1d69584..d803111e36385 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -678,7 +678,7 @@ static int sof_parse_token_sets(struct snd_soc_component *scomp,
 		asize = le32_to_cpu(array->size);
 
 		/* validate asize */
-		if (asize < 0) { /* FIXME: A zero-size array makes no sense */
+		if (asize < sizeof(*array)) {
 			dev_err(scomp->dev, "error: invalid array size 0x%x\n",
 				asize);
 			return -EINVAL;
-- 
2.53.0



