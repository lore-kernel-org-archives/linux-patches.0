Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45011A255B;
	Thu,  6 Jun 2024 14:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683745; cv=none; b=tJvTvp+x/Re8aHPVGtTm2uh5tSG9TZExKRo1UzEmrHjjdpzRrNw+AwffnkqMoF5qUqF66a+ebsiuPN8KVhTV3hEdnOtInYWgekgWxVXDW5ec46f9i5Wf6drOuZ1ITPyPj6d7Sh/sQDYS+qJB/CLDmPdny7My8MZrMdQ5a+FK99Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683745; c=relaxed/simple;
	bh=Typkk0LDaQPfrzThEGodZCquA6/png3Rzgx28sIp6SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXDG/8m77iV039mvVOoxOQ7ELK9CljREk96YfS8Ii29pp+xYo9+ruTQAR3kMsMwtezMyNQm72h9BdotTMUzqsLKZviswiL4ZE1Recdm3NdnSWRRw8adWn0znrUjj7vgN1IG1+UlNUZnslDnTqXB5ROdqdztX13ixCLVGoubWeKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHXZwR2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHXZwR2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A5DC2BD10;
	Thu,  6 Jun 2024 14:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683745;
	bh=Typkk0LDaQPfrzThEGodZCquA6/png3Rzgx28sIp6SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHXZwR2MuhkdabZxYEB7R2alBArDc8mLYkX0nF3CMKqkM2aRnjDumpTaJlhiHf7yW
	 UT7caRlDYH382eouF1BX9M2QKyY5zTphiBjjFq5WDVgonchgyL9PKtc59iezlJgkN7
	 o2KqB5ePq4wN7oxDLfDT/X3KsZwogVrWIa92NEyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 710/744] ALSA: seq: Dont clear bank selection at event -> UMP MIDI2 conversion
Date: Thu,  6 Jun 2024 16:06:22 +0200
Message-ID: <20240606131755.248376443@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

[ Upstream commit a200df7deb3186cd7b55abb77ab96dfefb8a4f09 ]

The current code to convert from a legacy sequencer event to UMP MIDI2
clears the bank selection at each time the program change is
submitted.  This is confusing and may lead to incorrect bank values
tranmitted to the destination in the end.

Drop the line to clear the bank info and keep the provided values.

Fixes: e9e02819a98a ("ALSA: seq: Automatic conversion of UMP events")
Link: https://lore.kernel.org/r/20240527151852.29036-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_ump_convert.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/core/seq/seq_ump_convert.c b/sound/core/seq/seq_ump_convert.c
index c21be87f5da9e..f5d22dd008426 100644
--- a/sound/core/seq/seq_ump_convert.c
+++ b/sound/core/seq/seq_ump_convert.c
@@ -892,7 +892,6 @@ static int pgm_ev_to_ump_midi2(const struct snd_seq_event *event,
 		data->pg.bank_msb = cc->cc_bank_msb;
 		data->pg.bank_lsb = cc->cc_bank_lsb;
 		cc->bank_set = 0;
-		cc->cc_bank_msb = cc->cc_bank_lsb = 0;
 	}
 	return 1;
 }
-- 
2.43.0



