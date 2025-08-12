Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0517D27703A;
	Tue, 12 Aug 2025 19:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026710; cv=none; b=g1Ci8wZof/27OSQt6TKA1bFf+Lh6p6LN1SZy+aBD/mDQdsguW7ecXsm3ynL7KpEy7X7e4gln7biOGzZiuCWSIdMqIgvKfXDzMYs0/F2f4NAaQIXhAJRiOnK1bTiHZhSf8irVkaDrof442juX+oaZpe4EF5OycNv9T6s8zRSb4+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026710; c=relaxed/simple;
	bh=UK7PlB97kLAO6FGX5Hd60ydi0LjEXvAnDevvNvaAV5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLlbibkHlEkJYRHZoFH10f1OQe4TvD4lprLnRCQp74vX7MeGDSUye6vTQXfoaVQw2Z71H+6TlzjWdxq536OHQ0GlXYjkGHnQvM9RLiBC1110rCyXs9xGeVgXvKLsoskf3Cz8seV/ai/76qQM67jW3xZ83dPmMJxDnZDLLtjDdLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09JqOU8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09JqOU8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD2AC4CEF0;
	Tue, 12 Aug 2025 19:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026709;
	bh=UK7PlB97kLAO6FGX5Hd60ydi0LjEXvAnDevvNvaAV5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09JqOU8Rb17r7GKFkY+YF4aaAy8WVIIO1/OtAMBqW/Q9p97G8fVsDAwfMHR/q3pp1
	 NwW2/0eqPwxt8dKJM/0AGZ4689fkLpJyT5sIHmpL1VXPH840pdFNFa7CET0Q/vjGGA
	 QEACgOB/8a4pczfvkugQgpvdeHIRNLhHz597AQVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 418/480] ALSA: hda/ca0132: Fix missing error handling in ca0132_alt_select_out()
Date: Tue, 12 Aug 2025 19:50:26 +0200
Message-ID: <20250812174414.652206866@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



