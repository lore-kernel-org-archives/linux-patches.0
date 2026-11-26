Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704484;
	b=eumGFxIIrrojTXOsDAavngM/TBRotSMuWY5vKNCtqBuBewR8/SEqXRAqFY1KUfIHO+Xo
	 8GYZTxkjaVofY8+/mgSvtqyxi5m3ULvAFl01RiLDbua9As/noasYWF0IP/uyGNUyDd5rZ
	 VDU+iMO4W+w2ncZiEEYEFGCiESv54ZeG7xuS1TperHoRrGgrd/IxJAjPVmX3p/PMWiJJI
	 FzV/H49RQQHH669ufnnZVL5Z3zbmALUSaQs7hnXEHe8niO8FmfCX4kk+tTK2WToAtNl+J
	 Io3ihn3G4asxFqwaHH4PydBO6ZF6oEUcPkAiKhnYkCzCtcXsFJ09ipgEmC3KaXpIL5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HUe7h8IERC+qbLw0kNKSOY0c336R5OjPLO2Mp+9L7VM=;
	b=TlDy1gD5gQ3M/hG2+yyJgDvdd9Ic0H5d+xP/mdOaMGVsAwbJvPdtNaoAr50DOk0Dz4+V
	 dy1/C9IyFY8Kc9hQNkouuKmEflzm26Etgrp3P7utJm1QJiiHCsb8Rwuvgiqq1eSk0YnxL
	 Mbk+Q+auqSFZqa8RjPn3L+OMGoZ0PaXtnFbV8UfNBvuFUlZrgII5N1GmFXV4GXnxTDoxV
	 TLmg3DYR/zleMb/hukYBP09E/RJA459KH42alzUWZy8e0EExdkzIAR9jQPrc49fqOVZ3/
	 Oa3JkboYBA7zW0Alv8LBe6/NZKjtRbjLfvgFmLW8oMZaRV9UZD0gLTI7dA4AJxFVnSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jzDBycja;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D187606A337;
	Thu, 26 Nov 2026 14:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jzDBycja
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688DE1F00A03;
	Thu, 26 Nov 2026 14:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704483;
	bh=HUe7h8IERC+qbLw0kNKSOY0c336R5OjPLO2Mp+9L7VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzDBycjabVXIYZyeNwZer+LoVz9CZ8g8DxEllNt7LIFJROjsz0ogixByrSGBBQ7dU
	 sXRd0f/Q8MfLSNYDP+iUg9tBFEW7jzdlqMXV3VaNBw8dHIwoXPZxVDMdcwIqVDfOhe
	 VVwZpsGUdGVyq7csVRIwdiN/R4d76ZfyNktmJbcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/265] Xen/gnttab: improve error handling in gnttab_dma_{alloc,free}_pages()
Date: Thu, 26 Nov 2026 15:37:49 +0100
Message-ID: <20261126143614.742868972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
index 8bf3a437cbd4b..7084065eda4ea 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -1014,6 +1014,24 @@ int gnttab_dma_alloc_pages(struct gnttab_dma_alloc_args *args)
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
@@ -1047,7 +1065,12 @@ int gnttab_dma_free_pages(struct gnttab_dma_alloc_args *args)
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



