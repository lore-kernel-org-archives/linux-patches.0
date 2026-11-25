Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624972;
	b=MDAZcna6TTwEVq1yBrcCEuSnRNf4EGNBd7V1AnynkPWhLjBdAPRUeogSsInQr5SAyhh0
	 iniEDX5SPA0JtssiP4mY/6uzkSwyJz4iMFiluwomGRYfuf9w/klv7wMXflGAlP6vWw2Xl
	 IrdNA3Z7V2OCb4wEFYmLMwYFmaIdX/7tNhyZrB54ULNPJjjo1aBJWJNYnbQOAEDo1Mi8+
	 xY5Y9SSaM3MosakEjdiRWeOq515oQimEy4JbuE0F5VvSokoZP3McPhzEx/xcL1gvwGzm5
	 y4tCTN8x3+8nEV+APYQV9mW/9yQi0e5SXAn6JZK5CrBqCaQ39LIqJDlJKynGQi/VwVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QRcUuRcvSR+lMEpaMOsYv3ot6mLtoZmhVIfLsML33FY=;
	b=O/PYmAk40syVXYBNq/juGAxkbJW1SsQpXIb3fiOj0Pdl2eOP5re0v2zrWyXTql4pNSrX
	 OeYRYWJZNRKtgL7soDoR+xI743x+USFmcuNpl3sV02m6Rkoy+xef05BLdQ3TDY9yBKpsT
	 SjCQWZ6RXkuL7MHrnfl2ds/yY4HskU7MZKQaBMUtlBjgPH3D/z9YDjZ5SPklwNKso3adk
	 Ji3J7lgHaXOOM2L7utMhUAEgg6pnv/CUZMCwjiQ3Hs1YB5FTGIASxG3+PFNeQ+6jwoRoN
	 o2vRVYJ70yqBkpixNZwrDnyU4kXjiXLn0MIIcbKJGrmQGVycUasAwI8o1tefmF6bDIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRc3Rjmq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA95606A31E;
	Wed, 25 Nov 2026 16:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRc3Rjmq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4C71F000C0;
	Wed, 25 Nov 2026 16:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624971;
	bh=QRcUuRcvSR+lMEpaMOsYv3ot6mLtoZmhVIfLsML33FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uRc3Rjmq4xh9XECNqKONZNat9EHUDFT04J8Bq+FLbt522XvBOVWFgI+oEu2DUtrbb
	 nVvUj8vs3UmnmP9Og70jmO8NKhXX/qRviki3qCxpe3rwBDc7FVVIs2hjXj4KLEdD4j
	 Xc1DT4lkhQ5pggoYsIh/31whbqXzMkQ5zpAta3Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 362/816] Xen/gnttab: improve error handling in gnttab_dma_{alloc,free}_pages()
Date: Wed, 25 Nov 2026 15:31:50 +0100
Message-ID: <20261125143857.577262246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 2b66f2cc753243a6adb3e9a5c038b0fc59ba7ec9 ]

Both decrease-reservation and populate-physmap can succeed partially. For
the former this may be pretty unlikely, but clearly the latter can hit
both out-of-memory conditions in the hypervisor or denial because of the
allocation exceeding the domain's allowance (there's no interaction with
the balloon driver here either).

In gnttab_dma_free_pages() we simply can't give back to the system what
hasn't been re-filled with backing memory. For gnttab_dma_alloc_pages()
both parts of the overall region need dealing with differently.

While no present caller of gnttab_dma_free_pages() checks its return
value, also don't use -EFAULT there: It really is an out-of-memory
condition. (In gnttab_dma_alloc_pages() -EFAULT doesn't look quite right
either, but I couldn't think of a clearly better error code there.)

Fixes: 9bdc7304f536 ("xen/grant-table: Allow allocating buffers suitable for DMA")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20261110095605.369848-3-jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/grant-table.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 51df0772f989d..90af7a9fd6cf4 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -1096,6 +1096,24 @@ int gnttab_dma_alloc_pages(struct gnttab_dma_alloc_args *args)
 	ret = xenmem_reservation_decrease(args->nr_pages, args->frames);
 	if (ret != args->nr_pages) {
 		pr_debug("Failed to decrease reservation for DMA buffer\n");
+		if (ret >= 0) {
+			/* Free the part where decrease didn't work. */
+			size_t done = ret << PAGE_SHIFT;
+
+			if (args->coherent)
+				dma_free_coherent(args->dev, size - done,
+						  args->vaddr + done,
+						  args->dev_bus_addr + done);
+			else
+				dma_free_wc(args->dev, size - done,
+					    args->vaddr + done,
+					    args->dev_bus_addr + done);
+
+			if (!ret) /* Nothing else to do? */
+				return -EFAULT;
+
+			args->nr_pages = ret;
+		}
 		ret = -EFAULT;
 		goto fail;
 	}
@@ -1129,7 +1147,12 @@ int gnttab_dma_free_pages(struct gnttab_dma_alloc_args *args)
 	ret = xenmem_reservation_increase(args->nr_pages, args->frames);
 	if (ret != args->nr_pages) {
 		pr_debug("Failed to increase reservation for DMA buffer\n");
-		ret = -EFAULT;
+		/* Can only free what has been re-filled. */
+		if (!ret)
+			return -ENOMEM;
+		if (ret > 0)
+			args->nr_pages = ret;
+		ret = -ENOMEM;
 	} else {
 		ret = 0;
 	}
-- 
2.53.0



