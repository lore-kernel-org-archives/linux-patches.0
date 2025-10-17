Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E795330B0D;
	Fri, 17 Oct 2025 15:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716207; cv=none; b=sPShehvgHcrp8hNwsZLbCD1W92tDGohJda8tdyQj/IT15yRCj3ZfvYQc8uocT1ct7oWBIuE2KODu7lajW/u55+cOuoSwTiCWOECgvLEkgKdjCiFKeBaTUX2cHhxeO18ZMRUUtdahuxcXF9IKlpxsQ/X7aSiAZvPziZ2ZlBIkQYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716207; c=relaxed/simple;
	bh=QEMe/kD45zeoMjorLfusttMRAob9Zb7So3qRQ04qDWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naYp1zsNPe4jdrHs5RHXMoHkI/7Y/RfaKPJXHFukHrpg3LO3YAN9SX3zwV+K/VeYx/XwGiZnCtrYVKLUJ1Tr/lV5OtpNFk6FZA5+NISBaxM9IokA0SsZ4yTEXxLbDOQaaOqusQABn893K7FLhazjWR72ZDyr9FtOZO+cAYjzLt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxwTpEmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxwTpEmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE63C4CEE7;
	Fri, 17 Oct 2025 15:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716207;
	bh=QEMe/kD45zeoMjorLfusttMRAob9Zb7So3qRQ04qDWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxwTpEmrH6pmFCjsq667cgmHwUr0NCHTngc+XXTihgZ9+3EVGOep/zknW9FAsGWIb
	 YoAzybZ/cNcBr7tWI2ewN4Ob/OoZjXpkmWGrr8Rr8wYmgaiHWeq14DiILi0uPKeDpL
	 mH9nAcjeWf/iQWMYgrDcd8mvLCpCsfL2fRVHoWpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/276] ACPI: NFIT: Fix incorrect ndr_desc being reportedin dev_err message
Date: Fri, 17 Oct 2025 16:52:51 +0200
Message-ID: <20251017145145.336083746@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit d1a599a8136b16522b5afebd122395524496d549 ]

There appears to be a cut-n-paste error with the incorrect field
ndr_desc->numa_node being reported for the target node. Fix this by
using ndr_desc->target_node instead.

Fixes: f060db99374e ("ACPI: NFIT: Use fallback node id when numa info in NFIT table is incorrect")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 2a6fdce3c2e6b..e420f773d6744 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3021,7 +3021,7 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 	if (ndr_desc->target_node == NUMA_NO_NODE) {
 		ndr_desc->target_node = phys_to_target_node(spa->address);
 		dev_info(acpi_desc->dev, "changing target node from %d to %d for nfit region [%pa-%pa]",
-			NUMA_NO_NODE, ndr_desc->numa_node, &res.start, &res.end);
+			NUMA_NO_NODE, ndr_desc->target_node, &res.start, &res.end);
 	}
 
 	/*
-- 
2.51.0



