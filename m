Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F845A79B;
	Thu, 16 Jul 2026 14:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210982; cv=none; b=PUDlJ2Yi96gvecW4Ct0IyHVJjeKmNQf6fIXQBh3SKjZGh5vXZe5c9J7AtdAI4gaHTz4seS+M9BZi2K4sHBNi2F2BMG4Jbv6C9U7udqoyBuFXvkMpqV7LOnQC/DJDtOoemxrgfuTBzf0moY2yY4yQqNCctJDpTU51KXhUUILYgAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210982; c=relaxed/simple;
	bh=wUB6Z1zbkgH1J5zIGadPPDdRg5o2DyiCS5HNV+vp0XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTeZk89gK17TrE5J7WUxsXiLKi1QA13W2QByX/yRmjzBT77Zc8CyfxLqLKXfvCcNNTRj8N3efJfr5cQLutOxYvmr6d3HgmAPyPJRYS1DqSRb7Q63aakm3+DJ78dZxSewCGyGPqDoFsSFes6TziRWFqxJckFvGUSG2x1wm3rt+Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7crSLEL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7crSLEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537571F000E9;
	Thu, 16 Jul 2026 14:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210980;
	bh=1mfozgNW33a7P9RACdVz7tHF0Xf9rYuITPb0B8Mu3rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7crSLELvbeChG4MrZexLnKI0RQk/eJC+wwxlMbQFsrA5FwmkVOdPdPA0RqZnxorU
	 zyV9GvWfM5IIo28ED9xPFWF/XgUJiYOmlkZfUVQF59IxeCvy7rUaE+VHKUPkZAHuk3
	 o4PujoRILU/dRDgPH3We9VxkmOcNrkCT0nnjtZ+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.18 254/480] perf/arm-cmn: Fix DVM node events
Date: Thu, 16 Jul 2026 15:30:01 +0200
Message-ID: <20260716133050.309288746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit 5936245125f78d896fdb1bbc2ae79213e28a6579 upstream.

The new DVM node events added in CMN-700 also apply to CMN S3; fix
the model encoding so that we can expose the aliases and handle
occupancy filtering on newer CMNs too.

Cc: stable@vger.kernel.org
Fixes: 0dc2f4963f7e ("perf/arm-cmn: Support CMN S3")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/arm-cmn.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -197,13 +197,14 @@
 enum cmn_model {
 	CMN600 = 1,
 	CMN650 = 2,
-	CMN700 = 4,
-	CI700 = 8,
+	CI700 = 4,
+	CMN700 = 8,
 	CMNS3 = 16,
 	/* ...and then we can use bitmap tricks for commonality */
 	CMN_ANY = -1,
 	NOT_CMN600 = -2,
-	CMN_650ON = CMN650 | CMN700 | CMNS3,
+	CMN_700ON = ~(CMN700 - 1),
+	CMN_650ON = CMN_700ON | CMN650,
 };
 
 /* Actual part numbers and revision IDs defined by the hardware */
@@ -919,14 +920,14 @@ static struct attribute *arm_cmn_event_a
 	CMN_EVENT_DVM(NOT_CMN600, txsnp_stall,		0x0a),
 	CMN_EVENT_DVM(NOT_CMN600, trkfull,		0x0b),
 	CMN_EVENT_DVM_OCC(NOT_CMN600, trk_occupancy,	0x0c),
-	CMN_EVENT_DVM_OCC(CMN700, trk_occupancy_cxha,	0x0d),
-	CMN_EVENT_DVM_OCC(CMN700, trk_occupancy_pdn,	0x0e),
-	CMN_EVENT_DVM(CMN700, trk_alloc,		0x0f),
-	CMN_EVENT_DVM(CMN700, trk_cxha_alloc,		0x10),
-	CMN_EVENT_DVM(CMN700, trk_pdn_alloc,		0x11),
-	CMN_EVENT_DVM(CMN700, txsnp_stall_limit,	0x12),
-	CMN_EVENT_DVM(CMN700, rxsnp_stall_starv,	0x13),
-	CMN_EVENT_DVM(CMN700, txsnp_sync_stall_op,	0x14),
+	CMN_EVENT_DVM_OCC(CMN_700ON, trk_occupancy_cxha, 0x0d),
+	CMN_EVENT_DVM_OCC(CMN_700ON, trk_occupancy_pdn,	0x0e),
+	CMN_EVENT_DVM(CMN_700ON, trk_alloc,		0x0f),
+	CMN_EVENT_DVM(CMN_700ON, trk_cxha_alloc,	0x10),
+	CMN_EVENT_DVM(CMN_700ON, trk_pdn_alloc,		0x11),
+	CMN_EVENT_DVM(CMN_700ON, txsnp_stall_limit,	0x12),
+	CMN_EVENT_DVM(CMN_700ON, rxsnp_stall_starv,	0x13),
+	CMN_EVENT_DVM(CMN_700ON, txsnp_sync_stall_op,	0x14),
 
 	CMN_EVENT_HNF(CMN_ANY, cache_miss,		0x01),
 	CMN_EVENT_HNF(CMN_ANY, slc_sf_cache_access,	0x02),


