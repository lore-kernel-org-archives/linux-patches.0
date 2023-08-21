Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7B111703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED44C433C7;
	Mon, 21 Aug 2023 19:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647819;
	bh=YkXt/uxdhqGudtrZQ6zKD6rcsUbTMgKt7hIp3CYYKJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qHWg7kn9UraZNYXNtirjNVAk2PDN3nLJ+A7SRgM8RBzHo2HSo2mRPeQVBLyIJFKct
	 sfVC9gESOJq+qSzJXaPILEnLYRyp/9Sl0iJSXrGKqMASleg+9WaQJa+Hqk8T3w1fnE
	 c62JIeVYrdzekfkQBBKl+ipJ5Qr8Dxok4q4/5bsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 149/194] ALSA: hda/realtek - Remodified 3k pull low procedure
Date: Mon, 21 Aug 2023 21:42:08 +0200
Message-ID: <20230821194129.273424732@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
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
index de6bd8a9871cf..aa475154c582f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10620,6 +10620,7 @@ static int patch_alc269(struct hda_codec *codec)
 	spec = codec->spec;
 	spec->gen.shared_mic_vref_pin = 0x18;
 	codec->power_save_node = 0;
+	spec->en_3kpull_low = true;
 
 #ifdef CONFIG_PM
 	codec->patch_ops.suspend = alc269_suspend;
@@ -10702,14 +10703,16 @@ static int patch_alc269(struct hda_codec *codec)
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



