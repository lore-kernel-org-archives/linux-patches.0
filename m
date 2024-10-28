Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B7D15B10D;
	Mon, 28 Oct 2024 06:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097174; cv=none; b=cslvFCAtiL5S9zvXetY4J5XmxgYDBOPAEuFzh2BzGBLcR0yjP02H5WGCZLzYlE3Uf8NjCXiD5YO5VXe8lpRyYtzf4r9JfRjsO1q54C093hssub/9u+Wu9ZxwjQyf4lcDY5Nfed8eDwGkNB7MKrjGr2axh+cqfXaKWvmL1/q10u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097174; c=relaxed/simple;
	bh=lIGRNmQYScDkWhPffwnCr4MjE2kmm/0T7O9Kz1qWCT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCfnqBInFD2P5H5ese/BPvQm4EwEjKDXMdiarKOr//HMZWTCO7nQwxQ303MRBEN516O3Z08YaR4pFGdmbZgjxGDckKd65N1U40aWZCcHvjwB4t4RO2I45PGHE9NjENWhCtnsmaLbvC36KDV1Z4UWLWJH+GQw6JOSQG6d4MewoMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4jGpc86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4jGpc86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23557C4CEC7;
	Mon, 28 Oct 2024 06:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097174;
	bh=lIGRNmQYScDkWhPffwnCr4MjE2kmm/0T7O9Kz1qWCT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4jGpc86a1mW5aSwRlUZHFhkRP9tUZa4VwublY8myhAplJ3Na2kP7CL36FbFZXrqf
	 XqHIHe8shWFtXnvlP7r9PZk2v5yExguUdK9FDwwMjxfF11Wc1UI1o06efLI/F7RU5a
	 sehEt5Lr+kq1SpTQGD5FPn2wuYTibyuzaEids/uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@maxima.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/137] ALSA: hda/cs8409: Fix possible NULL dereference
Date: Mon, 28 Oct 2024 07:24:13 +0100
Message-ID: <20241028062259.176214525@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

From: Murad Masimov <m.masimov@maxima.ru>

[ Upstream commit c9bd4a82b4ed32c6d1c90500a52063e6e341517f ]

If snd_hda_gen_add_kctl fails to allocate memory and returns NULL, then
NULL pointer dereference will occur in the next line.

Since dolphin_fixups function is a hda_fixup function which is not supposed
to return any errors, add simple check before dereference, ignore the fail.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 20e507724113 ("ALSA: hda/cs8409: Add support for dolphin")
Signed-off-by: Murad Masimov <m.masimov@maxima.ru>
Link: https://patch.msgid.link/20241010221649.1305-1-m.masimov@maxima.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_cs8409.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_cs8409.c b/sound/pci/hda/patch_cs8409.c
index e41316e2e9833..892223d9e64ab 100644
--- a/sound/pci/hda/patch_cs8409.c
+++ b/sound/pci/hda/patch_cs8409.c
@@ -1411,8 +1411,9 @@ void dolphin_fixups(struct hda_codec *codec, const struct hda_fixup *fix, int ac
 		kctrl = snd_hda_gen_add_kctl(&spec->gen, "Line Out Playback Volume",
 					     &cs42l42_dac_volume_mixer);
 		/* Update Line Out kcontrol template */
-		kctrl->private_value = HDA_COMPOSE_AMP_VAL_OFS(DOLPHIN_HP_PIN_NID, 3, CS8409_CODEC1,
-				       HDA_OUTPUT, CS42L42_VOL_DAC) | HDA_AMP_VAL_MIN_MUTE;
+		if (kctrl)
+			kctrl->private_value = HDA_COMPOSE_AMP_VAL_OFS(DOLPHIN_HP_PIN_NID, 3, CS8409_CODEC1,
+					       HDA_OUTPUT, CS42L42_VOL_DAC) | HDA_AMP_VAL_MIN_MUTE;
 		cs8409_enable_ur(codec, 0);
 		snd_hda_codec_set_name(codec, "CS8409/CS42L42");
 		break;
-- 
2.43.0



