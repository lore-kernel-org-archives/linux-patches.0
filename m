Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F9030F81D;
	Mon, 13 Oct 2025 15:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367958; cv=none; b=ZlCw3AKLznP+zlwYto74WZEau2TQVnUU+I9pNzvEEz9rsW7mSs9yRwaFFptlXGIa4HPQ0Yj3a2BRJhdbEHP0k+Hv0ec2calKrcUtUkZqA9XQDrykTGO+//nUEVIuE7bIyoOelHPqTndEvsBVmWoc+K3uJUaLb30EvRMkqHqi2HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367958; c=relaxed/simple;
	bh=h3RcrkUnV2HYi000SegIAWOGeTuioxaiCXmew4U1eLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8RH9Bou5TcdIJegX/IABY1uVYuD3FURwvDZvEmS3ur4XAA0ml8U4ebjzwZU2zrqhPvGPuAeLPpRnNDJEUOc05gWXB6qubgUwzZ2WGlr/DvdWqebJco6e7/l38Tcg4hPTNh+K+bhjjbzX9s1eblChpgSsFaYzYYdQ+lCejJmJ/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dz6QE3/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dz6QE3/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40072C4CEE7;
	Mon, 13 Oct 2025 15:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367958;
	bh=h3RcrkUnV2HYi000SegIAWOGeTuioxaiCXmew4U1eLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dz6QE3/KihNFgvIptnPg7sGE4E6IqwBn5BypHXFYfE1lMAOv3Xb38+npaGsCxNvB1
	 3TbFsla4+aQwuy6bOIAon7+x73P5y7BKhERzuDxeCTQkkrqEhniBW9Arlgrzf3Ti7N
	 8ANlBkaf/4di9w/vTZ8fS0QZPqTHDlJBKpnoJmw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.6 192/196] bus: fsl-mc: Check return value of platform_get_resource()
Date: Mon, 13 Oct 2025 16:46:23 +0200
Message-ID: <20251013144322.250915238@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1103,6 +1103,9 @@ static int fsl_mc_bus_probe(struct platf
 	 * Get physical address of MC portal for the root DPRC:
 	 */
 	plat_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!plat_res)
+		return -EINVAL;
+
 	mc_portal_phys_addr = plat_res->start;
 	mc_portal_size = resource_size(plat_res);
 	mc_portal_base_phys_addr = mc_portal_phys_addr & ~0x3ffffff;


