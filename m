Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DFB1494DB;
	Thu,  5 Sep 2024 10:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530436; cv=none; b=tZ7sYk3IIgs5OMJS35etmcucKHyQijB8ENGH58HzKJXTAfySqMwGKq0+cbp/ipx0JTlH2sQUnicLVdXnxWgjnuZBwC4FLzYF+xyRzyDXUPz3VRVIHLSYWqNAVMhGxK+iOTB7Kc3PeBfKkkZa3HEzZHppqPKBxK3lM2vUB88a6JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530436; c=relaxed/simple;
	bh=KXP04V+dbJmKXvzkZB4spTs5Iqm6Ld3BMQo7NFFRSh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ri/2/C8dPGD6cYA0vlv1tpOp6jNuEDyPPaIUpiEVHFK00O0/S5M4b9rfXIrQivJvNeOx8tvGs9oTcsPVKkZzq6FrMZAfSBE+ID87BNukzbmObw2ew1sArJ8+jPjhk//LHfTnVnOFXeQSQkHcKkdCnx6kzkAvM74WFcL2E1rqaJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFZbLHR2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFZbLHR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11905C4CEC3;
	Thu,  5 Sep 2024 10:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530436;
	bh=KXP04V+dbJmKXvzkZB4spTs5Iqm6Ld3BMQo7NFFRSh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFZbLHR2gj/vXQ7E5HMETPRwGsOjeVtYad3InDG6djW20izn7L9PxilDgprjKswYT
	 /Uqcg0X7TW3L3EgPvZ5UdzlW2PtpxwREomRLZA9PyiYGslP/Xi0PMkBBal8GftH7TK
	 DJekNnZFhVvo3WfC9BZRDOpQDURvjgTHRD7RByXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/101] ALSA: hda/conexant: Mute speakers at suspend / shutdown
Date: Thu,  5 Sep 2024 11:40:36 +0200
Message-ID: <20240905093716.253560476@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



