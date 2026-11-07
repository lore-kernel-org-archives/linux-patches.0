Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060575;
	b=1wHjsa5yoQO/2Ja5GcWBGBNzn8BGMp32iy4RHe3eezzDH24bT5d/p8emdGR8I3Is4fx9
	 yJH5JO4cqFlV1TqBEWNP5OMyd0QgHa9nXGD8NgUDuN5VaJOqiyWdUTQcpTmnQ7wecdSSq
	 KH7JteDFdVR+aNClaeR4Peqv4eZjpObCcML1W8dPPOc1wInXNRPXkR9KKu2xJi7PpTmLf
	 InI/wg/BQH1GtP9KAZU2CBq7CRSVv6vIc8ub+TBfFTRUIBCLXHmxVgz9lAOk3F6habsni
	 /YSxrRnLB0XdEl9tlrIqtNo18Ba8GdvaHpZSIP250+8REOEDHuuAKZaw6JF8N84lUpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q6shfnPZwDviWyKPqbgAEJ+hVvEZR95CKmX4kiwosAE=;
	b=2ArdXQ601OZxT0sfDFSb4qk6kpct2FHTLvQTTcGOmuhhD37RbwimpSosMAnd4TXg7JFC
	 ERhzkFOkGQBVKXi8ipA5dMYNirLs6R24S/yVw1ZDozT2x5dYcsfy1wsUqfIBaE80+1qU4
	 rCW692mTrmo/dNIAX4Qt60vSEaarkbLV2/IPlMHlAumLRRq4W56uEAJDBDzhd6YqWR/hl
	 +tKhKqV3j6BNUa5URiM+tfG1luXNeuq3SUWjDE2qI5LB772dF+KhrbOFJyA6N5szgGOrh
	 ydmMayY3BoCfLFK2VOsMy6hf6P8+bwt27IOic0nNdomugmZ3SKpMop1BYbajrAW8bSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LCODALdX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEBE606A32C;
	Sat,  7 Nov 2026 14:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LCODALdX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364511F0089F;
	Sat,  7 Nov 2026 14:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060574;
	bh=Q6shfnPZwDviWyKPqbgAEJ+hVvEZR95CKmX4kiwosAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LCODALdXeOK55u6q2DbqBGjYoNe++ytBDgB2IO4LMll3N1UFhZkAXDsdlA8fXIWU3
	 5p47em3CvFbS5bbP53U5OAl+7tDz2ZAC09M6IGo3Oa75k2lghNiwLf1wRdjeW6mihl
	 wGn3hxMPvYXfyzV3uWMAMT5mbVqxYoeepV/9oaLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0034/1536] irqdomain: Plug leak in irq_domain_alloc_irqs_locked() error path
Date: Sat,  7 Nov 2026 08:34:10 -0500
Message-ID: <20261107134958.623671980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e0bff21f30e0a..675b7a356e595 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1632,7 +1632,7 @@ static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
 	for (i = 0; i < nr_irqs; i++) {
 		ret = irq_domain_trim_hierarchy(virq + i);
 		if (ret)
-			goto out_free_irq_data;
+			goto out_free_irqs;
 	}
 
 	for (i = 0; i < nr_irqs; i++)
@@ -1640,6 +1640,8 @@ static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
 
 	return virq;
 
+out_free_irqs:
+	irq_domain_free_irqs_hierarchy(domain, virq, nr_irqs);
 out_free_irq_data:
 	irq_domain_free_irq_data(virq, nr_irqs);
 out_free_desc:
-- 
2.53.0



