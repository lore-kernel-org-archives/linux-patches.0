Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E3534028B;
	Sat, 28 Feb 2026 17:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301472; cv=none; b=VcpxhowzDh2E0Lc5cQc0DYm03OwxMMtcoCpMHtRDkrUtJDuF715Pp18eAgVGuUme/Jz9x103eJxn2WNsyVzEaWC3SbPvVQDArqHEgceJARKk1D5KeQtu8pbKtgDKG11KLv26W1Lg7NaqvBOjWPd7SbqC5NzS4s/dxeyyKT1JD9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301472; c=relaxed/simple;
	bh=S7eFNdkVrO8QDXkHBh+Sia2xcyU4ekGamgMGgDtYibg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CqTxTHJUjPLMxlvIygn1MhF5XO2JPGfHWJ1TUPcXhVd0xFn8nVQv3jo8HOI8y4W46XTQVicMpFIZocpxZn5dNnCx5pInLgn3DwDt0SjgFm8UuQ/BRY9IFdDnySEYKSdFG+EMybu05UMEfaJqaIIuEvBQyPb+sGwRXn/f9siUj5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eKfPCdR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eKfPCdR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723FBC116D0;
	Sat, 28 Feb 2026 17:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301472;
	bh=S7eFNdkVrO8QDXkHBh+Sia2xcyU4ekGamgMGgDtYibg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKfPCdR9+T00K+yACu45s9r/p1X+wG8OYKS/IIWYKfjI85XgkfYDLnVWZydodMeHh
	 TxsEV4ECzTlj7J9EGaszmcEtuONG6tfcdlOv3X4f+ICb3wGSPSb/QIyABV0K2fWalU
	 8yQZ+b07s8dhU5Y2KVZoiqupbDciEat9OCE7WVfIFPmJ53w1nu3oqqcb2ZbXA5NOJF
	 PI7wGWX8ouqr/yefcQELSb90AliaUqGTS4JHSeDBuRU5xwXqSpCO2SM0Ud3kYd9Z1A
	 IxHBtnJwk0GmSY2NxR0p9+rz1li2au731YTXVhYU3f02KPiuyCOCx1CON3wosoq3NJ
	 i/D4CYFm8xOMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Robin Murphy <robin.murphy@arm.com>,
	stable@vger.kernel.org,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 657/752] perf/arm-cmn: Reject unsupported hardware configurations
Date: Sat, 28 Feb 2026 12:46:08 -0500
Message-ID: <20260228174750.1542406-657-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 36c0de02575ce59dfd879eb4ef63d53a68bbf9ce ]

So far we've been fairly lax about accepting both unknown CMN models
(at least with a warning), and unknown revisions of those which we
do know, as although things do frequently change between releases,
typically enough remains the same to be somewhat useful for at least
some basic bringup checks. However, we also make assumptions of the
maximum supported sizes and numbers of things in various places, and
there's no guarantee that something new might not be bigger and lead
to nasty array overflows. Make sure we only try to run on things that
actually match our assumptions and so will not risk memory corruption.

We have at least always failed on completely unknown node types, so
update that error message for clarity and consistency too.

Cc: stable@vger.kernel.org
Fixes: 7819e05a0dce ("perf/arm-cmn: Revamp model detection")
Reviewed-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 651edd73bfcb1..4fbafc4b79843 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -2422,6 +2422,15 @@ static int arm_cmn_discover(struct arm_cmn *cmn, unsigned int rgn_offset)
 			arm_cmn_init_node_info(cmn, reg & CMN_CHILD_NODE_ADDR, dn);
 			dn->portid_bits = xp->portid_bits;
 			dn->deviceid_bits = xp->deviceid_bits;
+			/*
+			 * Logical IDs are assigned from 0 per node type, so as
+			 * soon as we see one bigger than expected, we can assume
+			 * there are more than we can cope with.
+			 */
+			if (dn->logid > CMN_MAX_NODES_PER_EVENT) {
+				dev_err(cmn->dev, "Node ID invalid for supported CMN versions: %d\n", dn->logid);
+				return -ENODEV;
+			}
 
 			switch (dn->type) {
 			case CMN_TYPE_DTC:
@@ -2471,7 +2480,7 @@ static int arm_cmn_discover(struct arm_cmn *cmn, unsigned int rgn_offset)
 				break;
 			/* Something has gone horribly wrong */
 			default:
-				dev_err(cmn->dev, "invalid device node type: 0x%x\n", dn->type);
+				dev_err(cmn->dev, "Device node type invalid for supported CMN versions: 0x%x\n", dn->type);
 				return -ENODEV;
 			}
 		}
@@ -2499,6 +2508,10 @@ static int arm_cmn_discover(struct arm_cmn *cmn, unsigned int rgn_offset)
 		cmn->mesh_x = cmn->num_xps;
 	cmn->mesh_y = cmn->num_xps / cmn->mesh_x;
 
+	if (max(cmn->mesh_x, cmn->mesh_y) > CMN_MAX_DIMENSION) {
+		dev_err(cmn->dev, "Mesh size invalid for supported CMN versions: %dx%d\n", cmn->mesh_x, cmn->mesh_y);
+		return -ENODEV;
+	}
 	/* 1x1 config plays havoc with XP event encodings */
 	if (cmn->num_xps == 1)
 		dev_warn(cmn->dev, "1x1 config not fully supported, translate XP events manually\n");
-- 
2.51.0

