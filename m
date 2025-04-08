Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B329A22257E;
	Tue,  8 Apr 2025 11:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113006; cv=none; b=UcU2EK66Xd3otfBupM3BRWj92+bzqEl7D1/PTkpEYBcNRlgOTvNKu6e/zMSA1L5BVc28gYpZqNrs3HaJA3+bM+dQqcqhW5yXEFnAe1UmdqXULTrBUeaqk14pABkOxiQLKRm1XYPQ9Y38yoAq36LPcM0CmngQLS1oLuml1Jg0E9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113006; c=relaxed/simple;
	bh=76a2ZE1WPOaDxBOO0nRdU2XsjnJ+hpJckm5rImXZS08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9zTrRzGLWjub9/D214/9s+x81wrhrvAC6HWgEoA0O3wJ1RJrrorNYRmWJe9YIm+1vD6rfyD4PpZBem5db6Gq6YJArm7aPwww3TxFXPWlUtwT/mpC39FUtTHvWmEpa6uls63DNDaCAhRkgXRRUX8UZLVgdQoOf0xwIb0TyIq0X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUe0kWuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUe0kWuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45073C4CEE5;
	Tue,  8 Apr 2025 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113006;
	bh=76a2ZE1WPOaDxBOO0nRdU2XsjnJ+hpJckm5rImXZS08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUe0kWuCjn/nMr+DwWeBYtPFkm16ByRlrFTOejS3wPRWFwQ5pzGiUIUQdrU+DwSpb
	 r5hIfQ4dM7S+LG7K6E5U0UHbx/15HIAjTJt+AYouLUNmC/2bMssCXarC2iXiMcVla5
	 KAV+oxRarjbr7qbL0E2BkRBmw3KOWcXHkFQT7Z5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kdasu.kdev@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 278/279] mmc: sdhci-brcmstb: use clk_get_rate(base_clk) in PM resume
Date: Tue,  8 Apr 2025 12:51:01 +0200
Message-ID: <20250408104833.895889300@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Dasu <kdasu.kdev@gmail.com>

commit 886201c70a1cab34ef96f867c2b2dd6379ffa7b9 upstream.

Use clk_get_rate for base_clk on resume before setting new rate.
This change ensures that the clock api returns current rate
and sets the clock to the desired rate and honors CLK_GET_NO_CACHE
attribute used by clock api.

Fixes: 97904a59855c (mmc: sdhci-brcmstb: Add ability to increase max clock rate for 72116b0)
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220714174132.18541-1-kdasu.kdev@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-brcmstb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-brcmstb.c
+++ b/drivers/mmc/host/sdhci-brcmstb.c
@@ -414,7 +414,14 @@ static int sdhci_brcmstb_resume(struct d
 	ret = sdhci_pltfm_resume(dev);
 	if (!ret && priv->base_freq_hz) {
 		ret = clk_prepare_enable(priv->base_clk);
-		if (!ret)
+		/*
+		 * Note: using clk_get_rate() below as clk_get_rate()
+		 * honors CLK_GET_RATE_NOCACHE attribute, but clk_set_rate()
+		 * may do implicit get_rate() calls that do not honor
+		 * CLK_GET_RATE_NOCACHE.
+		 */
+		if (!ret &&
+		    (clk_get_rate(priv->base_clk) != priv->base_freq_hz))
 			ret = clk_set_rate(priv->base_clk, priv->base_freq_hz);
 	}
 


