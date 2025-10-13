Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACA81A9B46;
	Mon, 13 Oct 2025 15:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368712; cv=none; b=pz21hlQuvmEGqRQxlyDJf4gR4urHnABfMlIK+S3MZFlAzSRf78lueHBjQVUVDfNpheD5td/DDlIE4zFSW/LPa1+Sf+yzaMv7V/MUNek6KTf1bkMDslOcBjELmT+T8dX9oaRR5kjTD/uFhL+IFkqZQZ38ATDJAySyKkJygLqgwTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368712; c=relaxed/simple;
	bh=44kPqm/oX1aN8GGsDwWCJI4AMt70EV332CLE6x3zyf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lS7UO5Cxsuxyb/JnJovwrGOd0W9cxYcUhD1/XhrbVvK8Id7TvVRVtqjTZyXNPK9rUfu48eDK5oZu2xu4v2hoCPe9ScCWYC7Tbn6r8W+SZO/1oYFkNfsDdRXZ5Asi/DYjmdP8t9JQ0QbMIR/qaAoPuPsHtGX6NVK7/9+qW4RnUZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lIEwwUn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lIEwwUn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93DCC4CEE7;
	Mon, 13 Oct 2025 15:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368712;
	bh=44kPqm/oX1aN8GGsDwWCJI4AMt70EV332CLE6x3zyf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lIEwwUn/+bDAfkEH0tBL1mV3fAcL92t301aZXdo/hLKamudo9iDXKuPNIKbhMgl8J
	 TQX+85ifzQG39GksowscBHS++Zs/yJMu84JLFmTWaSp+bl2AZuEhY79dguI9WDooWx
	 le72QGZ8K6c6V30cKsBLf7Umsivr+PfLJ0kvOQuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.12 257/262] bus: fsl-mc: Check return value of platform_get_resource()
Date: Mon, 13 Oct 2025 16:46:39 +0200
Message-ID: <20251013144335.489446893@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


