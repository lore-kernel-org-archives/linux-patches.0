Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC4F423A89;
	Tue, 31 Mar 2026 16:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976308; cv=none; b=mvBSo3glue7EeD/sq7KLVRw4QVE9321MJ2VXrIhsL+vN9/PDLsgPYlyXq3DsD8PZ2slwrXnpueQoxQO0+1nlgDQ+amnLMZws0uk62XK+OoEWLjBKHfEHllw9G/+fjCsweCMnCYBDCKHvVVkpvyeECfROcrJvq4fLsx8DKHs/9wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976308; c=relaxed/simple;
	bh=U/mLIFHReUeV51X0JtvifmZlg0OGD1Tqn4AphPLo8ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miDAVH/cGEqCDXj9tfxSW+PDLUAKNlIBHEHaPIUumT1XUBejx8GhX8ld89ZH9Ha0ZBKJc7zsS1KPJ7BHRwULHD5qrvYgUywu/6nQYxQLYUwNS+t6d3LL/n43++wxIpeOL/hSprIyvNBy5+iN/webLh8sAThG6SGmlk+DXFYNmcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYOoAujY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYOoAujY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91FFC19423;
	Tue, 31 Mar 2026 16:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976308;
	bh=U/mLIFHReUeV51X0JtvifmZlg0OGD1Tqn4AphPLo8ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYOoAujY+zdKD/+ENEvb0GJ9AA/fCSX8GlivJ7e/TSRwrHF8BDoc1dEsywmqpzSl7
	 +szATzvts+yx7FZ5QydYi4RyLcHD68zceQqeiIi25rvoOSxXnnK2mAikNhv44ObIDR
	 xET7DnZhgVx701zYcvrNeKCRanyDyeq9QzOBI9+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 042/309] ASoC: rt1321: fix DMIC ch2/3 mask issue
Date: Tue, 31 Mar 2026 18:19:05 +0200
Message-ID: <20260331161755.034189386@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 986841dcad257615a6e3f89231bb38e1f3506b77 ]

This patch fixed the DMIC ch2/3 mask missing problem.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20260225091210.3648905-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1320-sdw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt1320-sdw.c b/sound/soc/codecs/rt1320-sdw.c
index e3f9b03df3aae..e1bd991a823a4 100644
--- a/sound/soc/codecs/rt1320-sdw.c
+++ b/sound/soc/codecs/rt1320-sdw.c
@@ -1455,7 +1455,7 @@ static int rt1320_sdw_hw_params(struct snd_pcm_substream *substream,
 	struct sdw_port_config port_config;
 	struct sdw_port_config dmic_port_config[2];
 	struct sdw_stream_runtime *sdw_stream;
-	int retval;
+	int retval, num_channels;
 	unsigned int sampling_rate;
 
 	dev_dbg(dai->dev, "%s %s", __func__, dai->name);
@@ -1487,7 +1487,8 @@ static int rt1320_sdw_hw_params(struct snd_pcm_substream *substream,
 				dmic_port_config[1].num = 10;
 				break;
 			case RT1321_DEV_ID:
-				dmic_port_config[0].ch_mask = BIT(0) | BIT(1);
+				num_channels = params_channels(params);
+				dmic_port_config[0].ch_mask = GENMASK(num_channels - 1, 0);
 				dmic_port_config[0].num = 8;
 				break;
 			default:
-- 
2.51.0



