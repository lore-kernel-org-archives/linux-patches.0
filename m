Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD78A18F2FC;
	Tue, 26 Aug 2025 13:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213588; cv=none; b=nSdBBHN0AvlcP9Zy12PpCYS7upEkGlk1MmVFM88KcsVNHzDsGN++x8KexNTRSdTNuQbwOt5iayZNI4wNSxu3NL7oGpHenOZfsVRkkuZ0TaB9XH5ZZHIFr3KQz0NSlLO2Gcbbo0Xo+wjIgGkEi+Tdr1bnfb7KgudcArTe+q6zMD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213588; c=relaxed/simple;
	bh=1h9EuLP6nj8sLwfkWxBeQ6vwXrfThpuL35+wGOiTArU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n8QQHXdaBj1M4LpHvozfHmTgSaDHn5iGX6tnx95XPvMS51tVCfYLY/VPvexz2Y4Q3/g7kpaplym9DBTSBXPMPHyV+2r0nYxbaTb80ANt5sGr4UoLD7mVYXin/h8aP3hvJN0/QU0GQ195Jhzb7UqakPAdtAngq+K/VQ7+gTirnS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzSpR2Ng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzSpR2Ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F97AC4CEF1;
	Tue, 26 Aug 2025 13:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213588;
	bh=1h9EuLP6nj8sLwfkWxBeQ6vwXrfThpuL35+wGOiTArU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzSpR2NgkGYf9HkKCisAjh5tdguOENIOFjX8aqhj4MHgDBrcBY3QFr+nbcEeN3Yzf
	 3jPJ7iqV10B3EW5ty9zZ6FEhrz4soxY80csfZGGhKNH4CFjSO3ytqBOObVkYajbJzv
	 t8Q4L60s9UhIDQov+FJzQ3dc8GDqgxi5QrxlBixs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.6 377/587] pwm: mediatek: Handle hardware enable and clock enable separately
Date: Tue, 26 Aug 2025 13:08:46 +0200
Message-ID: <20250826111002.496534880@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

commit 704d918341c378c5f9505dfdf32d315e256d3846 upstream.

Stop handling the clocks in pwm_mediatek_enable() and
pwm_mediatek_disable(). This is a preparing change for the next commit
that requires that clocks and the enable bit are handled separately.

Also move these two functions a bit further up in the source file to
make them usable in pwm_mediatek_config(), which is needed in the next
commit, too.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/55c94fe2917ece152ee1e998f4675642a7716f13.1753717973.git.u.kleine-koenig@baylibre.com
Cc: stable@vger.kernel.org
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-mediatek.c |   60 +++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 32 deletions(-)

--- a/drivers/pwm/pwm-mediatek.c
+++ b/drivers/pwm/pwm-mediatek.c
@@ -118,6 +118,26 @@ static inline void pwm_mediatek_writel(s
 	writel(value, chip->regs + chip->soc->reg_offset[num] + offset);
 }
 
+static void pwm_mediatek_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct pwm_mediatek_chip *pc = to_pwm_mediatek_chip(chip);
+	u32 value;
+
+	value = readl(pc->regs);
+	value |= BIT(pwm->hwpwm);
+	writel(value, pc->regs);
+}
+
+static void pwm_mediatek_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct pwm_mediatek_chip *pc = to_pwm_mediatek_chip(chip);
+	u32 value;
+
+	value = readl(pc->regs);
+	value &= ~BIT(pwm->hwpwm);
+	writel(value, pc->regs);
+}
+
 static int pwm_mediatek_config(struct pwm_chip *chip, struct pwm_device *pwm,
 			       int duty_ns, int period_ns)
 {
@@ -180,35 +200,6 @@ out:
 	return ret;
 }
 
-static int pwm_mediatek_enable(struct pwm_chip *chip, struct pwm_device *pwm)
-{
-	struct pwm_mediatek_chip *pc = to_pwm_mediatek_chip(chip);
-	u32 value;
-	int ret;
-
-	ret = pwm_mediatek_clk_enable(chip, pwm);
-	if (ret < 0)
-		return ret;
-
-	value = readl(pc->regs);
-	value |= BIT(pwm->hwpwm);
-	writel(value, pc->regs);
-
-	return 0;
-}
-
-static void pwm_mediatek_disable(struct pwm_chip *chip, struct pwm_device *pwm)
-{
-	struct pwm_mediatek_chip *pc = to_pwm_mediatek_chip(chip);
-	u32 value;
-
-	value = readl(pc->regs);
-	value &= ~BIT(pwm->hwpwm);
-	writel(value, pc->regs);
-
-	pwm_mediatek_clk_disable(chip, pwm);
-}
-
 static int pwm_mediatek_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 			      const struct pwm_state *state)
 {
@@ -218,8 +209,10 @@ static int pwm_mediatek_apply(struct pwm
 		return -EINVAL;
 
 	if (!state->enabled) {
-		if (pwm->state.enabled)
+		if (pwm->state.enabled) {
 			pwm_mediatek_disable(chip, pwm);
+			pwm_mediatek_clk_disable(chip, pwm);
+		}
 
 		return 0;
 	}
@@ -228,8 +221,11 @@ static int pwm_mediatek_apply(struct pwm
 	if (err)
 		return err;
 
-	if (!pwm->state.enabled)
-		err = pwm_mediatek_enable(chip, pwm);
+	if (!pwm->state.enabled) {
+		err = pwm_mediatek_clk_enable(chip, pwm);
+		if (!err)
+			pwm_mediatek_enable(chip, pwm);
+	}
 
 	return err;
 }


