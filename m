Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04C52580F2;
	Mon, 13 Oct 2025 15:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370344; cv=none; b=hYiAJzGQZWuK6GGW+ejyMXNVfBuM14u92S5AqDXi7VoXmxhzHnV6dEJ5IG48ed/+X5eRogYZe5H3Uly82KqQ/QyU5GTOHsRVMjmtS5nT6XMVX2VJxLKTSwSERceOOZASq06PasAEiER0tWIB8go06ahKHD0Opc+9+6rLsmEys74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370344; c=relaxed/simple;
	bh=l7p+ZRR/Ho2/6iDy4PzppO/ZRs+5YXClQWdfs5ES20E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdLtI6hD6D123q7HOfz5HwTeVu/D4YH17CzgJu8i3JA3vRgDJDzdxmwCo/APUEsHRkaX4HY003c/vAfdNBUm+qIDxjdHg5N6LL/kBKE17sa9y5CPbCnaEtGGa4v3zR9uYd3L1hQOKE6YYeZmwkc/kPaCQCQtgQuZ/EdMeKtpERc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fscz9Z9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fscz9Z9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBC9C4CEE7;
	Mon, 13 Oct 2025 15:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370343;
	bh=l7p+ZRR/Ho2/6iDy4PzppO/ZRs+5YXClQWdfs5ES20E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fscz9Z9E8aZIVPjUO32DRLi2Tk4PhhtiUkZCc04iDwoyPOaHs+YK8g2ZHc+GgE2KE
	 zF+Y6PYW24bk5UAPKHTSGklrIEbTdDuWyll1tzw4G9vSHl7k+MQfz8GOZwseP3Z+RS
	 FIVREreMOOlhJEb1Rlq038eo4NEg8tY25U/9IOcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.17 556/563] bus: fsl-mc: Check return value of platform_get_resource()
Date: Mon, 13 Oct 2025 16:46:57 +0200
Message-ID: <20251013144431.445433099@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1104,6 +1104,9 @@ static int fsl_mc_bus_probe(struct platf
 	 * Get physical address of MC portal for the root DPRC:
 	 */
 	plat_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!plat_res)
+		return -EINVAL;
+
 	mc_portal_phys_addr = plat_res->start;
 	mc_portal_size = resource_size(plat_res);
 	mc_portal_base_phys_addr = mc_portal_phys_addr & ~0x3ffffff;


