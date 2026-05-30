Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D463112BC;
	Sat, 30 May 2026 16:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780157637; cv=none; b=qv6ItZnZQoPMBNSZz8r0Nfv9mrWyvItb1lQeeSgi8Gh6zCEKWQJHMtLS3vYjHR1t908aAlSvQQHcO6S8P+t2BhRIwWI2SetCjWtOqQNGEYOKdNZ7PFR/1XzEp2SWvOje9E1Xs0P0AiEntHoTpneNWu8YpZJYUvOLjiMnYIRdreg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780157637; c=relaxed/simple;
	bh=oFtiZJhufbsKqPgS9mPVcj/ZW23MeZj3GoANXQoVNzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q35LRXSZm7GMBVuREKohHFwvXxQBRJ+H8iVm9yBlfIRlS6Qlz1Fe1EsE/OsqvzCC3aukWc/X3n0Q6P8sgcfXQf8UnJZsRZIm4g944JXP352BqYmFxB4R2Q9uKSPeVewJG4sT+67ColdMmW2ZJMOqR6Kq5oMknNtI8VOeiQ41Dy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6nCBKW2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6nCBKW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B901F00893;
	Sat, 30 May 2026 16:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780157635;
	bh=p8HCJdJDWwm8ee692KnnQxbelb1J/RbPSFI5ex+/UPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6nCBKW2P46c6Xrc78WsLBL3hHY3rvLbKwmFXvYz+ep1qTmnvuO20KNxnbtD14Btp
	 FqSWYuyS2qRNLu98I1b5hd8TNQNkt0GdjEW6rkOY9YmaQ4UxXODFKKeTsSBV6Hdvo4
	 c1w/jpvRvOYMVybF+6T89zMez3qcOJUTa94XtGSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/589] ASoC: SOF: topology: reject invalid vendor array size in token parser
Date: Sat, 30 May 2026 17:58:03 +0200
Message-ID: <20260530160224.642881938@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e3aa9fa0f112f..b1682879253f6 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -941,7 +941,7 @@ static int sof_parse_token_sets(struct snd_soc_component *scomp,
 		asize = le32_to_cpu(array->size);
 
 		/* validate asize */
-		if (asize < 0) { /* FIXME: A zero-size array makes no sense */
+		if (asize < sizeof(*array)) {
 			dev_err(scomp->dev, "error: invalid array size 0x%x\n",
 				asize);
 			return -EINVAL;
-- 
2.53.0



