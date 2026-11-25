Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622268;
	b=tKi6jwAPqfP339P6q2CvzAQuh/GreYB5NqCeMImP5+UgHtDMRb98MM4eCNkM+5/UQs0+
	 FkoG2gsQtDIktV9bUVi27IKJdVSn7/hYggpVgr9mjcVaaFCLStlfmgwUbnpCItzY2UsnF
	 7A5yKIaYVa2QMh2tH0wNz0/2K8LKBpkyVDi/J1xgrH0yDzT3O64WWqorsSwJBxzvDTwhV
	 mpwM894dmV7GNky49OXjXmgZoaKwqJn/kmAqucSrlOGQUG0BdHk/qE8xtbG2Jw3Fa4gaN
	 Epyp9lU3Ir8LUdmsFakygBQK0lFKcjpdwg8nUu/8KiF21tvt0HiGv7T0BM+VGCqaZ0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622268;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZUmVxcCSSFSKHz4uVi52sNEeufpfS8ran/SYunXXb7I=;
	b=fureHzE9CZVMdOEhj0DN9I0+yFmBlDuyMiteQOBa8L0B8kK2HLY5ttwMjQTqFSB3nwgy
	 1IIvCLr/YZtWTzr/aTOcimUzFRkQpjhip5ItpNZmPMSWuWOqor0+PPPYs1arHiFFbQm+a
	 6DmSuBvIaXkB/u9v1vJFfeA7eXH7IymPMxrDOMJtt06LFML9EmyAXVI0t8zX3n4JIFwMe
	 JLrftOtT0KKFegMgC7nMZYCzotwEeFLOcbpIY7NyY3Wbyi9zqbji3AET10U5wfXIje/kN
	 mx+iQRB8HAbWNoyLClKz0PxYKLmp4EoVG9/a6CQX3lTnfEBFe9KsN7WXF/yzqRaKFbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IiWACLRD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726E0606A31E;
	Wed, 25 Nov 2026 15:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IiWACLRD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247551F000D2;
	Wed, 25 Nov 2026 15:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622267;
	bh=ZUmVxcCSSFSKHz4uVi52sNEeufpfS8ran/SYunXXb7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IiWACLRDmG7oD1wWGEGLlZBVDT00veW0Tquqptl7j9DMUm5lb7qRjSblOtJMuxih3
	 P7Ed6lzsj6DwV1jS3Hhmay1bdr+XuJWP0VMgaaKrj5xXJN5FDAxxct7pP4mByukLr+
	 74NXAX8yW4hplZ2ggzYG/dp5kLAjbUFi/pP+zHa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 482/990] Xen/gnttab: improve error handling in gnttab_dma_{alloc,free}_pages()
Date: Wed, 25 Nov 2026 15:30:49 +0100
Message-ID: <20261125143833.385368422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 261020f6b7776..823bd755a472c 100644
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



