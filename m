Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963F817C9A9;
	Thu, 15 Aug 2024 13:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730149; cv=none; b=iRYj9FYOjcaTkcdcEaNR6jkAOiGGGbYE8KBeRxoeaBBBkxHar2QZk0qW92lfDQ74bP1fvDWYlNHDaNhGbclEuY+8pf8kDg5DfeburmInXMHOeN3T/O3BMcuISuJL4Bgj2n/aV468dpqnVuaH1KYXdjGcIAwAQFvYs3ZZNVeKHsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730149; c=relaxed/simple;
	bh=itAhFh+XrmDoSOJFDhlsYQaMmJK/MDWEJSwd6RFZbH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kwv1XiE44haZ5ZuWfw1loECC+cKdZW4aznBns0HY759S8aetEh1+GL+zt4Vw9UsPy/vfV/PqXkho1BetN4PMSf9bszdhSWl+wibSm98exJHAcsQOLlP5owHdY6In63tY1McOFJmRGBBNQwlkBWGL0QEQi/zldqoCpk1b11xtWw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdhLm7xy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdhLm7xy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140A3C32786;
	Thu, 15 Aug 2024 13:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730149;
	bh=itAhFh+XrmDoSOJFDhlsYQaMmJK/MDWEJSwd6RFZbH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdhLm7xyB+HfUwjVzgHPEZp/zKOGqKmBAufGAsp1rG508V4+yfAFy9dX2wDrDsMgL
	 IZZC77cflkGNthSZ6VF2BfBOsSmnQCTEZKIpMikrstbW7NWOlLfjbNQBKcVJrnVu2o
	 cdvCCqw0B4LippSVP2VjGiiBlLe3bbNUm3PYPYF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Tony Lindgren <tony@atomide.com>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 318/484] genirq: Allow the PM device to originate from irq domain
Date: Thu, 15 Aug 2024 15:22:56 +0200
Message-ID: <20240815131953.688865651@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 1f8863bfb5ca500ea1c7669b16b1931ba27fce20 ]

As a preparation to moving the reference to the device used for
runtime power management, add a new 'dev' field to the irqdomain
structure for that exact purpose.

The irq_chip_pm_{get,put}() helpers are made aware of the dual
location via a new private helper.

No functional change intended.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Tony Lindgren <tony@atomide.com>
Acked-by: Bartosz Golaszewski <brgl@bgdev.pl>
Link: https://lore.kernel.org/r/20220201120310.878267-2-maz@kernel.org
Stable-dep-of: 33b1c47d1fc0 ("irqchip/imx-irqsteer: Handle runtime power management correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irqdomain.h | 10 ++++++++++
 kernel/irq/chip.c         | 23 ++++++++++++++++++-----
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 9ee238ad29ce9..a7c80bd4b45b6 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -147,6 +147,8 @@ struct irq_domain_chip_generic;
  * @gc: Pointer to a list of generic chips. There is a helper function for
  *      setting up one or more generic chips for interrupt controllers
  *      drivers using the generic chip library which uses this pointer.
+ * @dev: Pointer to a device that the domain represent, and that will be
+ *       used for power management purposes.
  * @parent: Pointer to parent irq_domain to support hierarchy irq_domains
  *
  * Revmap data, used internally by irq_domain
@@ -167,6 +169,7 @@ struct irq_domain {
 	struct fwnode_handle *fwnode;
 	enum irq_domain_bus_token bus_token;
 	struct irq_domain_chip_generic *gc;
+	struct device *dev;
 #ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
 	struct irq_domain *parent;
 #endif
@@ -222,6 +225,13 @@ static inline struct device_node *irq_domain_get_of_node(struct irq_domain *d)
 	return to_of_node(d->fwnode);
 }
 
+static inline void irq_domain_set_pm_device(struct irq_domain *d,
+					    struct device *dev)
+{
+	if (d)
+		d->dev = dev;
+}
+
 #ifdef CONFIG_IRQ_DOMAIN
 struct fwnode_handle *__irq_domain_alloc_fwnode(unsigned int type, int id,
 						const char *name, phys_addr_t *pa);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index f3920374f71ce..7ea66e55ef86b 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -1559,6 +1559,17 @@ int irq_chip_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 	return 0;
 }
 
+static struct device *irq_get_parent_device(struct irq_data *data)
+{
+	if (data->chip->parent_device)
+		return data->chip->parent_device;
+
+	if (data->domain)
+		return data->domain->dev;
+
+	return NULL;
+}
+
 /**
  * irq_chip_pm_get - Enable power for an IRQ chip
  * @data:	Pointer to interrupt specific data
@@ -1568,12 +1579,13 @@ int irq_chip_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
  */
 int irq_chip_pm_get(struct irq_data *data)
 {
+	struct device *dev = irq_get_parent_device(data);
 	int retval;
 
-	if (IS_ENABLED(CONFIG_PM) && data->chip->parent_device) {
-		retval = pm_runtime_get_sync(data->chip->parent_device);
+	if (IS_ENABLED(CONFIG_PM) && dev) {
+		retval = pm_runtime_get_sync(dev);
 		if (retval < 0) {
-			pm_runtime_put_noidle(data->chip->parent_device);
+			pm_runtime_put_noidle(dev);
 			return retval;
 		}
 	}
@@ -1591,10 +1603,11 @@ int irq_chip_pm_get(struct irq_data *data)
  */
 int irq_chip_pm_put(struct irq_data *data)
 {
+	struct device *dev = irq_get_parent_device(data);
 	int retval = 0;
 
-	if (IS_ENABLED(CONFIG_PM) && data->chip->parent_device)
-		retval = pm_runtime_put(data->chip->parent_device);
+	if (IS_ENABLED(CONFIG_PM) && dev)
+		retval = pm_runtime_put(dev);
 
 	return (retval < 0) ? retval : 0;
 }
-- 
2.43.0



