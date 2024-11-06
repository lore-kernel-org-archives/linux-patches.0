Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2EA1EC00E;
	Wed,  6 Nov 2024 12:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896691; cv=none; b=k6TvVeK/+PoTUnzVfprM8Z6J3+7yqRLuQ8/MbM8L05SAgeWmHoNkOsFG/fCOfNqSfOHa1+Cq+XCj9EmjuuBeEvgGV0dRapr6S6uzXc2rOmDYnjWn8AHHC1524YpUt76dkRMfiZmyNIkUCf/oHbscw61ry7I6Lc75oQRFsooYEBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896691; c=relaxed/simple;
	bh=t07wsVdDbaDed3NcNiJ3FNQ0DGvb+gk0LYdl4sZ6LMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SaBIpiMfLC6djjPUxVkJhSM6VFm/ClSzj2x0fOy1bR0H2kR17aaTUgl8jArf2SjY72UT5eIBcAF86b/NyTOLwB2OEL5cFfalRCtoJuw5XoMct2yGKr/aiqP/zQGS/xe3RbG7bPu08DXgZzgI9i26qrq8dS6VX29LZe160RLXfV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPl7gPwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPl7gPwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBC5C4CECD;
	Wed,  6 Nov 2024 12:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896690;
	bh=t07wsVdDbaDed3NcNiJ3FNQ0DGvb+gk0LYdl4sZ6LMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LPl7gPwj0Ejs3l8foYfls9BMMYpQpGbIWqo34J7VT+vk/3B5Ab9uOJp7q2Ar9uc7W
	 OcdzdZuKANj4a/XgtNGkdDj9jlpgMtBHlTVfYazJgvNKWLI8vIq4tham2Yot5fTSa7
	 MV6PLsC/fobbpbXB0ApYj1NE/n0bXmo2YyWelsxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Shumilin <shum.sdl@nppct.ru>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/110] ALSA: firewire-lib: Avoid division by zero in apply_constraint_to_size()
Date: Wed,  6 Nov 2024 13:04:07 +0100
Message-ID: <20241106120304.334927601@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7a282d8e71485..bd272ab2048e4 100644
--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -163,6 +163,9 @@ static int apply_constraint_to_size(struct snd_pcm_hw_params *params,
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



