Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F993B1ECC;
	Tue, 21 Jul 2026 20:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666064; cv=none; b=bdusfPbFXTVMvISojKyc6T+joosS4wOYjrffDgGKGRhgot4s6xEEVhmbaQcaV+yyrCR6w/k5MhdGWgQufeSKtHOF1PaVPDAtj7Bz+QqoHT8hMRgXRQbs8dXlIAk0v9XD0MHWgL3cV4LklqlcC03ef/pfmU5T2i3lE5hB3XrjZek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666064; c=relaxed/simple;
	bh=aHKANRQa+qhIBCan+1yZMlrllnZHQw78fumCRSPXErE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcGSH/UlQZaYddMZvGTC6ynGWqVh397bh2iUqJVd50E+dz4loVloyli2klPWx4nsa8zRsH/XyBeyWaRSg15ImJrQ/RbL6eLQ19L3miXUBUqS6h/1RnYnekC22R6oVygY7OaOHXDb8yb9TaNYmUfhU/H4FJ++2t0mdDC4yXLbGEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=siI0NveZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="siI0NveZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B907B1F000E9;
	Tue, 21 Jul 2026 20:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666061;
	bh=ZCcta/9/Y/slJCTBlMv8LzYv3hT8/sGnjUonwsP54dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=siI0NveZlgNaBs1b7yEcYlwfWr8NQKqRf3RdoGY81NCtDeMbIKg3RYFJH3Vt8tteZ
	 K9StE5URIXxiwb+EbuBPy5EuQuurTtEEgjoi562GRZKe15w7ctZofsFOFGYHtz6On2
	 G3SMSefXdLGZXS/VByDK1LEJ9Zz3bZndGkAXdWtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0539/1266] ASoC: cs35l56: Fix missing calls to wm_adsp2_remove()
Date: Tue, 21 Jul 2026 17:16:16 +0200
Message-ID: <20260721152453.928515247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 85f7bf03632bfcdd6cedfb3945b7e387d9487d73 ]

Call wm_adsp2_remove() in cs35l56_remove() and the error path of
cs35l56_common_probe().

Depends on commit 7d3fb78b5503 ("ASoC: wm_adsp: Fix NULL dereference
when removing firmware controls").

The call to wm_halo_init() during driver probe should be paired with
a call to wm_adsp2_remove() but this was missing. The consequence
would be a memory leak of the control lists in the cs_dsp driver.

Fixes: e49611252900 ("ASoC: cs35l56: Add driver for Cirrus Logic CS35L56")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260610093432.557375-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index 015269f0db54cf..15637b60ac2ea1 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -1318,11 +1318,14 @@ int cs35l56_common_probe(struct cs35l56_private *cs35l56)
 					      cs35l56_dai, ARRAY_SIZE(cs35l56_dai));
 	if (ret < 0) {
 		dev_err_probe(cs35l56->base.dev, ret, "Register codec failed\n");
-		goto err;
+		goto err_remove_wm_adsp;
 	}
 
 	return 0;
 
+err_remove_wm_adsp:
+	wm_adsp2_remove(&cs35l56->dsp);
+
 err:
 	gpiod_set_value_cansleep(cs35l56->base.reset_gpio, 0);
 	regulator_bulk_disable(ARRAY_SIZE(cs35l56->supplies), cs35l56->supplies);
@@ -1420,6 +1423,8 @@ void cs35l56_remove(struct cs35l56_private *cs35l56)
 	flush_workqueue(cs35l56->dsp_wq);
 	destroy_workqueue(cs35l56->dsp_wq);
 
+	wm_adsp2_remove(&cs35l56->dsp);
+
 	pm_runtime_dont_use_autosuspend(cs35l56->base.dev);
 	pm_runtime_suspend(cs35l56->base.dev);
 	pm_runtime_disable(cs35l56->base.dev);
-- 
2.53.0



