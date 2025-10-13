Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECEF3081A8;
	Mon, 13 Oct 2025 15:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368417; cv=none; b=ib6nlMQ/pc1LETzu/pqyjBVpNBPGL/hRYL0iVfjVgfs+I84LYgj6WorAXiOjw/qIZAsA8wOGeO2iEsx+6LW+XTfRruDz90eMVNvjAnq1VTaiyhqsOD5KkvF/Gw3h5zgUDuoq5i52fF3nDks0LjhQmS9VhEKHbTdiNs598wqM6qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368417; c=relaxed/simple;
	bh=K36APKBQv/nxXd5G2UvUEFKbPL3CKptXHLVEqJci4Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svyAU0H0Lay2PrCLwknmIwxU5e+pmTYRcDjnULViqLaNAv/iTBpUStUkgaC9h1fboQxJIetJ66rcdgpBGJ8vH5PcM7TgxWiJ9e+S52HyjI0ClUXULi9t5t4azE3/1n2Wbd2uBTqrwGIIlO5w1gLUZTtMuWg1/g8iFQMfrUUOjNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PW9lPMR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PW9lPMR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FFAC4CEE7;
	Mon, 13 Oct 2025 15:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368417;
	bh=K36APKBQv/nxXd5G2UvUEFKbPL3CKptXHLVEqJci4Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PW9lPMR9Jom9cYDbYupONDTQzLUXYCqslSgdWi7hstA6R5KyPvjBRbDmTJd74dqpF
	 Y7TiDH+r4cIC/r/OdM8NCqc84+z5oqw9q2KwSCwxPmfrjUReQW3/klsS681J+QdtvI
	 xF4mF7l8CbdYdQgOi5Gox/r8k1s5nyZZw+8yoCdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/262] ACPI: NFIT: Fix incorrect ndr_desc being reportedin dev_err message
Date: Mon, 13 Oct 2025 16:44:57 +0200
Message-ID: <20251013144331.703050542@linuxfoundation.org>
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
index ae035b93da087..3eb56b77cb6d9 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2637,7 +2637,7 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 	if (ndr_desc->target_node == NUMA_NO_NODE) {
 		ndr_desc->target_node = phys_to_target_node(spa->address);
 		dev_info(acpi_desc->dev, "changing target node from %d to %d for nfit region [%pa-%pa]",
-			NUMA_NO_NODE, ndr_desc->numa_node, &res.start, &res.end);
+			NUMA_NO_NODE, ndr_desc->target_node, &res.start, &res.end);
 	}
 
 	/*
-- 
2.51.0



