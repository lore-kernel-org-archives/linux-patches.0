Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B51343C05C;
	Tue, 16 Jun 2026 15:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623071; cv=none; b=exJXuuEC3YZ/0194vXurwfVDEK0MO/tcRc7G63pPZe+sIIe774njCIdhbPrhfAAT1egfCV86tn9PNQF9N3mcFctHKeopg2QkLWpCJgvu801U2jLslKZf4fMDfmPwWLHswPo3cssiq38Lv36+J1a/Lww40KfKKSMGiKdc9ER25Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623071; c=relaxed/simple;
	bh=2l/GB4iH4oxXhhKRExLwhcbBkbTPfCiCfpiBKb3XfQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiSYWlzNmSmL6GmcV8/2Jv3CfHJ24d8FUE2pGnIlaB4kJUe+9R4f7flvxoBDadOgw/nAGoEPFoLX+X72i8nmkGWnzvH1mGWNww0Wf234T18yXghVZqOH/Fsic8cGApyiCJjiey8MeOunlqDr7qSZvZczYHNL3k9cSXruekQ4PT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBQoqc1Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBQoqc1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1D91F000E9;
	Tue, 16 Jun 2026 15:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623070;
	bh=duAPOTeNGWfCX7q9icvsGZEHWBj+Z/V4H0nkWE8GeO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XBQoqc1YUlu9OMxYdYuLLzKAUaIBJMCtjVWfaVXphk2e3DtQqPeUwKcDPtCmk8MYp
	 dRSr+jogTFTTPd0Y95oVPB4w82bDUxjuZddxQ4fk/UAwGcrafySjmAlYAFgpaYKmDu
	 Cf/XmlZUY2Jm/1kGTpduNga8Vl8iyRj0hZ3PK0Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+185a631927096f9da2fc@syzkaller.appspotmail.com,
	Qing Wang <wangqing7171@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 083/378] rseq: Fix using an uninitialized stack variable in rseq_exit_user_update()
Date: Tue, 16 Jun 2026 20:25:14 +0530
Message-ID: <20260616145114.595434042@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Qing Wang <wangqing7171@gmail.com>

[ Upstream commit 6d99479799c69c3cb588fcda19c81d8f61d64ecd ]

There is an bug in which an uninitialized stack variable is used in
rseq_exit_user_update() as reported by syzbot:

BUG: KMSAN: kernel-infoleak in rseq_set_ids_get_csaddr include/linux/rseq_entry.h:502 [inline]

The local variable:

	struct rseq_ids ids = {
		.cpu_id	 = task_cpu(t),
		.mm_cid	 = task_mm_cid(t),
		.node_id = cpu_to_node(ids.cpu_id),
	};

According to the C standard, the evaluation order of expressions in an
initializer list is indeterminately sequenced. The compiler (Clang, in
this KMSAN build) evaluates `cpu_to_node(ids.cpu_id)` *before*
`ids.cpu_id` is initialized with `task_cpu(t)`.

This is fixed by moving the assignment of ids.node_id outside the
structure initialization.

Fixes: 82f572449cfe ("rseq: Implement read only ABI enforcement for optimized RSEQ V2 mode")
Closes: https://syzkaller.appspot.com/bug?extid=185a631927096f9da2fc
Reported-by: syzbot+185a631927096f9da2fc@syzkaller.appspotmail.com
Signed-off-by: Qing Wang <wangqing7171@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://patch.msgid.link/20260602030854.574038-1-wangqing7171@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rseq_entry.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/rseq_entry.h b/include/linux/rseq_entry.h
index 413a3543fbe8ed..69bdb93951b904 100644
--- a/include/linux/rseq_entry.h
+++ b/include/linux/rseq_entry.h
@@ -625,10 +625,11 @@ static __always_inline bool rseq_exit_user_update(struct pt_regs *regs, struct t
 		return true;
 	}
 
+	int cpu = task_cpu(t);
 	struct rseq_ids ids = {
-		.cpu_id	 = task_cpu(t),
+		.cpu_id	 = cpu,
 		.mm_cid	 = task_mm_cid(t),
-		.node_id = cpu_to_node(ids.cpu_id),
+		.node_id = cpu_to_node(cpu),
 	};
 
 	return rseq_update_usr(t, regs, &ids);
-- 
2.53.0



