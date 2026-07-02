Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10606345CA3;
	Thu,  2 Jul 2026 16:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009532; cv=none; b=ltvjDTmzAlbu8JqjhL5I2aRvsK1FpyAz2lfxYG2cSMaYApLQChaCX2kxTkgjTpNYKrPXpatgpfmMtHsgmW0lctrCxUUU80drSDTIubow2HGuSeFSRrCn0Csuyb2RsbDXl9lBl9502mHSeLmmIoYSxS1UMdLnAPuRKO2R/zO8QC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009532; c=relaxed/simple;
	bh=J1aTt68AO9Orl1LPST8LZ29rOv4GLZHu0Jt4rKR4KgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qri2cJYJPctQ3rzTBkZzqjGWQXLv0VdLOC0L4+j7edab/9muAUB0q7cVFbwoYysSl8aRjZ14D1+J0tXDUZrNBs0pi+E4+9QQgwkaaU4CB2n9alD02NxJB18ghTmE3QgQ8kwp7WJjen6GAtZyS9lcyj5VSjOH53gImMB80xeB4Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOmcM6/6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOmcM6/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD691F00A3A;
	Thu,  2 Jul 2026 16:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009528;
	bh=99b2O+yMtQZA/7QblZJ32ibPj9brfVs25rey2zWlZVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YOmcM6/6fH0mpGb31MicD3m73XQa/66O9TCqETuvEi2q0AWhreE3XiyRcpaDY8ooN
	 VYmQJcdd7DoAp86QC1+h2zFscXSXj8Yc2cRKMNRnmCyNY4ZlGNc7t/UgrvHZvKJWqy
	 iUHwzSeXrdqckipeEepY9qDdU/0X3EaGmfhyFZl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Meyer <kyle.meyer@hpe.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 85/96] bnxt_en: Fix NULL pointer dereference
Date: Thu,  2 Jul 2026 18:20:17 +0200
Message-ID: <20260702155110.766199130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Meyer <kyle.meyer@hpe.com>

[ Upstream commit d930276f2cddd0b7294cac7a8fe7b877f6d9e08d ]

PCIe errors detected by a Root Port or Downstream Port cause error
recovery services to run on all subordinate devices regardless of
administrative state.

The .error_detected() callback, bnxt_io_error_detected(), disables
and synchronizes IRQs via bnxt_disable_int_sync(), which calls
bnxt_cp_num_to_irq_num() to map completion rings to IRQs using
bp->bnapi.

Since bp->bnapi is allocated on NIC open and freed on NIC close, PCIe
error recovery on a closed NIC can dereference a NULL pointer.

Check if bp->bnapi is NULL before disabling and synchronizing IRQs.

Fixes: e5811b8c09df ("bnxt_en: Add IRQ remapping logic.")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/aiNM1CY2-StPilxW@hpe.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4382,7 +4382,7 @@ static void bnxt_disable_int_sync(struct
 {
 	int i;
 
-	if (!bp->irq_tbl)
+	if (!bp->irq_tbl || !bp->bnapi)
 		return;
 
 	atomic_inc(&bp->intr_sem);


