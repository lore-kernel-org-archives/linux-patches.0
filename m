Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBA8276051;
	Tue, 27 May 2025 17:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365380; cv=none; b=TF3NjHSFceDToabJZJeRBzWm3T/ylZfHW7t2WxPS26lm3zssDiFLmYLZynVD3BCDUvC+AkiO69QXDy1VUhkiDjTZfsy8YO7WqcAT7A1/JI+e2MPv7OcoLuHaqfJqDqrj09KSGcrd+NsYk9GtgXMHHe8xUL3x6hS3cUhY/JRWaVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365380; c=relaxed/simple;
	bh=E+al4RDfpmXdBLsGxbre1x7gf9WgJolhMw+YeAM/GMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G7sKTjcQWDkdwbSiZz2RoYUZcOI+TnYhvzZmIF+GQLYhSQ8sPF0qb+lM8NTtrs0t7Z3wWOwWPfCw/yivGZzXXfWKx7md11Z9fpKwQZsWAfM0/r/oqoY3vw2ZFb+9gRRtpo/RNusf43U1FmQ0l5uZocJa/G4f7Q2xR1HAMkRBjLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrofbPIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrofbPIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4CBC4CEE9;
	Tue, 27 May 2025 17:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365380;
	bh=E+al4RDfpmXdBLsGxbre1x7gf9WgJolhMw+YeAM/GMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrofbPImav3DF7X9k17j00PCADzFvqymQEb+9Wn1wew8s33QjuKS8dspwo0Pk2QF/
	 YOuqlE1aAz/aLx0FSG8mhIglBDS4UU7sv7MnhyCGrPxRAxLp/BbqklE2lLjTT2UyNp
	 1OJtrQG9tQ0hRiEWCIE7EFyUCmxb+QQX8AZ3kv7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 358/626] ASoC: ops: Enforce platform maximum on initial value
Date: Tue, 27 May 2025 18:24:11 +0200
Message-ID: <20250527162459.560338671@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit 783db6851c1821d8b983ffb12b99c279ff64f2ee ]

Lower the volume if it is violating the platform maximum at its initial
value (i.e. at the time of the 'snd_soc_limit_volume' call).

Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
[Cherry picked from the Asahi kernel with fixups -- broonie]
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20250208-asoc-volume-limit-v1-1-b98fcf4cdbad@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ops.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index b0e4e4168f38d..fb11003d56cf6 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -639,6 +639,33 @@ int snd_soc_get_volsw_range(struct snd_kcontrol *kcontrol,
 }
 EXPORT_SYMBOL_GPL(snd_soc_get_volsw_range);
 
+static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
+{
+	struct soc_mixer_control *mc = (struct soc_mixer_control *)kctl->private_value;
+	struct snd_ctl_elem_value uctl;
+	int ret;
+
+	if (!mc->platform_max)
+		return 0;
+
+	ret = kctl->get(kctl, &uctl);
+	if (ret < 0)
+		return ret;
+
+	if (uctl.value.integer.value[0] > mc->platform_max)
+		uctl.value.integer.value[0] = mc->platform_max;
+
+	if (snd_soc_volsw_is_stereo(mc) &&
+	    uctl.value.integer.value[1] > mc->platform_max)
+		uctl.value.integer.value[1] = mc->platform_max;
+
+	ret = kctl->put(kctl, &uctl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 /**
  * snd_soc_limit_volume - Set new limit to an existing volume control.
  *
@@ -663,7 +690,7 @@ int snd_soc_limit_volume(struct snd_soc_card *card,
 		struct soc_mixer_control *mc = (struct soc_mixer_control *)kctl->private_value;
 		if (max <= mc->max - mc->min) {
 			mc->platform_max = max;
-			ret = 0;
+			ret = snd_soc_clip_to_platform_max(kctl);
 		}
 	}
 	return ret;
-- 
2.39.5



