Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371EA151CDC;
	Tue, 20 Feb 2024 21:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463749; cv=none; b=hK26LxcO5LVis+Ci1SJnipPJzx4DRMTTaHCgLuVO03t5LZo0Yn6BSCoL3uceloQRJiRU+LNqVeEDrvrI9YKRLjoSe0/L3YczRNABNp5CEe3+28hWrPYrS1q9tQf0JyQHGeucRyxi+5uhPu+PrJKkYTaslqybcyEDIytaHbjP17A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463749; c=relaxed/simple;
	bh=335VZ7XZ2dXS3C5qqaynmq0JXa/+S5qftWxoUVnAUQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRXfBETgqyk+IrdJMcdvCDwWgmNAl8gXqj/VA56H84qgORd0O5jpc0YhIVzfvhipcvzvw/i7tnU5wBXEfx7KWfawvmOX4jb3HdjpuVFtJpaFPwFzLGhX0nyuooVkf2Ijx5IolMmqGA0Pabkbyhg+MPwUa/1lEr0JhRegkXqkjb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzkYeI07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzkYeI07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCD5C433C7;
	Tue, 20 Feb 2024 21:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463748;
	bh=335VZ7XZ2dXS3C5qqaynmq0JXa/+S5qftWxoUVnAUQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzkYeI07Ie/gzGCllF7T/G+lE9LMhPlwQYn9sTMhz5Amd1CmOtlVt9SbUaEbAsX0S
	 wenX9vNOnTI0asHy95iWw9KC32CfsjKogd2ucW+M5sJFlSo0cMDs8EPmxzw1sKu1Qd
	 9oNJ2QY4pPIDvGXYg5TvztzhzXQ1QxTtky7mocgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 140/331] ALSA: hda/realtek - Add speaker pin verbtable for Dell dual speaker platform
Date: Tue, 20 Feb 2024 21:54:16 +0100
Message-ID: <20240220205641.958678715@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Kailang Yang <kailang@realtek.com>

commit fcfc9f711d1e2fc7876ac12b1b16c509404b9625 upstream.

SSID 0x0c0d platform. It can't mute speaker when HP plugged.
This patch add quirk to fill speaker pin verbtable.
And disable speaker passthrough.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/38b82976a875451d833d514cee34ff6a@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -438,6 +438,10 @@ static void alc_fill_eapd_coef(struct hd
 		alc_update_coef_idx(codec, 0x67, 0xf000, 0x3000);
 		fallthrough;
 	case 0x10ec0215:
+	case 0x10ec0285:
+	case 0x10ec0289:
+		alc_update_coef_idx(codec, 0x36, 1<<13, 0);
+		fallthrough;
 	case 0x10ec0230:
 	case 0x10ec0233:
 	case 0x10ec0235:
@@ -451,9 +455,7 @@ static void alc_fill_eapd_coef(struct hd
 	case 0x10ec0283:
 	case 0x10ec0286:
 	case 0x10ec0288:
-	case 0x10ec0285:
 	case 0x10ec0298:
-	case 0x10ec0289:
 	case 0x10ec0300:
 		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
 		break;
@@ -9629,6 +9631,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0b71, "Dell Inspiron 16 Plus 7620", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
 	SND_PCI_QUIRK(0x1028, 0x0beb, "Dell XPS 15 9530 (2023)", ALC289_FIXUP_DELL_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1028, 0x0c03, "Dell Precision 5340", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0c0d, "Dell Oasis", ALC289_FIXUP_RTK_AMP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0c19, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x0c1a, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x0c1b, "Dell Precision 3440", ALC236_FIXUP_DELL_DUAL_CODECS),


