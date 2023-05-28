Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F932611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1233C433D2;
	Sun, 28 May 2023 19:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301537;
	bh=93b3mrcIyExyeJtF850IPZ3PcVHhub6IU+SOlw8o600=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpS9vgUQpMEh/oZQTN36b3vJM/jyD6RUkvxF2QkJZQIh8l3xxRG9EQeuMLESwdQLB
	 R5jaczmU6tWguxBGRjvFw21zv3qwu0X5EbaDoiYMVlPBGwcLHgPVCS/ynxxR8/xCU/
	 RV8/YURJkR/ExhlnzX04Rwxzmm85HSXOpfUD5ODU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olliver Schinagl <oliver@schinagl.nl>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 069/132] ALSA: hda: Fix Oops by 9.1 surround channel names
Date: Sun, 28 May 2023 20:10:08 +0100
Message-Id: <20230528190835.654413932@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
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

commit 3b44ec8c5c44790a82f07e90db45643c762878c6 upstream.

get_line_out_pfx() may trigger an Oops by overflowing the static array
with more than 8 channels.  This was reported for MacBookPro 12,1 with
Cirrus codec.

As a workaround, extend for the 9.1 channels and also fix the
potential Oops by unifying the code paths accessing the same array
with the proper size check.

Reported-by: Olliver Schinagl <oliver@schinagl.nl>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/64d95eb0-dbdb-cff8-a8b1-988dc22b24cd@schinagl.nl
Link: https://lore.kernel.org/r/20230516184412.24078-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_generic.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -1159,8 +1159,8 @@ static bool path_has_mixer(struct hda_co
 	return path && path->ctls[ctl_type];
 }
 
-static const char * const channel_name[4] = {
-	"Front", "Surround", "CLFE", "Side"
+static const char * const channel_name[] = {
+	"Front", "Surround", "CLFE", "Side", "Back",
 };
 
 /* give some appropriate ctl name prefix for the given line out channel */
@@ -1186,7 +1186,7 @@ static const char *get_line_out_pfx(stru
 
 	/* multi-io channels */
 	if (ch >= cfg->line_outs)
-		return channel_name[ch];
+		goto fixed_name;
 
 	switch (cfg->line_out_type) {
 	case AUTO_PIN_SPEAKER_OUT:
@@ -1238,6 +1238,7 @@ static const char *get_line_out_pfx(stru
 	if (cfg->line_outs == 1 && !spec->multi_ios)
 		return "Line Out";
 
+ fixed_name:
 	if (ch >= ARRAY_SIZE(channel_name)) {
 		snd_BUG();
 		return "PCM";


