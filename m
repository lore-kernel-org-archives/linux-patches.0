Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999C8149C50;
	Tue, 25 Jun 2024 09:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308415; cv=none; b=RlTYXsILDaVUJLv4/K5wTMKZIe8aL+OA5iUMReeLw9xKaS9wusXsH9yUbAd0u8Lj3ssTHnvtlSu3yglSLTT+wy9UdCbdCv7G5pfyE0dmFqstRMC3puaFE6YSP/S+RGFm2u5qPoH2C45JP/547r/5e7DSlqSprxcOUAMgGmxwIxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308415; c=relaxed/simple;
	bh=4uQwZBN5d/kqVlq7JHnJBO86nWwC4iHyrECYE9H/Qt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/mf/KUfAX1ICq0lkeE6ehskDHg7R20lc8BlWq9HriRs/YT4vrrDhlFfd8e87Aqmn80NxjIGpC2GYXSK6vMYfQDQ/WsKrVqAfAqBMCG0sOH86s4A+Vu4W9JYGuGVqJK/qdEesmE0RQROea5wbsMmv9iDYevbtA/NGBTytqhUplc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2c8kfFxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2c8kfFxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221ACC32781;
	Tue, 25 Jun 2024 09:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308415;
	bh=4uQwZBN5d/kqVlq7JHnJBO86nWwC4iHyrECYE9H/Qt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2c8kfFxskiZlhh+iXEocE6QX5qKmZzOz+2qkgaV9o8/2vB181aMaszYvYSVHD9ezJ
	 SCEbDxWYE+AwYmg9RGvScqLllqjUH2sYaf1DoD9qtFpjjM8Jb9+/b1Ytg1/s2Kw6tw
	 Iiip3HWz/EnJm0UUQXVlLywd/mayRYgeORUd9ShU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 096/250] ALSA: seq: ump: Fix missing System Reset message handling
Date: Tue, 25 Jun 2024 11:30:54 +0200
Message-ID: <20240625085551.754789954@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 55fac50ea46f46a22a92e2139b92afaa3822ad19 ]

The conversion from System Reset event to UMP was missing.
Add the entry for a conversion to a proper UMP System message.

Fixes: e9e02819a98a ("ALSA: seq: Automatic conversion of UMP events")
Link: https://lore.kernel.org/r/20240531123718.13420-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_ump_convert.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/seq/seq_ump_convert.c b/sound/core/seq/seq_ump_convert.c
index 171fb75267afa..d81f776a4c3dd 100644
--- a/sound/core/seq/seq_ump_convert.c
+++ b/sound/core/seq/seq_ump_convert.c
@@ -1075,6 +1075,8 @@ static const struct seq_ev_to_ump seq_ev_ump_encoders[] = {
 	  system_ev_to_ump_midi1, system_ev_to_ump_midi2 },
 	{ SNDRV_SEQ_EVENT_SENSING, UMP_SYSTEM_STATUS_ACTIVE_SENSING,
 	  system_ev_to_ump_midi1, system_ev_to_ump_midi2 },
+	{ SNDRV_SEQ_EVENT_RESET, UMP_SYSTEM_STATUS_RESET,
+	  system_ev_to_ump_midi1, system_ev_to_ump_midi2 },
 };
 
 static const struct seq_ev_to_ump *find_ump_encoder(int type)
-- 
2.43.0



