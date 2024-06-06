Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB0B197A6A;
	Thu,  6 Jun 2024 14:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683219; cv=none; b=NW9FlZrmHPGPWBeAgz/Zq3yohWoEKao4RLkutD4RdYgKFXwJtXp7SHbxHMTiEQGtYd67cgoS5WPAWfazJlPYu7apdyuWKyJffiqtl2wK0jB319rDfOlXl4vQC2sqJ8YFmxpdwTTx1nPXEGeLgMDXXJQawOF+pncFIyvFfgRKSvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683219; c=relaxed/simple;
	bh=9qXlEI2zZS+Fkk1jKIwLuSqMA57TIYPwYF5b0dz9XA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIjYLPfysyEiNOdP/rkq0RlRZBLIPs0577M/rJs+H42KNE9U+dm2RmreUHWahYIbIw8hLXcEWRkW5donFXs2sgIqdBnEWdeRTEd4hvMZF4cXvMyVPdBB4zm65fZ/zEuqibMnW2eN7hl172LgOCyxQ2dut9vsAzSDkRI8/SHoqiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHiLvDLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHiLvDLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14972C32781;
	Thu,  6 Jun 2024 14:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683219;
	bh=9qXlEI2zZS+Fkk1jKIwLuSqMA57TIYPwYF5b0dz9XA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHiLvDLi3tjAcDGDWkek4kBYeorZnObabBBYVYCK5G/DoxX8+GSUTuZbLzW9fMVzM
	 38f5zudDkJpVZQTSIg5P/28Ql+ebDRn8Riftjua699HFOMqssyHYAC4DLesqkaXNwq
	 rjLIlKircaBMiUQhDWzBif+5M8tagIVcX1a+ClLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/744] irqchip/loongson-pch-msi: Fix off-by-one on allocation error path
Date: Thu,  6 Jun 2024 15:57:13 +0200
Message-ID: <20240606131737.588493981@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit b327708798809328f21da8dc14cc8883d1e8a4b3 ]

When pch_msi_parent_domain_alloc() returns an error, there is an off-by-one
in the number of interrupts to be freed.

Fix it by passing the number of successfully allocated interrupts, instead of the
relative index of the last allocated one.

Fixes: 632dcc2c75ef ("irqchip: Add Loongson PCH MSI controller")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Link: https://lore.kernel.org/r/20240327142334.1098-1-yuzenghui@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongson-pch-msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-loongson-pch-msi.c b/drivers/irqchip/irq-loongson-pch-msi.c
index 6e1e1f011bb29..dd4d699170f4e 100644
--- a/drivers/irqchip/irq-loongson-pch-msi.c
+++ b/drivers/irqchip/irq-loongson-pch-msi.c
@@ -136,7 +136,7 @@ static int pch_msi_middle_domain_alloc(struct irq_domain *domain,
 
 err_hwirq:
 	pch_msi_free_hwirq(priv, hwirq, nr_irqs);
-	irq_domain_free_irqs_parent(domain, virq, i - 1);
+	irq_domain_free_irqs_parent(domain, virq, i);
 
 	return err;
 }
-- 
2.43.0



