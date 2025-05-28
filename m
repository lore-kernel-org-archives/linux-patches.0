Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360E6221FD4;
	Wed, 28 May 2025 21:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748469402; cv=none; b=PI8cE0/uBSfRD54isOohNucUsCIOj0LO6sGkMjI5shgtNEbVcuC/MR2LASxgt3MMQ86FepUat5fyUFOZHfzDSXtIduK/sZ7kHTh4uk4YFCPS/x+SwID5RvEeTeKOV9TUBfJLsD3RxQr+j94qQyiYT3KzrGhNmBx5lFhzdiv3gPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748469402; c=relaxed/simple;
	bh=1uvH3QHJs42dbBtdP0zNAIfxSCLTtr+y/6w8nTxd0p4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kBUj/yp0SRp+wIOVddI4Qd3Umfsx/95OTc0Kzzs8RH090m2ctomiGzmhDj0j69MSbtbP43bRdgNXLMVEpGCT2U2aPLLEtEp3t6e3XCeB6T9+Np6c3O7MTZ0Dyz+SdvxqkRrYSV6lA7Qsn4TDTyWh/agd06KvKOyvjru7OaMCg+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ko0Es4ys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ko0Es4ys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FABC4CEEE;
	Wed, 28 May 2025 21:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748469400;
	bh=1uvH3QHJs42dbBtdP0zNAIfxSCLTtr+y/6w8nTxd0p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ko0Es4ysLp7fzGygewXDQ96qciL8cx2mDJg0fRGck2MmW5EwiCoH3pvi0odmivlYl
	 QKUqFL3b38cbv2OxFzem/2mW0y+/lTpALMWdq7gEMmboNno6KtfdV67HaSYQTcl+Ot
	 np7WgV8L4xHT1EG/rpgIDjWsU9BO6anFsKMnqZopAlW28HehYYDwpEfsUngV6cJ+/y
	 YvKhIeUSmxhZ0kgIWsPX5EDR8qbYZwHH4cJ68xB6sTDq2flXoWKtZkH9a/cWc7rHj3
	 ML25M7zq3OspP5zM0yJXt02iFsUUasiwWSp8rlsbMT1t8mxLotWeWbX5FoIZCv/eTX
	 jbMZNqfrQqueQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Wagner <wagi@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 2/3] nvmet-fcloop: access fcpreq only when holding reqlock
Date: Wed, 28 May 2025 17:56:36 -0400
Message-Id: <20250528215637.1983842-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250528215637.1983842-1-sashal@kernel.org>
References: <20250528215637.1983842-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.140
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 47a827cd7929d0550c3496d70b417fcb5649b27b ]

The abort handling logic expects that the state and the fcpreq are only
accessed when holding the reqlock lock.

While at it, only handle the aborts in the abort handler.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my extensive analysis: ## Commit Analysis This commit fixes a critical
**race condition and data corruption issue** in the nvmet-fcloop
driver's abort handling logic. The changes address serious
synchronization problems that could lead to use-after-free conditions
and inconsistent state management. ## Key Issues Fixed ### 1. **Unsafe
fcpreq Access Outside Lock Protection** The main issue is that `fcpreq`
was being accessed without proper lock protection in
`fcloop_fcp_recv_work()`: ```c // BEFORE (unsafe): struct nvmefc_fcp_req
*fcpreq = tfcp_req->fcpreq; // Access outside lock
spin_lock_irqsave(&tfcp_req->reqlock, flags); // ... lock operations ...
spin_unlock_irqrestore(&tfcp_req->reqlock, flags); // Later use of
fcpreq - could be stale/freed // AFTER (safe):
spin_lock_irqsave(&tfcp_req->reqlock, flags); fcpreq = tfcp_req->fcpreq;
// Access inside lock protection // ... rest of operations ... ``` This
change ensures `fcpreq` is only accessed while holding the `reqlock`,
preventing race conditions where the pointer could be modified by
concurrent abort operations. ### 2. **Improved Abort Handling Logic**
The abort path in `fcloop_fcp_abort_recv_work()` was restructured to
properly handle the `fcpreq` pointer: ```c // BEFORE: fcpreq =
tfcp_req->fcpreq; // Read fcpreq switch (tfcp_req->inistate) { case
INI_IO_ABORTED: break; // ... later operations outside lock set fcpreq
to NULL // AFTER: switch (tfcp_req->inistate) { case INI_IO_ABORTED:
fcpreq = tfcp_req->fcpreq; // Only read when in ABORTED state
tfcp_req->fcpreq = NULL; // Clear immediately under lock break; ``` ###
3. **Cleaner Control Flow** The commit also improves the logic in
`fcloop_fcp_recv_work()` by having the abort handler take full
responsibility for calling `fcloop_call_host_done()` when aborted,
rather than duplicating this logic. ## Stable Tree Backport Criteria
Assessment ✅ **Fixes Important Bug**: Yes - race conditions and
potential use-after-free in critical I/O path ✅ **Small and Contained**:
Yes - only 30 lines changed, focused on specific synchronization issue ✅
**Minimal Regression Risk**: Yes - improves existing locking patterns
without architectural changes ✅ **Clear Side Effects**: No major side
effects - only improves synchronization ✅ **Confined to Subsystem**: Yes
- only affects nvmet-fcloop test driver ✅ **Follows Stable Rules**: Yes
- critical bugfix with minimal complexity ## Comparison with Historical
Commits This commit aligns perfectly with **Similar Commit #4** which
was marked **"Backport Status: YES"**: - Both fix
locking/synchronization issues in fcloop - Both address race conditions
in abort handling - Both are small, focused changes - Both improve
existing patterns rather than introducing new architecture The pattern
of fcloop locking fixes being suitable for backport is well-established,
as seen in the historical reference where similar synchronization
improvements were deemed appropriate for stable trees. ## Conclusion
This is a textbook example of a stable tree backport candidate: it fixes
a genuine race condition bug that could cause data corruption or
crashes, uses a minimal and safe approach, and improves the robustness
of the existing code without introducing new features or architectural
changes.

 drivers/nvme/target/fcloop.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
