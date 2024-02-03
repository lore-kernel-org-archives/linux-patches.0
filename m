Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B371101C1;
	Sat,  3 Feb 2024 04:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933407; cv=none; b=VXNWW8//ZZoycEsBZk3pTGx5zMRj39lyA3em79RlwXqcLtw2YS2KLje0kPTKNiOr/z5oy+GDzxjCrtQCqI6vVCgaBDBUBSOdFomzNfws6pr/2DGJ8GszB/et117THLA+/bbU+Rz5PA1hVgrWSMt09I7Yupi7hiBpPAcwjFFkqZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933407; c=relaxed/simple;
	bh=tRmvJSLQcnrt/lV2JED7+7fk7TUoVq4tFm/6A+LVpu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRrGseZrVOB2E9EumuARJGpyF7d0QDxQrqxTXVJ8XktnzUAU+/a1KEci3CgptmLVU2LuB577LG2glOFDekuvOzK/U8H2QDHm/cIf8oKHoMLn5YBf2g9PuY91177bGxbtIs2gNyQiYP3bdc56jo0G0uH9hCFM4maAGB8G2y94dsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBwVnJ2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBwVnJ2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D869FC433C7;
	Sat,  3 Feb 2024 04:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933406;
	bh=tRmvJSLQcnrt/lV2JED7+7fk7TUoVq4tFm/6A+LVpu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBwVnJ2UfLVB2821ZVckDzsCAtZDpxTJhp5/kZ2zyWQqu0O7hV7aEZ8sYbQJsF03+
	 SJc0MRNIXhG6m9JjpQcQKeTPit3ydyVfFJMPFdWdfDV5tDf4Rav99OCD6rvra1/I5y
	 zPAzSgML//MqlyiwyKA/KRBp00bxj7Q9INaVcb48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/219] octeontx2-af: Fix max NPC MCAM entry check while validating ref_entry
Date: Fri,  2 Feb 2024 20:04:35 -0800
Message-ID: <20240203035331.697852887@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Ghosh <sumang@marvell.com>

[ Upstream commit 4ebb1f95e0c3c3e0eec5bb21aa43097580c4b6e4 ]

As of today, the last MCAM entry was not getting allocated because of
a <= check with the max_bmap count. This patch modifies that and if the
requested entry is greater than the available entries then set it to the
max value.

Signed-off-by: Suman Ghosh <sumang@marvell.com>
Link: https://lore.kernel.org/r/20240101145042.419697-1-sumang@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 0bcf3e559280..3784347b6fd8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2678,18 +2678,17 @@ int rvu_mbox_handler_npc_mcam_alloc_entry(struct rvu *rvu,
 	rsp->entry = NPC_MCAM_ENTRY_INVALID;
 	rsp->free_count = 0;
 
-	/* Check if ref_entry is within range */
-	if (req->priority && req->ref_entry >= mcam->bmap_entries) {
-		dev_err(rvu->dev, "%s: reference entry %d is out of range\n",
-			__func__, req->ref_entry);
-		return NPC_MCAM_INVALID_REQ;
-	}
+	/* Check if ref_entry is greater that the range
+	 * then set it to max value.
+	 */
+	if (req->ref_entry > mcam->bmap_entries)
+		req->ref_entry = mcam->bmap_entries;
 
 	/* ref_entry can't be '0' if requested priority is high.
 	 * Can't be last entry if requested priority is low.
 	 */
 	if ((!req->ref_entry && req->priority == NPC_MCAM_HIGHER_PRIO) ||
-	    ((req->ref_entry == (mcam->bmap_entries - 1)) &&
+	    ((req->ref_entry == mcam->bmap_entries) &&
 	     req->priority == NPC_MCAM_LOWER_PRIO))
 		return NPC_MCAM_INVALID_REQ;
 
-- 
2.43.0



