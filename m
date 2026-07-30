Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A90B33D4E2;
	Thu, 30 Jul 2026 14:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422060; cv=none; b=Zhz0lt13Dfgad5c6ig7NQPE1TnV2Chv7IDIZv4ym2TINi+Ni4kvM3vuy99ltqNuvEriP61hOOP834ZV8gMn/HZeC3F7PfoRcWm0HWKtcHYmr6xQi9o+UTiizGypWZdKApfAcAQg6ktmBPNO44EXuSTAlwChDoKxoRyktuuyowhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422060; c=relaxed/simple;
	bh=Zu1iMpjFiwS14FutCzwZD5kKyQE0mBgzOrtdH1P/laY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TU9WOgM2daHXZhqqKhKJoTumtx1nhr+rcBzruJxQzdJv3ZoCAthO4BbMOVXJnhTAvW7si+DKszL2pfDPx9tqa8RQ6tcSfojIeJjkzVTNdl3G9KPt1WhLi76zlNuDL6TNZrLkOrG/TQK3CAMqAECsYayXsiWWq+gO3JLONhkYj+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsTFcWCC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsTFcWCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9F41F00AC4;
	Thu, 30 Jul 2026 14:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422059;
	bh=dU5NNYW/9JWtxv8QgwCIzhv/az0SAM8VqO0Oj4+7Nu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DsTFcWCC0+sQDJNzjCphtQRZclkfcyJJjE3Dv+7EMfKLhy4FDF2FUwjuyiaCwTxHx
	 5Ij6Lux0Oj57H9QANPr73eW5unlSZqIHpMHx4qlzxL+5U1gaE7sQq0aYBS2IZy9bU9
	 sg73HYd8sNwa3dER+w+qzbDUFPMGxfJje0D1GM9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuyi Zhou <zhouchuyi@bytedance.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 309/744] smp: Avoid invalid per-CPU CSD lookup with CSD lock debug
Date: Thu, 30 Jul 2026 16:09:42 +0200
Message-ID: <20260730141450.856377377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuyi Zhou <zhouchuyi@bytedance.com>

[ Upstream commit c58ea9adf7342508c6ac0b7ad79ef10d589f9c6e ]

Commit b0473dcd4b1d ("smp: Improve smp_call_function_single()
CSD-lock diagnostics") made smp_call_function_single() use the destination
CPU's csd_data when CSD lock debugging is enabled. That lets the debug code
associate a stuck CSD lock with the target CPU, but it also means the CPU
argument is used in per_cpu_ptr() before generic_exec_single() has a chance
to validate it.

This becomes unsafe when smp_call_function_any() cannot find an online CPU
in the supplied mask. In that case the selected CPU can be nr_cpu_ids, and
the !wait path calls get_single_csd_data(cpu) before generic_exec_single()
returns -ENXIO. With csdlock_debug_enabled set, that indexes the per-CPU
offset array with an invalid CPU number.

Use the destination CPU's csd_data only when the CPU number is within
nr_cpu_ids. For invalid CPU numbers, fall back to the local CPU's csd_data
and let generic_exec_single() perform the existing validation and return
-ENXIO.

Fixes: b0473dcd4b1d ("smp: Improve smp_call_function_single() CSD-lock diagnostics")
Signed-off-by: Chuyi Zhou <zhouchuyi@bytedance.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Link: https://patch.msgid.link/20260716004539.13983-1-paulmck@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/smp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index a0bb56bd8ddadb..dc6582bb35d084 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -380,7 +380,8 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(call_single_data_t, csd_data);
 #ifdef CONFIG_CSD_LOCK_WAIT_DEBUG
 static call_single_data_t *get_single_csd_data(int cpu)
 {
-	if (static_branch_unlikely(&csdlock_debug_enabled))
+	if (static_branch_unlikely(&csdlock_debug_enabled) &&
+	    (unsigned int)cpu < nr_cpu_ids)
 		return per_cpu_ptr(&csd_data, cpu);
 	return this_cpu_ptr(&csd_data);
 }
-- 
2.53.0



