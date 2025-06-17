Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAA42E264E;
	Tue, 17 Jun 2025 16:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177839; cv=none; b=hEYnuWaS74Fz9zb6j2NUwZJXIghoh3y57IB6hKV7pi4IJegj/TJ37HJ1XDn9UfKWMrNjTB26hPlQvHki2RF0XMLqetbzxu4hC9ibC9QbFjpYEchNs/27x/n6JEMZT9pgAPyLow349JiqUBN+yklYg5sdgOBhemjwdQT01QiBdSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177839; c=relaxed/simple;
	bh=9/CmTl24N4bRONdBXEx1Ja962OmSrqeo3LbQAz4b9vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oQujHLvrO9QdwnMYqQXIK3AiUTqkZCERgsu9x4oscMY7cwbSBp7ch7pJdifV7lue0WWB6uNxvQ7UA4hLcwiE/W3SQBObwd4Z2Iz5IN0f/BlW0ZLzpPryl3Dx8oXnqYja6WONIAxCc1nJv7vSqceBe6wlopqHCB7T8xBZGDKBQGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUB6JtTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUB6JtTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7133DC4CEE3;
	Tue, 17 Jun 2025 16:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177838;
	bh=9/CmTl24N4bRONdBXEx1Ja962OmSrqeo3LbQAz4b9vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUB6JtTLmuW2kq1SV0uZG6l2vrcVPpDmhcvpPjnmeTxxi9wf6NZO/LNqqklVfEKes
	 8k62gVY6Zpxb3hdn/teolMnGvbgsHcyj3ErhLMBmK6iTJXZb4P701W3ZaHKkqAR6kW
	 TOG14wDWrVGPpf/OyoSKUx2964JYwGzE1QWj6qSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 370/780] firmware: exynos-acpm: silence EPROBE_DEFER error on boot
Date: Tue, 17 Jun 2025 17:21:18 +0200
Message-ID: <20250617152506.519525360@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

[ Upstream commit 53734383a73888e6d765aa07f4523802fdf1ee10 ]

This driver emits error messages when client drivers are trying to get
an interface handle to this driver here before this driver has
completed _probe().

Given this driver returns -EPROBE_DEFER in that case, this is not an
error and shouldn't be emitted to the log, similar to how
dev_err_probe() behaves, so just remove them.

This change also allows us to simplify the logic around releasing of
the acpm_np handle.

Fixes: a88927b534ba ("firmware: add Exynos ACPM protocol driver")
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/20250319-acpm-fixes-v2-2-ac2c1bcf322b@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/samsung/exynos-acpm.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/samsung/exynos-acpm.c b/drivers/firmware/samsung/exynos-acpm.c
index 15e991b99f5a3..e80cb7a8da8f2 100644
--- a/drivers/firmware/samsung/exynos-acpm.c
+++ b/drivers/firmware/samsung/exynos-acpm.c
@@ -696,24 +696,17 @@ static const struct acpm_handle *acpm_get_by_phandle(struct device *dev,
 		return ERR_PTR(-ENODEV);
 
 	pdev = of_find_device_by_node(acpm_np);
-	if (!pdev) {
-		dev_err(dev, "Cannot find device node %s\n", acpm_np->name);
-		of_node_put(acpm_np);
-		return ERR_PTR(-EPROBE_DEFER);
-	}
-
 	of_node_put(acpm_np);
+	if (!pdev)
+		return ERR_PTR(-EPROBE_DEFER);
 
 	acpm = platform_get_drvdata(pdev);
 	if (!acpm) {
-		dev_err(dev, "Cannot get drvdata from %s\n",
-			dev_name(&pdev->dev));
 		platform_device_put(pdev);
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 
 	if (!try_module_get(pdev->dev.driver->owner)) {
-		dev_err(dev, "Cannot get module reference.\n");
 		platform_device_put(pdev);
 		return ERR_PTR(-EPROBE_DEFER);
 	}
-- 
2.39.5



