Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FF52F90C5;
	Sat, 12 Sep 2026 18:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238740; cv=none; b=OhaJsnufi/Mtf1cyQCLi2Qv7hF5Hb/ZtTUtvBvSpx9B666U/xx+VZ1IjDs0p6oz8Sqv36Vnlc+PXUnuS1OHzbyDNsA8J3zS4A50GLZui/4dItUoFavbP+JE88CeEUiSooom6lt5nmKjTDmLuwFxSVnndw2Bd4okk1dmoWwFcuhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238740; c=relaxed/simple;
	bh=nZto2RmJV1NsxRqFQN6Y0mFy1kF82/OAcmDdDvIvt+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEEqFsOadeRoh/WgF4+C/41We5kXIERTRmPj7Vzn9DD51dzvmFjAPF22xb4Nm57lAT4euNlenHrnzDGjSrWWluu+GX10YO6zvAbMWvnC7SRx3DbFoIki0UQRui92CKYg5hlDERSQ6n+QAkhMB4dAPgzEO9P1Z7SPQXnHyyZreHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9pjjOzo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9pjjOzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B4E1F000FF;
	Sat, 12 Sep 2026 18:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238739;
	bh=mPNiiAmnlK8LOXdkUvOBanwzwkSB5dI3Ij1/BiGqWZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u9pjjOzoCZxrxDNKdml3L0kOM3yHV/TZwuXF7NzPuogSdprDadRNwoWKt0f1Ecj1Z
	 pTjHu6zfO0Q8kjBsZFTdLpJBIBRbTeMFDrTmzIJ3OkouVtLAfjsgLunUDShz7i2ArU
	 lqNQh8fxo5zucNlO3w038sF9AM4+ldKweTG/m6QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Herve Codina <herve.codina@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 522/935] irqdomain: Introduce irq_domain_free()
Date: Sat, 12 Sep 2026 08:59:12 +0200
Message-ID: <20260912065538.796320323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 89b37541ca38954f8ac01c2ca25405b140cfc8eb ]

In preparation of the introduction of the irq domain instantiation,
introduce irq_domain_free() to avoid code duplication on later
modifications.

This new function is an extraction of the current operations performed
to free the irq domain. No functional change intended.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240614173232.1184015-2-herve.codina@bootlin.com
Stable-dep-of: 616dd89d81ad ("irqchip/renesas-irqc: Fix generic interrupt chip leak on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irqdomain.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 4ac1c01346d4e..be9f67647595a 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -229,6 +229,15 @@ static void __irq_domain_publish(struct irq_domain *domain)
 	pr_debug("Added domain %s\n", domain->name);
 }
 
+static void irq_domain_free(struct irq_domain *domain)
+{
+	fwnode_dev_initialized(domain->fwnode, false);
+	fwnode_handle_put(domain->fwnode);
+	if (domain->flags & IRQ_DOMAIN_NAME_ALLOCATED)
+		kfree(domain->name);
+	kfree(domain);
+}
+
 /**
  * __irq_domain_add() - Allocate a new irq_domain data structure
  * @fwnode: firmware node for the interrupt controller
@@ -284,12 +293,7 @@ void irq_domain_remove(struct irq_domain *domain)
 	mutex_unlock(&irq_domain_mutex);
 
 	pr_debug("Removed domain %s\n", domain->name);
-
-	fwnode_dev_initialized(domain->fwnode, false);
-	fwnode_handle_put(domain->fwnode);
-	if (domain->flags & IRQ_DOMAIN_NAME_ALLOCATED)
-		kfree(domain->name);
-	kfree(domain);
+	irq_domain_free(domain);
 }
 EXPORT_SYMBOL_GPL(irq_domain_remove);
 
-- 
2.53.0



