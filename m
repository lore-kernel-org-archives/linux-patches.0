Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4F635A2B2;
	Tue, 26 Aug 2025 14:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219086; cv=none; b=MT0Ot5sZnoN5ifjLVQxu4dqyewOUaMRPqI4Dptm43EOdjBBVOM1YtlCM+sf5NtqfsxbZZTiLhSc06zkkWYpiYr02RkmK44rOB4fq9j7SLq0FDnnA3Eied6yUPOQffFOkTmyqjJHyBEdfI98y4KJHVtHX36ZSrkQYIM1UqJwRLDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219086; c=relaxed/simple;
	bh=Ub+W8vgQctU/F9Tfi1eeIEJR2BwF/MtEFOZvVIO1qwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7u7XK7F5JkTQB/J5Mtgv0Q4jr4zq6A1TYATy26oomcyuvNyHPpiEyEa/nzwN/QndxsemcMJxbll7m2Q1t9sue6M2uU4fgdT1VPoRNlbtcMBqTNV2Quwhe0ixiiUUWa5tvoAJQmgGQdXCAZ/28i1vXqNd064wbqdGOHmw2jnjdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrgxAMue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrgxAMue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1E4C113CF;
	Tue, 26 Aug 2025 14:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219086;
	bh=Ub+W8vgQctU/F9Tfi1eeIEJR2BwF/MtEFOZvVIO1qwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrgxAMue30J/tVMR2WbjhxWpNrF0/jjsWr9QSvI0iuejbMvYXTihkefmgyZV10Abc
	 xsOTJzIVzvWXblIgUXU6nk1p1OcQrI1n2lHbqrwsm0FeOOvIoG9ykzl/WphOQWio0/
	 YZr/0KLAz2E1Klajt95bASYUjR1KSTOcu8vHu9sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheick Traore <cheick.traore@foss.st.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 246/403] pinctrl: stm32: Manage irq affinity settings
Date: Tue, 26 Aug 2025 13:09:32 +0200
Message-ID: <20250826110913.621034668@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 10595b43360b..2a9c2d94eb55 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -340,6 +340,7 @@ static struct irq_chip stm32_gpio_irq_chip = {
 	.irq_set_wake	= irq_chip_set_wake_parent,
 	.irq_request_resources = stm32_gpio_irq_request_resources,
 	.irq_release_resources = stm32_gpio_irq_release_resources,
+	.irq_set_affinity = IS_ENABLED(CONFIG_SMP) ? irq_chip_set_affinity_parent : NULL,
 };
 
 static int stm32_gpio_domain_translate(struct irq_domain *d,
-- 
2.39.5



