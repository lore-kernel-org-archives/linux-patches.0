Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2168D198E85;
	Thu,  5 Sep 2024 09:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530023; cv=none; b=stsUKba/RZqsprgm3yxiGwv98haruVtlIz+j3tqpZeyRa1MOA/zqREseZ/opuG4R+1wac4FoxnMTDALxk9/O5C2OMQ+fKWSpr91QKPOwRwMWgaXM9g9M8LPsZWkoWJn2IyCjergDoIf1hOdeFbl9kQCCP4FJbWe3ji+dLznCW2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530023; c=relaxed/simple;
	bh=JmFSEtOxgJRveV7nnVEkXlqb3wajV9HfHQ63VQNnAQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fei62SaOY5bYuISvgKZuJK5q45JX1GUgTyj214W/ahcRM+gfzEw2NGPWU7qydZ/Lkw3XPdECKfQmDysBwyGtu+ZA+G3L90NKve2CiasThkiAPdp0SxO115N0sVXIEFRNjwyKvnXGSJYCc9eiu1qtwkf5HKgx+1uYSYl7UY5x55g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1gbbrn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1gbbrn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9934EC4CEC7;
	Thu,  5 Sep 2024 09:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530023;
	bh=JmFSEtOxgJRveV7nnVEkXlqb3wajV9HfHQ63VQNnAQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1gbbrn75dICKc154GN4UKzQWUGoIa4MLVaDnyDTIaKrTSdbT6/eBmMNF7POEvVzj
	 jqcbE9BHCj6bMK3Y6TzMVzWDS5qRmwVDKwFvYRIZ0qS962OnWQP5YvsJTkkhe1VtTv
	 rE0IU2mOep6JXjlVUjp7JNbhJzX/OjIzEjj0CHbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/132] ALSA: hda/conexant: Mute speakers at suspend / shutdown
Date: Thu,  5 Sep 2024 11:39:54 +0200
Message-ID: <20240905093722.521332458@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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
index af921364195e4..8396d1d93668c 100644
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



