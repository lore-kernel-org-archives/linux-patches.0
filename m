Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE43415B10D;
	Mon, 28 Oct 2024 06:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097103; cv=none; b=uggRhzWs8JfKhT5Gjf+u3kdOc3JXJT+df4w2OdFThgzah/uHu6FJX9YSVUN1SwiOrSKl8TPhCkH4H4fWjE9LdtzRswP0v8mrpcjn/4brQuPqLwVbbZpp7Q4nZ67BuSAeI8lth/N1Tm0iSPZALHLJ5FZqVRas2wBK8nY+3bLE4MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097103; c=relaxed/simple;
	bh=Z0BVdUzqnPINpz/mZKJTUVq6xClEchSsRzZaq8Lsq2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAruGBSPw45ZQqvrpLnEu3FIXT0xyYUGw/+91oim6FndWINCU3VuXrZJ+AcZEPmG/ZYNdTzF0qghrdgzYBlaFH41zI5nngPplr0o5jQENQQpsRDH/HmuU34yotzFiLyjxHWAheFzWLZFWB88P78xuysC5XDkMm/7M4F9ajkSdkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDWLZxcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDWLZxcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9B5C4CEC7;
	Mon, 28 Oct 2024 06:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097103;
	bh=Z0BVdUzqnPINpz/mZKJTUVq6xClEchSsRzZaq8Lsq2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VDWLZxcNU02IkE5FHnTdCa543o/xWQcVcS8JyJNdRI1W5exmSdtY+GPlnUoDwgtFe
	 J+hPnBc3AVkzlk0FuoZL7gMqwaLrkc7+aQI/xMAoxfSUEoBC3Zg5ymOZ2XP1gHPLgw
	 msijWteG0o2BkbalX9A4KcgA6qU+Y+fBSIzVPzO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Shumilin <shum.sdl@nppct.ru>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 65/80] ALSA: firewire-lib: Avoid division by zero in apply_constraint_to_size()
Date: Mon, 28 Oct 2024 07:25:45 +0100
Message-ID: <20241028062254.419040303@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 842fe127c5378..b5b3b4d177aaf 100644
--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -172,6 +172,9 @@ static int apply_constraint_to_size(struct snd_pcm_hw_params *params,
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



