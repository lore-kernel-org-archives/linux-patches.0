Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6502B1DFC7;
	Wed,  3 Jul 2024 11:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005328; cv=none; b=KfnuxNvEOai8Zw9Jw+b/CduMOEM7oAFOt1NmL+eSwQR3ovUMcrTGjcUxOmFkVxdmbpa0OlAafcXqGafP2Z/uvx7qasX20mdybfUA9uTjrlAw4K5H9ZxiPH+0+pqJHAz7LIgXD2tyycKmWvJa9vZZKve08drEvxc3a95jiwYYmFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005328; c=relaxed/simple;
	bh=s2HuhKQGN7ytwGSZHIveH97VRpl5iZSFEt7kzHLtulE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZdY/wgXys6CLdDPq79nYn76ReqCSTtW9QStC/fm0YFK8YF+SPDMz9oRT9VFxLLayx2pFKC1AwQDDsWCzd/vD7JRpFQiSlmURCSrmibblqPj7Xaf8SH1Zz9UspR3+lPMQzApfJOv4XhONlN7wZOcZggzh41OlNfSR90ecX8JdrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jel+b4jw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jel+b4jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA826C2BD10;
	Wed,  3 Jul 2024 11:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005328;
	bh=s2HuhKQGN7ytwGSZHIveH97VRpl5iZSFEt7kzHLtulE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jel+b4jwAazWyqxXqmeapO9lwZCNw9wTVVQfRgnohpGAulGZHjxKzeGt8nWDNlzYE
	 RI8gQGvNoQjvlkcDGxJK8IAqg5j+0k8YIyRrkz/U8xa2cX20eAFo6hjLmTWFq0Jkpd
	 UXrVFzgcWVmXttcQmApKdqpX3PLDyvjFOvASXmbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/356] octeontx2-af: Always allocate PF entries from low prioriy zone
Date: Wed,  3 Jul 2024 12:35:50 +0200
Message-ID: <20240703102913.639335485@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c6b6d709e5908..84003243e3b75 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2459,7 +2459,17 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
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
@@ -2468,17 +2478,6 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
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
@@ -2508,6 +2507,18 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
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



