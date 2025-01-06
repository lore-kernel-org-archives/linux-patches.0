Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DC5148316;
	Mon,  6 Jan 2025 15:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177671; cv=none; b=AhMaTQLE2BB+u658es7nACGLx2rQ54q1yXsuG4/6tdNzv+6qP1Nfq7VVuiVnhxEbcHrxZONaGgdoVuw8SKUJSBeSJouvDKp8VzmPSFYTHF7SzaUn4cKMyQQL9aZB9Fqz3xU6Uu6SmM4cawHm7tKlfSMTPyJ6vG5fuHTnbNvqDag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177671; c=relaxed/simple;
	bh=yo8KR6eafpXm1Lq3gcakhhHEfOv4MoOw9YSLBGPsiL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGCgvWiKpl71KpqkxHwIrxJTNW3U2ZErTAIJm1rbjxH669ezMiN0IfXhvLtWB+jecVGuUu3xxbSdug+nLQsIRTaEneagy3+mukEcwnxU8raPlnos3UYkWwjo/1V4kn6cPUNtWSjQsf0GveejyJmHmxiFkf7e0fNGLsSXxRoUuOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Peca+0Ao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Peca+0Ao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77057C4CED2;
	Mon,  6 Jan 2025 15:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177670;
	bh=yo8KR6eafpXm1Lq3gcakhhHEfOv4MoOw9YSLBGPsiL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Peca+0AolGnmkO5VtjlgKE7PDlS0FB11XDPskmgrR49nArJf/hK90VdXI1z5NdTXm
	 ZgqIvioZUK4yT27G+RzcBgGzLy0zQrKRV8o5WRI8q2nMKlfOaBfVM6z5ZEYROlvnPP
	 eJimZx56yPvVOjMxQXm05+7a+e9jZISEKBUAqLDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 007/156] pmdomain: imx: gpcv2: fix an OF node reference leak in imx_gpcv2_probe()
Date: Mon,  6 Jan 2025 16:14:53 +0100
Message-ID: <20250106151142.020294722@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit 469c0682e03d67d8dc970ecaa70c2d753057c7c0 upstream.

imx_gpcv2_probe() leaks an OF node reference obtained by
of_get_child_by_name(). Fix it by declaring the device node with the
__free(device_node) cleanup construct.

This bug was found by an experimental static analysis tool that I am
developing.

Fixes: 03aa12629fc4 ("soc: imx: Add GPCv2 power gating driver")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Cc: stable@vger.kernel.org
Message-ID: <20241215030159.1526624-1-joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/gpcv2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pmdomain/imx/gpcv2.c
+++ b/drivers/pmdomain/imx/gpcv2.c
@@ -1458,12 +1458,12 @@ static int imx_gpcv2_probe(struct platfo
 		.max_register   = SZ_4K,
 	};
 	struct device *dev = &pdev->dev;
-	struct device_node *pgc_np;
+	struct device_node *pgc_np __free(device_node) =
+		of_get_child_by_name(dev->of_node, "pgc");
 	struct regmap *regmap;
 	void __iomem *base;
 	int ret;
 
-	pgc_np = of_get_child_by_name(dev->of_node, "pgc");
 	if (!pgc_np) {
 		dev_err(dev, "No power domains specified in DT\n");
 		return -EINVAL;


