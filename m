Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B609947127E;
	Tue, 21 Jul 2026 18:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659195; cv=none; b=fVqevPxyNMx43mq0fpZzTNwkZ/Priy+pV6aMdUiRtmxINtt4rmjOZGPkU8fTuCfvncBLFACIh1f10aUrhwWg/3iq2lPpOSq6le9665QRPxa+2Upb3GKPyKAIyeGEcHLUjAPPIBFWJt+HooeY2EHD077ItRS9+OmS8FQyEwb38RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659195; c=relaxed/simple;
	bh=dJOfBiqmtM2cEg2fugNsZxOc0HS9uYTOuQkpD5HL4dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5DEoZugbEWtlPJxeAcEWUNZC4w85kc0DY3sJ9AMUoC4gemeMSMwaRatsQuqTFvqfI6e8N56qwg7VCC0EVDsHFak8ZqURnsgJOu/mYSowWG8g9hRLQSoyeOhMplVSO6GZ+9zrmWgr8ol5JThY7CjQYV9wpUa3866ICuWGuH1BcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHaOOusp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHaOOusp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E0A1F000E9;
	Tue, 21 Jul 2026 18:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659194;
	bh=pilGDXUEANRnhib2ObSiaWN204JPLAnd7rqi1bDpIfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LHaOOusp7kmfwTmPRyYp8jOV9hEXUlyjbNzmDgeVozk1dPITL2Xg7MHvmuCMWoMG1
	 7vvxqXSJzRv7DRgT3yCnpuBU4eQAJ59rhlsgtmy8bKUlIhgikRQqw2EuKq9S6+z40V
	 8VkqTOpMYQwXlzupnXaN5YB9+C7Xi+uFUUNYPjdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1428/1611] bnx2x: fix potential memory leak in bnx2x_alloc_mem_bp()
Date: Tue, 21 Jul 2026 17:25:44 +0200
Message-ID: <20260721152547.555464503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit a986fde914d88af47eb78fd29c5d1af7952c3500 upstream.

If the allocation of fp[i].tpa_info fails, the error path will not free
the struct bnx2x_fastpath allocated earlier, as it is not linked to the
bp structure yet. Fix that by linking it immediately after allocation.

Cc: stable@vger.kernel.org
Fixes: 15192a8cf8a8 ("bnx2x: Split the FP structure")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260620062402.89549-1-nihaal@cse.iitm.ac.in
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4750,6 +4750,7 @@ int bnx2x_alloc_mem_bp(struct bnx2x *bp)
 	fp = kcalloc(bp->fp_array_size, sizeof(*fp), GFP_KERNEL);
 	if (!fp)
 		goto alloc_err;
+	bp->fp = fp;
 	for (i = 0; i < bp->fp_array_size; i++) {
 		fp[i].tpa_info =
 			kcalloc(ETH_MAX_AGGREGATION_QUEUES_E1H_E2,
@@ -4758,8 +4759,6 @@ int bnx2x_alloc_mem_bp(struct bnx2x *bp)
 			goto alloc_err;
 	}
 
-	bp->fp = fp;
-
 	/* allocate sp objs */
 	bp->sp_objs = kcalloc(bp->fp_array_size, sizeof(struct bnx2x_sp_objs),
 			      GFP_KERNEL);


