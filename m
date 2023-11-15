Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C68D364A8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/fpEWrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9A0C433CA;
	Wed, 15 Nov 2023 19:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076594;
	bh=DFsFnZjEJI4Bzpq+HqO646/zv0VB1JDabfpve4SAPNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/fpEWrNADlk8koup8lf5VhtQ5khvVOPHgLerLvKH8FiiYyBHGdQ6VGJP/pUylfbA
	 INZ+kjqWuI/Qc2JBJJUvp17ukxjzQGxrmCGNDgAIN8Nhcmvwm8uNPp2R+OJgNMpa8y
	 IKvDHgolPDxJjGJEKnG18PutTlnV8+ejezZTTZCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 305/550] ASoC: cs35l41: Handle mdsync_down reg write errors
Date: Wed, 15 Nov 2023 14:14:49 -0500
Message-ID: <20231115191621.957267161@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit a9a3f54a23d844971c274f352500dddeadb4412c ]

The return code of regmap_multi_reg_write() call related to "MDSYNC
down" sequence is shadowed by the subsequent
wait_for_completion_timeout() invocation, which is expected to time
timeout in case the write operation failed.

Let cs35l41_global_enable() return the correct error code instead of
-ETIMEDOUT.

Fixes: f5030564938b ("ALSA: cs35l41: Add shared boost feature")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20230907171010.1447274-2-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l41-lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l41-lib.c b/sound/soc/codecs/cs35l41-lib.c
index 1e4205295a0de..74b9494ca83e9 100644
--- a/sound/soc/codecs/cs35l41-lib.c
+++ b/sound/soc/codecs/cs35l41-lib.c
@@ -1224,7 +1224,7 @@ int cs35l41_global_enable(struct regmap *regmap, enum cs35l41_boost_type b_type,
 		cs35l41_mdsync_down_seq[2].def = pwr_ctrl1;
 		ret = regmap_multi_reg_write(regmap, cs35l41_mdsync_down_seq,
 					     ARRAY_SIZE(cs35l41_mdsync_down_seq));
-		if (!enable)
+		if (ret || !enable)
 			break;
 
 		if (!pll_lock)
-- 
2.42.0



