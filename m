Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1377F47B;
	Thu, 13 Jun 2024 12:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280827; cv=none; b=fG3OjIdLsSo2zOXn3N5w1XAfVGLPs46wKeIDNgtxcXrf/GM3kiWsDqXs8twOmjeHflnCStAHRgCZRFrrCu0ZOyxMM0bOTa2gByc6cUOjXBtSeEM9qtKNUpZkes9LtQS0XZQN1XvZwY6vQwg7XprAgE8ttD78ovZc8exWXuZ8BN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280827; c=relaxed/simple;
	bh=iA/09wkj7QNIHs/taVG5tEVjJNy41D26WTSLsCOAHh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ognLw352T2K4moJ2sFDnzYz5/XNNOrj5C2hXYzpaZ9MK7MwkfToefkYjZmJtkDJlXXXn2XQ15KlXIQ0xLfq0xRt66mD3utKG7v5Ai4JSUFHeiaHR92DVw+Ywt3M44/ajK7kJj/yAcE2LgrvblZqByGskO8Dpt0CmTRO7JrDu+ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXnb6d4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXnb6d4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9DEC2BBFC;
	Thu, 13 Jun 2024 12:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280827;
	bh=iA/09wkj7QNIHs/taVG5tEVjJNy41D26WTSLsCOAHh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXnb6d4NPbbcyLPQytBpLMouTuZNWj267IY7K+0Abx7Nx+WFO0K4L4kbVBkaTJFB5
	 lVoDp3D8gQSOAzLwnJd9DgRau9U5oFL00y/2IN8Bk7yPpagucV1yluOnQYZKwKdH2T
	 xDAPM3RouG9MCpf+rPkatCjg/xpTbn1r8IRzLT2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/317] irqchip/loongson-pch-msi: Fix off-by-one on allocation error path
Date: Thu, 13 Jun 2024 13:31:06 +0200
Message-ID: <20240613113249.408181769@linuxfoundation.org>
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



