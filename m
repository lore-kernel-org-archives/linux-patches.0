Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033343;
	b=pAzDmgBNrHwwUV4oiyR2toHqBZvTbZtuf8lTN/TLUOGp+xuRipnpGF25HfbQAm94XYed
	 yoCFRxZJZ58xBjdBPCOy2Y1kSv6BP62pREgtYeJFxXz+DJd73a2Tuf4LqOfhtxbsfRd3S
	 bxOrABJ5b+8Qmq4/A1RW1leEBOuL8pq27WKxz8hLaQmwSZkVkMWekpCw0q6OPDfCR35Z8
	 f5AtkVurccaFZVoMJ9DMf8TQyHgphyEj3chdNMDqkqGo7KBrigqdi61JWrfwu0SxwtYvJ
	 i6HRQA2sEwGJr3/bDIHv/T80ljJozOv35eGSYE3ItMryPfTuf150IhYenJpDADaZO+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gK8mCK2/PoMTRIXaaTuVz5SmcobmGj1a74APGoHrVyM=;
	b=oQHLq7D+IQzHoF3ZDTmdOYVuYXCw6OsAaBOzdYHZJgc6G4+OPL3ER8O2Eea+8LyN502F
	 raUApYjf/NwuCeWQuC7/GoTP7i7ruSjnVjhZVAmRbMUk0UbgOsVV1dAsymBNs+Lt9Vt5X
	 EEexzH1homVJ7NPFa+SHGFELEXM1gCc5Ofs/ke8+Vz+id58Ng+GyBrUj7eBVVMBnUYZvM
	 zniFTh8r6YxcjqiJXonkIrSFfogWKXVxdYlj7Fshp7JC+5fvBqxSvwOfmd01QIVU8fWoe
	 O+QiQvTf7Bttz2v3f9DHMSsv6Tn4T/+VL1tuZimdceO4uZhVsacohDmi5yntyle4v6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2wZtxD4n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC2D606A320;
	Wed, 18 Nov 2026 20:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2wZtxD4n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DAF1F000C4;
	Wed, 18 Nov 2026 20:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033343;
	bh=gK8mCK2/PoMTRIXaaTuVz5SmcobmGj1a74APGoHrVyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2wZtxD4ncTVpxzHjSaRiQ7fLtH7Co9FdtRGbExOpzQERHdzLw2g1+nRO1qDhPKaU6
	 FU8hDiyn17enJJ5NtF6i8VTHnfOLhyXolyobHPurSBZs1T2LtYtoUKlkEYgoapCdrw
	 spDZn6V+5AG8VpQwthB9/X5NvZJOp1SqKM0oMTPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Steven Price <steven.price@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 1733/1756] irqchip/gic-v3-its: Fix over allocation in itt_alloc_pool()
Date: Wed, 18 Nov 2026 16:04:20 +0100
Message-ID: <20261118150118.558008322@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Steven Price <steven.price@arm.com>

commit bc88d44bd7e45b992cf8c2c2ffbc7bb3e24db4a7 upstream.

itt_alloc_pool() calls its_alloc_pages_node() to allocate an individual
page to add to the pool (for allocations <PAGE_SIZE). However the final
argument of its_alloc_pages_node() is the page order not the number of
pages. Currently it allocates two pages and leaks the second page.
Fix it by passing 0 instead (1 << 0 = 1 page).

Fixes: b08e2f42e86b ("irqchip/gic-v3-its: Share ITS tables with a non-trusted hypervisor")
Reported-by: Shanker Donthineni <sdonthineni@nvidia.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/1f6e19c4-1fb9-43ab-a8a2-a465c9cff84b@arm.com
Closes: https://lore.kernel.org/r/ed65312a-245c-4fa5-91ad-5d620cab7c6b%40nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -265,7 +265,7 @@ static void *itt_alloc_pool(int node, in
 		if (addr)
 			break;
 
-		page = its_alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 1);
+		page = its_alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
 		if (!page)
 			break;
 


