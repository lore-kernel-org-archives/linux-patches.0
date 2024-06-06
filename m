Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392661C7D87;
	Thu,  6 Jun 2024 14:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683705; cv=none; b=ZoRKeftPF0PxoK0aPcFe+DrFqfFQBzkMln8TNPCpr97/zLY5pAzzmFmLZI0dFvPX47nQBKiPcWMFi7W6fw/v5dQ2oIx5gJzICg02Fu+xJgLc4LdokZCCDD3FIH14dFOwmYmjOSBn/fX3G3XN7E8iX9ZjDoL8Sjtrh7+Y7xWj+NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683705; c=relaxed/simple;
	bh=uQaoi3iWu5DaC9ssNTYSIMDl0e3VTUm/f7vz0fBG0Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RFki5ux5K5Mqpat8d3s9q65sZBio3NVa/pHW0fnAcgve0E498gFLl68v2HvnkzoB1sG4fK53zwhg/HfTlHWSsUEs+vLCIhWtBmUhJv1QnKVxW3cmRhJIfnCFaNLwbZOz3gQ9CKiySZIgj05giDYhyPtSh7k+4cvWW1FCGwaZFrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1XqmT8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1XqmT8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19845C32781;
	Thu,  6 Jun 2024 14:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683705;
	bh=uQaoi3iWu5DaC9ssNTYSIMDl0e3VTUm/f7vz0fBG0Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v1XqmT8cnhgz2ZcWSv1WOD33uDniLhhKvRQPDssZ41Xxk6+zm0jPAiEvCYir3zb64
	 rR0ZPikV2J34b2/ajBwNTGUhgPS8JK7X/CnY+TdryfN1kwAQM8Rmxgi+7eEIzsoWMP
	 rF84viPeoZSL1nQfKGzoXwTK5T/K7T/MmxIMlalg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 630/744] xen/x86: add extra pages to unpopulated-alloc if available
Date: Thu,  6 Jun 2024 16:05:02 +0200
Message-ID: <20240606131752.687533677@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



