Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E94A2FA65D;
	Tue, 17 Jun 2025 16:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178991; cv=none; b=tAQ8ckyBoqO1m/JDOwIpCU3nBAbLR4mnxwSl+Ei847kCL/MlUxIHZpA1f9L/yNCEw7JWuo5uP0Lt+lAhu5NDGySJpHL47dWd2iMr8DLqLmxhR8DiztyCMy8oEf0B8ZSUqgi2TpKO3GpjEBTtt9hR3Epb7u3f3Rt6pho989IKRzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178991; c=relaxed/simple;
	bh=5GKueUfVl1WgCU+yE2YMVSgmv2q+RaGWKDGhUYHNaes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJldQC+mH3l66hjw9FAePam3ucms8Ncsr/M7S+Hfz470Wq7AcQFM5M3JPvn56WNJrALLzoL9mR/ALD7/AxdAT1IcCqASY4+KaJksywnRbjjsRGBU43hApOD4rrFwJ4Z3gUJ00Aku9s9Smq9C6rRK5jxjP5sgeiyBVA4ufvNzZeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGEQM8mK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGEQM8mK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F20C4CEE3;
	Tue, 17 Jun 2025 16:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178990;
	bh=5GKueUfVl1WgCU+yE2YMVSgmv2q+RaGWKDGhUYHNaes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGEQM8mK5EMxGDfgxWN1E7j3q9Fzk+NM60SUkxbsDVVTQJDXsf8NUQfEsVi7WjSnZ
	 2Ho6a9REKCaEs59kVksAEfw4vuad6qGslWlKs24m/3hVas6FGEb8Yu3M6Y/0aq4qnx
	 zbOeJjWKcT9N5sesjKvlpGzJBit8Q3K5Aucm+djM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 615/780] net: dsa: b53: do not touch DLL_IQQD on bcm53115
Date: Tue, 17 Jun 2025 17:25:23 +0200
Message-ID: <20250617152516.527533651@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit bc1a65eb81a21e2aa3c3dca058ee8adf687b6ef5 ]

According to OpenMDK, bit 2 of the RGMII register has a different
meaning for BCM53115 [1]:

"DLL_IQQD         1: In the IDDQ mode, power is down0: Normal function
                  mode"

Configuring RGMII delay works without setting this bit, so let's keep it
at the default. For other chips, we always set it, so not clearing it
is not an issue.

One would assume BCM53118 works the same, but OpenMDK is not quite sure
what this bit actually means [2]:

"BYPASS_IMP_2NS_DEL #1: In the IDDQ mode, power is down#0: Normal
                    function mode1: Bypass dll65_2ns_del IP0: Use
                    dll65_2ns_del IP"

So lets keep setting it for now.

[1] https://github.com/Broadcom-Network-Switching-Software/OpenMDK/blob/master/cdk/PKG/chip/bcm53115/bcm53115_a0_defs.h#L19871
[2] https://github.com/Broadcom-Network-Switching-Software/OpenMDK/blob/master/cdk/PKG/chip/bcm53118/bcm53118_a0_defs.h#L14392

Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20250602193953.1010487-6-jonas.gorski@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index be4493b769f44..862bdccb74397 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1354,8 +1354,7 @@ static void b53_adjust_531x5_rgmii(struct dsa_switch *ds, int port,
 	 * tx_clk aligned timing (restoring to reset defaults)
 	 */
 	b53_read8(dev, B53_CTRL_PAGE, off, &rgmii_ctrl);
-	rgmii_ctrl &= ~(RGMII_CTRL_DLL_RXC | RGMII_CTRL_DLL_TXC |
-			RGMII_CTRL_TIMING_SEL);
+	rgmii_ctrl &= ~(RGMII_CTRL_DLL_RXC | RGMII_CTRL_DLL_TXC);
 
 	/* PHY_INTERFACE_MODE_RGMII_TXID means TX internal delay, make
 	 * sure that we enable the port TX clock internal delay to
@@ -1375,7 +1374,10 @@ static void b53_adjust_531x5_rgmii(struct dsa_switch *ds, int port,
 		rgmii_ctrl |= RGMII_CTRL_DLL_TXC;
 	if (interface == PHY_INTERFACE_MODE_RGMII)
 		rgmii_ctrl |= RGMII_CTRL_DLL_TXC | RGMII_CTRL_DLL_RXC;
-	rgmii_ctrl |= RGMII_CTRL_TIMING_SEL;
+
+	if (dev->chip_id != BCM53115_DEVICE_ID)
+		rgmii_ctrl |= RGMII_CTRL_TIMING_SEL;
+
 	b53_write8(dev, B53_CTRL_PAGE, off, rgmii_ctrl);
 
 	dev_info(ds->dev, "Configured port %d for %s\n", port,
-- 
2.39.5



