Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148DD331227;
	Wed,  3 Dec 2025 15:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777144; cv=none; b=e5LGbKz4tATArotmE6ruGRCPGY/p1vEn+KBMJ+EIWZPTunFS8QiIve5Lq9hc45slJS9AmWICouJHP/2dU04nQfRjYByidkFvTHdbuRPq/Tg2eNlw3qGFA3vVe4CLGSRnJ+nuVb/dVkhoM4NpaTz5KKi7NvjE5aT89/XsvbiKu/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777144; c=relaxed/simple;
	bh=L5bnergv5wMk1KBb0kAp6Na3I6ezO3ks/W2VjG+mJcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvGSDKc2mtnmeRGcWsJcBOMqpRB7Dy+6c2bSRM8NTyGlk8rMwLPDH34i+IFv2oYeXE7RYTAWl5BTNR7OcVF2cOp8WX0/jyyVb1J4QqrxoUwqSs9bPIh7yCGUCOYSqNjGlxRTGpJx+qvoDUBjFlFDXXwd12LZR4aQ/RfMD54TN/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIzP2trR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIzP2trR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDDCC116B1;
	Wed,  3 Dec 2025 15:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777143;
	bh=L5bnergv5wMk1KBb0kAp6Na3I6ezO3ks/W2VjG+mJcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIzP2trRumDVO01pYbgJWBwc+683M10GFjz9wHzTKvCQThGaVXqk4tXjnIVwhYjVo
	 1ZW87VV3oS1HydJfpiKjVAMekgtgTAoUFLILTVs4clvsJQEYosL/iP/aUE6TD5IoKS
	 7LplK+jURwHaDE/ABvG/3A3Y3D1gVm2ivSaK7gOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.17 095/146] pmdomain: tegra: Add GENPD_FLAG_NO_STAY_ON flag
Date: Wed,  3 Dec 2025 16:27:53 +0100
Message-ID: <20251203152349.937409097@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

commit c98c99d5dbdf9fb0063650594edfd7d49b5f4e29 upstream.

Commit 13a4b7fb6260 ("pmdomain: core: Leave powered-on genpds on until
late_initcall_sync") kept power-domains on longer during boot which is
causing some GPU related tests to fail on Tegra234. While this is being
investigated, add the flag GENPD_FLAG_NO_STAY_ON for Tegra devices to
restore the previous behaviour to fix this.

Fixes: 13a4b7fb6260 ("pmdomain: core: Leave powered-on genpds on until late_initcall_sync")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/tegra/powergate-bpmp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pmdomain/tegra/powergate-bpmp.c
+++ b/drivers/pmdomain/tegra/powergate-bpmp.c
@@ -184,6 +184,7 @@ tegra_powergate_add(struct tegra_bpmp *b
 	powergate->genpd.name = kstrdup(info->name, GFP_KERNEL);
 	powergate->genpd.power_on = tegra_powergate_power_on;
 	powergate->genpd.power_off = tegra_powergate_power_off;
+	powergate->genpd.flags = GENPD_FLAG_NO_STAY_ON;
 
 	err = pm_genpd_init(&powergate->genpd, NULL, off);
 	if (err < 0) {


