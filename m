Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563961422B8;
	Wed, 19 Jun 2024 13:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802760; cv=none; b=nz9ra8b02FEWf9OTjuMoHvqff8vJXC4BNYCh2ogS6RVYDDX/6k7Pc3zeiIPR7IsD4IfGoiZsFR10SzE8yar44nuEd1YqdTly0HSiI1b3kGzH/m5dPQa2ojsrPClsZ8fVXzRRibI+q6Ja2cm5v0rXGeHpx8mPW3j7thv7bzno7+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802760; c=relaxed/simple;
	bh=TklqdShCxzI2YWhM1bhNAvCRrSvbsT/WC2qu3JXca60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XuRu2NUEgVkVvKhVG/nPg2J7uZjVYQ31ZCXrrhf86R/N1/WqVkU3v9fp5uw3l+BR3xFingi6GRBdg+3RvUv2gcwzhstvak54wUsR19nqGf5COZkddR6WgAl0/kJgmiEwgvy9Nvzmdt7UtwKEgPJ+4ANmCm2yqSP8KKPegzB432Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbVSKtky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbVSKtky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A584C2BBFC;
	Wed, 19 Jun 2024 13:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802759;
	bh=TklqdShCxzI2YWhM1bhNAvCRrSvbsT/WC2qu3JXca60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RbVSKtkyoU0V6qZ2Kxd1dX7XuQtVprRHQP1tL5aGBI38VEIF1XYRJLkwFZFQ2iSAw
	 8WuI1sH+Uhka2v2lVh3r67iDawffvQlJmFQmIWH27bx5HAP5u4OwQV1jjQxqu1eoDe
	 ShPnA/Wz7qmWdLb5mxri2lF4JtJ3IdXaf6pLBZY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 036/281] octeontx2-af: Always allocate PF entries from low prioriy zone
Date: Wed, 19 Jun 2024 14:53:15 +0200
Message-ID: <20240619125611.239393091@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index e8b73b9d75e31..97722ce8c4cb3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2519,7 +2519,17 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
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
@@ -2528,17 +2538,6 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
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
@@ -2568,6 +2567,18 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
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



