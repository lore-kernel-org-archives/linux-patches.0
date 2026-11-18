Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050937;
	b=qPSOctPQz/ynyEIijRcVnf9n9Bm6YjhroycF9BF5EwsRtxfmdLifbVYQakkR2pylyUAv
	 JXgEBu1EFGTrzrtLhb2lYUFhXrRFbaqbqyYLY3rTJUPQvZsgyai5r8fRxmrroZQwpO9nx
	 jWet9TqrGouRCebzO4qc1GRmxOirsOp14iuU1XNQ9jTblDO9+jt2OHpFmzCy1P97DDc6X
	 AmTGWJ6NY5lafEKlo3X7jxbvDkymdrFwaqr/c+Jv/YfHaRpENL13M5PXqcrq8RRqAB5yU
	 1MtWn5gmSCFPUp4syKaVU+dQYXCp8N8UBBNHMlJesEAXhn6mEyG84SuUk3K6yoxYiRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3SBHR+beu/DXIPCFQItsiwLQyXplFp2Ge5yNk9H5jOY=;
	b=N0fH8y0W+p+2Jokw8tZqkkGvrL8O5yIqORV+9BddCdhzr/DhmsYCRxAq40vMHihgCnfE
	 y4/0ikBUun5+X+mND2rJCErcoSok1ls9y9iGPnXkPKUAYUI5Lm68pk2dOvehqWHkigBjo
	 9GXlCtWVu55a0RvByMF4dQgvOK9cQIGfplIZVjOU5I0/Z1j0LmxVPs7o1VqFm6PnQT/ZF
	 r425NGt/M1Pkr0i7eFuwuafvE3ix6d0CuBLkLI/A1fh1n8xXGgxEQJ7LsWiV5PUaCSNs0
	 hDod9qj5txeiwr+iuDR3P49g79dTCRc75PgfdxO+jyl9H3k9d7RqWr0gHWy61BkaUCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ahi35Iyw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EC4606A320;
	Thu, 19 Nov 2026 01:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ahi35Iyw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5511F000C4;
	Thu, 19 Nov 2026 01:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050937;
	bh=3SBHR+beu/DXIPCFQItsiwLQyXplFp2Ge5yNk9H5jOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ahi35Iyw6v5/XRhc9Dr3NUlZVvHiBywOsvh1MrcygLxGgAkKzohxLCldbVn7/4iTo
	 A4WkAJ3pcqEB4U/WBeW+M6HIpN02xwziSE6qkKIWfkW2uNi4mKcBsLHh3joLzs3/2X
	 IfZiZBTfZz1u/sN8UPPYrBsraKmq/WolQkHp7NTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0031/2214] irqdomain: Plug leak in irq_domain_alloc_irqs_locked() error path
Date: Wed, 18 Nov 2026 15:28:27 +0100
Message-ID: <20261118150011.341926999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c6152a6942e6e..90e2ec3da82ca 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1544,7 +1544,7 @@ static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
 	for (i = 0; i < nr_irqs; i++) {
 		ret = irq_domain_trim_hierarchy(virq + i);
 		if (ret)
-			goto out_free_irq_data;
+			goto out_free_irqs;
 	}
 
 	for (i = 0; i < nr_irqs; i++)
@@ -1552,6 +1552,8 @@ static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
 
 	return virq;
 
+out_free_irqs:
+	irq_domain_free_irqs_hierarchy(domain, virq, nr_irqs);
 out_free_irq_data:
 	irq_domain_free_irq_data(virq, nr_irqs);
 out_free_desc:
-- 
2.53.0



