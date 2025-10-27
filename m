Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FF831D389;
	Mon, 27 Oct 2025 18:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591174; cv=none; b=dEoLhoPcmxYGdFIZPLVVSBEO6Pke98CtG3PfZO41cnZ83Y5KJtSqn6SMi4S6bKZMuKl2l8KufTnjfVlBbCWEViyQ6640T0he58YzJ80QnT8AP+WZ/vOIEIOVgCkasaSI+cjPi770XIv8ZaN8onZzGn97PUj8LZohthIbm9P68QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591174; c=relaxed/simple;
	bh=pNqmFDw/zIOLrtz+d30pP4IyIC2htivT3hXAxQRvRac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhGyRKZQpBuG0Tjv5NnUmIVrpVK+5PCegGNSHLLnZEzEDmgnTmMcgJ9Z/JYMb3qAv06bHa+lSeZAoxh2wY0LbBMYsMXCR9vC5I1DJhjkeop1E1PJjTOVMKQ0sOyIZcTj1YoB72znrDUpEW2jqIhy+GQZVaj8WKI5nvYVGNH7g4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gx3+NZ0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gx3+NZ0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260C5C4CEF1;
	Mon, 27 Oct 2025 18:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591174;
	bh=pNqmFDw/zIOLrtz+d30pP4IyIC2htivT3hXAxQRvRac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gx3+NZ0T7B88wNgSAxay7rlPZ2FEXaBFyosDH1WkugZ+ocAeSIsVl2MeIKgVdtm2u
	 0ZUolxbPVhF+gGiK92X/ueDmnMGUesIU1I7qdwVdk7QdpDhm0K4fy3+hdLJ8o1i3oJ
	 4X0DaWOVTHo3ft/TynoEgkSNl0klA0pfqX9DfIIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 5.10 095/332] bus: fsl-mc: Check return value of platform_get_resource()
Date: Mon, 27 Oct 2025 19:32:28 +0100
Message-ID: <20251027183527.129259363@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1014,6 +1014,9 @@ static int fsl_mc_bus_probe(struct platf
 	 * Get physical address of MC portal for the root DPRC:
 	 */
 	plat_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!plat_res)
+		return -EINVAL;
+
 	mc_portal_phys_addr = plat_res->start;
 	mc_portal_size = resource_size(plat_res);
 	mc_portal_base_phys_addr = mc_portal_phys_addr & ~0x3ffffff;


