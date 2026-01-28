Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F32481AA8;
	Wed, 28 Jan 2026 16:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616076; cv=none; b=AKwyPTu9gHECCt/P60/VaOHPi8dbQTh9RNyV3xtxec61AUocs0+BK80FeKelLrggzrTPMsbeSn5kAQnMynH270kGXz0Rho5TaJsZZsl1TLPm+MdJ7+wDS/ECtjiXwvTSD0oTE3xJ5op3awyDeQssF85s0Sld/cpvqOPqwTt0OZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616076; c=relaxed/simple;
	bh=ZiTjOFfFqJhRI4gY/vgo1KBPiSf6DHH2TQbH52f87Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpwUwueWSvu3wMTHc5Nq9AxhaCv497yiUxNsaLd0bogLupe22sQZIHTA9PaPyS1GwntVM9sbL/zKfjqB36GRJORscU2pHOC+EGTMuIYi3NFt9csf1A/F+z6SWKtvkmhAerpFcQxYawe5QVzJWfd/4udtXhUGJHagM5x7vk82+CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgbPgXSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgbPgXSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006EFC4CEF1;
	Wed, 28 Jan 2026 16:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616076;
	bh=ZiTjOFfFqJhRI4gY/vgo1KBPiSf6DHH2TQbH52f87Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgbPgXSLu1eKI1sbrXbZCrZ62+zzUKBB40H129H/s3/o/rZzgDrwAeVLH9loZOwpm
	 2/fkqjMXm4Gh9gxx/VuEkZyTn8CE2dkEyib05D2Syd4NBqY9MKbqNscOdVrFOHPCrQ
	 euYGhmF4yL32YC4TsGDJghfPHhVl60pPfcixJ9fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Zhang <rmxpzlb@gmail.com>,
	Chaoyi Chen <chaoyi.chen@rock-chips.com>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 198/227] pmdomain:rockchip: Fix init genpd as GENPD_STATE_ON before regulator ready
Date: Wed, 28 Jan 2026 16:24:03 +0100
Message-ID: <20260128145351.568190226@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Frank Zhang <rmxpzlb@gmail.com>

commit 861d21c43c98478eef70e68e31d4ff86400c6ef7 upstream.

RK3588_PD_NPU initialize as GENPD_STATE_ON before regulator ready.
rknn_iommu initlized success and suspend RK3588_PD_NPU. When rocket
driver register, it will resume rknn_iommu.

If regulator is still not ready at this point, rknn_iommu resume fail,
pm runtime status will be error: -EPROBE_DEFER.

This patch set pmdomain to off if it need regulator during probe,
consumer device can power on pmdomain after regulator ready.

Signed-off-by: Frank Zhang <rmxpzlb@gmail.com>
Tested-by: Chaoyi Chen <chaoyi.chen@rock-chips.com>
Tested-by: Quentin Schulz <quentin.schulz@cherry.de>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Fixes: db6df2e3fc16 ("pmdomain: rockchip: add regulator support")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/rockchip/pm-domains.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/pmdomain/rockchip/pm-domains.c
+++ b/drivers/pmdomain/rockchip/pm-domains.c
@@ -861,6 +861,16 @@ static int rockchip_pm_add_one_domain(st
 		pd->genpd.name = pd->info->name;
 	else
 		pd->genpd.name = kbasename(node->full_name);
+
+	/*
+	 * power domain's needing a regulator should default to off, since
+	 * the regulator state is unknown at probe time. Also the regulator
+	 * state cannot be checked, since that usually requires IP needing
+	 * (a different) power domain.
+	 */
+	if (pd->info->need_regulator)
+		rockchip_pd_power(pd, false);
+
 	pd->genpd.power_off = rockchip_pd_power_off;
 	pd->genpd.power_on = rockchip_pd_power_on;
 	pd->genpd.attach_dev = rockchip_pd_attach_dev;


