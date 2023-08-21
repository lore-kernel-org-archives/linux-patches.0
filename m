Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE981171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48562C433C8;
	Mon, 21 Aug 2023 20:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648497;
	bh=U84drdeIwj4jxIXHVNqTC6F/WAraPxCCvzJhxfjX5HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S8OnFkK3XLUxxMki6YcTyM7Gd9Mq9QMk0miraKQWlIpmDqC7P0G8q7lYr9cbuEMuo
	 d1fj1kwhDNcCgFkkeziDPnKMACnp9w7L/ho9lBeZ7nOp0uJ1XP0Wq/E7uR7nxVswgF
	 nBB9HM2t9V8KUs4nrqJKGjuCds3yy3bvxs3QR+Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 197/234] ALSA: hda/realtek - Remodified 3k pull low procedure
Date: Mon, 21 Aug 2023 21:42:40 +0200
Message-ID: <20230821194137.537460308@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 46cdff2369cbdf8d78081a22526e77bd1323f563 ]

Set spec->en_3kpull_low default to true.
Then fillback ALC236 and ALC257 to false.

Additional note: this addresses a regression caused by the previous
fix 69ea4c9d02b7 ("ALSA: hda/realtek - remove 3k pull low procedure").
The previous workaround was applied too widely without necessity,
which resulted in the pop noise at PM again.  This patch corrects the
condition and restores the old behavior for the devices that don't
suffer from the original problem.

Fixes: 69ea4c9d02b7 ("ALSA: hda/realtek - remove 3k pull low procedure")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217732
Link: https://lore.kernel.org/r/01e212a538fc407ca6edd10b81ff7b05@realtek.com
Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 0289d9109bf32..074aa06aa585c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10633,6 +10633,7 @@ static int patch_alc269(struct hda_codec *codec)
 	spec = codec->spec;
 	spec->gen.shared_mic_vref_pin = 0x18;
 	codec->power_save_node = 0;
+	spec->en_3kpull_low = true;
 
 #ifdef CONFIG_PM
 	codec->patch_ops.suspend = alc269_suspend;
@@ -10715,14 +10716,16 @@ static int patch_alc269(struct hda_codec *codec)
 		spec->shutup = alc256_shutup;
 		spec->init_hook = alc256_init;
 		spec->gen.mixer_nid = 0; /* ALC256 does not have any loopback mixer path */
-		if (codec->bus->pci->vendor == PCI_VENDOR_ID_AMD)
-			spec->en_3kpull_low = true;
+		if (codec->core.vendor_id == 0x10ec0236 &&
+		    codec->bus->pci->vendor != PCI_VENDOR_ID_AMD)
+			spec->en_3kpull_low = false;
 		break;
 	case 0x10ec0257:
 		spec->codec_variant = ALC269_TYPE_ALC257;
 		spec->shutup = alc256_shutup;
 		spec->init_hook = alc256_init;
 		spec->gen.mixer_nid = 0;
+		spec->en_3kpull_low = false;
 		break;
 	case 0x10ec0215:
 	case 0x10ec0245:
-- 
2.40.1



