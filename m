Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2687335BAF;
	Mon, 18 Aug 2025 13:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525175; cv=none; b=V8KBYISPQ2oMROY6609ozxSbek1TYr42pg3ezwUI4tDAvKMGquPWO4hiETvPa22dTpAG0PozgLZJEo0M8ya8mG9I4xqdPF4/sm9jxW4tFXacdC1y1Qa1K6OaVYUE/bCOB1b5S2CJn2DRakYlZ7cJKzTj7xGGHgMkg/40DWii7Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525175; c=relaxed/simple;
	bh=yrOI9y0Y1edkT3LDPA/lDKDRJyE5tk/PPh0CujrUU9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjL640KNPF3kM64mN2/PACM1ORPPvO9L+ZmfyfmB0Hpa1zvyyJeotTZde8p9hcZ12SuvzyXgSMcwVaHhMaIjy2gnDkvXho8PE3gQewnDKs4d0qvtaKNk8Iy0cU3vJ/kNCWgDsOMD4CTk4UErp/i7DNSYDQmuX5LUNIsu2pe5BaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4Zjih+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4Zjih+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A081C4CEEB;
	Mon, 18 Aug 2025 13:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525174;
	bh=yrOI9y0Y1edkT3LDPA/lDKDRJyE5tk/PPh0CujrUU9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4Zjih+WDHecCjrlzrJ5gux8+5nTl9+w8dfHyzsKoypCAOZuWvHXqud3yUxYfCbAA
	 Hj4yaxYLKhHmhPINa32b+fO6+zoodEVFeqlzdTTGQFyQqJws4FEYDCOHflbBXMDLuh
	 WPB2NjLQ/39f2+r+0QrU8nBBKd3KndgmYj1mv0Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Zhang <joakim.zhang@cixtech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 182/570] ALSA: hda: Disable jack polling at shutdown
Date: Mon, 18 Aug 2025 14:42:49 +0200
Message-ID: <20250818124512.819925419@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index d205f13653bb..0398df0f159a 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -3006,6 +3006,7 @@ void snd_hda_codec_shutdown(struct hda_codec *codec)
 	if (!codec->core.registered)
 		return;
 
+	codec->jackpoll_interval = 0; /* don't poll any longer */
 	cancel_delayed_work_sync(&codec->jackpoll_work);
 	list_for_each_entry(cpcm, &codec->pcm_list_head, list)
 		snd_pcm_suspend_all(cpcm->pcm);
-- 
2.39.5



