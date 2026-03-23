Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E1E2D9ECB;
	Mon, 23 Mar 2026 14:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277691; cv=none; b=qPpEB2qVcX4Izaif9E3alFg8B7kZnsOKpdDgW7WyDouVvXbzj63HzXacYiVXXtfN0yhcwg3TglnurJx2kLpXU1dQwdpqXk9fg6hJY64746hwQEybCHjdbX5j2FfY1uUXUFybAMuxYnNtKjnQwPwH35vLKjHmhq/ujZzzRmNvK+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277691; c=relaxed/simple;
	bh=seHl/cyquG98Qq0LoSqmFLWo2Z6fHdPwrxlgk+p0Hjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmmXXbj+g0uWczkoj3ZpgFfYUXuKuHl2WfsqmoBmCE2i4fcWgwlMqiuVK+87fiX9lmyLQzzx1iPIm0y6s1qq8JUL+0vPeYlD1KrwysuS+jgQYEChs1KkKiu3JB7qpvuXrOsqtUgD3tJ2cDH7wfZ9R5jRbzedh4wL/qem+E/3X3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KewSjpoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KewSjpoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AB0C4CEF7;
	Mon, 23 Mar 2026 14:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277691;
	bh=seHl/cyquG98Qq0LoSqmFLWo2Z6fHdPwrxlgk+p0Hjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KewSjpoLwzBRPjwYANdj0c6fEfPaWIDo0g/1yJz0VGV42G+Y4uQOOsqawf4cbvGTg
	 UcDczd9yHTP0DrY1GlFWthx7yAm+q+wocUpa0fFfPKxZ1q/KHjGE+azfbX/mz6yJig
	 mFkC1CZ06R5HIdV9cuAQiiNMFm539vjUaRG7r0H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/567] mfd: qcom-pm8xxx: Fix OF populate on driver rebind
Date: Mon, 23 Mar 2026 14:39:52 +0100
Message-ID: <20260323134535.608145399@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 27a8acea47a93fea6ad0e2df4c20a9b51490e4d9 ]

Since commit c6e126de43e7 ("of: Keep track of populated platform
devices") child devices will not be created by of_platform_populate()
if the devices had previously been deregistered individually so that the
OF_POPULATED flag is still set in the corresponding OF nodes.

Switch to using of_platform_depopulate() instead of open coding so that
the child devices are created if the driver is rebound.

Fixes: c6e126de43e7 ("of: Keep track of populated platform devices")
Cc: stable@vger.kernel.org	# 3.16
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20251219110947.24101-1-johan@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/qcom-pm8xxx.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/mfd/qcom-pm8xxx.c b/drivers/mfd/qcom-pm8xxx.c
index 8b6285f687da5..0e490591177a2 100644
--- a/drivers/mfd/qcom-pm8xxx.c
+++ b/drivers/mfd/qcom-pm8xxx.c
@@ -579,17 +579,11 @@ static int pm8xxx_probe(struct platform_device *pdev)
 	return rc;
 }
 
-static int pm8xxx_remove_child(struct device *dev, void *unused)
-{
-	platform_device_unregister(to_platform_device(dev));
-	return 0;
-}
-
 static void pm8xxx_remove(struct platform_device *pdev)
 {
 	struct pm_irq_chip *chip = platform_get_drvdata(pdev);
 
-	device_for_each_child(&pdev->dev, NULL, pm8xxx_remove_child);
+	of_platform_depopulate(&pdev->dev);
 	irq_domain_remove(chip->irqdomain);
 }
 
-- 
2.51.0



