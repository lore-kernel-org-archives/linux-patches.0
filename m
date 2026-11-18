Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026321;
	b=pu15/iw/kWuNi+UDRjHeHVk/1AEkTNLMSFWVwj9df2LziWgYSpC48damQ1khq3XtRZdY
	 d8zzUsrUTSHJJ4KKHU4u9UryAvisCaejAaRzMr+WtesKhF8pJx95srjcvl1DWYJFs4zPL
	 9gqAvVaBL25bMAsYdv0e9VCpFk36Rivcf4fbUQTisd1f93tTX7lUsEfyM7kE42esMIa6k
	 C7fOodhzpLxNC3NOa6kqJwI8SVoTbeLKSu3qsGTCkHS43CHR8UndHyqRYOzbkPCtak/x5
	 52yTENwiA6u2RKd4cvd16xiQM8JQ5XIHAnpir+hf9hC2gy+ObDyExX+nyP967wB7dow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1zN0h0eYm/jW4fSGPyMNeFGHbhiWvOCBKEmlzQx2JS4=;
	b=F0DzM1hgDbR59n2XSv47t75d5iME5AkbuX3JZsxFugwXkLaaLQuZmUvg5VZnj/5A8PPE
	 47sQPAUf0IdG1tDEsVdi9cERw0XsRGON82CtRjz3la9CP/AJYLWNGBU4HxGVrFgy3D276
	 jnsI9Dz5Qs965f+aNIODMXGfohZQ+m1Ut1bFPMrnKUUBFJLTuE8HBrd4p9CFo5iQ1PwOJ
	 hGzidPmySpeM1PfBuTIjzgoHJ1qYGRSltu1SAe0EyJL3nELg0B7UdT4NOoyaWHUWAgW3/
	 fazScnGQLzmSiwq2ouKqTiaXuF5etA9MebPqNQW6kj74BtBg6KZuNPPK1XYA0mAvkUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bK1910mC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABC4606A325;
	Wed, 18 Nov 2026 18:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bK1910mC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6C51F000C4;
	Wed, 18 Nov 2026 18:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026321;
	bh=1zN0h0eYm/jW4fSGPyMNeFGHbhiWvOCBKEmlzQx2JS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bK1910mCoE1Rl3FzfnTE/jQiuGEfjNhmjAiygaODqnhrf9p2lGlvPAaMJs2B7iiRh
	 IXdr0974ASqojh6hL0E8iy+p8XglTgUSPhr81JGsLy3rUb/PLFoN91mXDyhOiOuxBM
	 FdQTeWyzEIoGegTFJ4FWFWlL5+miyOaO0o/9b6MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Margolin <mrgolin@amazon.com>,
	Tom Sela <tomsela@amazon.com>,
	Yonatan Nachum <ynachum@amazon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1394/2151] RDMA/efa: Fix race between admin command timeout and completion
Date: Wed, 18 Nov 2026 15:52:09 +0100
Message-ID: <20261118150212.777687986@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonatan Nachum <ynachum@amazon.com>

[ Upstream commit 466612f8a8020c6b3af6377c730775a4c630f12c ]

An admin command that times out can race with the interrupt handler
processing its completion, in two ways.

The timeout path releases the completion context without synchronizing
against the handler. A handler that has already seen the command as
submitted then copies the CQE into the caller's response buffer after
the waiter returned and that buffer went out of scope.

The waiter can also observe the command as completed before the CQE was
copied, since the status is published first. It decodes its own
uninitialized response buffer, returns success with garbage contents and
leaks stack data to the caller. Both wait paths read the status without
the CQ lock.

Add a timed-out state and publish it under the CQ lock in both wait
paths before returning, so the handler, which only completes commands in
submitted state, cannot act on an abandoned context. In the interrupt
wait path test the return value of the wait instead of the status: the
handler signals the completion after copying the CQE, so a successful
wait implies a valid response. Read the status in the polling wait path
inside the critical section that drains the CQ, which also lets a
completion arriving on the last iteration be honored instead of reported
as a timeout.

