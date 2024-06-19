Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5DC14388C;
	Wed, 19 Jun 2024 12:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801951; cv=none; b=t7fUgAjDYgIQU/qPLoI/OeSFxmPik4m8wf92NR2fRLewlBWpAiIxRSSE1TROEWMGFFbAh+YUyhXjk9vZlFNALwu1gu3mn3v4pF6gqfyREBeEM1LBpo8qDLpyGWET4RUExzVYuud04xlPAseUumbR1dsvH45WQfq1fw6Ui6G/ef4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801951; c=relaxed/simple;
	bh=IDxi58p/ohpFxgiT4UiVx3ZJ/Jnh/sLSiuLAFt/185M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+I/r4L0uUCstUEhSW054N28wMgUrCskg8i6/tmBjDkTfTkRwrn7fXMLTqHlc9Vv69aM1a3B1Y8lj0y0Oqrp7gF/3h9og22bFdbIqX93rfNapMCEz+ZzVM18wmloOnhyMEoR8A7bvgzyY5xKH6IhX5OP++wZM39pTiazLIkqSv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6fgUqb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6fgUqb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FE5C2BBFC;
	Wed, 19 Jun 2024 12:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801951;
	bh=IDxi58p/ohpFxgiT4UiVx3ZJ/Jnh/sLSiuLAFt/185M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6fgUqb8g5g7fx6ac7cOSSgNZiIImi8BFKBlEPJ9ldWNzEQtNoXU43vocuBIAZfxq
	 mcfKDutdEjItFE6+WPMOgHD9DGbsLuD2R2NJzbiRmYzsZnBvHLbrKLanSiUTcqBovw
	 1u2o7OGk7QfIZrLh+dh932lEu1cALzLPi4xXYP6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/267] octeontx2-af: Always allocate PF entries from low prioriy zone
Date: Wed, 19 Jun 2024 14:53:03 +0200
Message-ID: <20240619125607.596575597@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit 8b0f7410942cdc420c4557eda02bfcdf60ccec17 ]

PF mcam entries has to be at low priority always so that VF
can install longest prefix match rules at higher priority.
This was taken care currently but when priority allocation
wrt reference entry is requested then entries are allocated
from mid-zone instead of low priority zone. Fix this and
always allocate entries from low priority zone for PFs.

Fixes: 7df5b4b260dd ("octeontx2-af: Allocate low priority entries for PF")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 33 ++++++++++++-------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 91a4ea529d077..00ef6d201b973 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2506,7 +2506,17 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
 	 * - when available free entries are less.
 	 * Lower priority ones out of avaialble free entries are always
 	 * chosen when 'high vs low' question arises.
+	 *
+	 * For a VF base MCAM match rule is set by its PF. And all the
+	 * further MCAM rules installed by VF on its own are
+	 * concatenated with the base rule set by its PF. Hence PF entries
+	 * should be at lower priority compared to VF entries. Otherwise
+	 * base rule is hit always and rules installed by VF will be of
+	 * no use. Hence if the request is from PF then allocate low
+	 * priority entries.
 	 */
+	if (!(pcifunc & RVU_PFVF_FUNC_MASK))
+		goto lprio_alloc;
 
 	/* Get the search range for priority allocation request */
 	if (req->priority) {
@@ -2515,17 +2525,6 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
 		goto alloc;
 	}
 
-	/* For a VF base MCAM match rule is set by its PF. And all the
-	 * further MCAM rules installed by VF on its own are
-	 * concatenated with the base rule set by its PF. Hence PF entries
-	 * should be at lower priority compared to VF entries. Otherwise
-	 * base rule is hit always and rules installed by VF will be of
-	 * no use. Hence if the request is from PF and NOT a priority
-	 * allocation request then allocate low priority entries.
-	 */
-	if (!(pcifunc & RVU_PFVF_FUNC_MASK))
-		goto lprio_alloc;
-
 	/* Find out the search range for non-priority allocation request
 	 *
 	 * Get MCAM free entry count in middle zone.
@@ -2555,6 +2554,18 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
 		reverse = true;
 		start = 0;
 		end = mcam->bmap_entries;
+		/* Ensure PF requests are always at bottom and if PF requests
+		 * for higher/lower priority entry wrt reference entry then
+		 * honour that criteria and start search for entries from bottom
+		 * and not in mid zone.
+		 */
+		if (!(pcifunc & RVU_PFVF_FUNC_MASK) &&
+		    req->priority == NPC_MCAM_HIGHER_PRIO)
+			end = req->ref_entry;
+
+		if (!(pcifunc & RVU_PFVF_FUNC_MASK) &&
+		    req->priority == NPC_MCAM_LOWER_PRIO)
+			start = req->ref_entry;
 	}
 
 alloc:
-- 
2.43.0



