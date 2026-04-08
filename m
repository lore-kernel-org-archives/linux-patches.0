Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3344B39EF2B;
	Wed,  8 Apr 2026 18:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672121; cv=none; b=JWCp6md5K7Oj0tD1Wk1rUDdfLjGuhYAyUznh6NUWslHPL608XsXjtZAohisQ4CnZ9cYiuSRPrgVsnjRZSWTJ/rXFJtFsgtjndnLAvJqa0EasCy7fYgQA9EzGfXLzaI3Ht9QerSthjgZr7ULS0eCuceZvl0FFi618cDukwRsGTQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672121; c=relaxed/simple;
	bh=FzBZhKqgOd/1tILc66DlGTKRjuuMlbEuGskVtRtyhqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADcXMxWXsMTcq2LHEJJ8gGbDcDsg1IMw1QjFbDddHYBB9MONvbyvntXrTcDz42abiUxf+AOwcY8BprYk+sEy7kPiygKrgXF23lJy7dD3cxK1rALopjz+LciY3/scKBB2wKOow5YW08TbCg9Sm+me0HDpFCBLh0qbtnjbO8HIUSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPQYFeJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPQYFeJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD949C2BC87;
	Wed,  8 Apr 2026 18:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672121;
	bh=FzBZhKqgOd/1tILc66DlGTKRjuuMlbEuGskVtRtyhqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPQYFeJgoVTcBHDnPEWDT/BRRwwNE3oPbe6GeRSor2N3GUUerbWL3J+/YwpmN8YIb
	 nIOQYhVL2+vF2KD7zwa6FVVbVFPBkcAWkTp3CvTo5XpmVyJh8dmXZd75Lt6x+nuFcN
	 SFJpSQycspl/3OAwNDV1aCxY9RBM00JJiyAgoOOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/312] ASoC: ep93xx: i2s: move enable call to startup callback
Date: Wed,  8 Apr 2026 20:01:12 +0200
Message-ID: <20260408175939.555260708@linuxfoundation.org>
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

From: Alexander Sverdlin <alexander.sverdlin@gmail.com>

[ Upstream commit 80f47122538d40b1a6a2c1a3c2d37b6e51b74224 ]

Make startup/shutdown callbacks symmetric to avoid clock subsystem warnings
(reproduced with "aplay --dump-hw-params" + ctrl-c):

WARNING: CPU: 0 PID: 102 at drivers/clk/clk.c:1048 clk_core_disable
lrclk already disabled
CPU: 0 PID: 102 Comm: aplay Not tainted 6.2.0-rc4 #1
Hardware name: Generic DT based system
 ...
 clk_core_disable from clk_core_disable_lock
 clk_core_disable_lock from ep93xx_i2s_shutdown
 ep93xx_i2s_shutdown from snd_soc_dai_shutdown
 snd_soc_dai_shutdown from soc_pcm_clean
 soc_pcm_clean from soc_pcm_close
 soc_pcm_close from snd_pcm_release_substream.part.0
 snd_pcm_release_substream.part.0 from snd_pcm_release
 snd_pcm_release from __fput
 __fput from task_work_run
 ...

WARNING: CPU: 0 PID: 102 at drivers/clk/clk.c:907 clk_core_unprepare
lrclk already unprepared
CPU: 0 PID: 102 Comm: aplay Tainted: G        W          6.2.0-rc4 #1
Hardware name: Generic DT based system
 ...
 clk_core_unprepare from clk_unprepare
 clk_unprepare from ep93xx_i2s_shutdown
 ep93xx_i2s_shutdown from snd_soc_dai_shutdown
 snd_soc_dai_shutdown from soc_pcm_clean
 soc_pcm_clean from soc_pcm_close
 soc_pcm_close from snd_pcm_release_substream.part.0
 snd_pcm_release_substream.part.0 from snd_pcm_release
 snd_pcm_release from __fput
 __fput from task_work_run
 ...

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Link: https://lore.kernel.org/r/20230410223902.2321834-2-alexander.sverdlin@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 622363757b22 ("ASoC: ep93xx: Fix unchecked clk_prepare_enable() and add rollback on failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/cirrus/ep93xx-i2s.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/sound/soc/cirrus/ep93xx-i2s.c b/sound/soc/cirrus/ep93xx-i2s.c
index 982151330c896..46160796af31a 100644
--- a/sound/soc/cirrus/ep93xx-i2s.c
+++ b/sound/soc/cirrus/ep93xx-i2s.c
@@ -208,6 +208,16 @@ static int ep93xx_i2s_dai_probe(struct snd_soc_dai *dai)
 	return 0;
 }
 
+static int ep93xx_i2s_startup(struct snd_pcm_substream *substream,
+			      struct snd_soc_dai *dai)
+{
+	struct ep93xx_i2s_info *info = snd_soc_dai_get_drvdata(dai);
+
+	ep93xx_i2s_enable(info, substream->stream);
+
+	return 0;
+}
+
 static void ep93xx_i2s_shutdown(struct snd_pcm_substream *substream,
 				struct snd_soc_dai *dai)
 {
@@ -348,7 +358,6 @@ static int ep93xx_i2s_hw_params(struct snd_pcm_substream *substream,
 	if (err)
 		return err;
 
-	ep93xx_i2s_enable(info, substream->stream);
 	return 0;
 }
 
@@ -395,6 +404,7 @@ static int ep93xx_i2s_resume(struct snd_soc_component *component)
 #endif
 
 static const struct snd_soc_dai_ops ep93xx_i2s_dai_ops = {
+	.startup	= ep93xx_i2s_startup,
 	.shutdown	= ep93xx_i2s_shutdown,
 	.hw_params	= ep93xx_i2s_hw_params,
 	.set_sysclk	= ep93xx_i2s_set_sysclk,
-- 
2.53.0



