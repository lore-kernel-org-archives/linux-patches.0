Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D963446CA;
	Wed,  8 Apr 2026 18:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671699; cv=none; b=X8SQpPwPrnTTBdPVez8Mjk0/r0b9ebZnD0U4+uub0SxTW5mQLHXvru7ZATqI9kYhMpdRCkBAWtJLO+KL3lVN/fq6pnuN0Xk/iv7st8EWxGlEjteDIAlytU8OzeLNtn4cFQa/kC1AxjaWVAW8xflPYlWsa9hvkAscIAg+sBdAAIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671699; c=relaxed/simple;
	bh=CMyqyxTUE4UcnEFECNL2ghx2E5Bp6NXMgMky7PMx5y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kProzeTM95HHnQM7RCmrlSQEcDWDah4m4ZLl395BKY+TvOL01dH7d+gt9AOqHfVyZsfImUUl3wAhXWmRP1GvQBnr9huB3KxJJSsGa+BMcP7/LUWExo35bYEO4g/HBcrUZ3xt6eNMoYgaWH5Phr03DKNgczYCr3D+8Cyc1Y9i+HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VgDvz30n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VgDvz30n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD76C19421;
	Wed,  8 Apr 2026 18:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671698;
	bh=CMyqyxTUE4UcnEFECNL2ghx2E5Bp6NXMgMky7PMx5y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgDvz30n+4Clx1Rsa4OXMOZGWwhGtYCHc9HR//wyfJk9pQEeg96RL3AhFpmntEwFd
	 boHNSf10qEwi85KgcnbYKO2AwJrg+uhr0v2VYg7lVB9EeFWNBJy/pPxs05FtvE8Mrc
	 cBXIb8FoZW4dPxJddm/9m72LwTuz1YjdSlWQy4Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/312] ASoC: fsl_easrc: Fix event generation in fsl_easrc_iec958_put_bits()
Date: Wed,  8 Apr 2026 19:58:53 +0200
Message-ID: <20260408175934.337395346@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 54a86cf48eaa6d1ab5130d756b718775e81e1748 ]

ALSA controls should return 1 if the value in the control changed but the
control put operation fsl_easrc_iec958_put_bits() unconditionally returns
0, causing ALSA to not generate any change events. This is detected by
mixer-test with large numbers of messages in the form:

    No event generated for Context 3 IEC958 CS5
    Context 3 IEC958 CS5.0 orig 5224 read 5225, is_volatile 0

Add a suitable check.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20260205-asoc-fsl-easrc-fix-events-v1-1-39d4c766918b@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_easrc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_easrc.c b/sound/soc/fsl/fsl_easrc.c
index 8cf414ab1295b..cbe1f48a58d23 100644
--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -52,10 +52,13 @@ static int fsl_easrc_iec958_put_bits(struct snd_kcontrol *kcontrol,
 	struct soc_mreg_control *mc =
 		(struct soc_mreg_control *)kcontrol->private_value;
 	unsigned int regval = ucontrol->value.integer.value[0];
+	int ret;
+
+	ret = (easrc_priv->bps_iec958[mc->regbase] != regval);
 
 	easrc_priv->bps_iec958[mc->regbase] = regval;
 
-	return 0;
+	return ret;
 }
 
 static int fsl_easrc_iec958_get_bits(struct snd_kcontrol *kcontrol,
-- 
2.51.0



