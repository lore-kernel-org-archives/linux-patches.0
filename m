Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD64D1D6B0
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtHpTYjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF24C433CA;
	Wed,  4 Oct 2023 18:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444422;
	bh=JBU6R7/TkR8lDZuhxkhr+xXzF2RQs66DVkzJHmKLROg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtHpTYjh+8TmzlyVWuHteKMtzkBO06V0rK8ipQBZl1NjQxWGl2r1P2PM/zk5xX4b0
	 LGSsacFP4l93aVpZkx7j4+qRpm+TWAZ7MfCkoiPtVuPImF7MWwF8fZIMwXjuVHDN0+
	 +jmuURJnkvCuQvouybtOpMJYsRDlLqIlkMgHcJEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 216/321] ASoC: wm_adsp: Fix missing locking in wm_adsp_[read|write]_ctl()
Date: Wed,  4 Oct 2023 19:56:01 +0200
Message-ID: <20231004175239.252315647@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 781118bc2fc1026c8285f83ea7ecab07071a09c4 ]

wm_adsp_read_ctl() and wm_adsp_write_ctl() must hold the cs_dsp pwr_lock
mutex when calling cs_dsp_coeff_read_ctrl() and cs_dsp_coeff_write_ctrl().

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20230913160250.3700346-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 5a89abfe87846..8c20ff6808941 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -687,7 +687,10 @@ int wm_adsp_write_ctl(struct wm_adsp *dsp, const char *name, int type,
 	struct wm_coeff_ctl *ctl;
 	int ret;
 
+	mutex_lock(&dsp->cs_dsp.pwr_lock);
 	ret = cs_dsp_coeff_write_ctrl(cs_ctl, 0, buf, len);
+	mutex_unlock(&dsp->cs_dsp.pwr_lock);
+
 	if (ret < 0)
 		return ret;
 
@@ -703,8 +706,14 @@ EXPORT_SYMBOL_GPL(wm_adsp_write_ctl);
 int wm_adsp_read_ctl(struct wm_adsp *dsp, const char *name, int type,
 		     unsigned int alg, void *buf, size_t len)
 {
-	return cs_dsp_coeff_read_ctrl(cs_dsp_get_ctl(&dsp->cs_dsp, name, type, alg),
-				      0, buf, len);
+	int ret;
+
+	mutex_lock(&dsp->cs_dsp.pwr_lock);
+	ret = cs_dsp_coeff_read_ctrl(cs_dsp_get_ctl(&dsp->cs_dsp, name, type, alg),
+				     0, buf, len);
+	mutex_unlock(&dsp->cs_dsp.pwr_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(wm_adsp_read_ctl);
 
-- 
2.40.1



