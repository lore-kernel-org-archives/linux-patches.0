Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9D7611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497FEC433EF;
	Sun, 28 May 2023 19:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301285;
	bh=UYuDM7YaJ424cLpbqxn7E/muRLJuVvmEpF3Vez274v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VraJydyKYYOkCt+pUfLMMMf78hdMIh1fpCaFqKNMiJSR62W3Rkqz0QcuFbAgfDVuW
	 nr0iBFr6X7QS1At83beR710ODf2q6vju159sv+rrPuTKYKlNfsp5TBxJo6tjTEjBFt
	 pTLeQQwhRlzEy49ifLwyHugDfwujIo43qFCn+6r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olliver Schinagl <oliver@schinagl.nl>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 48/86] ALSA: hda: Fix Oops by 9.1 surround channel names
Date: Sun, 28 May 2023 20:10:22 +0100
Message-Id: <20230528190830.379461623@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.564682883@linuxfoundation.org>
References: <20230528190828.564682883@linuxfoundation.org>
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
@@ -1157,8 +1157,8 @@ static bool path_has_mixer(struct hda_co
 	return path && path->ctls[ctl_type];
 }
 
-static const char * const channel_name[4] = {
-	"Front", "Surround", "CLFE", "Side"
+static const char * const channel_name[] = {
+	"Front", "Surround", "CLFE", "Side", "Back",
 };
 
 /* give some appropriate ctl name prefix for the given line out channel */
@@ -1184,7 +1184,7 @@ static const char *get_line_out_pfx(stru
 
 	/* multi-io channels */
 	if (ch >= cfg->line_outs)
-		return channel_name[ch];
+		goto fixed_name;
 
 	switch (cfg->line_out_type) {
 	case AUTO_PIN_SPEAKER_OUT:
@@ -1236,6 +1236,7 @@ static const char *get_line_out_pfx(stru
 	if (cfg->line_outs == 1 && !spec->multi_ios)
 		return "Line Out";
 
+ fixed_name:
 	if (ch >= ARRAY_SIZE(channel_name)) {
 		snd_BUG();
 		return "PCM";


