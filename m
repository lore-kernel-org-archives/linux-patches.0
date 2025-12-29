Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D9133343F;
	Mon, 29 Dec 2025 16:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025987; cv=none; b=bXf0m1Q9w7e7sU87Go6IXlZRCr1FDCruHQ9RQ/SIU5+MyJYhCmYl3OeF+om3D9d4+ovFRx5vx1ej+t3a4gK+Loa2pvwzL17aUPMF3ug9dN26GT1Neh/cTuEeczm7b0iGP/Utzh9rRaY0GpOswA9+lo873fuDc+eYEAti2rVwlao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025987; c=relaxed/simple;
	bh=PPnPsfAOaQIs+Ofd6D63a+VAVxXhLbidXHbthHpdqVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmnn1WyAUHED3ONg+ugNpCnKGHH2tDVFR2nJgj9lrs3su8fNCUstGXQVqYJo4AHLwt6WL21pKm1otoEVFRsEGwj26lo3YCNHoDsT3qNBjxp3TXt5NkVnHA2UEab/vlJv4qplz/JH5oPj1CvURJ+dNLcGwpEbB/9F2mbk4pAUqYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OqveLWoc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OqveLWoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D7CC4CEF7;
	Mon, 29 Dec 2025 16:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025984;
	bh=PPnPsfAOaQIs+Ofd6D63a+VAVxXhLbidXHbthHpdqVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OqveLWoc8jBILCdjmxc32UeHU5QpD53BZmXYysf+yyjylMsckLdVhTR46SUQobUqI
	 PyVuC2Fy3i7Zmk1ySFLqWiXyWkK8Dnpfu+6eExtbPfpGn5/0muax2G4sf53SCAdDCM
	 nZm3lw4DsmbSnIg2tsbMCcjLgD18kVXbszNQ44Uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 6.18 406/430] soc: samsung: exynos-pmu: fix device leak on regmap lookup
Date: Mon, 29 Dec 2025 17:13:28 +0100
Message-ID: <20251229160739.252462061@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
@@ -346,6 +346,8 @@ struct regmap *exynos_get_pmu_regmap_by_
 	if (!dev)
 		return ERR_PTR(-EPROBE_DEFER);
 
+	put_device(dev);
+
 	return syscon_node_to_regmap(pmu_np);
 }
 EXPORT_SYMBOL_GPL(exynos_get_pmu_regmap_by_phandle);


