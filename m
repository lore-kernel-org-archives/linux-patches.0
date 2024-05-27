Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA994262BE;
	Mon, 27 May 2024 19:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837947; cv=none; b=fIndQRqEYYOM/okDSH2Va1oBkCf/hQEw1ViVex/l+dJDXmSXIlSxEn4J50FFi/LOyjZGu9W8irGEwgUl/DOF+rV4o6/HtffcvuJjIfyd/3j3QL0h7AVGhikTNLOM2T7D9nzyob4ImUFaTCmCG8q0Wr+QAhOJM4ic8izwrXX+EV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837947; c=relaxed/simple;
	bh=4zR8np2Q9Mhu5ft9sXIvTmbb1mS7v7aCxLySk9NZahk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHVSvnWOWzYpA2ew7dTtsyJcjqBsHKM0PQ6ONHIBykRrK972sFKJphYlgPfpxWtVNcOwhonx7OJI1i0r3plTkK80LRvCOfnzUwGiaiKbXPIrFMEcp1R/hz53uQJwXcbmshsE/6IBtyDD7+gHfdKy1SsxpUCcHkviOCakcYHJCL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHcSHG/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHcSHG/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D486C2BBFC;
	Mon, 27 May 2024 19:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837947;
	bh=4zR8np2Q9Mhu5ft9sXIvTmbb1mS7v7aCxLySk9NZahk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHcSHG/aj/zbzdLqK+ROj1DRSQBVqMv4nUOpcUQZ0b5Bp5Dri+QEIvJ9G5smibwHX
	 kg321Ye4zNiVu9FUMErBi1XdwkLQxus6CAboyiZNhzsvjTBDm/33mWsr39fbuAgjEG
	 gmTlrS8UJi3PWW37fg3tlg6GVXiNFPfzm6jHUTxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 206/493] irqchip/alpine-msi: Fix off-by-one in allocation error path
Date: Mon, 27 May 2024 20:53:28 +0200
Message-ID: <20240527185637.064571739@linuxfoundation.org>
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
index 9c8b1349ee17b..a1430ab60a8a3 100644
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



