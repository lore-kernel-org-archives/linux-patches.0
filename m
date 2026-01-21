Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA89363C68;
	Wed, 21 Jan 2026 18:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020276; cv=none; b=NjMGAw3VxIW/DcW7oJjhzx8H3gEbqmiCEYIChfy9zs1UhRvsB4hhv5m2LWPzbe2oXjaCbECTFWqtP+LQCX68AapI39Ugch1r7dEMt9UT5UW/0SVBDG6JxF015BJFWtoPjedujdec8ivUUkLBdx6kscDrui8zGWdGwNwU+qyoE3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020276; c=relaxed/simple;
	bh=AAdBg9tP6drnVwq46FHtt+gybNEys0YlWJpfYmLXpio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3PnZojtdF/gVxaDz11PQPVnwJ91Xa0f+PIQCAU/Fy0KwljJEOybbswDfcHsAeqiDxQjFFYGzDJNfGia2OSBDYMLYMvEV49xbAJSBnTReJ3KKGDLUh1MCBsriKnm/+XyxiGbdUOf2Kz3MeX9edAxaaogr3VDCSZEWLHAjfYidrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5mdn2OG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5mdn2OG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61194C16AAE;
	Wed, 21 Jan 2026 18:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020275;
	bh=AAdBg9tP6drnVwq46FHtt+gybNEys0YlWJpfYmLXpio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5mdn2OGSWgQ1jspYTJnfr5RvylRM9kwonrKvjcyLYfzBSPFBYo7ssvGeKTrfnEO5
	 B2aDctuj2hPuW9VPb0l1VCNkETmvdLxZnQ5Nwzz9teRPcv/Emoalz+A8mVm0gGs+Lj
	 qquuO2aT6YlLKY5VoI97cqeT/PydX0Nz9FrHknn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 111/198] phy: ti: gmii-sel: fix regmap leak on probe failure
Date: Wed, 21 Jan 2026 19:15:39 +0100
Message-ID: <20260121181422.548868303@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 4914d67da947031d6f645c81c74f7879e0844d5d upstream.

The mmio regmap that may be allocated during probe is never freed.

Switch to using the device managed allocator so that the regmap is
released on probe failures (e.g. probe deferral) and on driver unbind.

Fixes: 5ab90f40121a ("phy: ti: gmii-sel: Do not use syscon helper to build regmap")
Cc: stable@vger.kernel.org	# 6.14
Cc: Andrew Davis <afd@ti.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Andrew Davis <afd@ti.com>
Link: https://patch.msgid.link/20251127134834.2030-1-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/ti/phy-gmii-sel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/ti/phy-gmii-sel.c
+++ b/drivers/phy/ti/phy-gmii-sel.c
@@ -512,7 +512,7 @@ static int phy_gmii_sel_probe(struct pla
 			return dev_err_probe(dev, PTR_ERR(base),
 					     "failed to get base memory resource\n");
 
-		priv->regmap = regmap_init_mmio(dev, base, &phy_gmii_sel_regmap_cfg);
+		priv->regmap = devm_regmap_init_mmio(dev, base, &phy_gmii_sel_regmap_cfg);
 		if (IS_ERR(priv->regmap))
 			return dev_err_probe(dev, PTR_ERR(priv->regmap),
 					     "Failed to get syscon\n");


