Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07E9230BC2;
	Mon, 23 Jun 2025 13:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685351; cv=none; b=U96sKmGHciHP2MQ3eimCC+mD04Rlw1nUuB7XlsmawTPNzcSkQ10YbCQWGQPy8fmYgw5+9uC/8f+1brI7qGBsAS6e6vqOJrcTW2KPCm4BeoY8HIWj2o9+8SjKe4tV4WNsyznmXh+fMpmkAUZq7HGf9Lk9qH4LZlzh5mgXimpkSO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685351; c=relaxed/simple;
	bh=VRgfYyxrh2GKksDzZ/JBnjv4XyoltPqtaNPluUmaLps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mm6X8xaEstjBlufbJauxCovdFTG93fD1ylUo59w/lgL6knfgXBK+OJbgM8wZQPGurvX2WLQZTpBm5jq9/cZv27ByjGQNOeKl7h9GLREf5Bjck67/7NCD3B+HbOa/svd7GLcoetla00qwJElguSjioWBKHOG6Nl6CkkxvlAgp6No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSIPwXVc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSIPwXVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C38C4CEEA;
	Mon, 23 Jun 2025 13:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685351;
	bh=VRgfYyxrh2GKksDzZ/JBnjv4XyoltPqtaNPluUmaLps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSIPwXVczwP/WuDt3r42om/GK0maLdYA8vzfXKphio14gcQs0aMC+yT7AneGeOrZi
	 kGu104WllGJXHifPRj4LJJoIPvq1Z5woLeKZLYwO3/CcF4ahSZhK2KiQcuNh1jzZUS
	 rra3YKM85f9HptfPYMnEDpYgnJGZ8moo7j0Sdovw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 227/592] platform-msi: Add msi_remove_device_irq_domain() in platform_device_msi_free_irqs_all()
Date: Mon, 23 Jun 2025 15:03:05 +0200
Message-ID: <20250623130705.690713275@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 9a958e1fd40d6fae8c66385687a00ebd9575a7d2 ]

platform_device_msi_init_and_alloc_irqs() performs two tasks: allocating
the MSI domain for a platform device, and allocate a number of MSIs in that
domain.

platform_device_msi_free_irqs_all() only frees the MSIs, and leaves the MSI
domain alive.

Given that platform_device_msi_init_and_alloc_irqs() is the sole tool a
platform device has to allocate platform MSIs, it makes sense for
platform_device_msi_free_irqs_all() to teardown the MSI domain at the same
time as the MSIs.

This avoids warnings and unexpected behaviours when a driver repeatedly
allocates and frees MSIs.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/all/20250414-ep-msi-v18-1-f69b49917464@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/platform-msi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
index 0e60dd650b5e0..70db08f3ac6fa 100644
--- a/drivers/base/platform-msi.c
+++ b/drivers/base/platform-msi.c
@@ -95,5 +95,6 @@ EXPORT_SYMBOL_GPL(platform_device_msi_init_and_alloc_irqs);
 void platform_device_msi_free_irqs_all(struct device *dev)
 {
 	msi_domain_free_irqs_all(dev, MSI_DEFAULT_DOMAIN);
+	msi_remove_device_irq_domain(dev, MSI_DEFAULT_DOMAIN);
 }
 EXPORT_SYMBOL_GPL(platform_device_msi_free_irqs_all);
-- 
2.39.5



