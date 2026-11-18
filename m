Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042808;
	b=eqtzg63wGrp5TwudJndqjEQ/3TkCbKXb/7xNkmekXjx3pt/oAT2/0OES6NOia909Rtoi
	 56p5gZZlIs7wFsKy2X0xF1FAFX9ZLJJnwxzxp/fp9B+sEQC8AAGFIHQlc6s7V2ONM07ND
	 TOt0aYkSN1Xve7x49nUEsEQbAA4u20NN6i+qMv70XpQp7Ep2f7wGyV9ms3q1j0hTc4YCo
	 rP3M7XSkg4gKFelkqNdxUIvylvxDpvWzcL1jv+PqoxqqA2z8fB+6cCfMkf0ODl0IFj959
	 7F1uX+xehbuk7FTN1yBdztVG86/rCI8QaHbbVRZW8t4x2HdHSo2lTYKP4gxfBgS9pnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nAixyfxEHKdgY5GuO9AuyKg15Nkh1PKuO/G2NK53Flg=;
	b=Vwm3Bbkd81SZ/ELlctQi8Hv6Kliq81Rx6GYEDINnWS2Novr+5WfSrPQzy604+aofV9UB
	 xUkUOZk9HZSqzS6u7aJdqo3ur8Wb9pJPBogiPKVCZaTRjSckVe/oBJgd6LaW80x4sdJbc
	 IByhEpwArkNQCjDllWRPK8nsBkngAn45nk8wSMEdBKFv2//XVhcBg9qdJI9JQCrWR7N6s
	 K09mn8ca/CLDq4z51xLPC3BKcqrkt16xuUMrpEdvEimvoj5r/3osr5ESN2nZRQTtXK6Us
	 z+FKSzKc2pE/BGNHKXOqjUidV3j0R+5EJwCH/wEdcfPKWk1syAzWKMJoCsg6LpkRyAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1mA+cf4u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C81606A330;
	Wed, 18 Nov 2026 23:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1mA+cf4u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A151F000C5;
	Wed, 18 Nov 2026 23:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042807;
	bh=nAixyfxEHKdgY5GuO9AuyKg15Nkh1PKuO/G2NK53Flg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1mA+cf4ucT8awdIFgLlYmkcLGma7fYyurY/XgUqVlfgw1+gu74p/XiXDF6D5g83GT
	 HdwQXRiOQwKCccz6FtVGXgW0tD+H8xtsjGSaQD8SZSTdbsJsTi2GyryTdwWnJWOF8b
	 1IZToDz1ZjBl1uLg4vLOxHOOplxsKhy862ArCSbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Steven Price <steven.price@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 3303/3318] irqchip/gic-v3-its: Fix over allocation in itt_alloc_pool()
Date: Wed, 18 Nov 2026 16:05:25 +0100
Message-ID: <20261118150458.683276887@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -262,7 +262,7 @@ static void *itt_alloc_pool(int node, in
 		if (addr)
 			break;
 
-		page = its_alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 1);
+		page = its_alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
 		if (!page)
 			break;
 


