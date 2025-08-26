Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63331DEFF5;
	Tue, 26 Aug 2025 12:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212943; cv=none; b=rkOw/28TNLnQHh0oByNNDTwyeVe+Z+cekEbkU4gzE3OecBwQ2YTHnrYfmRN+nZMfVfffdlMPYIoPYvIk3mLhB9Vp43qDW+tdepapXj0k5Zvzc3uWHuO3EI3nHAkqXsDZ24YY5+kuAePK8m8JHsM1qQMOkj1QaWiZcOMql5+NcWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212943; c=relaxed/simple;
	bh=idQoVXWA0UMvPX/HudZ9YPkIRnOauooC8a1hGaWdbB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1PAgS4PrEAZx3/kgBj+K8SnVguc4LyO2Zyz276gVCxJR1vnXVbRel67CjUwVZxJUDtYFWb73BG8602rGyHslI/Ds7AYfhUbhE2JiSXuTMci7XPAjyh0n2no27oOs5shDh5j+WtbuZ7E/j2fbi7lIVboV3homPsTJwKbe3AR/bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=erlMjw0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="erlMjw0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58012C4CEF1;
	Tue, 26 Aug 2025 12:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212943;
	bh=idQoVXWA0UMvPX/HudZ9YPkIRnOauooC8a1hGaWdbB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erlMjw0LZvauDQEtY92QeLIlpnfMQ4FSRhyDfowJO9adR/IPmvvgiUVOn+layOasX
	 I6eS4o8WLnSoIJUdXnDVP3ROm0OnFTbvTc19udngs33C6zkNPyGzNjJ+W06r3rfSQc
	 JJwyhRH3S2TGwY6mUnWnE1J2MdiYUXXEMQ9KHSfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Zhang <joakim.zhang@cixtech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/587] ALSA: hda: Disable jack polling at shutdown
Date: Tue, 26 Aug 2025 13:04:30 +0200
Message-ID: <20250826110956.039029972@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2d4b7527b840..80c3084189b0 100644
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



