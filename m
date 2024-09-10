Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3A318B498;
	Tue, 10 Sep 2024 10:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963338; cv=none; b=aBe29G59kQbbf/ZSdPVePrcNp45o37qqcp0A+f9n8rXh+ekUWiA9TPX7A8b3TOTLxopFLM2E4kKNdXdBERIZmcI/cE1jrpyB00RZn3uPP4jBy284x8k8W+YqxjeFFg7MlwHJvPHz+hRFAfixOoNixc0XansPpVE7/DXY6qIleoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963338; c=relaxed/simple;
	bh=x4U5I1eTBLqHFAVJhJRhsZ55T3OmfzmweYCbfvgTK2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IH/Vx1/RC91Z5ArD4wGz84lSvQz5SIx4igC/2eiURtCT+Uol9qaD7mB6U02dM9lgN7f5Zikh6uG/6VUSR8MkH9pfWvG/PNPjSlu88QOCmPhCzpf2neg9hejgNEa8ZnlUJzDV5Ll73DNyejGqhM+ulJSOUzdyj5eRSU5/BG4mNek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUDLvk7j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUDLvk7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462F2C4CED0;
	Tue, 10 Sep 2024 10:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963338;
	bh=x4U5I1eTBLqHFAVJhJRhsZ55T3OmfzmweYCbfvgTK2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUDLvk7j0zZNrgDKFWK9yoLPsyQSwb6n3jMtwxcvbqSAZp/xFeIEe2it8mf6ANWGU
	 AO6MeLx/GY77l+GKbykgLsrxh8AowiubWfChfmI8SVE1zQ7RKGtCTBhaEQl49Byj3Z
	 HXGAEsUcLoBM82jsJG1LOEKxDMqywog8quF4kghc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/214] ALSA: hda/conexant: Mute speakers at suspend / shutdown
Date: Tue, 10 Sep 2024 11:30:25 +0200
Message-ID: <20240910092558.853481425@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 4f61c8fe35202702426cfc0003e15116a01ba885 ]

Use the new helper to mute speakers at suspend / shutdown for avoiding
click noises.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1228269
Link: https://patch.msgid.link/20240726142625.2460-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 09a272c65be11..802a33aaa0d62 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -205,6 +205,8 @@ static void cx_auto_shutdown(struct hda_codec *codec)
 {
 	struct conexant_spec *spec = codec->spec;
 
+	snd_hda_gen_shutup_speakers(codec);
+
 	/* Turn the problematic codec into D3 to avoid spurious noises
 	   from the internal speaker during (and after) reboot */
 	cx_auto_turn_eapd(codec, spec->num_eapds, spec->eapds, false);
-- 
2.43.0



