Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A85A29B793;
	Tue,  6 Jan 2026 17:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720716; cv=none; b=iYvOEe1gAy1AV9F6SeeswB4OghZFMG+t7kb8fJ6rxHT1uSaxOPWt5/OmzCy53xrjyqI42KSlRIxiUJgV+r7xsY1YSh9MC7KbKoYKRsrGLS6ImOpmZsrc6bjf3/ZVOx5MLH6czuPWNlWoZ5V4X0NVlhY3V3aPSrEYfb5VFVDHsxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720716; c=relaxed/simple;
	bh=DpMN6pnLc6ZE7WDJI9wkpxPKCEGiX+mmWlgLs5B2gew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URue+sJUDMXWq2WOsvmvigGEsHVzymt/cQRIz/ZZEI3x7vB2CCOwTR+nbbVRsLcIKxOlIbxyPsDHvd96Es5cN2v3ulTcdMHtaQje7UXp7jP/p09glHPHhmo+b5daCTGDlAQc163IUGSgBHzteAvg4Am0PTyzeDPtS9M8h7Enobk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKPb7YF1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKPb7YF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA130C19424;
	Tue,  6 Jan 2026 17:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720716;
	bh=DpMN6pnLc6ZE7WDJI9wkpxPKCEGiX+mmWlgLs5B2gew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKPb7YF1afOFQvooDqX9e87D6d65ETEeVC7dE+tOZ+MtKax0dgTMGrvGEEAqfgqnD
	 TqC0hrHNJdfbY03b35LZhL9Mz8nAq36IovEkEe65IX2jiLb2xcE6jWISqQfRvWdcXn
	 Du6jr7Jo2zLYfSPGC0vyZfafaUbxjKaR8Lyff/lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 6.12 277/567] soc: samsung: exynos-pmu: fix device leak on regmap lookup
Date: Tue,  6 Jan 2026 18:00:59 +0100
Message-ID: <20260106170501.573001955@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 990eb9a8eb4540ab90c7b34bb07b87ff13881cad upstream.

Make sure to drop the reference taken when looking up the PMU device and
its regmap.

Note that holding a reference to a device does not prevent its regmap
from going away so there is no point in keeping the reference.

Fixes: 0b7c6075022c ("soc: samsung: exynos-pmu: Add regmap support for SoCs that protect PMU regs")
Cc: stable@vger.kernel.org	# 6.9
Cc: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251121121852.16825-1-johan@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/samsung/exynos-pmu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -322,6 +322,8 @@ struct regmap *exynos_get_pmu_regmap_by_
 	if (!dev)
 		return ERR_PTR(-EPROBE_DEFER);
 
+	put_device(dev);
+
 	return syscon_node_to_regmap(pmu_np);
 }
 EXPORT_SYMBOL_GPL(exynos_get_pmu_regmap_by_phandle);


