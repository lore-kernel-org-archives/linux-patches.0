Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C6F329E4B;
	Tue, 31 Mar 2026 16:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974281; cv=none; b=Zhptt+70e/m5ahnVK/6d+7X6wDaStByi8KYuIACVRTe7GheyiTPOJVtWZ5w+n8Y7VHKgnjhAijereVGj9Fn++KviRvVrrfqhh5T0e2EpsuAS9N7nyazd/fPNieyB7bXT1KjGQhN8hsAtKdkZhQhA8wW8STfpBGqZCp1CxqkkR6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974281; c=relaxed/simple;
	bh=B4uEnqXAHji3iC6Yix44IAahw2sGmG501QaL4l0lvbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFIZ08jYu09uhds0OFBsUHEno3eck9SsQccVify1dpzHI4vq++zEsk73YcbaY6S1+IoJdagg3kWIWIvw5EoOQlkLOmrb6ssWiJUxVv8nhkV0xV+6RjmXb0KwIgwXY5e5zZZxz41VBIZapoQLjYT+1w2eihQ3QVRGtYoHj9pH614=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ry7Qw87+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ry7Qw87+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29086C19423;
	Tue, 31 Mar 2026 16:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974281;
	bh=B4uEnqXAHji3iC6Yix44IAahw2sGmG501QaL4l0lvbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ry7Qw87+d84HPSSTLjl6/2IwiRfrrxsCYUq9i26jwzKs3SyOeK9cR3L5RqOH2nxH4
	 GoAhsXbjJ27L1DvBCDK/ERig43cdFThhJwxnPCr6/DLE4cOvr32UegcbjLRC+vwM8E
	 CA/dZa3R1lSAUsVJxoq3VMK/5ZcaEXibqocnX1Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/175] ASoC: fsl_easrc: Fix event generation in fsl_easrc_iec958_put_bits()
Date: Tue, 31 Mar 2026 18:20:08 +0200
Message-ID: <20260331161730.670692303@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c3d81cab2556d..13396a167b8ac 100644
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



