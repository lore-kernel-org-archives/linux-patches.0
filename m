Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94C225A642;
	Wed, 25 Feb 2026 01:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983476; cv=none; b=n79RDsYYLYrFPb+b+UT9wzHUIZ2lU8PpMZ2RXlOWMc3kR7gRxK8LNE3A5yE/B7sVntJ+nrcmmJdlHF0ewUkrCYoE4R/NP2OfC0NeWndPwO7axkre4V0PjHxe6FdWwJZLJd97dypiOX9D1a+oinccvX0wcVbeEmI/FQNAxrPCmGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983476; c=relaxed/simple;
	bh=0pxPA0WaFa+V4nTxQ1N5iQCedwB29w9kQTReKOnGxWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nCcKwZYVupC/QJgZCEfossj7cIFTWG+Rnh5NO/y//hE65D+GrWFlERcvYI6NW8eaCrJJ+VwbMc6cYUHmIpz803q94wDVVZ26fQTX95YBkj75PZs/ZGuZB3jOC3WHPAiyOxGyMP+Xsty3cCygJBfYLDbjWyA7C6ea51f5Kf85nXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAQbEAfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAQbEAfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E08CC116D0;
	Wed, 25 Feb 2026 01:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983476;
	bh=0pxPA0WaFa+V4nTxQ1N5iQCedwB29w9kQTReKOnGxWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAQbEAfjCLeJcGcAezfL1kHHt3SQekjPrjByO9npDe0Bk2IqWtmGfaJzsmyoA0o8Y
	 HfsOa4xupK7gx88fZihhlqGYqu0WfRI+7DYZ4btGU/OcL5kbNv+mJTkPCldR6ccbxd
	 ooi0wjhVm/herPfhSVhSeaCtqUL5NRTo9BGYta0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 591/781] mfd: sec: Fix IRQ domain names duplication
Date: Tue, 24 Feb 2026 17:21:40 -0800
Message-ID: <20260225012414.292845161@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

[ Upstream commit b60c2dba6d3c3ad72a7c30bbd8eda07d8a49bc7f ]

For the S2MPG10 IRQ and chained IRQ, regmap IRQ will try to create a
folder with the same name which is impossible and fails with:

  debugfs: ':firmware:power-management:pmic' already exists in 'domains'

Add domain_suffix to the chained IRQ chip driver to fix it.

Fixes: ee19b52c31b3 ("mfd: sec: Use chained IRQs for s2mpg10")
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://patch.msgid.link/20260105-s2mpg10-chained-irq-domain-suffix-v1-1-01ab16204b97@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/sec-irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
index 74ac70002d1fc..ff2671186e89f 100644
--- a/drivers/mfd/sec-irq.c
+++ b/drivers/mfd/sec-irq.c
@@ -198,6 +198,7 @@ static const struct regmap_irq_chip s2mpg10_irq_chip = {
 
 static const struct regmap_irq_chip s2mpg10_irq_chip_pmic = {
 	.name = "s2mpg10-pmic",
+	.domain_suffix = "pmic",
 	.status_base = S2MPG10_PMIC_INT1,
 	.mask_base = S2MPG10_PMIC_INT1M,
 	.num_regs = 6,
-- 
2.51.0