Fixes: 0420e542569b ("RDMA/efa: Implement functions that submit and complete admin commands")
Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Reviewed-by: Tom Sela <tomsela@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
Link: https://patch.msgid.link/20261012165113.576899-1-ynachum@amazon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_com.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 21b9bd1c1fef2..517555760fe30 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -27,6 +27,7 @@ enum efa_cmd_status {
 	EFA_CMD_ALLOCATED,
 	EFA_CMD_SUBMITTED,
 	EFA_CMD_COMPLETED,
+	EFA_CMD_TIMED_OUT,
 };
 
 struct efa_comp_ctx {
@@ -501,6 +502,7 @@ static int efa_com_comp_status_to_errno(u8 comp_status)
 static int efa_com_wait_and_process_admin_cq_polling(struct efa_comp_ctx *comp_ctx,
 						     struct efa_com_admin_queue *aq)
 {
+	bool comp_timeout = false;
 	unsigned long timeout;
 	unsigned long flags;
 
@@ -509,12 +511,19 @@ static int efa_com_wait_and_process_admin_cq_polling(struct efa_comp_ctx *comp_c
 	while (1) {
 		spin_lock_irqsave(&aq->cq.lock, flags);
 		efa_com_handle_admin_completion(aq);
-		spin_unlock_irqrestore(&aq->cq.lock, flags);
-
-		if (comp_ctx->status != EFA_CMD_SUBMITTED)
+		if (comp_ctx->status != EFA_CMD_SUBMITTED) {
+			spin_unlock_irqrestore(&aq->cq.lock, flags);
 			break;
+		}
 
 		if (time_is_before_jiffies(timeout)) {
+			comp_ctx->status = EFA_CMD_TIMED_OUT;
+			comp_timeout = true;
+		}
+
+		spin_unlock_irqrestore(&aq->cq.lock, flags);
+
+		if (comp_timeout) {
 			ibdev_err_ratelimited(
 				aq->efa_dev,
 				"Wait for completion (polling) timeout\n");
@@ -535,10 +544,11 @@ static int efa_com_wait_and_process_admin_cq_polling(struct efa_comp_ctx *comp_c
 static int efa_com_wait_and_process_admin_cq_interrupts(struct efa_comp_ctx *comp_ctx,
 							struct efa_com_admin_queue *aq)
 {
-	unsigned long flags;
+	unsigned long flags, remaining_jiffies;
+	bool completed;
 
-	wait_for_completion_timeout(&comp_ctx->wait_event,
-				    usecs_to_jiffies(aq->completion_timeout));
+	remaining_jiffies = wait_for_completion_timeout(
+		&comp_ctx->wait_event, usecs_to_jiffies(aq->completion_timeout));
 
 	/*
 	 * In case the command wasn't completed find out the root cause.
@@ -546,14 +556,16 @@ static int efa_com_wait_and_process_admin_cq_interrupts(struct efa_comp_ctx *com
 	 * 1) No completion (timeout reached)
 	 * 2) There is completion but the device didn't get any msi-x interrupt.
 	 */
-	if (comp_ctx->status == EFA_CMD_SUBMITTED) {
+	if (remaining_jiffies == 0) {
 		spin_lock_irqsave(&aq->cq.lock, flags);
 		efa_com_handle_admin_completion(aq);
+		completed = (comp_ctx->status == EFA_CMD_COMPLETED);
+		comp_ctx->status = EFA_CMD_TIMED_OUT;
 		spin_unlock_irqrestore(&aq->cq.lock, flags);
 
 		atomic64_inc(&aq->stats.no_completion);
 
-		if (comp_ctx->status == EFA_CMD_COMPLETED)
+		if (completed)
 			ibdev_err_ratelimited(
 				aq->efa_dev,
 				"The device sent a completion but the driver didn't receive any MSI-X interrupt for admin cmd %s(%d) status %d (id: %d, sq producer: %d, sq consumer: %d, cq consumer: %d)\n",
-- 
2.53.0



