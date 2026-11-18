Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057159;
	b=vXHR87+g5ZsjZ07z2kXNGrLK+Ln/H0gFRAgQ586Kz/e1Wv42sdC+Dn9ger4TZMBWDk4n
	 Gp5lwpBJayhCnzE4Lm4A5s8TNIr50kRM2HardA454y0MuaQXwiXRnZcmDOYDGYnlXAydZ
	 6EA3CgycfRS/aq4gRhjqgZauRNf/EzFLBL0eDkcA2sri18BkEWyk21kTIzDkQZqVilDcq
	 QM8APjcyviEOquk5u6kkcjWNCX4SWTfARZ26+1VRillsDnDhS9jeyEfGoh++KX2iFPVbJ
	 EatnpU73ykyUwAzbT7Ldc8Rt2uVeRd7qRsbdFKnXtATUxhgVgB9a5c19dc1eOJJrpbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JGv3LjpWm39FNx4rMlPJ7cuygienhcYWO+3ZhOLXIOU=;
	b=lQUpn+gKDWhJF7WccoexYpaBhXj4is+TEly8gvEscFe25JVmlCH/GolN8VbJx82FWw85
	 EhZKtymzz3wDaWn6lV+3JkoRQbC2mvEsvr8Z2pQn2l3tEeJu0KBmOwfphrDWvbOJi5c2H
	 e/gcHsIK53mRb1/SdeuzcI9sjfpzjHJcn5w/2SRK2fLsJlzlQY3QkxXlS4YPKARMD93Hi
	 YLiccgLERpjTtMS3U7paNAJ7p0icx1OcCOJt1H4k28sBKw+++vGWjZDAOg7KyDshp0Ni1
	 HA7UJ0lsPRyXZdf1O5rkQQZTjwOkWC29BUHHAhnlM/E2NzGKs/qRnudcA5xWuXXbPDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XHSKNyJP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C17606A31C;
	Thu, 19 Nov 2026 02:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XHSKNyJP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141EC1F000C5;
	Thu, 19 Nov 2026 02:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057159;
	bh=JGv3LjpWm39FNx4rMlPJ7cuygienhcYWO+3ZhOLXIOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XHSKNyJPUNui18z7folkyyNJIhg6kI6cIXV4O8PCxvW3UB19rmuGJToxIuGmQAIfh
	 tAKG7lhEOrBu3+yA5vLxfqWOMqHPIAUW+LCaxTNVcqYXGZB9dZ2TbOMVwHwvfgMAYF
	 Wyyo4zeNIwtoECBSvPsTR08NNyFEx3rPCslT5oVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0032/1848] irqdomain: Plug leak in irq_domain_alloc_irqs_locked() error path
Date: Wed, 18 Nov 2026 15:34:30 +0100
Message-ID: <20261118145912.511487393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 13856e22217fbf7c1200633716ff87ccb50fd89a ]

When irq_domain_trim_hierarchy() fails in irq_domain_alloc_irqs_locked(),
the error handling path fails to undo the hierarchy allocations.

Add the missing cleanup.

[ tglx: Massage change log ]

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260623075134.4432-2-shikemeng@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irqdomain.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index b318826c8a415..71fb7d9e1464a 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1514,7 +1514,7 @@ static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
 	for (i = 0; i < nr_irqs; i++) {
 		ret = irq_domain_trim_hierarchy(virq + i);
 		if (ret)
-			goto out_free_irq_data;
+			goto out_free_irqs;
 	}
 
 	for (i = 0; i < nr_irqs; i++)
@@ -1522,6 +1522,8 @@ static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
 
 	return virq;
 
+out_free_irqs:
+	irq_domain_free_irqs_hierarchy(domain, virq, nr_irqs);
 out_free_irq_data:
 	irq_domain_free_irq_data(virq, nr_irqs);
 out_free_desc:
-- 
2.53.0



