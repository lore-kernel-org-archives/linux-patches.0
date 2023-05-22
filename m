Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE4E171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA701C433EF;
	Mon, 22 May 2023 19:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783197;
	bh=BtcZZjwoFE+Kpx3IvX0oQB/oHDEWqpJ3AWTZySHw8Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZN8SK05UTuH5qmG9GGO38w4PtDFkJXAM8Jg0CDahsZE660oRsnQIvQCjC4c2In1JT
	 jPd9XVUC51wHLETbQSv39Iu1fUU6SliGU9W9I8VsjGHly8pF/4ACtw5YULi8ZAbwEz
	 hMaVOE4sse8VbOV5+Bs4HgxhDI6uVx99PquWukQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olliver Schinagl <oliver@schinagl.nl>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 170/203] ALSA: hda: Fix Oops by 9.1 surround channel names
Date: Mon, 22 May 2023 20:09:54 +0100
Message-Id: <20230522190359.687222743@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
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
@@ -1155,8 +1155,8 @@ static bool path_has_mixer(struct hda_co
 	return path && path->ctls[ctl_type];
 }
 
-static const char * const channel_name[4] = {
-	"Front", "Surround", "CLFE", "Side"
+static const char * const channel_name[] = {
+	"Front", "Surround", "CLFE", "Side", "Back",
 };
 
 /* give some appropriate ctl name prefix for the given line out channel */
@@ -1182,7 +1182,7 @@ static const char *get_line_out_pfx(stru
 
 	/* multi-io channels */
 	if (ch >= cfg->line_outs)
-		return channel_name[ch];
+		goto fixed_name;
 
 	switch (cfg->line_out_type) {
 	case AUTO_PIN_SPEAKER_OUT:
@@ -1234,6 +1234,7 @@ static const char *get_line_out_pfx(stru
 	if (cfg->line_outs == 1 && !spec->multi_ios)
 		return "Line Out";
 
+ fixed_name:
 	if (ch >= ARRAY_SIZE(channel_name)) {
 		snd_BUG();
 		return "PCM";


