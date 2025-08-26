Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF62C221264;
	Tue, 26 Aug 2025 12:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213179; cv=none; b=sfG5/COL1vEVR1B9pbBU/GlC6XpEiIoxtRTeSoH8WlKEM2BCQex3+7XnSCjnu5XR/o+rTQFdE6RyNWLT6e2ONJrJC4A7ExTK6OMVecf/wKXCx4OXN/Hyo3sac9tUpBGVjam2dDHO1YZ+Am1b9oCAI4j33yPZ7mfix4dwgg97Vvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213179; c=relaxed/simple;
	bh=R3RaTPBCyigUhaC+9Qsj1nqNZNJWSeB7FDj4oMsfoOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IetSVPor1k3uUFSA5LRCn6HbQmFILSDBwiAJJTqTDvzKHAWcziAcpV1wSj4z2a3iIhKZX3bOsPZ4ahIsLvJcf7+C4wwQR6hr9r5N15FmdIyqiKnRZh8IHGPDDoL4Kjqnxzt0v2baEzKk5494ifQyHa8jXrJwJLs6AtWukoGfKBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4L3P6BP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4L3P6BP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0ABC4CEF4;
	Tue, 26 Aug 2025 12:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213179;
	bh=R3RaTPBCyigUhaC+9Qsj1nqNZNJWSeB7FDj4oMsfoOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4L3P6BP8wis58bEgc8aBX94QLIjyA91oopCWf26YNZxYYPbZPNsY9d93xu67ilwp
	 MHOCwDLmzeMqFBrvM6sFofoAMf+nKl2wRpwiJrOjE/R10svUgoFZXKpmvItayZJ7aY
	 OW3blCs8FnFWtQarTmiaDfQHV0pnNCSsF8AFkjuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheick Traore <cheick.traore@foss.st.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 250/587] pinctrl: stm32: Manage irq affinity settings
Date: Tue, 26 Aug 2025 13:06:39 +0200
Message-ID: <20250826110959.292492854@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheick Traore <cheick.traore@foss.st.com>

[ Upstream commit 4c5cc2f65386e22166ce006efe515c667aa075e4 ]

Trying to set the affinity of the interrupts associated to stm32
pinctrl results in a write error.

Fill struct irq_chip::irq_set_affinity to use the default helper
function.

Signed-off-by: Cheick Traore <cheick.traore@foss.st.com>
Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Link: https://lore.kernel.org/20250610143042.295376-3-antonio.borneo@foss.st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 84121b125d90..67c2791ee246 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -418,6 +418,7 @@ static struct irq_chip stm32_gpio_irq_chip = {
 	.irq_set_wake	= irq_chip_set_wake_parent,
 	.irq_request_resources = stm32_gpio_irq_request_resources,
 	.irq_release_resources = stm32_gpio_irq_release_resources,
+	.irq_set_affinity = IS_ENABLED(CONFIG_SMP) ? irq_chip_set_affinity_parent : NULL,
 };
 
 static int stm32_gpio_domain_translate(struct irq_domain *d,
-- 
2.39.5



