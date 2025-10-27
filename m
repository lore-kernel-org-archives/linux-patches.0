Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9462E31B81D;
	Mon, 27 Oct 2025 18:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591091; cv=none; b=YHtW5qcEXQzEtrLocq6RG4EHcIQE6TEYeGRshGk8Oy8A8hOe4QH9lROkTAFS5nDT6gBfABFyoz5f6wGHO3CxHmfRlxWvAV5wJ1WPLprkoPnjHf4j/qZw2LhwZpfVf/767JYCSVOUXfQrm2vm6e0DrUH7CbwRCnptuedNn9+R/2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591091; c=relaxed/simple;
	bh=shfCA36iQ5S96CgE0QXBLnT86DPnjbdn4DCNr01wYiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEZmiXIJHG6nJLDg2Mj1dtKQYyMxuRdCGm0kv4g9WZyP84IdzcisVPrRx72YCoNdD+vCgE7J7EgsKS9/B9Y0l3rpog/KnGGrEa4uNAwzyehEKX9yvVk762l/aOVfaZrGI1ZLY6hKpilMORL7mzurbOrXn3ssdVSmnfDyhBDcCaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4SppSFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4SppSFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DBAC4CEF1;
	Mon, 27 Oct 2025 18:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591091;
	bh=shfCA36iQ5S96CgE0QXBLnT86DPnjbdn4DCNr01wYiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4SppSFkdAtv12HAL5qPo34nSUNff2TRdIek1aJAe7YH9w5wLzKo2uEB7qVOFA0a7
	 NxtFP951IVzhZsVy4k8PC2Rs2wT+6d6fcO/AVPQ05uzaxxqnN8OPNKFBeZjc/SPn5b
	 aSnTGQEPuIk5+8zF0xjblKVS6YOaYaeXryDuLZTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/332] ACPI: NFIT: Fix incorrect ndr_desc being reportedin dev_err message
Date: Mon, 27 Oct 2025 19:31:56 +0100
Message-ID: <20251027183526.282668104@linuxfoundation.org>
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
index 8992fdb92902f..d314afec44b56 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3032,7 +3032,7 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 	if (ndr_desc->target_node == NUMA_NO_NODE) {
 		ndr_desc->target_node = phys_to_target_node(spa->address);
 		dev_info(acpi_desc->dev, "changing target node from %d to %d for nfit region [%pa-%pa]",
-			NUMA_NO_NODE, ndr_desc->numa_node, &res.start, &res.end);
+			NUMA_NO_NODE, ndr_desc->target_node, &res.start, &res.end);
 	}
 
 	/*
-- 
2.51.0



