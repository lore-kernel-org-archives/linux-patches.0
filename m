Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B10153814;
	Mon,  6 Jan 2025 15:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177924; cv=none; b=iZtfY3mtHE4xeZtgl1op9GUJ4N1WUhZw1VOpdTcEXyo/Ps8T1o0lDyz4WHoYif+lnc4NekEsMd7lcuq/qo4o7cEdsBtz59Y6LPu/r6KXXZI3DmRdPAsC22wHyncBHpNnW6uYOtavXo0DquIxJgQXy96mD3VpLz666Iu/gMliyfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177924; c=relaxed/simple;
	bh=Bt6m1Db+fogdQkwVdFQRtPtAOHwj/1FYSMd+1ppkx1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbxGzDt/zF+JAwPrSuveSez7peErVLTWEHocScWHb+zm3kUJcEaxTc4JjlQOGwT+eB0Hxn2kGXqtVf/flAa2XnNR+li0uoS6ldDbHJ5K25+lPaH0/BU9k7JGsBXbSZhhAZmpZxNP2Ua+A7BrNfweEh3tfFxc/236FT2xkg7Putg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4KBdoM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4KBdoM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9A0C4CED2;
	Mon,  6 Jan 2025 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177924;
	bh=Bt6m1Db+fogdQkwVdFQRtPtAOHwj/1FYSMd+1ppkx1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4KBdoM/pHlWoGrHsTcl++tddWvl3rVyAZVA+hCxqrZDaAqLNNb0VjiedpoGYTGTn
	 NckquhZt+XP7YlQzZYmxxd3rQ5AFc53pRoUhelG4uitmUl9A3fvgkfwDYybbzmO4if
	 ckflISP9LNtlrBVsBEQ1eH6Ktol7hZbJd++XymNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/156] irqchip/gic: Correct declaration of *percpu_base pointer in union gic_base
Date: Mon,  6 Jan 2025 16:16:28 +0100
Message-ID: <20250106151145.569639524@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit a1855f1b7c33642c9f7a01991fb763342a312e9b ]

percpu_base is used in various percpu functions that expect variable in
__percpu address space. Correct the declaration of percpu_base to

void __iomem * __percpu *percpu_base;

to declare the variable as __percpu pointer.

The patch fixes several sparse warnings:

irq-gic.c:1172:44: warning: incorrect type in assignment (different address spaces)
irq-gic.c:1172:44:    expected void [noderef] __percpu *[noderef] __iomem *percpu_base
irq-gic.c:1172:44:    got void [noderef] __iomem *[noderef] __percpu *
...
irq-gic.c:1231:43: warning: incorrect type in argument 1 (different address spaces)
irq-gic.c:1231:43:    expected void [noderef] __percpu *__pdata
irq-gic.c:1231:43:    got void [noderef] __percpu *[noderef] __iomem *percpu_base

There were no changes in the resulting object files.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/all/20241213145809.2918-2-ubizjak@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 3be7bd8cd8cd..32abc2916b40 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -64,7 +64,7 @@ static void gic_check_cpu_features(void)
 
 union gic_base {
 	void __iomem *common_base;
-	void __percpu * __iomem *percpu_base;
+	void __iomem * __percpu *percpu_base;
 };
 
 struct gic_chip_data {
-- 
2.39.5



