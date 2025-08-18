Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FFD1E51FE;
	Mon, 18 Aug 2025 12:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521854; cv=none; b=P6PFhIuPfmrMVOhWy6yQM2q/hmu/7itiKWN5EmMZ4USa8bFqcDh4TNel93sCaDNFF74IQrn/T7J6Uwx9Cr+jpv1LFRUTvxvw8ZjEJGRbn0VPSKWMDQin3kBqaLz3NRMjDeccK1v9UYrSEYJlHZ8eV3H0sIGA/AIfqjiKQ1Huy20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521854; c=relaxed/simple;
	bh=z6copyuM+/rMxctM4ZjqcTecFZQc5LwaBFYBeF1UbIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/9CLtrAM4+r+i3nbd1y0CwOXHk0XepLiIynZeEpjLs2EhCfLY7Wwc7EfUUIyrYN2h8vP+LOy1StCSxM7eirAQKuwPxqpEBhgOFOvj50Uu2glXdfCioN5ZXSBkHSgKHrQJ2hM4ZPY/cAEAu4jJQVk1cKIX9IHplPmKZ+5GxC4xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lnr3j1is; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lnr3j1is"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2117BC4CEEB;
	Mon, 18 Aug 2025 12:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521854;
	bh=z6copyuM+/rMxctM4ZjqcTecFZQc5LwaBFYBeF1UbIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lnr3j1is7mI0futyLrfpDP6EIipBS42JJ3Eb+M25In4XbxON6d5fHZyppK0Udc+Rz
	 hsGKY289vhK7UoM7kUkXhDnXUz0DCIkY4zuG9BSKMVuKc2OWDHfIwGGZCiwB8YnrG8
	 cZ+P0OmEp/MZoFTWTxgxefJ//n+2VKxEZ11Fzb6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Zhang <joakim.zhang@cixtech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 141/444] ALSA: hda: Disable jack polling at shutdown
Date: Mon, 18 Aug 2025 14:42:47 +0200
Message-ID: <20250818124454.197763011@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cb3bba7eed4f..db2487cfd5da 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -3038,6 +3038,7 @@ void snd_hda_codec_shutdown(struct hda_codec *codec)
 	if (!codec->core.registered)
 		return;
 
+	codec->jackpoll_interval = 0; /* don't poll any longer */
 	cancel_delayed_work_sync(&codec->jackpoll_work);
 	list_for_each_entry(cpcm, &codec->pcm_list_head, list)
 		snd_pcm_suspend_all(cpcm->pcm);
-- 
2.39.5



