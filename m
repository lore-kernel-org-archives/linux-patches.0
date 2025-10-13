Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5A930DD24;
	Mon, 13 Oct 2025 14:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367389; cv=none; b=rrJPUF+1WcFflRiTBPa9lo/BZ5F+Yjbp0K7RAxyS+G/UKGbdbdDICe1yEjntjWAzkCJO8O2D3xzZ6ZUqJNNxA8C5XNvwGzqbUSTYWp9j07//qbiYU3ulXYhxtCaZcrdSon7n4RwdYLTKyMRk62X1I4wzOGYE4B0b5MPvMCm4zYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367389; c=relaxed/simple;
	bh=5yg5qJ5/zM49pWD7vxt7FAPJpmcUH8Q5KWP6u/rgIxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLVuNZY1v4wTr2sxQfmfV3FkTsYVD8yYL0RHunPpn5CxJae3z+7S1cBdLVBZDSdDw3qszQHan6yqCyNX1brTsT9A8auLJ7ixevklqbAc28D6ZrNsrBh/AGzmfZhVYo3cuFPczbXkfXqWzORXLNoCzGNh89DmUO6XkNyLooRH+zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/UXOm9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/UXOm9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAE9C4CEE7;
	Mon, 13 Oct 2025 14:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367389;
	bh=5yg5qJ5/zM49pWD7vxt7FAPJpmcUH8Q5KWP6u/rgIxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/UXOm9pCITEziWD0JwLYGMHtPsG/pxAUf2WRqAD30DFZgH4xxWI54BeEFmVBai8e
	 U2dhbC3pLbAKZUjGCngc3UK1Znm8Z6keAfpbR8Q8eAZQq5HQAwFksybug9qL6LJ1KS
	 rWbNo9nZ13YjV9Vyh/IG51SS0k/0y7LZ/63cwCNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.1 190/196] bus: fsl-mc: Check return value of platform_get_resource()
Date: Mon, 13 Oct 2025 16:46:03 +0200
Message-ID: <20251013144321.564670583@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

commit 25f526507b8ccc6ac3a43bc094d09b1f9b0b90ae upstream.

platform_get_resource() returns NULL in case of failure, so check its
return value and propagate the error in order to prevent NULL pointer
dereference.

Fixes: 6305166c8771 ("bus: fsl-mc: Add ACPI support for fsl-mc")
Cc: stable@vger.kernel.org
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/aKwuK6TRr5XNYQ8u@pc
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -1172,6 +1172,9 @@ static int fsl_mc_bus_probe(struct platf
 	 * Get physical address of MC portal for the root DPRC:
 	 */
 	plat_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!plat_res)
+		return -EINVAL;
+
 	mc_portal_phys_addr = plat_res->start;
 	mc_portal_size = resource_size(plat_res);
 	mc_portal_base_phys_addr = mc_portal_phys_addr & ~0x3ffffff;


