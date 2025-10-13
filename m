Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBDB2FE577;
	Mon, 13 Oct 2025 15:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367742; cv=none; b=jlDXMFRSLRkbYAgRg+qfRo7NYL8PpWnbwWw215cLZEybKq0kSpiD42JsOHJ+JrGLXRqEVzVimEalG1l7TU31EaTmGxjJtJsKSAzznw8yJYLwgn1D0F4ZUjjPRvZT8O6i01IPGBlvy+KFBTpnJ71nZEtvJspdsnYHZDTtSbTlxp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367742; c=relaxed/simple;
	bh=m7GMniQjvtKwOmi3mEJQnkEbdp2d0N0e2HO7zVP0A9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ag1jbGy2TSjIQGJVpgN8BL0FiB7CwZmRWmXG8bCmoULumZp7oSjLQtacpYQ92hB/alk6ifsF/2/kHtjSkNsv8XVx4fO2/E0keMQQ26CgMq3HWcAUWpGh04Ayddnq/DXlZ9QtpuIYLTnP2303STRvdbZXQcMNoX+tW2geqw9ZAcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqYv2WZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqYv2WZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BEBC4CEFE;
	Mon, 13 Oct 2025 15:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367741;
	bh=m7GMniQjvtKwOmi3mEJQnkEbdp2d0N0e2HO7zVP0A9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqYv2WZXIyr1W0vvxrMSDYfW7lvs/pwqKTuoPp3wa59MXoIx10qZrcGNpTuS0AWyz
	 ouCw0aBJ5DRFbex7z6dDzLgLA6CvF5iAC4m55fSlzUVvHvH3TYRQW+pcKLxJh97JDI
	 opxzFoBZNnQtvWpl29h7xLL9h+gzRGcMyVOFrRKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/196] ACPI: NFIT: Fix incorrect ndr_desc being reportedin dev_err message
Date: Mon, 13 Oct 2025 16:45:09 +0200
Message-ID: <20251013144319.579625986@linuxfoundation.org>
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
index a466ad6e5d93a..5a1ced5bf7f6f 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2643,7 +2643,7 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 	if (ndr_desc->target_node == NUMA_NO_NODE) {
 		ndr_desc->target_node = phys_to_target_node(spa->address);
 		dev_info(acpi_desc->dev, "changing target node from %d to %d for nfit region [%pa-%pa]",
-			NUMA_NO_NODE, ndr_desc->numa_node, &res.start, &res.end);
+			NUMA_NO_NODE, ndr_desc->target_node, &res.start, &res.end);
 	}
 
 	/*
-- 
2.51.0



