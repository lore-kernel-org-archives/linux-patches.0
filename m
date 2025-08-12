Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F29E26B2C8;
	Tue, 12 Aug 2025 17:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021184; cv=none; b=TTLcxc1BAd/Qck41nS3DSqfkcRg7sjYGhfzzWuJAmvme9AMWhTY8rqSz8LpW1cmmXDlFkiU9dPzPjehU3xFteeR1k1qWj37ZBTbv4/+SBl8Ae5K6UXZzkcENh2p3Q18cS0AGYn260XTdiqVx2Z46uYmZGux6e8CCaC8Bb2I7MFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021184; c=relaxed/simple;
	bh=MIUzq7r/4xrhMBFIr9Lj8hozY3or4bkogmlE+mZtqsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/V/w9o5RZHjS4BuyaSxV9ZKGjbYIYWFRmV/S7M5oQQHowQO+OCFsQQQflJFLMhSCbQj1rIXVi4XcFBTlGB4KRRToWkTkI4ANaK+dk4asWQr/0cteHjNye7HDCKMbxNk7q0MweQq/xtK2tPxx85BnCW7KSVGvNkw0GexCNGTf4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWAafi/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWAafi/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82454C4CEF0;
	Tue, 12 Aug 2025 17:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021184;
	bh=MIUzq7r/4xrhMBFIr9Lj8hozY3or4bkogmlE+mZtqsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWAafi/gMxMHQAZ1dFzSlvARSbibqZjYMe3ymPsh/c9SJXNea0WDckJonMs1J06/q
	 LNgFqBNJfnBqOqKFHksB8St9RoBEmW7TJN0IImpTGDL6MSUJ/NU2UMaY7Z9GbeJloq
	 dm6/FiT0DkCMWs2WzKwn9S9npwiylXI6gSRUOkoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 226/253] ALSA: hda/ca0132: Fix missing error handling in ca0132_alt_select_out()
Date: Tue, 12 Aug 2025 19:30:14 +0200
Message-ID: <20250812172958.447330409@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 748a3c40966e..d825fcce05ee 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4791,7 +4791,8 @@ static int ca0132_alt_select_out(struct hda_codec *codec)
 	if (err < 0)
 		goto exit;
 
-	if (ca0132_alt_select_out_quirk_set(codec) < 0)
+	err = ca0132_alt_select_out_quirk_set(codec);
+	if (err < 0)
 		goto exit;
 
 	switch (spec->cur_out_type) {
@@ -4881,6 +4882,8 @@ static int ca0132_alt_select_out(struct hda_codec *codec)
 				spec->bass_redirection_val);
 	else
 		err = ca0132_alt_surround_set_bass_redirection(codec, 0);
+	if (err < 0)
+		goto exit;
 
 	/* Unmute DSP now that we're done with output selection. */
 	err = dspio_set_uint_param(codec, 0x96,
-- 
2.39.5



