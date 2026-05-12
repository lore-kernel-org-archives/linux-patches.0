Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5850D33ADBA;
	Tue, 12 May 2026 18:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609205; cv=none; b=msaurBvB/8lu8sxL7qNuZDOKrBjSgwLQkJvGMrDKdfxu+mF1ABDGUNfW1d/sqL1zWdILWmluvMTtqwKIIzuJ4N9B3bdBamGG5sYp7a7e38bSauVMu117tltS2yc+7FQLIwX+6cCfLTeOHN6co287ggvBxlXzYKulMV8pmhVF3pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609205; c=relaxed/simple;
	bh=ccFcH7UM7U6cJcwhEGYgPVsbmsUblQjXPloMwLIE+6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoHJqVqHD5E+ME0Ncj4UViykk2BsFhPgIaffYjsCnjQV3W8EEqec5MNbL504W1M6jm1y7LtoI/PgNgAeVXN8/9w6Qcgw0c4dxQc3XUuGNEIciClEj+8P8eL/ETI12WIP9zToH8Um/TQNRpx6n5p+vSCCUMuA1gTyB6ZEuDWv+3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/gJfvit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/gJfvit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4844C2BCF6;
	Tue, 12 May 2026 18:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609205;
	bh=ccFcH7UM7U6cJcwhEGYgPVsbmsUblQjXPloMwLIE+6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/gJfvitwjOZ9kPDbncdJWCNo3FsTSaDLfFlA9lLDZKvBHpJFT96EP6q49Lxjnl2H
	 8e1/BkLNobsfjj86eiNm2WSlM+zyMN26kS1io5Avvh0v/qa9ad5OaxqBFtwQFNlb+q
	 eTuYRHRbxfLnE/vHoBUsIEH1xJOYdTg2zITIHjyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Vyukov <dvyukov@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 7.0 104/307] rseq: Protect rseq_reset() against interrupts
Date: Tue, 12 May 2026 19:38:19 +0200
Message-ID: <20260512173942.320424371@linuxfoundation.org>
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

commit e9766e6f7d330dce7530918d8c6e3ec96d6c6e24 upstream.

rseq_reset() uses memset() to clear the tasks rseq data. That's racy
against membarrier() and preemption.

Guard it with irqsave to cure this.

Fixes: faba9d250eae ("rseq: Introduce struct rseq_data")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Link: https://patch.msgid.link/20260428224427.353887714%40kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rseq.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/rseq.h
+++ b/include/linux/rseq.h
@@ -119,6 +119,8 @@ static inline void rseq_virt_userspace_e
 
 static inline void rseq_reset(struct task_struct *t)
 {
+	/* Protect against preemption and membarrier IPI */
+	guard(irqsave)();
 	memset(&t->rseq, 0, sizeof(t->rseq));
 	t->rseq.ids.cpu_id = RSEQ_CPU_ID_UNINITIALIZED;
 }


