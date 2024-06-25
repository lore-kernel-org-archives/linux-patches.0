Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4115C149E06;
	Tue, 25 Jun 2024 09:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309007; cv=none; b=tsvIp1ONf4UQhutoNYehxXylcYCODGVW2YOJ7oQAuz/zf1jC6FfwI4y0oYXY0CdWVM0HiSdvMQpThxSoNRpZ1ufJ9KK0+VrCS64qaZ3jqDPeADwJ4eSE3eseLVO2PxlTj2w6KUhV/0L99GmQ6iR7geeatUWqXQT5zSfspzzFLSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309007; c=relaxed/simple;
	bh=RDOUPCCeU9U2bkJL54UZXB1vewDpiC0J1gCSNh4pCdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iu/HLX3ETrQSEQz77UetmywK2QiGVSZexWSM1umCBQY5ui7bSrh8++DnC/65Ddpa6zpw+iIRVb5Yu2coQN8eXLTWyEHhm3K+3Jw/aKLLXpcZyBGGPesbYlHY+7hSuMxAVXgP6NFKKii3bLG8FVkcLoR1kujyZ1zOmDMXWA7qb0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9TxGmgW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9TxGmgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF67C4AF09;
	Tue, 25 Jun 2024 09:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309007;
	bh=RDOUPCCeU9U2bkJL54UZXB1vewDpiC0J1gCSNh4pCdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9TxGmgWt7w2ZYWzJ5j9xqpw75EJgxvuEVt1I9+lHOoAMqECPE82aYKSU5A3GGupQ
	 ymVD/CNuE+klO2wLIpnph5lOOaLtD/O+zC3rz/7HHh0P8KGoJVf4BHtwZudUBtHewl
	 Km7VadoDQLCMK0t1Xtb4Z5cxIVZaUF+FA1Ejpd6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/192] ALSA: seq: ump: Fix missing System Reset message handling
Date: Tue, 25 Jun 2024 11:32:16 +0200
Message-ID: <20240625085539.629690954@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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



