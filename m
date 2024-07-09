Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231A227713;
	Tue,  9 Jul 2024 11:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524480; cv=none; b=ayp+WjMXNz9OI3rtY08wunj2rJQZYWxJlLnusCaiuRhwpdAwVq6+07E1qxwF1sCXWLOGqvMPLW1CayZAVxxvG4TuFe2QVDHrB7rAfXCh4s0q72/NP4mkioUUZIu9WuQnzcxI3Ns1FFM7U3wxsaRHqlPIdoMM/rOd9zjqR1l9j3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524480; c=relaxed/simple;
	bh=zsfGS9v2gs476EexJLYQntRDk/tojo5gjzThHtPdusY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNulVWJdHGj4M2xmHt843phOZ6K4FXhRnEdL2bb+wfovrtM2tDZgxoIiWwmjf6z8qzf5NN4C4nmd7JjuP4NeuIAR/i7FDIkNgAhH1EfxaWumGTs6kuTEa6N9q1B34MrwOAfpgVPA2/i2wxumXSH6MxfWy3lYih7WjL2dJaKg9ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0mTRzEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0mTRzEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94618C3277B;
	Tue,  9 Jul 2024 11:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524480;
	bh=zsfGS9v2gs476EexJLYQntRDk/tojo5gjzThHtPdusY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0mTRzExy+hesE/blRvXTTYb7OQMqAf/qJ+0r/JGbxJxqOLm3/mojkpGmTfjBNZdc
	 tBLZBg/arqo4bsLVZDKCAL/417hFcG3THL0+BkhvcSjdt76sLWztqo6x6VrTlHcY10
	 f4qnindqO4bBFZmcSZ1nwJXuuBMRP4jjRFv8xrkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 193/197] ALSA: ump: Set default protocol when not given explicitly
Date: Tue,  9 Jul 2024 13:10:47 +0200
Message-ID: <20240709110716.409871809@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit bc42ca002d5d211f9c57334b9b4c25ddb0b4ec35 ]

When an inquiry of the current protocol via UMP Stream Configuration
message fails by some reason, we may leave the current protocol
undefined, which may lead to unexpected behavior.  Better to assume a
valid protocol found in the protocol capability bits instead.

For a device that doesn't support the UMP v1.2 feature, it won't reach
to this code path, and USB MIDI GTB descriptor would be used for
determining the protocol, instead.

Link: https://lore.kernel.org/r/20240529164723.18309-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index 117c7ecc48563..3f61220c23b4e 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -967,6 +967,14 @@ int snd_ump_parse_endpoint(struct snd_ump_endpoint *ump)
 	if (err < 0)
 		ump_dbg(ump, "Unable to get UMP EP stream config\n");
 
+	/* If no protocol is set by some reason, assume the valid one */
+	if (!(ump->info.protocol & SNDRV_UMP_EP_INFO_PROTO_MIDI_MASK)) {
+		if (ump->info.protocol_caps & SNDRV_UMP_EP_INFO_PROTO_MIDI2)
+			ump->info.protocol |= SNDRV_UMP_EP_INFO_PROTO_MIDI2;
+		else if (ump->info.protocol_caps & SNDRV_UMP_EP_INFO_PROTO_MIDI1)
+			ump->info.protocol |= SNDRV_UMP_EP_INFO_PROTO_MIDI1;
+	}
+
 	/* Query and create blocks from Function Blocks */
 	for (blk = 0; blk < ump->info.num_blocks; blk++) {
 		err = create_block_from_fb_info(ump, blk);
-- 
2.43.0



