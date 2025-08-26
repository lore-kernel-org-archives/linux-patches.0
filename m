Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F44B341ABD;
	Tue, 26 Aug 2025 13:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215977; cv=none; b=CHIW+6YrzP16qqpXam8kbDzNYs/a9grp96Bhgn33ePM/j3n6n+Y5Z7lY5xmMppy4rdspwx99cEwMkqFhvjrbrsg6ChO+aCnSr+7lKerRfIYgm/xjpp6CWbveP88MzWbiMuG7bLOueFTt+KBs/BX9Wi/lQrMyCJ+Cra7tcTRlUg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215977; c=relaxed/simple;
	bh=V2WIP621NsAt/iQYuzTVW55ILCv1YftezTTG/6SqbqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZbxFxRaDZiipW0U5UdS8lpeAQfXX3iACixK7KQrqYsRokZJbMQOjR7AsjTWMevzg1MiC3aX3yDN/MDdCiHJUwZ8VZR4C5GYnC/aznFTib6UMxnRVPccfmtiNQH1sXJjL5I21yba6UtkF9FWaC8iidQ+hI6tcIoTb738zfKQfUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljkDrbl/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljkDrbl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38D5C4CEF1;
	Tue, 26 Aug 2025 13:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215977;
	bh=V2WIP621NsAt/iQYuzTVW55ILCv1YftezTTG/6SqbqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljkDrbl/O14u3O4Y+Lu2hCSpljN/5tCJndMjOFTPr77NUREdt85HdRZ6+RdoYpEQJ
	 +JpC05ma8A+PqYjOd+jNHYQLGcb9x53J0xCYTbseP0eg1o2vNgjZ3udcOuOFpdiaJt
	 1KknhrEsxHpeDnIlJMAYIko3uLWcaWJldbNpJ2iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 238/644] ALSA: hda/ca0132: Fix missing error handling in ca0132_alt_select_out()
Date: Tue, 26 Aug 2025 13:05:29 +0200
Message-ID: <20250826110952.301788921@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fab7c329acbe..a922c5079880 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4794,7 +4794,8 @@ static int ca0132_alt_select_out(struct hda_codec *codec)
 	if (err < 0)
 		goto exit;
 
-	if (ca0132_alt_select_out_quirk_set(codec) < 0)
+	err = ca0132_alt_select_out_quirk_set(codec);
+	if (err < 0)
 		goto exit;
 
 	switch (spec->cur_out_type) {
@@ -4884,6 +4885,8 @@ static int ca0132_alt_select_out(struct hda_codec *codec)
 				spec->bass_redirection_val);
 	else
 		err = ca0132_alt_surround_set_bass_redirection(codec, 0);
+	if (err < 0)
+		goto exit;
 
 	/* Unmute DSP now that we're done with output selection. */
 	err = dspio_set_uint_param(codec, 0x96,
-- 
2.39.5



