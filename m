Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11CA13B7BE;
	Tue, 27 Feb 2024 13:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041024; cv=none; b=FiJywoTnjqfRu03UQPYXW0srcqEa5y0MHvfEffYo1E3jOmM5IC6agNklXG0aK1LkT88lnqsaA1G6l6x/B2DB7NTsGi/X7ZpDeSJWLjm682BD3CjCc9Sx4yFddTf/Jdcwp4byTSB2vA0FeYPjca4QlKRCyV/j6Xt6SlRefi8y2jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041024; c=relaxed/simple;
	bh=pG3VpkkreHcCGycoo0CadSiauZpzt07DZ8dqrB8ULtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pI8vEfN5BD2Po1EyN8zfqXf4x59mWGwspnPxIe9z4tawUlh0/+rEQeOh5O8Y3JQO7zDwtrtAE7e9wcInn3fMs+dLPBefE+QPJPUatigGxMYTSYkkgOvQMC53QpCdYie8u1lyb/a64LcOmfTs/vlOWbd/xJ4iOVE97jYFbUldygE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJpUyRSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJpUyRSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE5FC433F1;
	Tue, 27 Feb 2024 13:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041024;
	bh=pG3VpkkreHcCGycoo0CadSiauZpzt07DZ8dqrB8ULtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJpUyRSnaO0FkM3mIMMF3I0+fQbbIjSj8OtjorK8+fe6HxD252iOvVv+60xD53/kR
	 Ik9i1FA5pHm2ugCX4Xusq1/xTakaJTL93xSDp0/opIx1BQ2wMnrYLOq468cN1DtBoy
	 ZvTDze0HQOjsDnCRs0OJ/EVZafU4b3AUROVD9e1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Jun <chenjun102@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.7 193/334] irqchip/mbigen: Dont use bus_get_dev_root() to find the parent
Date: Tue, 27 Feb 2024 14:20:51 +0100
Message-ID: <20240227131636.919872848@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Jun <chenjun102@huawei.com>

commit fb33a46cd75e18773dd5a414744507d84ae90870 upstream.

bus_get_dev_root() returns sp->dev_root which is set in subsys_register(),
but subsys_register() is not called by platform_bus_init().

Therefor for the platform_bus_type, bus_get_dev_root() always returns NULL.
This makes mbigen_of_create_domain() always return -ENODEV.

Don't try to retrieve the parent via bus_get_dev_root() and
unconditionally hand a NULL pointer to of_platform_device_create() to
fix this.

Fixes: fea087fc291b ("irqchip/mbigen: move to use bus_get_dev_root()")
Signed-off-by: Chen Jun <chenjun102@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240220111429.110666-1-chenjun102@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-mbigen.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/irqchip/irq-mbigen.c
+++ b/drivers/irqchip/irq-mbigen.c
@@ -235,22 +235,17 @@ static const struct irq_domain_ops mbige
 static int mbigen_of_create_domain(struct platform_device *pdev,
 				   struct mbigen_device *mgn_chip)
 {
-	struct device *parent;
 	struct platform_device *child;
 	struct irq_domain *domain;
 	struct device_node *np;
 	u32 num_pins;
 	int ret = 0;
 
-	parent = bus_get_dev_root(&platform_bus_type);
-	if (!parent)
-		return -ENODEV;
-
 	for_each_child_of_node(pdev->dev.of_node, np) {
 		if (!of_property_read_bool(np, "interrupt-controller"))
 			continue;
 
-		child = of_platform_device_create(np, NULL, parent);
+		child = of_platform_device_create(np, NULL, NULL);
 		if (!child) {
 			ret = -ENOMEM;
 			break;
@@ -273,7 +268,6 @@ static int mbigen_of_create_domain(struc
 		}
 	}
 
-	put_device(parent);
 	if (ret)
 		of_node_put(np);
 


