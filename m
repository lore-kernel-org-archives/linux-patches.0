Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B729D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40764C433EF;
	Mon, 12 Jun 2023 10:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566903;
	bh=OmDO8pz1ZQmZtxu5i3JarLH6phDgmB2CxUNpveHhcqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXW9ZpMLddVNs1E/1ylj31Fa7DzEeZuK00f2Mogktjevmy+CRF6MrxN6/yRWxEAma
	 12y7RU/jy6x6a4Z2CK7Q405epNYAdbnO0q6QtoDSA/s0wdN1V04eLebq4rn2kudvF3
	 Gt0raNQPbbqyizj+4oynrh/s6d+ae5HcEQRUTT2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.3 075/160] ALSA: hda: Fix kctl->id initialization
Date: Mon, 12 Jun 2023 12:26:47 +0200
Message-ID: <20230612101718.451406717@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

commit 5c219a340850233aecbb444af964653ecd3d1370 upstream.

HD-audio core code replaces the kctl->id.index of SPDIF-related
controls after assigning via snd_ctl_add().  This doesn't work any
longer with the new Xarray lookup change.  The change of the kctl->id
content has to be done via snd_ctl_rename_id() helper, instead.

Fixes: c27e1efb61c5 ("ALSA: control: Use xarray for faster lookups")
Cc: <stable@vger.kernel.org>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20230606093855.14685-5-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_codec.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2458,10 +2458,14 @@ int snd_hda_create_dig_out_ctls(struct h
 		   type == HDA_PCM_TYPE_HDMI) {
 		/* suppose a single SPDIF device */
 		for (dig_mix = dig_mixes; dig_mix->name; dig_mix++) {
+			struct snd_ctl_elem_id id;
+
 			kctl = find_mixer_ctl(codec, dig_mix->name, 0, 0);
 			if (!kctl)
 				break;
-			kctl->id.index = spdif_index;
+			id = kctl->id;
+			id.index = spdif_index;
+			snd_ctl_rename_id(codec->card, &kctl->id, &id);
 		}
 		bus->primary_dig_out_type = HDA_PCM_TYPE_HDMI;
 	}


