Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296591171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E030C433C8;
	Mon, 21 Aug 2023 20:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648559;
	bh=3q7p2bFw7kiWIpnQ6Cc3rtSTti6zo0yW21jZGNdzux4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOaJPr8LXdwB8iC0qmiS/peb8Hbr7ScFwt81Zy7OqJhdF/0aimJaup+SselKNNh+p
	 rT8XzhGvKFsR38hfx1kICc3jgdXMiqguGRRK8FFywBc6Vrd+VR7NmY3AaeIKx+PpZT
	 4fmC3sG1rDKWwlukiUi5w1CmyszpezSzkXhu08AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 189/234] ASoC: max98363: dont return on success reading revision ID
Date: Mon, 21 Aug 2023 21:42:32 +0200
Message-ID: <20230821194137.188369740@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 385311101538b071a487a9245e01349e3a68ed2c ]

max98363_io_init needs to keep going when we read revision ID
successfully.

Fixes: 18c0af945fa3 ("ASoC: max98363: add soundwire amplifier driver")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20230804034734.3848227-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98363.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/max98363.c b/sound/soc/codecs/max98363.c
index e6b84e222b504..169913ba76dd7 100644
--- a/sound/soc/codecs/max98363.c
+++ b/sound/soc/codecs/max98363.c
@@ -191,10 +191,10 @@ static int max98363_io_init(struct sdw_slave *slave)
 	pm_runtime_get_noresume(dev);
 
 	ret = regmap_read(max98363->regmap, MAX98363_R21FF_REV_ID, &reg);
-	if (!ret) {
+	if (!ret)
 		dev_info(dev, "Revision ID: %X\n", reg);
-		return ret;
-	}
+	else
+		goto out;
 
 	if (max98363->first_hw_init) {
 		regcache_cache_bypass(max98363->regmap, false);
@@ -204,10 +204,11 @@ static int max98363_io_init(struct sdw_slave *slave)
 	max98363->first_hw_init = true;
 	max98363->hw_init = true;
 
+out:
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);
 
-	return 0;
+	return ret;
 }
 
 #define MAX98363_RATES SNDRV_PCM_RATE_8000_192000
-- 
2.40.1



