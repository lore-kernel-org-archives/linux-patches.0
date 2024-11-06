Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E089554765;
	Wed,  6 Nov 2024 13:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898968; cv=none; b=CDUN6t3lesz8jwElCLLfgSgjPJxrs12D9jLG/XoASxP/w5a/sDObFj6YDVDKCWTp3+dJSn3ORFh41XYqRJowA33hYieJFi6t7N71CsYLH4855uxoAJwikqARPBRI6gXjt3NbNRYx0Wn5OCwgE+NGLw9Ifwpc3S4LymxPMUoQwM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898968; c=relaxed/simple;
	bh=yVNDwk8p4nvkUAUtGGUYmJDFUtXDS68vwkdgv/YmTLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S03XOGIZOg4KSUhAB+b75a024VG/rylgCKfw7NCeDyVkpllrO5UPY0tiSRXDgsg8m1SmnEgTI5mmC7LtwJrcUVcru5Opkq9BePBu7Oi0t35X7pkUnRfCmIWVj4KQ5i2/WljiEeRoVmzCfIeQexJaEiYtWrakZUnQHtxQsUCGJl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kL7py2c0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kL7py2c0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68332C4CECD;
	Wed,  6 Nov 2024 13:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898967;
	bh=yVNDwk8p4nvkUAUtGGUYmJDFUtXDS68vwkdgv/YmTLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kL7py2c0rfy9dH8/ZVYdQWVDxhSxkvLPlgVyMKav9+e8FhlXR4dx37wnH6bdP6onx
	 XddUmqXyfxbelS9gtVj1qSfX19U4DtgwufatUE7ar6p4HOqUmCjjN3TKeQSi23A/0B
	 go7jFtb3wkuKclIZW+RfqBolBSNruLfsLajZfhp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Shumilin <shum.sdl@nppct.ru>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 415/462] ALSA: firewire-lib: Avoid division by zero in apply_constraint_to_size()
Date: Wed,  6 Nov 2024 13:05:08 +0100
Message-ID: <20241106120341.768115237@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Shumilin <shum.sdl@nppct.ru>

[ Upstream commit 72cafe63b35d06b5cfbaf807e90ae657907858da ]

The step variable is initialized to zero. It is changed in the loop,
but if it's not changed it will remain zero. Add a variable check
before the division.

The observed behavior was introduced by commit 826b5de90c0b
("ALSA: firewire-lib: fix insufficient PCM rule for period/buffer size"),
and it is difficult to show that any of the interval parameters will
satisfy the snd_interval_test() condition with data from the
amdtp_rate_table[] table.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 826b5de90c0b ("ALSA: firewire-lib: fix insufficient PCM rule for period/buffer size")
Signed-off-by: Andrey Shumilin <shum.sdl@nppct.ru>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://patch.msgid.link/20241018060018.1189537-1-shum.sdl@nppct.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/amdtp-stream.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/firewire/amdtp-stream.c b/sound/firewire/amdtp-stream.c
index 07e58dcad4afc..14a4905a777e1 100644
--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -164,6 +164,9 @@ static int apply_constraint_to_size(struct snd_pcm_hw_params *params,
 			step = max(step, amdtp_syt_intervals[i]);
 	}
 
+	if (step == 0)
+		return -EINVAL;
+
 	t.min = roundup(s->min, step);
 	t.max = rounddown(s->max, step);
 	t.integer = 1;
-- 
2.43.0



