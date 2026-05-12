Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0181436604C;
	Tue, 12 May 2026 18:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609203; cv=none; b=TpIQnY7Lyxz8bBvs4+NyqvZnDzHzUPL5bb3BKzP6W4fIJA2XLPllH+MADR0v4nLOUYMciGhCX4a6c2qZxh0vNOg18y9KxFxwBcuWJvbvZKQtMIkOF5+4RpsBt/WRYTyfwEHrBEkjTeb/Sud3f/9Tiz8bq5sJ01t1uXmir5xwwGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609203; c=relaxed/simple;
	bh=/uYWQ8uoBdnMWY5yBto8bMp089qb8mnHsgQG9t2BPSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLksmwsi99cTlLcvx9YJ5QhZjv9TJc4+3Cu+ks3t3R2CqMXMOAx0mMQWLFu7JkFpfk/c2RZRiLTB0OMjjKkYuqKm/kHR3YsS/fbI99ylLeeppaubUPFXpGXIiHcugNOSrxKuX+RfgqSNukbGZpnsGJ6iFgr/6bHtWjaxCzs5Y3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBUba2bF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBUba2bF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E40C2BCFB;
	Tue, 12 May 2026 18:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609202;
	bh=/uYWQ8uoBdnMWY5yBto8bMp089qb8mnHsgQG9t2BPSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBUba2bF3Cdjg4VXZOBUZ4Kzn52+85y1O23hDhOFg5XAfjLx/yMXv7M3FzHF8WS/p
	 Sm0GoQaZvH7VakHfkCXlTL3l7ctruDhaEmgGxAULyenZxGr97LtkSkotJdhPVK4BLC
	 2omUaVYIQXjGacX66mJNrIesIOkEu2RoseeFEu4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Vyukov <dvyukov@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 7.0 103/307] rseq: Set rseq::cpu_id_start to 0 on unregistration
Date: Tue, 12 May 2026 19:38:18 +0200
Message-ID: <20260512173942.299789359@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@kernel.org>

commit 2cb68e45120dfc66404c7547d95b8ac6ff0b25ce upstream.

The RSEQ rework changed that to RSEQ_CPU_UNINITILIZED, which is obviously
incompatible. Revert back to the original behavior.

Fixes: 0f085b41880e ("rseq: Provide and use rseq_set_ids()")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Link: https://patch.msgid.link/20260428224427.271566313%40kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rseq.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -236,11 +236,6 @@ static int __init rseq_debugfs_init(void
 }
 __initcall(rseq_debugfs_init);
 
-static bool rseq_set_ids(struct task_struct *t, struct rseq_ids *ids, u32 node_id)
-{
-	return rseq_set_ids_get_csaddr(t, ids, node_id, NULL);
-}
-
 static bool rseq_handle_cs(struct task_struct *t, struct pt_regs *regs)
 {
 	struct rseq __user *urseq = t->rseq.usrptr;
@@ -384,19 +379,22 @@ void rseq_syscall(struct pt_regs *regs)
 
 static bool rseq_reset_ids(void)
 {
-	struct rseq_ids ids = {
-		.cpu_id		= RSEQ_CPU_ID_UNINITIALIZED,
-		.mm_cid		= 0,
-	};
+	struct rseq __user *rseq = current->rseq.usrptr;
 
 	/*
 	 * If this fails, terminate it because this leaves the kernel in
 	 * stupid state as exit to user space will try to fixup the ids
 	 * again.
 	 */
-	if (rseq_set_ids(current, &ids, 0))
-		return true;
+	scoped_user_rw_access(rseq, efault) {
+		unsafe_put_user(0, &rseq->cpu_id_start, efault);
+		unsafe_put_user(RSEQ_CPU_ID_UNINITIALIZED, &rseq->cpu_id, efault);
+		unsafe_put_user(0, &rseq->node_id, efault);
+		unsafe_put_user(0, &rseq->mm_cid, efault);
+	}
+	return true;
 
+efault:
 	force_sig(SIGSEGV);
 	return false;
 }


