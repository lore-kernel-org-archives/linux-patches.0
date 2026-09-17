Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF363BD65D;
	Thu, 17 Sep 2026 18:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670879; cv=none; b=Sxugzqrva2igbWldS2m6uucsAk7Aa9Bpuw3pc1gA1HnY5m6KU35+ylVodvObHFrhV7tVN5kCJE7/dhuRbz5Yh2Rtt8/xEhO1azgMgSvRXh+l6a8TnVRHxJHOBroL4f3281KCgGTOXJ2eGXk/PtJmmj++biwZPkmQ7Oq5ln0c8no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670879; c=relaxed/simple;
	bh=bv1qEqju8lLZjDPlyefPcIXd14CLCi/uAVar6R6tf9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIuey7MedlguDrl/z+OWYNf1X4x+zUhfKcJbIhJjpOef+pIssICoYSP2A/mgUP1PkOsl22n+AYf7+mCi/B54lRBN+ghrUb/8Fa80BfKmfmGGepJCbINe3BRi+EC3w0LPOmKjq8E+au1U+cyZBywQLvQrZxMsnQ+9tR4xEeKZ3Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpMkxUvA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpMkxUvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13441F000FF;
	Thu, 17 Sep 2026 18:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670878;
	bh=ljWVLTGrQZTJkQi29lJdw69rNpZYkOTVNcIvLP/gHbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpMkxUvA3Afi72WWL3D8262ycUQgp8njMUbxLb2zRjHlWK0TkvP53ZigxsURwBp4t
	 5C+t2/jM7zTGK7mZqwi5pAZkqzN5x1rMf4ebyDyThGoZuXtKm1Y34P3Z/WLz6aVkJm
	 +heRZf3k+6BWLmbE3g5mEXLR/1yfd3yZkXI/qsWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0762/1102] hwmon: (aspeed-pwm-tacho) Propagate reset deassert errors
Date: Thu, 17 Sep 2026 16:11:45 +0100
Message-ID: <20260917151559.565086990@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 09a9e1746a87845d7d8e2b4e23bb613306effdff ]

aspeed_pwm_tacho_probe() installs its reset cleanup action and configures
the
controller after an unchecked reset deassertion.

Stop probing when the reset controller rejects the transition, before the
hwmon device becomes visible.

Fixes: 18c514cc0e02 ("hwmon: (aspeed-pwm-tacho) Deassert reset in probe")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260830125044.97718-1-pengpeng@iscas.ac.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aspeed-pwm-tacho.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/aspeed-pwm-tacho.c b/drivers/hwmon/aspeed-pwm-tacho.c
index aa159bf158a37..4c62487336db0 100644
--- a/drivers/hwmon/aspeed-pwm-tacho.c
+++ b/drivers/hwmon/aspeed-pwm-tacho.c
@@ -933,7 +933,9 @@ static int aspeed_pwm_tacho_probe(struct platform_device *pdev)
 			"missing or invalid reset controller device tree entry");
 		return PTR_ERR(priv->rst);
 	}
-	reset_control_deassert(priv->rst);
+	ret = reset_control_deassert(priv->rst);
+	if (ret)
+		return ret;
 
 	ret = devm_add_action_or_reset(dev, aspeed_pwm_tacho_remove, priv);
 	if (ret)
-- 
2.53.0



