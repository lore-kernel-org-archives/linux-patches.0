Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD28C11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED16C433CA;
	Mon, 11 Sep 2023 14:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444273;
	bh=4O+1DJ34+NlhATQ5dzzaI2v//w/AzNUAeaQnGTZN+F0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBR/dyl5z0G1JjELqLrktgyeZxkYfLIVxWebWUQnwXSqCLJFG5G1M4WF36Mnl1XnG
	 eyQFgnVvO4nG9DrjJNdkB1KxiCmF2K6Kzvf1aarZvcFAVRpKLm8OSRw2BnEpZ/1dMU
	 cuM9/NvAsVR8SG78tVeNetO7z9doBhLkWPbtVMa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meng_Cai@novatek.com.cn,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.4 644/737] ALSA: pcm: Fix missing fixup call in compat hw_refine ioctl
Date: Mon, 11 Sep 2023 15:48:23 +0200
Message-ID: <20230911134708.521478769@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 358040e3807754944dbddf948a23c6d914297ed7 upstream.

The update of rate_num/den and msbits were factored out to
fixup_unreferenced_params() function to be called explicitly after the
hw_refine or hw_params procedure.  It's called from
snd_pcm_hw_refine_user(), but it's forgotten in the PCM compat ioctl.
This ended up with the incomplete rate_num/den and msbits parameters
when 32bit compat ioctl is used.

This patch adds the missing call in snd_pcm_ioctl_hw_params_compat().

Reported-by: Meng_Cai@novatek.com.cn
Fixes: f9a076bff053 ("ALSA: pcm: calculate non-mask/non-interval parameters always when possible")
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230829134344.31588-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_compat.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -253,10 +253,14 @@ static int snd_pcm_ioctl_hw_params_compa
 		goto error;
 	}
 
-	if (refine)
+	if (refine) {
 		err = snd_pcm_hw_refine(substream, data);
-	else
+		if (err < 0)
+			goto error;
+		err = fixup_unreferenced_params(substream, data);
+	} else {
 		err = snd_pcm_hw_params(substream, data);
+	}
 	if (err < 0)
 		goto error;
 	if (copy_to_user(data32, data, sizeof(*data32)) ||


