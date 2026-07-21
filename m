Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6BA47126B;
	Tue, 21 Jul 2026 18:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656863; cv=none; b=km1wt8373fbqPg5cGkhDJ0D5C6BNIbNqBotWtL1UcfnDXjNOcDmHrDiti4z/K5iCLed1N/gX3WramhRiCagQz8kG2hPRPi2qYFRwZa7zwajLZiKhVqJHHNXZT1Q1dVI5suQiwSG9yd7nU4c23eKJ202ED9xsqWA4B/Il2MEKmrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656863; c=relaxed/simple;
	bh=L1lTBYG1ymHIH2yAM0b4jSYN4q1wF1CvZBVSk7w3VyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mITu1KxQNNW4khXRtlNRy+zMNuZo1q5hrqHpxldLZouVscyiZubKG+G17dSLZPaSK3d/OvZjJG2fm+9PQaYChEo5wqmw27dho6vW6BF13wQBryK4JGK+UnnqlpeZjxyfTyLTWDduzV8MV2M37uDaldhrdUev+cvBsF3/okHD/0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGBuIwpz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGBuIwpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0E01F000E9;
	Tue, 21 Jul 2026 18:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656862;
	bh=LUEO9ldDuDgGESjsKTIJmpv1pJuyq4Aux8f3hE6qSaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EGBuIwpzgl29BTv7a44dB4hGMx5KAJB2T/BfVwCYtBuYbRSpmDbr6qJt7KL0sFvGz
	 QpWQXmK/N5SMMUhj/sxSNHFgCORA9XgJz/+IsEXFv6OjzB90vL/drHugaYxcTEv8j5
	 4yJbJxLuX57zapRVSPtd34Ose0Ed/T2EJjPPZlm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0546/1611] powerpc/perf: fix preempt count underflow in fsl_emb_pmu_del
Date: Tue, 21 Jul 2026 17:11:02 +0200
Message-ID: <20260721152527.649707926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Aboorva Devarajan <aboorvad@linux.ibm.com>

[ Upstream commit 81e3a86030462824a67d697739cf3f387f4ba350 ]

fsl_emb_pmu_del() unconditionally calls put_cpu_var(cpu_hw_events) at
the 'out:' label, but only calls the matching get_cpu_var() after the
'i < 0' early-return check. When event->hw.idx is negative the
function jumps to 'out:' without having taken get_cpu_var(), and the
trailing put_cpu_var() then issues an unmatched preempt_enable(),
underflowing preempt_count.

On a CONFIG_PREEMPT=y kernel preempt_count would underflow and
eventually present as a 'scheduling while atomic' BUG.

Move put_cpu_var() to pair with get_cpu_var() so the percpu access is
correctly bracketed and the 'out:' label only handles perf_pmu_enable.

Fixes: a11106544f33 ("powerpc/perf: e500 support")
Reviewed-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260605082912.305100-2-aboorvad@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/core-fsl-emb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/core-fsl-emb.c b/arch/powerpc/perf/core-fsl-emb.c
index 7120ab20cbfecb..02b5dd74c187a0 100644
--- a/arch/powerpc/perf/core-fsl-emb.c
+++ b/arch/powerpc/perf/core-fsl-emb.c
@@ -366,9 +366,10 @@ static void fsl_emb_pmu_del(struct perf_event *event, int flags)
 
 	cpuhw->n_events--;
 
+	put_cpu_var(cpu_hw_events);
+
  out:
 	perf_pmu_enable(event->pmu);
-	put_cpu_var(cpu_hw_events);
 }
 
 static void fsl_emb_pmu_start(struct perf_event *event, int ef_flags)
-- 
2.53.0



