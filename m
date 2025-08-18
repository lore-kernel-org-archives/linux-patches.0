Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52CA2135CE;
	Mon, 18 Aug 2025 13:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523422; cv=none; b=Tkn72JFEdiZnTjrB1AgTAPv9Gtqib4c1gkF1qFbRRDQY+Pf4XydLF+Ohm3zGKVoiyZAV2TBzXAY8sBu9K+3mPvICtMcy5og+9dVCvaF0jdWIYExELVhV8YafzRdBviGrSd4yYVQ+EALP5/Ov2iMY4GLgA/zEG+8ocDg9ytnqG9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523422; c=relaxed/simple;
	bh=Lbrl1LQ1L6UWfU/3qME8ftpW0IfubX5ZsQKGcg4/64c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPunErNEtyVxN0KWQUy4hwDXh9YVNMLLQnbEcnRrwkuqTm/iXghXTTlOFYzQlwNwxbc5NEqPu9u4KsCM4lBphacLskoXuWRv3HvZgRu4LpE2Y3kV17JemuNOh0Bf97nZXkR8XlkH+tX+hxUTFVA/C7ymBcLQoDz3eBVCL4gl1pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqvLDikT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqvLDikT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A5EC4CEEB;
	Mon, 18 Aug 2025 13:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523422;
	bh=Lbrl1LQ1L6UWfU/3qME8ftpW0IfubX5ZsQKGcg4/64c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqvLDikT6dn951SE8TN7x1GKY6o94BOGL8KZWwa9b81wHeMiD2HPoWvJRELVvkO78
	 bEmBWbjpZRhG8cHHhamYnTOKbUjfHiEAnX4VkY1g8DgI23MycDLNhcuWrOfCk8ca5J
	 3BV2YqcfRbsRmmPdb2pifQLxJ6mM6cuFcCrY6G6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Zhang <joakim.zhang@cixtech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 167/515] ALSA: hda: Disable jack polling at shutdown
Date: Mon, 18 Aug 2025 14:42:33 +0200
Message-ID: <20250818124504.803365343@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 1adcbdf54f76e1004bdf71df4eb1888c26e7ad06 ]

Although the jack polling is canceled at shutdown in
snd_hda_codec_shutdown(), it might be still re-triggered when the work
is being processed at cancel_delayed_work_sync() call.  This may
result in the unexpected hardware access that should have been already
disabled.

For assuring to stop the jack polling, clear codec->jackpoll_interval
at shutdown.

Reported-by: Joakim Zhang <joakim.zhang@cixtech.com>
Closes: https://lore.kernel.org/20250619020844.2974160-4-joakim.zhang@cixtech.com
Tested-by: Joakim Zhang <joakim.zhang@cixtech.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250623131437.10670-2-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_codec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index ca7c3517c341..7b090c953974 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -3037,6 +3037,7 @@ void snd_hda_codec_shutdown(struct hda_codec *codec)
 	if (!codec->core.registered)
 		return;
 
+	codec->jackpoll_interval = 0; /* don't poll any longer */
 	cancel_delayed_work_sync(&codec->jackpoll_work);
 	list_for_each_entry(cpcm, &codec->pcm_list_head, list)
 		snd_pcm_suspend_all(cpcm->pcm);
-- 
2.39.5



