Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280391A6192;
	Tue, 30 Jul 2024 17:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358990; cv=none; b=cLoMyAIdV8J4c9ozXXDt3VW7Mxlf6YPL8LF6OiW5R1Yx0O0p1UOnvifA6/TcSNi1FXrBOBFVM4vSmahn39CASenbGwAH1WOiSHXJo9AMu3PfmA1maP+NJd5dZk7rtHdTxoh4Q9SQtu96HnQyN/pLlV07EQYKmH524idQHEZy6BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358990; c=relaxed/simple;
	bh=bWkYDurPoOfcing75TzRMddvHxlK0uXNnEgOJe/rnf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEDZ1VPB5Eq0mvThVlBFIhr0YzFBN2JQfP9lOuKPazNTeoiHhtLhZjDjq0zpTeHsMcgMDfQdt/6J6TjaG/RPB02rccfZidOIRprevBX/WTUbNRVv95gQUDftYcLFmYDYtFkcoJnsYAvJcDitEOEyGQJIXq+B6gcWk+jEg3WmoyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q17fObcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q17fObcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970B8C32782;
	Tue, 30 Jul 2024 17:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358990;
	bh=bWkYDurPoOfcing75TzRMddvHxlK0uXNnEgOJe/rnf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q17fObcyZ6EE8Urd33b9btYkisK1aDMByL4/WwfAR1zdXZOYW32PAwBmQc7bLx82y
	 vzPX+Y1l6GFvCFDOJVjkzwAoXaLw+j7ZVC/JTCj3S9PKxPVfnJa3EFbhOWhAYqjs07
	 djuSOsrEwkqAwonOFxdZOD8udLlou0WgcM64I6WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 417/568] ALSA: ump: Dont update FB name for static blocks
Date: Tue, 30 Jul 2024 17:48:44 +0200
Message-ID: <20240730151656.169711563@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 9a4ab167cfb1dea1df0c0c948205a62c7eb3b85b upstream.

When a device tries to update the FB name string even if its Endpoint
is declared as static, we should skip it, just already done for the FB
info update reply.

Fixes: 37e0e14128e0 ("ALSA: ump: Support UMP Endpoint and Function Block parsing")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240722135929.8612-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/ump.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index 3f61220c23b4..b325fcfa77d0 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -806,6 +806,13 @@ static int ump_handle_fb_name_msg(struct snd_ump_endpoint *ump,
 	if (!fb)
 		return -ENODEV;
 
+	if (ump->parsed &&
+	    (ump->info.flags & SNDRV_UMP_EP_INFO_STATIC_BLOCKS)) {
+		ump_dbg(ump, "Skipping static FB name update (blk#%d)\n",
+			fb->info.block_id);
+		return 0;
+	}
+
 	ret = ump_append_string(ump, fb->info.name, sizeof(fb->info.name),
 				buf->raw, 3);
 	/* notify the FB name update to sequencer, too */
-- 
2.45.2



