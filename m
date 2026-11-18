Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050811;
	b=zU3UVivolNMQMTihXdTPOxc07x0zT9q9HqBrnPwKacozYUooupZM/uU7H5ffiq57D/hF
	 e6OgSELX9nMHJCre34P7zGDH1bbMyXqtFX2nkPNSqwr8laGBYh8mqd9U21ErPmZ5m65Dr
	 lHN3poc4F75QLmfY+prZ7QN4/QMYf0oz7CPbhmOd5vXCKrftOin5piZaCdONacWcNQtni
	 ie9aqU9J2mCSSMKVDp0HsbmNfS6JAoNTmAJotQyHvBHLj/nEgooxWz3nR9lyDKs0de5qZ
	 tjYcYzfqL1PKQG/GMq8eI4731WGtwQFsS75mBo1XwVrZeH07VHGbONugthnhpToOpHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+l+jGJyzB2bXdA4LsZcaIHw0GBLJu4JlrRMgrV8KU18=;
	b=CQZdikm8VUiJ5tbkfquS7FC044HTGesLjHIImIha0dR06pRj4B0h8dsCOGaajw3e270a
	 i884L3IcRlgSHFMfn66VWUd5ruiVbFVz0O0EOW2768KzT71m8wr9Cwy493u+CoHOFf05z
	 qG6qEEwOGNay20oxRwEpE2Gzo8LLI7SBTQyyCNdjURGSWvN+T3B26jZRVYw0GyjhNR3lz
	 4cinedsCXDU+5ovuqaSUTJKI0U7HP3PWF/KoKGetAYz7wkIuDC1BhzHIh/nn1K55Icj59
	 G4ZUjrOaF2hN9bLkA3ue6MTdqElKNVfrgxrG3wy0jduqZqRKr3b0TAcyc2lsxMa8gQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=upmSSKlE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C02606A333;
	Thu, 19 Nov 2026 01:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=upmSSKlE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BED1F000C5;
	Thu, 19 Nov 2026 01:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050811;
	bh=+l+jGJyzB2bXdA4LsZcaIHw0GBLJu4JlrRMgrV8KU18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=upmSSKlE1+Y5EbSX1ixIFVtfc7JeAXsPW9XK0DWDfYNXV0n+4rZdIyvrEv0vWvNxP
	 yHVwD/N8errkGuSoTwLc/3K/7YJH55hi+t58q5+5m/IcS0igzlrROMTvB4Fiyeuu4N
	 DqSl1tutf5yKUpCx9kpSmWHsBBlDRj4Lj+jdNHY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Steven Price <steven.price@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.1 2839/2857] irqchip/gic-v3-its: Fix over allocation in itt_alloc_pool()
Date: Wed, 18 Nov 2026 16:04:33 +0100
Message-ID: <20261118150343.793203477@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