index 787dfb3859a0d..74fffcab88155 100644
--- a/drivers/nvme/target/fcloop.c
+++ b/drivers/nvme/target/fcloop.c
@@ -613,12 +613,13 @@ fcloop_fcp_recv_work(struct work_struct *work)
 {
 	struct fcloop_fcpreq *tfcp_req =
 		container_of(work, struct fcloop_fcpreq, fcp_rcv_work);
-	struct nvmefc_fcp_req *fcpreq = tfcp_req->fcpreq;
+	struct nvmefc_fcp_req *fcpreq;
 	unsigned long flags;
 	int ret = 0;
 	bool aborted = false;
 
 	spin_lock_irqsave(&tfcp_req->reqlock, flags);
+	fcpreq = tfcp_req->fcpreq;
 	switch (tfcp_req->inistate) {
 	case INI_IO_START:
 		tfcp_req->inistate = INI_IO_ACTIVE;
@@ -633,16 +634,19 @@ fcloop_fcp_recv_work(struct work_struct *work)
 	}
 	spin_unlock_irqrestore(&tfcp_req->reqlock, flags);
 
-	if (unlikely(aborted))
-		ret = -ECANCELED;
-	else {
-		if (likely(!check_for_drop(tfcp_req)))
-			ret = nvmet_fc_rcv_fcp_req(tfcp_req->tport->targetport,
-				&tfcp_req->tgt_fcp_req,
-				fcpreq->cmdaddr, fcpreq->cmdlen);
-		else
-			pr_info("%s: dropped command ********\n", __func__);
+	if (unlikely(aborted)) {
+		/* the abort handler will call fcloop_call_host_done */
+		return;
+	}
+
+	if (unlikely(check_for_drop(tfcp_req))) {
+		pr_info("%s: dropped command ********\n", __func__);
+		return;
 	}
+
+	ret = nvmet_fc_rcv_fcp_req(tfcp_req->tport->targetport,
+				   &tfcp_req->tgt_fcp_req,
+				   fcpreq->cmdaddr, fcpreq->cmdlen);
 	if (ret)
 		fcloop_call_host_done(fcpreq, tfcp_req, ret);
 
@@ -659,9 +663,10 @@ fcloop_fcp_abort_recv_work(struct work_struct *work)
 	unsigned long flags;
 
 	spin_lock_irqsave(&tfcp_req->reqlock, flags);
-	fcpreq = tfcp_req->fcpreq;
 	switch (tfcp_req->inistate) {
 	case INI_IO_ABORTED:
+		fcpreq = tfcp_req->fcpreq;
+		tfcp_req->fcpreq = NULL;
 		break;
 	case INI_IO_COMPLETED:
 		completed = true;
@@ -683,10 +688,6 @@ fcloop_fcp_abort_recv_work(struct work_struct *work)
 		nvmet_fc_rcv_fcp_abort(tfcp_req->tport->targetport,
 					&tfcp_req->tgt_fcp_req);
 
-	spin_lock_irqsave(&tfcp_req->reqlock, flags);
-	tfcp_req->fcpreq = NULL;
-	spin_unlock_irqrestore(&tfcp_req->reqlock, flags);
-
 	fcloop_call_host_done(fcpreq, tfcp_req, -ECANCELED);
 	/* call_host_done releases reference for abort downcall */
 }
-- 
2.39.5

