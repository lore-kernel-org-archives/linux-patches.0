Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE47332EBD;
	Wed, 20 May 2026 18:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301783; cv=none; b=pZ99AXRM7RkhrqQ8UA8ZtEAYmvTuoG2efuLtCUsV6jmyd0MMKnIWB9mSKfPV8j/zsxZlKtAcH88SN/ekTuzr8/R0PPeCzJPDpUy3ZvtSlJFCyo22j+2dv2yBM40HMBbs6NRYutvWGGwroK7WHC11wB0NB40lQxbqeA/ejJkvZ/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301783; c=relaxed/simple;
	bh=IyeQNQjNxShtmPUQggKFEqFasfzQsd4Scd8EIpM4zIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBFqF5gb98VhQVzmWLZRzu+gTXUtE4heUQgWX3Ys1BbJxOtlbrotrxhDAr+Cy1Xfg3hTKeo5LEMi10bTqNeDm0oqCYpEtdaS3vkfgIrMja6G3Afda0mWCGgutxIDi4OP0Xq/poRqq2V0bfUsn/Cuuo4MjNOeok9WQMfsU5Hy/oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAfPu6lc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAfPu6lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421561F000E9;
	Wed, 20 May 2026 18:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301781;
	bh=dHnHChg84gFkuuY6SLI0xgQOqFb6uZY1pLhgBN7kRNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gAfPu6lcSzMHdlZ6/cEYhNnXOdeOz6PNw92XspdtYha5PXPsTkVVisnH7vgVddbqy
	 Ofa42RLCXh0FuzQpUOnq145GZVBmnjU5Ue6rcapzGpxqRIF6aJ021jeolMmlT1rV8R
	 MlBpuMQLMO7ztLZGt4QS9vS+yuY/Sz71tfUYLjdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/508] hrtimer: Avoid pointless reprogramming in __hrtimer_start_range_ns()
Date: Wed, 20 May 2026 18:17:22 +0200
Message-ID: <20260520162059.004144092@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit d19ff16c11db38f3ee179d72751fb9b340174330 ]

Much like hrtimer_reprogram(), skip programming if the cpu_base is running
the hrtimer interrupt.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Reviewed-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260224163429.069535561@kernel.org
Stable-dep-of: f2e388a019e4 ("hrtimer: Reduce trace noise in hrtimer_start()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 9f41327d3a6d6..3bc3111ca5317 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1287,6 +1287,14 @@ static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	}
 
 	first = enqueue_hrtimer(timer, new_base, mode);
+
+	/*
+	 * If the hrtimer interrupt is running, then it will reevaluate the
+	 * clock bases and reprogram the clock event device.
+	 */
+	if (new_base->cpu_base->in_hrtirq)
+		return false;
+
 	if (!force_local) {
 		/*
 		 * If the current CPU base is online, then the timer is
-- 
2.53.0



