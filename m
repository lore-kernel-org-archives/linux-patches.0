Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76F5195;
	Thu, 13 Jun 2024 12:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281821; cv=none; b=CXfY7hOfCL4+liZhfwoNpkanbx/YyAnEJ0bH2sF2VRZo43zsRqpOXolDvMKaO9q1+GX4P3mHPXPII8MzUKAsAMOI4h1Ox3Vogf/PwVDE9MCB/0DGI/iTA8CagXxhcf4L4AxmvgWf2kO6GYV0ZBFj1KDPjxQ/29x1MyCu2BcUNhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281821; c=relaxed/simple;
	bh=kFse8ijlhYJ+ODW4/c9WRy9jw0wAGeuJZeZYyallQSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C33hjswYuIPVd0S5CLTM6P2x4cEcTUgcGlv4Fz4Q1vAKGL6bEUT8lPRu8ak5bjmkWGq3bgjtypY+uP6hkpFD1vEGTRqmDetO2IAGiBKT7mU36rRGU+icihTnvJeqrt3aGPkAqB936mUJdXBaeXANuGKnSEG4No49DjCwxL1Gau0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOpCOvBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOpCOvBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E786C2BBFC;
	Thu, 13 Jun 2024 12:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281821;
	bh=kFse8ijlhYJ+ODW4/c9WRy9jw0wAGeuJZeZYyallQSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOpCOvBv7/H7dX2gmpqQpzah8dqNt9tpJXcRI8XjRY2UHNUrlz0KJ9HvXnMb7QBIp
	 Wfiui1o4adCnq4GBk/x3ZvwAp3vhPB4OTaHAwQnx6k4dZLStwYXTEWPvqpXN2mD+YD
	 Rf6lXQ4HNXa0vUF/twej5KTonvq39EvFUBItozf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/402] irqchip/loongson-pch-msi: Fix off-by-one on allocation error path
Date: Thu, 13 Jun 2024 13:30:24 +0200
Message-ID: <20240613113304.749519852@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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
index 32562b7e681b5..254a58fbb844a 100644
--- a/drivers/irqchip/irq-loongson-pch-msi.c
+++ b/drivers/irqchip/irq-loongson-pch-msi.c
@@ -132,7 +132,7 @@ static int pch_msi_middle_domain_alloc(struct irq_domain *domain,
 
 err_hwirq:
 	pch_msi_free_hwirq(priv, hwirq, nr_irqs);
-	irq_domain_free_irqs_parent(domain, virq, i - 1);
+	irq_domain_free_irqs_parent(domain, virq, i);
 
 	return err;
 }
-- 
2.43.0



