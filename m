Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70BD2ED166;
	Tue, 15 Jul 2025 13:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587113; cv=none; b=cmUJWBfmDCJ8SAP3RQwhIQEb87GklXQTJsI6s53Q0rhvaQPTgij9R0pwdsSwJEUpVb7kQ9/+6bwUdP67mmAQ9nmTku9wG3oOW2FONbXfwDC0W9WFnaP4xi9Lsi5HXY2Cy/7X+7gOYDM+Ul+oBCVNvYDuPTGY7iTDljorWWv0jRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587113; c=relaxed/simple;
	bh=fcH/ZrKosThD4vbjkLJ11GF/1BpWsX3xvqINPMM/N4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A69naQbelCJk8X66tx4UbqXWAMkvbOQNnRR8iRnEbim707f1ysJb2OKqXzZ9kPKSHDue3q6XyI2DcQMuLCHo/8C3uHo02xuFksWuDsu1EhL5RTCJtQzbZ6qr+p7ymjCU0frWoqjXDkzLhF4jTSCb2GZBmOp85XrInGneGXgaPl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0QqlYIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0QqlYIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BFAC4CEE3;
	Tue, 15 Jul 2025 13:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587113;
	bh=fcH/ZrKosThD4vbjkLJ11GF/1BpWsX3xvqINPMM/N4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0QqlYIkyUYoXozIIbCgBiy0bMdsUIlQ7wBL1YVZOufyhOwnUWbbPYd97YfTYA4mG
	 FE10cjgCszMK9PZHfm+fOTDKz4fauH9wb4WQd+ToxHVCa8Kgg02kXmyls3wOb64tLe
	 XKhASguGQBnh7v7ImT+9gl2ov8jBQzUSmWg13By4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 172/192] ALSA: hda/realtek: Add mic-mute LED setup for ASUS UM5606
Date: Tue, 15 Jul 2025 15:14:27 +0200
Message-ID: <20250715130821.815651867@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

[ Upstream commit 41c66461cb2e8d3934a5395f27e572ebe63696b4 ]

ASUS UM5606* models use the quirk to set up the bass speakers, but it
missed the mic-mute LED configuration.  Other similar models have the
AMD ACP dmic, and the mic-mute is set up for that, but those models
don't have AMD ACP but rather built-in mics of Realtek codec, hence
the Realtek driver should set it up, instead.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220125
Link: https://patch.msgid.link/20250623151841.28810-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e33cbc6a385ea..beb9423658d72 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6609,6 +6609,7 @@ static void alc294_fixup_bass_speaker_15(struct hda_codec *codec,
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
 		static const hda_nid_t conn[] = { 0x02, 0x03 };
 		snd_hda_override_conn_list(codec, 0x15, ARRAY_SIZE(conn), conn);
+		snd_hda_gen_add_micmute_led_cdev(codec, NULL);
 	}
 }
 
-- 
2.39.5



