Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA5C2FAC06;
	Tue, 12 Aug 2025 18:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025061; cv=none; b=h9+rLn1bRQhuAM04UVKLEhIgdatkj+4WLXR+gXIhluHVRaUFTND4xaYrgdMnO/hvvwQkqF/bCVxfyhWrEtaT45O55r0JI8PJ1h8Mreye8roLyKEWu3mU5q9MnFSQnvgwTbDLDUQ5d5vwSELiKpe2Ebaza9Lfznc2dBqjj2uPUvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025061; c=relaxed/simple;
	bh=YXj4wtl95OMrnxL+mV7BHFiKj0AnTH5IuMLjPO5Fr7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBfuttPvT0SykIQxs3FUz7HAeTxlvikMs8zUhNIYu7xG+1g7EWGkmwg+SjOGfgzElA9O86pXnpqG/9QjUxRh4aM6U4cBRumis1vRppEDDxccAC+586Rikgrfg1FNhbFjyiQWF5OxfrWCkwPrHa5S5ZkFoGprQ7lUD0UJLTjGxnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nuk9wDg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nuk9wDg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D369AC4CEF0;
	Tue, 12 Aug 2025 18:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025061;
	bh=YXj4wtl95OMrnxL+mV7BHFiKj0AnTH5IuMLjPO5Fr7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nuk9wDg3Ad9kke2qhq8jRza03++/TvxhaeYWl7pyRVSGJqLyROIIOGuyq3mOZlyT7
	 upvIcaW9kDuRTwqCG6PswGlIooFpJi60kGzZHqVbtdKdSUqi9MTWvHQ577fB5/s/sV
	 a2E4gXVPkG/fsL7P5OkKafAd1Gsrq820+jkkjE0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 557/627] ALSA: hda/ca0132: Fix missing error handling in ca0132_alt_select_out()
Date: Tue, 12 Aug 2025 19:34:12 +0200
Message-ID: <20250812173453.086981992@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9f320dfb0ffc555aa2eac8331dee0c2c16f67633 ]

There are a couple of cases where the error is ignored or the error
code isn't propagated in ca0132_alt_select_out().  Fix those.

Fixes: def3f0a5c700 ("ALSA: hda/ca0132 - Add quirk output selection structures.")
Link: https://patch.msgid.link/20250806094423.8843-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_ca0132.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index d40197fb5fbd..77432e06f3e3 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4802,7 +4802,8 @@ static int ca0132_alt_select_out(struct hda_codec *codec)
 	if (err < 0)
 		goto exit;
 
-	if (ca0132_alt_select_out_quirk_set(codec) < 0)
+	err = ca0132_alt_select_out_quirk_set(codec);
+	if (err < 0)
 		goto exit;
 
 	switch (spec->cur_out_type) {
@@ -4892,6 +4893,8 @@ static int ca0132_alt_select_out(struct hda_codec *codec)
 				spec->bass_redirection_val);
 	else
 		err = ca0132_alt_surround_set_bass_redirection(codec, 0);
+	if (err < 0)
+		goto exit;
 
 	/* Unmute DSP now that we're done with output selection. */
 	err = dspio_set_uint_param(codec, 0x96,
-- 
2.39.5



