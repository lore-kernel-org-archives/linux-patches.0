Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7596B379EE8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301688; cv=none; b=kLObJhm853CvsA4Ot/PvVVx+69t/8bv/AY9rDr05us818vIJqEj7QHi+X2rP4ko5FVCnFozppQDUs+9G2RmigwK7zMvMQjHv4HfVFw2Lrhp9736/vIedRYwvbYCPYRp1tZzV0a4kxvX9oSn7wzO98oVTC7Gv8g/EEruOJ/tBKok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301688; c=relaxed/simple;
	bh=IGjNApjh96lY4ZSrrL3F6rbpgFJLEjJ8pRk8uYa890s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fyeY7teXHhahvDlHGpenrCGTvz9xqyuU/bviUBnas1bKWYlsvS0VmlBufFee1cBhALG25Z/n3D290/lTYX5sEeFjctFuszXamT8++YJyHD6UmyecCgwV8RbF19SZ8NIhpJDr1/Cy6DJb6Y9FfGIQcR0AB84h4ic/QO2cV3Efq2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DsHc20J9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DsHc20J9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E74C116D0;
	Sat, 28 Feb 2026 18:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301688;
	bh=IGjNApjh96lY4ZSrrL3F6rbpgFJLEjJ8pRk8uYa890s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DsHc20J9K0rSQeuv5khwuTDpc20YhnoG+zyqefAoP+CzlBhFqe5oBy3yo3N8AbpO8
	 0QsBk4837LhsOJz2ba3EQwxdSYg8GKFNqXhEDuWWVpNGeK4AZvfpb6r/zMWW7VHcJZ
	 rJKuJZqlBe6XjRMKzOOWHfU9IbEJUDsmWQ22XwgxcKE6J2f5bGk7WXhrRPoacVxa4j
	 uDn7SfsjAxZMQTs+iN6xbaN4DHx7TbVqGb6t6YucSfx6/pvVjGH+dmTlPAYh4NlOZP
	 1Y3yJFUF285uYDRvzgP7kek5SpREPcnFIx1YuqBHkyfu5z4BT+vRGnV2aJzAs8HEOl
	 7r/QJTCHkEKrA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/385] platform/x86: int0002: Remove IRQF_ONESHOT from request_irq()
Date: Sat, 28 Feb 2026 12:55:00 -0500
Message-ID: <20260228180011.1568201-78-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit f6bc712877f24dc89bdfd7bdbf1a32f3b9960b34 ]

Passing IRQF_ONESHOT ensures that the interrupt source is masked until the
secondary (threaded) handler is done. If only a primary handler is used
then the flag makes no sense because the interrupt cannot fire (again)
while its handler is running.

The flag also prevents force-threading of the primary handler and the
irq-core will warn about this.

The flag was added to match the flag on the shared handler which uses a
threaded handler and therefore IRQF_ONESHOT. This is no longer needed
because devm_request_irq() now passes IRQF_COND_ONESHOT for this case.

Revert adding IRQF_ONESHOT to irqflags.

Fixes: 8f812373d1958 ("platform/x86: intel: int0002_vgpio: Pass IRQF_ONESHOT to request_irq()")
Reported-by: Borah, Chaitanya Kumar <chaitanya.kumar.borah@intel.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Acked-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260128095540.863589-3-bigeasy@linutronix.de
Closes: https://lore.kernel.org/all/555f1c56-0f74-41bf-8bd2-6217e0aab0c6@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int0002_vgpio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/int0002_vgpio.c b/drivers/platform/x86/intel/int0002_vgpio.c
index 0171be8867fce..c5c70319b0f37 100644
--- a/drivers/platform/x86/intel/int0002_vgpio.c
+++ b/drivers/platform/x86/intel/int0002_vgpio.c
@@ -195,8 +195,8 @@ static int int0002_probe(struct platform_device *pdev)
 	 * FIXME: augment this if we managed to pull handling of shared
 	 * IRQs into gpiolib.
 	 */
-	ret = devm_request_irq(dev, irq, int0002_irq,
-			       IRQF_ONESHOT | IRQF_SHARED, "INT0002", chip);
+	ret = devm_request_irq(dev, irq, int0002_irq, IRQF_SHARED, "INT0002",
+			       chip);
 	if (ret) {
 		dev_err(dev, "Error requesting IRQ %d: %d\n", irq, ret);
 		return ret;
-- 
2.51.0

