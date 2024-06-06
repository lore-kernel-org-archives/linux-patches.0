Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27D519AA7C;
	Thu,  6 Jun 2024 14:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683037; cv=none; b=iCv0w7FElIoaPJqkao3UWgwk1BDYpHlJH/tc1JWQc9V2nMYOgAX2jEZoQB5TO54+dq8NqnNmcZw4bOevuLUy9s+i6n8r0PI+RhUO4mquUjFFo8n2hJYnsYJVi+qSyx+g2Zi0kx3qfuuEhikARPXIM+ruIrzcOad7qAgKIsRRNKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683037; c=relaxed/simple;
	bh=A2mndkHkOgejhf2ltnjNagnsJQ8cXP9UW8EFYT6XdkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eK3hFkBg44fRfwR7xjWVHwbAd+1NUTCxahMZFVtGx7Op1EOeTQ16gIZQ86e7mEgKCnIGmk6yCMkPzewu/FaZr+uCL/fQELVh6y6sMQLGunqq5ejHDHEQshuKpaiI65aZBiq5Ihp1crvBo2qSYJwDR/vxoEfdKUHIiZjfpFNedEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EC3hVEvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EC3hVEvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F3BC4AF55;
	Thu,  6 Jun 2024 14:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683036;
	bh=A2mndkHkOgejhf2ltnjNagnsJQ8cXP9UW8EFYT6XdkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EC3hVEvMy0+2684lulPWFkRsZmbh5peC2H9CgWlmM2SquBx2cxLYPD+qlPbjwXIjD
	 mBdyGEkQoShbMgkFQJwrNQu8+aSXTlP80VnH8LJJ2WEx+JuWQXy/OY3lb/W8orF+TA
	 yHJgHAl4U3cAwcMYXbDYkZ7oikzaFFo5dwAOrnHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 229/374] xen/x86: add extra pages to unpopulated-alloc if available
Date: Thu,  6 Jun 2024 16:03:28 +0200
Message-ID: <20240606131659.474316689@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Pau Monne <roger.pau@citrix.com>

[ Upstream commit a6aa4eb994ee9ced905743817c5de8451d26b911 ]

Commit 262fc47ac174 ('xen/balloon: don't use PV mode extra memory for zone
device allocations') removed the addition of the extra memory ranges to the
unpopulated range allocator, using those only for the balloon driver.

This forces the unpopulated allocator to attach hotplug ranges even when spare
memory (as part of the extra memory ranges) is available.  Furthermore, on PVH
domains it defeats the purpose of commit 38620fc4e893 ('x86/xen: attempt to
inflate the memory balloon on PVH'), as extra memory ranges would only be
used to map foreign memory if the kernel is built without XEN_UNPOPULATED_ALLOC
support.

Fix this by adding a helpers that adds the extra memory ranges to the list of
unpopulated pages, and zeroes the ranges so they are not also consumed by the
balloon driver.

This should have been part of 38620fc4e893, hence the fixes tag.

Note the current logic relies on unpopulated_init() (and hence
arch_xen_unpopulated_init()) always being called ahead of balloon_init(), so
that the extra memory regions are consumed by arch_xen_unpopulated_init().

Fixes: 38620fc4e893 ('x86/xen: attempt to inflate the memory balloon on PVH')
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20240429155053.72509-1-roger.pau@citrix.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/enlighten.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index a01ca255b0c64..b88722dfc4f86 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -382,3 +382,36 @@ void __init xen_add_extra_mem(unsigned long start_pfn, unsigned long n_pfns)
 
 	memblock_reserve(PFN_PHYS(start_pfn), PFN_PHYS(n_pfns));
 }
+
+#ifdef CONFIG_XEN_UNPOPULATED_ALLOC
+int __init arch_xen_unpopulated_init(struct resource **res)
+{
+	unsigned int i;
+
+	if (!xen_domain())
+		return -ENODEV;
+
+	/* Must be set strictly before calling xen_free_unpopulated_pages(). */
+	*res = &iomem_resource;
+
+	/*
+	 * Initialize with pages from the extra memory regions (see
+	 * arch/x86/xen/setup.c).
+	 */
+	for (i = 0; i < XEN_EXTRA_MEM_MAX_REGIONS; i++) {
+		unsigned int j;
+
+		for (j = 0; j < xen_extra_mem[i].n_pfns; j++) {
+			struct page *pg =
+				pfn_to_page(xen_extra_mem[i].start_pfn + j);
+
+			xen_free_unpopulated_pages(1, &pg);
+		}
+
+		/* Zero so region is not also added to the balloon driver. */
+		xen_extra_mem[i].n_pfns = 0;
+	}
+
+	return 0;
+}
+#endif
-- 
2.43.0



