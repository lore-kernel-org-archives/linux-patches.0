Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D68D15FCFC;
	Mon, 27 May 2024 19:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837950; cv=none; b=cQBWhAYUQZDe8oEGmlOsMfPa2d74nLosoxrvfLidZCbIFo9Gbf6AruqwhORVDn3xg3NohLxyFM0tcvT0ZI0Y0yZgecc/XKwvBAl1r+TS1Yu/ghxod2tnSSxV1U66AZPEUTORLOjrP/IER0JaeRKGNM6LH0EVak5Tsvx5zvsPnuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837950; c=relaxed/simple;
	bh=BaXdPoMf0Ya07gL8BRhyeF6IEbHVpjLTylMzmh+gS/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFbURoff0U/Ec1iRK/exhC0IjgIfTPVynRQAsuI+QYU3iLGGPTWxJCDTFXsZ+oblKPk4xIk87ysTJAGKVNwlMvQGNMXy+8RA4x0kM/rk/RhTcrcXdQCTAEHziM7gf0Is7MhmhFUeVVHzX35EAbQy7hcDKplw+ppYks/teoT5yqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITWmlbuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITWmlbuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56BBC2BBFC;
	Mon, 27 May 2024 19:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837950;
	bh=BaXdPoMf0Ya07gL8BRhyeF6IEbHVpjLTylMzmh+gS/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITWmlbuQBfFDbzsFqsth73xo8bJu9RD2wCagZtTFWrSlICBHbK521TY0AQLOm0TN+
	 fi/S8zJ1gOX1V/Ehau79evXzdXTQ97ZGkPybYfz3+GaB19B2Y66MPoJWu4Ou1jfsdx
	 sfvWtngzyrWCCqu37Bl9KVWYpqqSvt4vEktiTy68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 207/493] irqchip/loongson-pch-msi: Fix off-by-one on allocation error path
Date: Mon, 27 May 2024 20:53:29 +0200
Message-ID: <20240527185637.094818369@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



