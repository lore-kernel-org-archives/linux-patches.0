Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216400;
	b=RObH77AVG8N+1dXHFzGgYaGDVX9NcC3qcCN5S1RtlbekDPI52Vfn60q1AZrO7gFPbVXP
	 e5Go9R4pH6vZc9dVDtGNKZZFWpN70p7JxrPGrS9y4vq2dzGHetdbXPc7f8NZni9yujSVx
	 TF4JD0UYnXfLRRk7VRBP4jOsowCbZPTBw/oLKcR0ikOStYO0lpgpeECDUMUdnMxTHi4m6
	 NTnGMr+CGqndYWD31TH+iYJPetVuKIYMcnn/SkBtPw93irxgwEFyNeTU113GzpfZ/EJ6S
	 EE5sCFp62jlYHeoMPfvvDLILXqHeu3mf2IgRJdTZXbbVlE0RqLMWP0PaeTqPwYy2rpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iCbf784WUyZZ5uSLYvkFtlqSE/2Ejj4wb5rze18Mub8=;
	b=0LPy5iennOfN41l1ztVs6OVTmsnIw6h65IL/KUiQ1x6O+ammr4vDr8fwFtutdHBafWGf
	 VigvyzWweeh6cFdXUwaxJ3cThkdPCPMcU9JMesGalT/nduZd39WO8yqvYQ5S5OrGfvjD/
	 +lgp60dH/DvAvn/8FgKw3HsujjIOhV/FqbT6B8d5kzBXJ4E4z+Z7Yh6yGpp+r1FBsrBJn
	 kgnf18u3UxW4lzoE/ey7fQEjwDM3+8pDghjyRe1HAjuDhfbv2YX0HzWZSKO+a3FHzkXwo
	 cdL2kNFAkGzroKRRJIrXa0GLGQXAlJ0+cIgT9iHw/UdScIqL9QAjTjOo9OWADPFULdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K7FEytEu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310E8606A31C;
	Wed, 28 Oct 2026 19:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K7FEytEu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554EB1F01825;
	Wed, 28 Oct 2026 19:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216399;
	bh=iCbf784WUyZZ5uSLYvkFtlqSE/2Ejj4wb5rze18Mub8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7FEytEuBNckKwYNIM7hYnIIGfHkTGQbb0IsviW3HjdwYv38psdUZLlVtiCeZ2Fk1
	 +oOFC4m4P8P2q6iOBAXmL6RM885/zHNR6FZZAqBosLbZLYRZlnkAgs/KEjcArghSZx
	 D683xqcVw/w0xz+O8YCNBMiG4IwcKmbyn8evxAKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunseong Kim <yunseong.kim@est.tech>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1542/1887] ksmbd: serialize oplock close with pending break ownership
Date: Wed, 28 Oct 2026 18:00:38 +0100
Message-ID: <20261028170534.557629563@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit b0148dc5625dbfd50596ac63c7487c12e8a8ab03 ]

close may abort an in-flight oplock break while another breaker already
holds an opinfo reference. Releasing pending_break wakes that waiter, but
without serializing the close transition with bit acquisition it can become
a new break owner through the test_and_set_bit() fast path. It can then
overwrite OPLOCK_CLOSING with OPLOCK_ACK_WAIT and continue a break for
a dying opinfo.

Make OPLOCK_CLOSING terminal once the opinfo is removed from the inode
list. Serialize that transition, pending_break acquisition, and
OPLOCK_ACK_WAIT setup with an opinfo state lock. A breaker which loses
the race releases its ownership and returns -ENOENT. Explicitly wake
pending_break waiters during close so they can observe the terminal state.

Also prevent ACK and timeout paths from replacing OPLOCK_CLOSING with
OPLOCK_STATE_NONE.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Co-developed-by: Yunseong Kim <yunseong.kim@est.tech>
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c  | 81 ++++++++++++++++++++++++++++++++++-------
 fs/smb/server/oplock.h  |  1 +
 fs/smb/server/smb2pdu.c | 12 ++++--
 3 files changed, 77 insertions(+), 17 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index a81c56b3fe965..64724b371e5f1 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -41,6 +41,7 @@ static struct oplock_info *alloc_opinfo(struct ksmbd_work *work,
 	opinfo->conn = ksmbd_conn_get(work->conn);
 	opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
 	opinfo->op_state = OPLOCK_STATE_NONE;
+	spin_lock_init(&opinfo->state_lock);
 	opinfo->pending_break = 0;
 	opinfo->fid = id;
 	opinfo->Tid = Tid;
@@ -405,14 +406,23 @@ void close_id_del_oplock(struct ksmbd_file *fp)
 	opinfo_del(opinfo);
 
 	rcu_assign_pointer(fp->f_opinfo, NULL);
-	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
-		opinfo->op_state = OPLOCK_CLOSING;
-		wake_up_interruptible_all(&opinfo->oplock_q);
-		if (opinfo->is_lease) {
-			atomic_set(&opinfo->breaking_cnt, 0);
-			wake_up_interruptible_all(&opinfo->oplock_brk);
-		}
-	}
+	spin_lock(&opinfo->state_lock);
+	if (opinfo->op_state == OPLOCK_ACK_WAIT && opinfo->is_lease)
+		atomic_set(&opinfo->breaking_cnt, 0);
+	/*
+	 * An opinfo that has been removed from the inode list is terminal. Keep
+	 * this transition and releasing pending_break under state_lock. a breaker
+	 * takes the same lock before it acquires pending_break or sets ACK_WAIT.
+	 */
+	opinfo->op_state = OPLOCK_CLOSING;
+	clear_bit_unlock(0, &opinfo->pending_break);
+	spin_unlock(&opinfo->state_lock);
+	wake_up_interruptible_all(&opinfo->oplock_q);
+	if (opinfo->is_lease)
+		wake_up_interruptible_all(&opinfo->oplock_brk);
+	/* memory barrier is needed for wake_up_bit() */
+	smp_mb__after_atomic();
+	wake_up_bit(&opinfo->pending_break, 0);
 
 	opinfo_count_dec(fp);
 	atomic_dec(&opinfo->refcount);
