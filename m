Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C5534CC3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B81EC433EF;
	Wed,  7 Jun 2023 20:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170687;
	bh=7L8cY1/FfTpIww6poA0DK9pAvBkFIbJCwCOQD29Wgns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZRq4l8aQ+PJ76gEH6lVHWEuMSA3G0SGUrWULFPO5RLrR+CvtEd964391io3mDTmR
	 Svh6Z1r7iVbWIdUCJKAEcNcbDFMjBiEVIxfxHNB0/HDbnJvyjEpQleaaPoziWGabc2
	 YFhMXbiHvZKwMsXqy+7a1BtJtyKZVBpRkMYqSh7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Batra <gbatra@linux.vnet.ibm.com>,
	Brian King <brking@linux.vnet.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.1 179/225] powerpc/iommu: Limit number of TCEs to 512 for H_STUFF_TCE hcall
Date: Wed,  7 Jun 2023 22:16:12 +0200
Message-ID: <20230607200920.240520581@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaurav Batra <gbatra@linux.vnet.ibm.com>

commit 9d2ccf00bddc268045e3d65a8108d61ada0e4b4e upstream.

Currently in tce_freemulti_pSeriesLP() there is no limit on how many
TCEs are passed to the H_STUFF_TCE hcall. This has not caused an issue
until now, but newer firmware releases have started enforcing a limit of
512 TCEs per call.

The limit is correct per the specification (PAPR v2.12 § 14.5.4.2.3).

The code has been in it's current form since it was initially merged.

Cc: stable@vger.kernel.org
Signed-off-by: Gaurav Batra <gbatra@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
[mpe: Tweak change log wording & add PAPR reference]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230525143454.56878-1-gbatra@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/iommu.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -311,13 +311,22 @@ static void tce_free_pSeriesLP(unsigned
 static void tce_freemulti_pSeriesLP(struct iommu_table *tbl, long tcenum, long npages)
 {
 	u64 rc;
+	long rpages = npages;
+	unsigned long limit;
 
 	if (!firmware_has_feature(FW_FEATURE_STUFF_TCE))
 		return tce_free_pSeriesLP(tbl->it_index, tcenum,
 					  tbl->it_page_shift, npages);
 
-	rc = plpar_tce_stuff((u64)tbl->it_index,
-			     (u64)tcenum << tbl->it_page_shift, 0, npages);
+	do {
+		limit = min_t(unsigned long, rpages, 512);
+
+		rc = plpar_tce_stuff((u64)tbl->it_index,
+				     (u64)tcenum << tbl->it_page_shift, 0, limit);
+
+		rpages -= limit;
+		tcenum += limit;
+	} while (rpages > 0 && !rc);
 
 	if (rc && printk_ratelimit()) {
 		printk("tce_freemulti_pSeriesLP: plpar_tce_stuff failed\n");


