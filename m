Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BAE1419AA;
	Tue, 27 Feb 2024 13:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042083; cv=none; b=En/l0tYMHQIdO36D4BS34mvrr/muV9EXXVNydsU0BdlE1IZuK/BnSWtlSQ1SZ1R75+Jh1cEQF/DSVzk6wf7is94yPQR7YFRNCAChmwLmS3tBQiTJQqjF52/1QOP3Ri0BisS/vs2vZV68Cj5SmULf3jht4d7y8MVolOfZiYTyC9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042083; c=relaxed/simple;
	bh=sxE8eBL6e85fipFV6VEbVkYJk+Xl9n0VNrbyrQaQcvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7GKHbIdA8Kpgc2Wvq9PgHDGJvTQjgQrB+Psw0qUbkckSLK2UWWxqmNPoHm3a2t4eNcvsAN8Um/iViBxLGG0sCvk8tW0UQOdRh5qXz7z8UHNxQTPw3mv9trgGv3HZIbxuytOOj3xgOcgxNt3mmOfoOK2w/p2MSO9wNRi1o+3qaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqfAPHej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqfAPHej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EA8C433F1;
	Tue, 27 Feb 2024 13:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042082;
	bh=sxE8eBL6e85fipFV6VEbVkYJk+Xl9n0VNrbyrQaQcvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqfAPHejxMHMJgbISpab77e4sqYV3TgNCb/JtxDzbBMZNVKIml5tE6QLZjmofPv/0
	 rBQZ/Gw4Ls5cT+8vTgwwTi+41RthJhv/z6yfDkPqxietSSlOmFM6IkQJOMM2ZAQj0t
	 uHT81dDTQ8BCeIZTiuGtVhihp7C7KeJ2dEu80ClU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Jun <chenjun102@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 172/299] irqchip/mbigen: Dont use bus_get_dev_root() to find the parent
Date: Tue, 27 Feb 2024 14:24:43 +0100
Message-ID: <20240227131631.378115914@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/irqchip/irq-mbigen.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/irqchip/irq-mbigen.c b/drivers/irqchip/irq-mbigen.c
index 5101a3fb11df..58881d313979 100644
--- a/drivers/irqchip/irq-mbigen.c
+++ b/drivers/irqchip/irq-mbigen.c
@@ -235,22 +235,17 @@ static const struct irq_domain_ops mbigen_domain_ops = {
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
@@ -273,7 +268,6 @@ static int mbigen_of_create_domain(struct platform_device *pdev,
 		}
 	}
 
-	put_device(parent);
 	if (ret)
 		of_node_put(np);
 
-- 
2.44.0



