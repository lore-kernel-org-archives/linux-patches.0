Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF434314A8;
	Thu, 16 Jul 2026 14:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212209; cv=none; b=P41POyRrZVr7hN1PfCaVtqG1iQgsUSWtOlpuzLgg4rU1tc2C7An6j+zgKvbwMhreiR0zlDc4AVqIDrnsv5QDT5Sal9o1TznC0KMNRQUOdDQAX+CTQ2sfbTYWlNQXwsHdPl8n4A6jlvJvIzAgnOsfFkyKFXJ9j9J6tkbcR399vu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212209; c=relaxed/simple;
	bh=gp3AUb2lfD0nUzEOj2ee6uzRqsIOOxOlNla51EEIvrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdZ9+lZIc22t/GcLrvkCI3JtPDeaTBeJB1iogJUrO6QQ955zIpYvCBLJJpzXg12BeRZQ6ZGF/I2NOrf2hCD2zVz8XB1n/0VAF2H8ka+XVYP9xjkfLs1n+Svmj3QVcrAECtldlIrrg7rT+Vf5Jg2gD2sLEu4CnoGA8BC+y2QwJvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=US3yapns; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="US3yapns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CD51F00A3D;
	Thu, 16 Jul 2026 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212208;
	bh=EDnL3AL0r8lUsaUdcmatzG5vHqH81+be0YkdXACM8WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=US3yapns0LwkscVcMBkcDvCOnupftQj8bhX1V6vjGt9sZC4auVyIfUH9IArC09ajE
	 I6SnNMxtKBr80fQZeWk4swzBDuOiMuByYgW/f88TstIw8gidHUqb07KeNpTAu+m8uH
	 XPUv0Iybk03qGZ27RK3aVPxtJSwm4CKOwjiRogJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 197/349] perf/arm-cmn: Fix DVM node events
Date: Thu, 16 Jul 2026 15:32:11 +0200
Message-ID: <20260716133037.781278901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -921,14 +922,14 @@ static struct attribute *arm_cmn_event_a
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


