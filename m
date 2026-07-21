Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C00A449B2A;
	Tue, 21 Jul 2026 17:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656586; cv=none; b=Z4KZaIJZ7eElAH3CtX3X79JiN3t3adRUCZzjQoI5RxJd9B4cJ7RyzDqI/2pvJQPAL0vjf5WfOHKZEWU8ghSzORte+mDJPc3fub2Vbzl1TgPRTFBJzOZ+e9beImt3di+JLweLC8/OYyazakg0qbDP0JrUYyjDBM6JbjXM1sGdrIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656586; c=relaxed/simple;
	bh=6NNyrxfH7jFtxyipQ5JRvK6U8zKJFyoEADkZ4TTw7lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeflSgV6e1gqv+b88DY95pRM0j/J/MIBXzv/A3ghK8e9BNQdNwL2jRQKQ2b6deVAlO5WI2+Zw5t9dmh5cBG8ggO8/F826aeNhRQ7dxK4jnyw/r3Nr9RTTTURZjGcDbSeV6xAcUJrkB3QlpgP/Te3WDutCXRAZz9ZTsl4/gOIcCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nBmJ227i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nBmJ227i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC461F000E9;
	Tue, 21 Jul 2026 17:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656585;
	bh=yZoIAzIBedOMzlxBF9TQ2FV8evERTI1wmZgciDNjEho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nBmJ227iYUs5QylR9hg6I8qmXt50cyOchqYovP81I/we7GHq1iT2MX93hNZtIna9L
	 in7s/4NcN+Hyhba+l96STr0joRpHu1ZU9WfmJUFXkdozlNGcqXaauvt2mhcMVsQ4w0
	 wse1k7WslF9Nqdc4s5byU1ZuD/7EAXbveBYdCrGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0443/1611] ASoC: cs35l56: Fix missing calls to wm_adsp2_remove()
Date: Tue, 21 Jul 2026 17:09:19 +0200
Message-ID: <20260721152525.254236400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 193adba0cd1a41..f6d61bdfd24efc 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -1437,11 +1437,14 @@ int cs35l56_common_probe(struct cs35l56_private *cs35l56)
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
@@ -1544,6 +1547,8 @@ void cs35l56_remove(struct cs35l56_private *cs35l56)
 
 	destroy_workqueue(cs35l56->dsp_wq);
 
+	wm_adsp2_remove(&cs35l56->dsp);
+
 	pm_runtime_dont_use_autosuspend(cs35l56->base.dev);
 	pm_runtime_suspend(cs35l56->base.dev);
 	pm_runtime_disable(cs35l56->base.dev);
-- 
2.53.0



