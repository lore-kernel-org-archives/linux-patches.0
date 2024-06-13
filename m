Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB8D7F47B;
	Thu, 13 Jun 2024 12:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280824; cv=none; b=skDSNsoBbjzSDzUdqBpGOIv8zvOieuXsOuhb0hW9fG6c7sMXreVUc6XL6V6j745CCczHZyV3GK5sNgRLrQP8Qt7M4FryRt8fEPnrIDbE2CSj9YcFs6gYhIv+FNamhXWq1qlXG3KLYL7vzMLlySYVqgZ38HlNWHC5An49ZgTcd2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280824; c=relaxed/simple;
	bh=emOz1hz3LAUqpgE5i19HNV4tnKWc6MsKn5ChzzsNabE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYBi9mU9UqPvGs8nk0qnGWMHjyayUmCrtyCIb6WtbeUsqywMSUgZWDaaDih+p0zqa6yPOPJhWpFqmUlbG8KNJzBmcK6GGXo67W4RAP3KDU/rZW8j5S6FcOYixy2MSJ9hKTSPIdhprYrdQ0u17g53ohIAsL13drRxOjmSLc+Joac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpNdRPtQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpNdRPtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F21C2BBFC;
	Thu, 13 Jun 2024 12:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280824;
	bh=emOz1hz3LAUqpgE5i19HNV4tnKWc6MsKn5ChzzsNabE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpNdRPtQVAS2oqJV9pFS8U+Eq7r7igb5RjxdTavSF+Ih5wztDQxudmsjjlsIHDBNY
	 fdl5E6pAzvH8bL0xCVwRBWriSQrvbRE8kpcxzHGUOqzeuWYYLmo0nUpRJynD6QjrPJ
	 Ntkon8QneoCs34Tn2iKG7VkvSo94x6tszHoB9c0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/317] irqchip/alpine-msi: Fix off-by-one in allocation error path
Date: Thu, 13 Jun 2024 13:31:05 +0200
Message-ID: <20240613113249.370289067@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit ff3669a71afa06208de58d6bea1cc49d5e3fcbd1 ]

When alpine_msix_gic_domain_alloc() fails, there is an off-by-one in the
number of interrupts to be freed.

Fix it by passing the number of successfully allocated interrupts, instead
of the relative index of the last allocated one.

Fixes: 3841245e8498 ("irqchip/alpine-msi: Fix freeing of interrupts on allocation error path")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240327142305.1048-1-yuzenghui@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-alpine-msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-alpine-msi.c b/drivers/irqchip/irq-alpine-msi.c
index 1819bb1d27230..aedbc4befcdf0 100644
--- a/drivers/irqchip/irq-alpine-msi.c
+++ b/drivers/irqchip/irq-alpine-msi.c
@@ -165,7 +165,7 @@ static int alpine_msix_middle_domain_alloc(struct irq_domain *domain,
 	return 0;
 
 err_sgi:
-	irq_domain_free_irqs_parent(domain, virq, i - 1);
+	irq_domain_free_irqs_parent(domain, virq, i);
 	alpine_msix_free_sgi(priv, sgi, nr_irqs);
 	return err;
 }
-- 
2.43.0



