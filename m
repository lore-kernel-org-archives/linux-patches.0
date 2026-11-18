Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062280;
	b=p9cB82HUGHlqupJj73R969Ph9guDcspnWkf15Zm2G4QN6xHV2xRTItEv9WmYDLxJ0Ck+
	 jBZFnmIjKJkooBn2SzWTdDRB66ODWavgzvSjqzEM3MRaUi1TXViNRfhMMmgD/+SUhtOCu
	 hX7O4+DgZM4pHEBrPjGnLer6KhjwAftwO1nOSBleWmWgz8w2VxttxJZodp6qJBp/3jT7h
	 hOoA9GA17DTkKfHdiezu7LbzEY1L1mfjxYTOuiM8pwNTE4EvPLMo3cN+xLn+SqVb5akif
	 GwgBC/lxvMH/1xx3wSdIj24eBCSjmPe67dMCt6wWbfE2j/ZDPs15VIzuaPpvmcbQQRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gyJHF/S9loRmRPwySkJL69N49A/Vap1n1qv8YaRjkqs=;
	b=zuAK31A/z/a3w+nhEay3umH6ryqF3F6qMjkGxO7ppnmljjCTvI3BnYWNbBlfLWhrlnnl
	 Ii7z2/GuAI+IBONqZK19NjCpH+DrjTDAphSVRrZfcW1WJ9ua8MaiL+GWypm1ldFuBn8aL
	 x62ARVRjERLzA0j2Ui+CX3qWAYHTuQvOK2qqj/lrKoB0szKOuMAOSZN0pgpIzEK/NUuyg
	 WUcCpwzIh5/4Uhlxf7NW8v/EeR+LoJr+8gFJeyQ9W4kYszs6eZG2ogWADeUzm4SuGwK9E
	 SaFCTg7SXjJldhjTfA5Lkh884oGZfMUN7vflqzgyF2vW7/I/MBnJSxL5VRRrLGdIZWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U+3dviUq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46518606A325;
	Thu, 19 Nov 2026 04:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U+3dviUq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D9E1F000C4;
	Thu, 19 Nov 2026 04:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062280;
	bh=gyJHF/S9loRmRPwySkJL69N49A/Vap1n1qv8YaRjkqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+3dviUqkUnWbKL8QMKAJC2L8DdvdrFQLL/SKSzb8YxYr1EkP27cTsjekg6ZlCwGq
	 cd46/hifB3VT7ztZQ+O+ImrBQ18D6QrtLMP8nhJ91PwGIkU/AyLlfkdbylgLDJPvsk
	 gnu73LhpuRxusCsWXhJNXoRmcHCKNjyPgw5vq6gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Steven Price <steven.price@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 1825/1848] irqchip/gic-v3-its: Fix over allocation in itt_alloc_pool()
Date: Wed, 18 Nov 2026 16:04:23 +0100
Message-ID: <20261118150036.074040672@linuxfoundation.org>
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
@@ -264,7 +264,7 @@ static void *itt_alloc_pool(int node, in
 		if (addr)
 			break;
 
-		page = its_alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 1);
+		page = its_alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
 		if (!page)
 			break;
 


