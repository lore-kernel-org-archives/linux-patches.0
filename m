Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450E46CDA9;
	Mon,  8 Apr 2024 13:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583133; cv=none; b=Rahb2rUhRhOmC+9TCgnSBJzCy/cK6tizxWaLwRglcRIoWr23xhkXi/vQeF9NLCh8tq2F13Froc/GAve582RKuAsvh5+BlFKtDaIWxakWpG1rbq2TTeo66D1LEVvidpUISSIgONlsDZxRnyU68BN4/hswLtl6ard2JMrVS5KicsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583133; c=relaxed/simple;
	bh=eN5+eRJ8vFUx4fa2H2jyOCsn2hlBQO4q8lM+UjtmllY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BeeJpsYUs8zJ7JNMXEae970hjPYD0JJ6OGkA9tlgV/LgRWE+Gvef6pLGPBL5hUhHX7QhTL6LkyfbsaaV8rdXe08PR2TCq3Fnc1mOGec4otHMtnN5uu4ea7+MBeZSEKFYzIQPloueQCaSf/9lGT0MFcsrS0I2TPLlz5/3ZqBZNu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdOsH4rv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdOsH4rv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2541C433F1;
	Mon,  8 Apr 2024 13:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583133;
	bh=eN5+eRJ8vFUx4fa2H2jyOCsn2hlBQO4q8lM+UjtmllY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wdOsH4rvGl/G9Ms7SHUpsUv0FxFJU0I+glXu9cLa6PL3nR0Axt6guXlime3pzpOU1
	 M6kpSHBFwahW7HoV9Fpd4my7g069iUnPZQJlCYTtqALk+l4t7M6YJRflwrb8FbkOfI
	 LtBLWZ+spq8KbRI8gDeaTsgcz0g9Vvi4HaqEoYDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/252] ASoC: wm_adsp: Fix missing mutex_lock in wm_adsp_write_ctl()
Date: Mon,  8 Apr 2024 14:57:39 +0200
Message-ID: <20240408125311.619391592@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit f193957b0fbbba397c8bddedf158b3bf7e4850fc ]

wm_adsp_write_ctl() must hold the pwr_lock mutex when calling
cs_dsp_get_ctl().

This was previously partially fixed by commit 781118bc2fc1
("ASoC: wm_adsp: Fix missing locking in wm_adsp_[read|write]_ctl()")
but this only put locking around the call to cs_dsp_coeff_write_ctrl(),
missing the call to cs_dsp_get_ctl().

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 781118bc2fc1 ("ASoC: wm_adsp: Fix missing locking in wm_adsp_[read|write]_ctl()")
Link: https://msgid.link/r/20240307110227.41421-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 72b90a7ee4b68..b9c20e29fe63e 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -683,11 +683,12 @@ static void wm_adsp_control_remove(struct cs_dsp_coeff_ctl *cs_ctl)
 int wm_adsp_write_ctl(struct wm_adsp *dsp, const char *name, int type,
 		      unsigned int alg, void *buf, size_t len)
 {
-	struct cs_dsp_coeff_ctl *cs_ctl = cs_dsp_get_ctl(&dsp->cs_dsp, name, type, alg);
+	struct cs_dsp_coeff_ctl *cs_ctl;
 	struct wm_coeff_ctl *ctl;
 	int ret;
 
 	mutex_lock(&dsp->cs_dsp.pwr_lock);
+	cs_ctl = cs_dsp_get_ctl(&dsp->cs_dsp, name, type, alg);
 	ret = cs_dsp_coeff_write_ctrl(cs_ctl, 0, buf, len);
 	mutex_unlock(&dsp->cs_dsp.pwr_lock);
 
-- 
2.43.0



