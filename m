Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EF72701DA;
	Wed, 25 Feb 2026 01:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983783; cv=none; b=ifPSO0DbVXcrVNzNbdKPNE7oU+gtmZZ8XQ3XjdQ2WvjbD85IU0v89ELTOi22tqmmGjmC7F1OksGbCiVNiSVXgfOmPv+cydBtylfLA7N+bH3YB0akfgj9moLC+GQH85VeBbyFHoj94/SQ8t7r1dpxP6uBU2o+nyJs/4ONaAn7jiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983783; c=relaxed/simple;
	bh=wmjehVeucMKAxDYVBXdWXHDv9YsFBrbiiJZPEthqmtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMahejsHqQV6pOFt5jeFkWVqQ98F5MKNAnYtdAZufGfvvEEbGoUtrP2ynBDpm4KHdcsFJpadU2KSAPKRx8zkeGiDWn42tmHiAmdeTPSJxPBka64zpC589bBwDbVCojRcQMnKDS1FiEQNcc0B36GCcF55dMg7BXflR4XHRyNd1No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3kMK8lk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3kMK8lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F68C116D0;
	Wed, 25 Feb 2026 01:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983783;
	bh=wmjehVeucMKAxDYVBXdWXHDv9YsFBrbiiJZPEthqmtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3kMK8lkhXNplpe5CmOoRMWCT8iOtQA5HV+6YKk8jaIPpo2dxyW0Y3ywdhCiIP5t3
	 WQMTKyE0rrYLCvMomkXObRrnk5Kmm8alOfFbK1A8BjZ31xJPdhffGLXeZHKUCsrV4r
	 wSXxfaOaCwiD6v5LODIt4RNIgRxXFxNCcu451Eyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 071/641] sched: Fix build for modules using set_tsk_need_resched()
Date: Tue, 24 Feb 2026 17:16:37 -0800
Message-ID: <20260225012350.785878693@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit 8d737320166bd145af70a3133a9964b00ca81cba ]

Commit adcc3bfa8806 ("sched: Adapt sched tracepoints for RV task model")
added a tracepoint to the need_resched action that can be triggered also
by set_tsk_need_resched.
This function was previously accessible from out-of-tree modules but
it's no longer available because the __trace_set_need_resched() symbol
is not exported (together with the tracepoint itself, which was exported
in a separate patch) and building such modules fails.

Export __trace_set_need_resched to modules to fix those build issues.

Fixes: adcc3bfa8806 ("sched: Adapt sched tracepoints for RV task model")
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Link: https://patch.msgid.link/20260112140413.362202-1-gmonaco@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c1e4d8a5947cf..582c3847f483a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1139,6 +1139,7 @@ void __trace_set_need_resched(struct task_struct *curr, int tif)
 {
 	trace_sched_set_need_resched_tp(curr, smp_processor_id(), tif);
 }
+EXPORT_SYMBOL_GPL(__trace_set_need_resched);
 
 void resched_curr(struct rq *rq)
 {
-- 
2.51.0



