Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063751;
	b=nSGXy7g4qUkI8/U8lwcbP9+zP7a9wwNbXTJB8ZShyAFWyG3Oy4c20cY2eGq8Cg1JNTWF
	 KiZHnqWLk5ciQMQghU3lrZKSoZ9TcbbO7Gt/6X7JaEhYJjMGRnqkPesCwbftd8Ct/Kvbl
	 49Dl/rk2xxZKFNts1suUqOh2dkDb+ZUebODMbvD+Wx5akIdOdHtzM8wDOV45IPB0Jd1RV
	 ISnMwtHhL1VP3auruzl6sTyqaN0dFY2G2cregaKoOBX8Wv+Yj+EWlntHz2Di4M3sHglRU
	 sjG4Rxs7qnWwpPMwCs3x7QxDcbIjt7zD3u+RGLL2oQPYGLi+8rSeatgit2/B3BGnZaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jovPeuQSMDkHZzNlCVqY/RdNtS5RsAiwVea1/HWB8bA=;
	b=PmTNgJgimR3Mg8up41IA5txDgvSWrZoZgqQg9rARKbnZSYGr6N2CWe0/XMC1nimY928E
	 Kpi5d0U+D1DsJ8Bh2xnGN5ddFqSC1dS1NFXId3LLIeVlUwQz9ZBX4q3U/hY13L4GdZk46
	 B1vEucmO59/tj1Rb2v9Bs9bc3vy9CqcijSCEOj4l27yEboSVw2gxj+EavQghERb0U1LOH
	 pHqgh7e6HDJz1ZSy2ENQCAtPnLDepktpfn/gbArjuZ5lQ27r8IiakhBgGtKQiLq6dUiw2
	 JbvkdKhD6sEab9tiIPe3ArbmZbkOhxb/vKVEBkAWKwMWvrK/pP/ngCie7vER5eHUatw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ESBXcWl2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49454606D809;
	Sat,  7 Nov 2026 15:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ESBXcWl2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A8F1F008A1;
	Sat,  7 Nov 2026 15:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063751;
	bh=jovPeuQSMDkHZzNlCVqY/RdNtS5RsAiwVea1/HWB8bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ESBXcWl2EOE43jIE49vU9C+bWxsdStEweRq1RU/sJa2FLm/ZZaFyJm6tuVNLUlkIl
	 IdLNd6GWQUDK0m5mwZvLtdk364HqrML/myuqsIae+SVxbRjGgQwl6atU2cwODVt7DS
	 8ljjLOmx2DYDD8DjgQzxbIlIm3YWMAw8Fyrbv1EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 843/869] irqchip/irq-msi-lib: Free wired MSI descriptors
Date: Sat,  7 Nov 2026 08:58:45 -0500
Message-ID: <20261107134921.428863691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 1c16bc2b1122f78f9d51c5785f7a78b36d44972b ]

msi_device_domain_alloc_wired() allocates a descriptor for each
interrupt, but wired MSI domains do not set MSI_FLAG_FREE_MSI_DESCS.
msi_device_domain_free_wired() releases the IRQ without freeing its
descriptor, eventually exhausting the domain. Failed allocations also
leave descriptors behind.

Set MSI_FLAG_FREE_MSI_DESCS for wired MSI domains so both paths
release the descriptors.

Fixes: 64a855324311 ("irqchip/irq-msi-lib: Prepare for DOMAIN_BUS_WIRED_TO_MSI")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261025122058.2180685-1-thnkslprpt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-msi-lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-msi-lib.c b/drivers/irqchip/irq-msi-lib.c
index d5eefc3d72155..8b8a64f63a717 100644
--- a/drivers/irqchip/irq-msi-lib.c
+++ b/drivers/irqchip/irq-msi-lib.c
@@ -72,6 +72,7 @@ bool msi_lib_init_dev_msi_info(struct device *dev, struct irq_domain *domain,
 		info->flags = MSI_FLAG_ALLOC_SIMPLE_MSI_DESCS | MSI_FLAG_FREE_MSI_DESCS;
 		fallthrough;
 	case DOMAIN_BUS_WIRED_TO_MSI:
+		info->flags |= MSI_FLAG_FREE_MSI_DESCS;
 		/* Remove PCI specific flags */
 		required_flags &= ~MSI_FLAG_PCI_MSI_MASK_PARENT;
 		break;
-- 
2.53.0



