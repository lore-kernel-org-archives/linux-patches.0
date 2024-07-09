Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6537855E4C;
	Tue,  9 Jul 2024 11:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523874; cv=none; b=o6cWGi8JzLEGn77+nuzCM+qId7hndQGMoZKKRfhZIKX1MaScX+pXRu9gMU9iV70ePxpcLuSLA+DKw8/h69ExS9bT7OuQ/a68KkNOiM7NxE2kpTtHz3YKNyEPRS+en30dEmGvsaiMMyFsTczwYxdpa9VqCfrwAewj5tgKPoNHhrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523874; c=relaxed/simple;
	bh=EptISql3UU9rfG7aeCAkTzUg00FD/JR8WPdyoDYFyv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGBbsVhaKn0VR4w6zAmfgl67m45YaAOnZs/7zmGIOXBHnmQuRtCV9X6yYIJ/bvpM2eKr8jRv0R/hQOivESVMBxfJjcy+oG0cxxUAyTfB1perPoaN5ss6dXcbSmresr9/elG+PV57VpcnxcIV9186m8dlJAcVVPlxJUEirYfTsPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dk12itdW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dk12itdW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26F2C3277B;
	Tue,  9 Jul 2024 11:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523874;
	bh=EptISql3UU9rfG7aeCAkTzUg00FD/JR8WPdyoDYFyv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dk12itdWngio5zHHVMIxcEI+Ni/sWuyjy8M1COxi7MVXJFLao/x1VGmrxPfAKWAa5
	 jYws0UEYlOfTCMoAgYYJhL4PcVk2VM+/a4dVSx2U+X7R5cLpOglHj9rL/j0ZFxyM/K
	 yV8LPUee120k8SHWIQitEIeCr9xXL63/U0HiG4iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/139] ALSA: ump: Set default protocol when not given explicitly
Date: Tue,  9 Jul 2024 13:10:36 +0200
Message-ID: <20240709110703.423731641@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3cd07c103d9ea..d68d3bda97e42 100644
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



