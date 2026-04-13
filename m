Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB4631717C;
	Mon, 13 Apr 2026 16:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099189; cv=none; b=YtOK0ReLUBOcpgfRwXGqURCIQOab7VkLP8pnHF2MBtAtTbxfS0SJyd34eSMlAwFvBLsTFgLjTCUYERpYpRGquIObDX8I/Q+PZC1TFuIcGkVWB2dBPwGENDn3HcRNQmN6p4E+xCmUWFnvhCgd6xM1PrC98K4cgOkcJt8rGQ+7z+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099189; c=relaxed/simple;
	bh=XmIX8PmJf30zaCJwcfjOcfv635vs/9sQJPiupbQ79XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5ljKPKIkyluKYpX9w6gnlLlA5ZZKjbkm9wlbtpqiibpMnQcB0MDIQcaoe52GhFaqG44EE3HokE0cYOxdoDZFBHTpjxteW8IeYeG//Wbtn+dWV1B2iq8MLSEDp+CZ7TpJVYi9+fum0mojUnsJnVwzT0Rr9wkWJCH3RS6U5YPDs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4WpKcn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4WpKcn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A644CC2BCB3;
	Mon, 13 Apr 2026 16:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099189;
	bh=XmIX8PmJf30zaCJwcfjOcfv635vs/9sQJPiupbQ79XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4WpKcn0XmNayjLMVtzcnsTIebfPeOKiiDlmWM63V7NypEvt7bSUQpFp5t5BI6uH4
	 2jGeKGUtPkK5ixzR3KTxJyQmFR3ZZicMnynNKJOIJLQDpyLwRn/0X0256ukesjNlvu
	 LJsJMJHomLsxby+lJxIDajPnD7lkIRZmL4Bxug2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 243/491] ASoC: fsl_easrc: Fix event generation in fsl_easrc_iec958_set_reg()
Date: Mon, 13 Apr 2026 17:58:08 +0200
Message-ID: <20260413155828.154613169@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 31ddc62c1cd92e51b9db61d7954b85ae2ec224da ]

ALSA controls should return 1 if the value in the control changed but the
control put operation fsl_easrc_set_reg() only returns 0 or a negative
error code, causing ALSA to not generate any change events. Add a suitable
check by using regmap_update_bits_check() with the underlying regmap, this
is more clearly and simply correct than trying to verify that one of the
generic ops is exactly equivalent to this one.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20260205-asoc-fsl-easrc-fix-events-v1-2-39d4c766918b@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_easrc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/fsl_easrc.c b/sound/soc/fsl/fsl_easrc.c
index acd500c3b9d04..52b3f2d44f681 100644
--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -93,14 +93,17 @@ static int fsl_easrc_set_reg(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
 	struct soc_mreg_control *mc =
 		(struct soc_mreg_control *)kcontrol->private_value;
+	struct fsl_asrc *easrc = snd_soc_component_get_drvdata(component);
 	unsigned int regval = ucontrol->value.integer.value[0];
+	bool changed;
 	int ret;
 
-	ret = snd_soc_component_write(component, mc->regbase, regval);
-	if (ret < 0)
+	ret = regmap_update_bits_check(easrc->regmap, mc->regbase,
+				       GENMASK(31, 0), regval, &changed);
+	if (ret != 0)
 		return ret;
 
-	return 0;
+	return changed;
 }
 
 #define SOC_SINGLE_REG_RW(xname, xreg) \
-- 
2.51.0



