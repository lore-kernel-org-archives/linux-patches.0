Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB124EE842;
	Tue, 13 Oct 2026 11:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892238; cv=none; b=Nol263RQPyy4q8y5OUCTLHeqSTssK38eMa86zyXwqnKRN79WZD9oIcDpp3oBOx/sRKCEiEQz3ZpRg4COGAsBV/utI7eCgqAUX47ilISkT4J7V+gYyC/zqi0E9IRS76OENzI9MXSeYv9Ho8v7Qgr0PM+DgzufKWeiTDlo9qVCdPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892238; c=relaxed/simple;
	bh=NVdO0qSz3AZDICO3KzjSbbsolzOMCM9h4HEH92LRI2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tq76XzQpS1DuEHrVtUCePj2pV9ytDFba27YevRv7FGDb5rqycUlCLGGgRT/vtBPnaW4Dv/pTKHTCqnaZx+Woko8CMAMTER5VO3r/4K+AdrOn8R/EWJKUCSshoI33Z+Zx2p7vxfoil2Dle5cMlu4pVOLLGDoxNrzBSuV7BMBvaCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1lxfLhcs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1lxfLhcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8671F000FF;
	Tue, 13 Oct 2026 11:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892237;
	bh=fd2XOkCqBnUPaPTY9DvTZE7VX7LHJEUNtasq+MHTc9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1lxfLhcso2ZuBgb60n6Zk8x0p9MXTS5pELv4D45G96lVkTdeJIr1O49/37Y/rpoTg
	 QuRsUDkkl5zi8rvt0scTFQtHn3aciJ8PGnTC2IGYyzfYoGGJ0/zWlWoZEmeRtieUmu
	 GAzj265ew7Bm80IKL2/Q1ey64F8PP48Di3Av4y5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Stanley Jhu <stanleyjhu@google.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 105/281] scsi: ufs: core: Decouple CQ sweep from request iterator in MCQ
Date: Tue, 13 Oct 2026 13:37:01 +0200
Message-ID: <20261013112857.690426376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Jhu <stanleyjhu@google.com>

commit 469fa055664bfd8717b087a80d59c03055789c17 upstream.

In MCQ mode, ufshcd_mcq_compl_pending_transfer() uses
blk_mq_tagset_busy_iter() to iterate over busy requests during error
recovery and host reset. However, both iterator callbacks perform
whole-queue operations redundantly for each visited request:

 - force_compl == true: ufshcd_mcq_force_compl_one() calls
   ufshcd_mcq_compl_all_cqes_lock() on every busy request, sweeping the
   entire completion ring (hwq->max_entries slots) once per active request
   under spin_lock_irqsave even though the first sweep already cleared all
   completion entries.

 - force_compl == false: ufshcd_mcq_compl_one() acquires cq_lock and polls
   CQTPy over MMIO via ufshcd_mcq_poll_cqe_lock() for every busy request
   without doing any per-request work.

Sweep or poll each hardware queue (hba->uhq[i]) once at the start of
ufshcd_mcq_compl_pending_transfer(). When force_compl is true, run
blk_mq_tagset_busy_iter() afterward to complete residual in-flight
requests with DID_REQUEUE, and remove the now-unused
ufshcd_mcq_compl_one() callback.

Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Cc: stable@vger.kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/20260928035816.1294326-3-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |   31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5975,8 +5975,6 @@ static bool ufshcd_mcq_force_compl_one(s
 	if (blk_mq_is_reserved_rq(rq) || !hwq)
 		return true;
 
-	ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
-
 	/*
 	 * For those cmds of which the cqes are not present in the cq, complete
 	 * them explicitly.
@@ -5992,19 +5990,6 @@ static bool ufshcd_mcq_force_compl_one(s
 	return true;
 }
 
-static bool ufshcd_mcq_compl_one(struct request *rq, void *priv)
-{
-	struct scsi_device *sdev = rq->q->queuedata;
-	struct Scsi_Host *shost = sdev->host;
-	struct ufs_hba *hba = shost_priv(shost);
-	struct ufs_hw_queue *hwq = ufshcd_mcq_req_to_hwq(hba, rq);
-
-	if (!blk_mq_is_reserved_rq(rq) && hwq)
-		ufshcd_mcq_poll_cqe_lock(hba, hwq);
-
-	return true;
-}
-
 /**
  * ufshcd_mcq_compl_pending_transfer - MCQ mode function. It is
  * invoked from the error handler context or ufshcd_host_reset_and_restore()
@@ -6019,10 +6004,18 @@ static bool ufshcd_mcq_compl_one(struct
 static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
 					      bool force_compl)
 {
-	blk_mq_tagset_busy_iter(&hba->host->tag_set,
-				force_compl ? ufshcd_mcq_force_compl_one :
-					      ufshcd_mcq_compl_one,
-				NULL);
+	int i;
+
+	for (i = 0; i < hba->nr_hw_queues; i++) {
+		if (force_compl)
+			ufshcd_mcq_compl_all_cqes_lock(hba, &hba->uhq[i]);
+		else
+			ufshcd_mcq_poll_cqe_lock(hba, &hba->uhq[i]);
+	}
+
+	if (force_compl)
+		blk_mq_tagset_busy_iter(&hba->host->tag_set,
+					ufshcd_mcq_force_compl_one, NULL);
 }
 
 /**