@@ -591,10 +601,16 @@ static void wait_for_break_ack(struct oplock_info *opinfo)
 
 	/* is this a timeout ? */
 	if (!rc) {
+		spin_lock(&opinfo->state_lock);
+		if (opinfo->op_state == OPLOCK_CLOSING) {
+			spin_unlock(&opinfo->state_lock);
+			return;
+		}
 		if (opinfo->is_lease)
 			opinfo->o_lease->state = SMB2_LEASE_NONE_LE;
 		opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
 		opinfo->op_state = OPLOCK_STATE_NONE;
+		spin_unlock(&opinfo->state_lock);
 	}
 }
 
@@ -606,17 +622,46 @@ static void wake_up_oplock_break(struct oplock_info *opinfo)
 	wake_up_bit(&opinfo->pending_break, 0);
 }
 
+static bool oplock_break_set_ack_wait(struct oplock_info *opinfo)
+{
+	bool ret = false;
+
+	spin_lock(&opinfo->state_lock);
+	if (opinfo->op_state != OPLOCK_CLOSING) {
+		opinfo->op_state = OPLOCK_ACK_WAIT;
+		ret = true;
+	}
+	spin_unlock(&opinfo->state_lock);
+
+	return ret;
+}
+
 static int oplock_break_pending(struct oplock_info *opinfo, int req_op_level)
 {
-	while (test_and_set_bit(0, &opinfo->pending_break)) {
+	for (;;) {
+		bool closing;
+
+		spin_lock(&opinfo->state_lock);
+		closing = opinfo->op_state == OPLOCK_CLOSING;
+		if (!closing && !test_and_set_bit(0, &opinfo->pending_break)) {
+			spin_unlock(&opinfo->state_lock);
+			break;
+		}
+		spin_unlock(&opinfo->state_lock);
+		if (closing)
+			return -ENOENT;
+
 		wait_on_bit(&opinfo->pending_break, 0, TASK_UNINTERRUPTIBLE);
 
 		/* Not immediately break to none. */
 		opinfo->open_trunc = 0;
 
-		if (opinfo->op_state == OPLOCK_CLOSING)
+		spin_lock(&opinfo->state_lock);
+		closing = opinfo->op_state == OPLOCK_CLOSING;
+		spin_unlock(&opinfo->state_lock);
+		if (closing)
 			return -ENOENT;
-		else if (opinfo->level <= req_op_level) {
+		if (opinfo->level <= req_op_level) {
 			if (opinfo->is_lease == false)
 				return 1;
 
@@ -938,7 +983,11 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 				release_async_work(in_work);
 			}
 
-			brk_opinfo->op_state = OPLOCK_ACK_WAIT;
+			if (!oplock_break_set_ack_wait(brk_opinfo)) {
+				atomic_dec_if_positive(&brk_opinfo->breaking_cnt);
+				wake_up_oplock_break(brk_opinfo);
+				return -ENOENT;
+			}
 		} else
 			atomic_dec(&brk_opinfo->breaking_cnt);
 	} else {
@@ -947,8 +996,12 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 			return err < 0 ? err : 0;
 
 		if (brk_opinfo->level == SMB2_OPLOCK_LEVEL_BATCH ||
-		    brk_opinfo->level == SMB2_OPLOCK_LEVEL_EXCLUSIVE)
-			brk_opinfo->op_state = OPLOCK_ACK_WAIT;
+		    brk_opinfo->level == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
+			if (!oplock_break_set_ack_wait(brk_opinfo)) {
+				wake_up_oplock_break(brk_opinfo);
+				return -ENOENT;
+			}
+		}
 	}
 
 	if (brk_opinfo->is_lease)
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index 1890e7f82427e..a631006fc50d9 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -66,6 +66,7 @@ struct oplock_info {
 	struct ksmbd_file	*o_fp;
 	int                     level;
 	int                     op_state;
+	spinlock_t		state_lock;
 	unsigned long		pending_break;
 	u64			fid;
 	atomic_t		breaking_cnt;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ea28cc5524c7c..5b94db6480ad9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8392,7 +8392,10 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 	smb2_set_err_rsp(work);
 
 out:
-	opinfo->op_state = OPLOCK_STATE_NONE;
+	spin_lock(&opinfo->state_lock);
+	if (opinfo->op_state != OPLOCK_CLOSING)
+		opinfo->op_state = OPLOCK_STATE_NONE;
+	spin_unlock(&opinfo->state_lock);
 	wake_up_interruptible_all(&opinfo->oplock_q);
 	opinfo_put(opinfo);
 	ksmbd_fd_put(work, fp);
@@ -8538,9 +8541,12 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 		smb2_set_err_rsp(work);
 	}
 
-	opinfo->op_state = OPLOCK_STATE_NONE;
+	spin_lock(&opinfo->state_lock);
+	if (opinfo->op_state != OPLOCK_CLOSING)
+		opinfo->op_state = OPLOCK_STATE_NONE;
+	spin_unlock(&opinfo->state_lock);
 	wake_up_interruptible_all(&opinfo->oplock_q);
-	atomic_dec(&opinfo->breaking_cnt);
+	atomic_dec_if_positive(&opinfo->breaking_cnt);
 	wake_up_interruptible_all(&opinfo->oplock_brk);
 	opinfo_put(opinfo);
 }
-- 
2.53.0



