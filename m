Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1762E37E5CB;
	Thu, 20 Aug 2026 15:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238596; cv=none; b=L01thlWz7SyUlgClmU+hCJSO9Uq0LmnPgJ5IfsF3YAYsV/gAJBAvE2Ri+JVW9Z7FKhbu6DTWNPVYAc8F3LbIT34ShTRDgSTH2ZNzckN4MrVC9hF1tbhaeD5wXPIIRmqmLMZqgNhvhiYJzLRqtkFGrHQ8ykNC6ZuEDs6As0iWGiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238596; c=relaxed/simple;
	bh=JcTuXFMtVfhkGtzo5f69AEh/ef7kG1rGghrLw+w4T7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SkWsmzEuAOvRwqodbhUZz1/se9xTO1q609Y4gIpOQNnyThm4yrdrYFJYtnLqlh8bqwHEMWfSsop49CeVoY7aKre7S7+7ksk3Nf654UbbJtZb3wT1mSBZzC682d/Qj8/GWlXLHo/WrbMHCv26coEjiglfDbuIhHV3OINQDrJ3aJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7eBzet+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7eBzet+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718761F000E9;
	Thu, 20 Aug 2026 15:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238595;
	bh=ZlNVGElG8iM9FLIgAWYX99jDv5v4x4LBg57GsPnrfnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z7eBzet+mVZoPQ7LkEdTjGWcHGI1bchZbZY/R1VevtneBIIQfZgyOUgRPpbq3IelS
	 PPsor1xJFB6nAtlfhbCh7CNjxSG9yDzOud9FJVUNSgy/3Kc8eAp2z/zcBSAIVv45DO
	 3N6cy7+tLTnvMtJrFxN/97/nY0SfGDmwZ78fUPSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 185/228] ASoC: tas2781: fix clang build error for goto bypassing cleanup variable
Date: Thu, 20 Aug 2026 16:55:27 +0200
Message-ID: <20260820145250.319964014@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit 566fec6a33075a0ea5c441c26571221f17f4ed98 ]

Remove invalid goto exit paths that jump across guard(mutex) cleanup
variable initialization, replace them with direct kfree(src) and return,
to fix the s390 clang build error in acoustic_ctl_write().

Fixes: d75d38dc4604 ("ASoC: tas2781: Add a debugfs node for acoustic tuning")
Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://patch.msgid.link/20260807000304.826-1-shenghao-ding@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-i2c.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/tas2781-i2c.c b/sound/soc/codecs/tas2781-i2c.c
index 775c3767bf3a8..2ad7bb90cf543 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -1542,8 +1542,8 @@ static ssize_t acoustic_ctl_write(struct file *file,
 	if (src[0] > max_pkg_len && src[0] != count) {
 		dev_err(priv->dev, "pkg(%u), max(%u), count(%u) mismatch.\n",
 			src[0], max_pkg_len, (unsigned int)count);
-		ret = 0;
-		goto exit;
+		kfree(src);
+		return 0;
 	}
 
 	switch (src[1]) {
@@ -1557,14 +1557,14 @@ static ssize_t acoustic_ctl_write(struct file *file,
 		break;
 	default:
 		dev_err(priv->dev, "%s Wrong code %02x.\n", __func__, src[1]);
-		ret = 0;
-		goto exit;
+		kfree(src);
+		return 0;
 	}
 
 	if (len < 1) {
 		dev_err(priv->dev, "pkg fmt invalid %02x.\n", len);
-		ret = 0;
-		goto exit;
+		kfree(src);
+		return 0;
 	}
 
 	for (j = 0; j < priv->ndev; j++)
@@ -1574,8 +1574,8 @@ static ssize_t acoustic_ctl_write(struct file *file,
 		}
 	if (j >= priv->ndev) {
 		dev_err(priv->dev, "no such device 0x%02x.\n", src[2]);
-		ret = 0;
-		goto exit;
+		kfree(src);
+		return 0;
 	}
 
 	reg = TASDEVICE_REG(src[3], src[4], src[5]);
@@ -1606,7 +1606,7 @@ static ssize_t acoustic_ctl_write(struct file *file,
 		dev_err(priv->dev, "i2c communication error.\n");
 	else
 		ret = count;
-exit:
+
 	kfree(src);
 	return ret;
 }
-- 
2.53.0



