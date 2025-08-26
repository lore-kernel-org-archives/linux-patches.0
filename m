Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D451DAC95;
	Tue, 26 Aug 2025 13:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214329; cv=none; b=lUwdNJBARfR2QsIXxhG37yRVjgLXe8fHJ3KK5AdIiXe3rOIBWBX015Gn9a++0YD0eP81AHm1jS+LWZ11me6renSpBIqVHY3iTwtsWUe1fL6Aa6rcK/+0P2Rlpsev5Izo727hVBNgldGGUOXOUPteHEWx6Ef1a+ocSYIuqQ5yBZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214329; c=relaxed/simple;
	bh=uGm09rpjmIhE1u9u91ZeBm3E7hg8PPU2FfYacjshkNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDHMZ4oXAWZsha22Ch5Gj3dY0eE9gNDwk/eNa29DhJUGQ5xjgynaJxD1F4l90n3cskdc4JwQWrviJEHiWzDkLwiNOr6Cte2uFFiAaXlX3nKyn8mFvNIj60NE8kBBbfQlbaAXwlg2PbZyWqivionysUwGdfMuARi1ir9liopBcuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apAnhtuL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apAnhtuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822DEC4CEF1;
	Tue, 26 Aug 2025 13:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214328;
	bh=uGm09rpjmIhE1u9u91ZeBm3E7hg8PPU2FfYacjshkNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apAnhtuLH7CDK5usCrFX2oeqVThLAkFuuEl7PEui+ELs85wjLZpQjQV/eaAPr5wmb
	 bazVHm744PUkCTwcOMo2S9XSoP/zzqhROd0mmfpyA20O+t/3GntLF4qTKwB+D/5+Kp
	 WWuQd53nvQ+4txhHjx4N/kdqXi9o1mi3K24NZHe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Zhang <joakim.zhang@cixtech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/482] ALSA: hda: Disable jack polling at shutdown
Date: Tue, 26 Aug 2025 13:05:51 +0200
Message-ID: <20250826110933.249190960@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 94b3732e6cb2..aef60044cb8a 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -3040,6 +3040,7 @@ void snd_hda_codec_shutdown(struct hda_codec *codec)
 	if (!codec->core.registered)
 		return;
 
+	codec->jackpoll_interval = 0; /* don't poll any longer */
 	cancel_delayed_work_sync(&codec->jackpoll_work);
 	list_for_each_entry(cpcm, &codec->pcm_list_head, list)
 		snd_pcm_suspend_all(cpcm->pcm);
-- 
2.39.5



