Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EF5235071;
	Tue, 17 Jun 2025 16:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178620; cv=none; b=JUVs7omh708i8cHsVfxHy/8+Xhyw3LgKIH8W714EewyJvuQY1J5cYC+j0mLWTO2nR71fHvxFdNXt1sGbYsBjOAoXc+RMgGVb0tSwkDqRP+sbxWtWSt0kS22Sfytf+aAtHaJjC4Y8eZmdOyewW1VM591YrPSU1/gjAQW+877e9lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178620; c=relaxed/simple;
	bh=XJZn8OYOIjj4NDiLM1+VQoHwGvl4eKBNgbj8U7wWKjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvbZ2UJoMUAniyRJEaqQ5ip6ArW6np1MokhN9+UlQGJDJfwh7kZqyJZ2U10Nu2CaRZ25WscT0sWH24diGd7s9SGvsk/MG25+cZ9yXsH5HLwmhJ3g0fMx/VokHe6RZQFjJHIR+2MigbtUrPkeyYYdgAazCsRfcofGYe9vmqOgJpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYqiYhoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYqiYhoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E29C4CEE3;
	Tue, 17 Jun 2025 16:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178620;
	bh=XJZn8OYOIjj4NDiLM1+VQoHwGvl4eKBNgbj8U7wWKjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYqiYhoStpqISfgzI5JSwLAO8unVxW8l7rAtafrHu0+97Vp2MKNOlMrDs5DhxMSw5
	 KTnZJ13ZeBQ6DgL4CIX4G/e3V2CA0ZtBZ43oAIj9AVu/DyDV1KhEqqCO4OMKinkzXh
	 zmWApPI9tAziZ4rQcoStmBrOYKiGBFRz6O3J/TQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 502/780] phy: qcom-qmp-usb: Fix an NULL vs IS_ERR() bug
Date: Tue, 17 Jun 2025 17:23:30 +0200
Message-ID: <20250617152511.942509084@linuxfoundation.org>
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

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit d14402a38c2d868cacb1facaf9be908ca6558e59 ]

The qmp_usb_iomap() helper function currently returns the raw result of
devm_ioremap() for non-exclusive mappings. Since devm_ioremap() may return
a NULL pointer and the caller only checks error pointers with IS_ERR(),
NULL could bypass the check and lead to an invalid dereference.

Fix the issue by checking if devm_ioremap() returns NULL. When it does,
qmp_usb_iomap() now returns an error pointer via IOMEM_ERR_PTR(-ENOMEM),
ensuring safe and consistent error handling.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Fixes: a5d6b1ac56cb ("phy: qcom-qmp-usb: fix memleak on probe deferral")
CC: Johan Hovold <johan@kernel.org>
CC: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250414125050.2118619-1-chenyuan0y@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
index 7877215704575..ed646a7e705ba 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
@@ -2106,12 +2106,16 @@ static void __iomem *qmp_usb_iomap(struct device *dev, struct device_node *np,
 					int index, bool exclusive)
 {
 	struct resource res;
+	void __iomem *mem;
 
 	if (!exclusive) {
 		if (of_address_to_resource(np, index, &res))
 			return IOMEM_ERR_PTR(-EINVAL);
 
-		return devm_ioremap(dev, res.start, resource_size(&res));
+		mem = devm_ioremap(dev, res.start, resource_size(&res));
+		if (!mem)
+			return IOMEM_ERR_PTR(-ENOMEM);
+		return mem;
 	}
 
 	return devm_of_iomap(dev, np, index, NULL);
-- 
2.39.5



