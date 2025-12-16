Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E0A313E13;
	Tue, 16 Dec 2025 11:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884218; cv=none; b=YK8bNlTMNbjB2kNlFN7UcNroON5ZyNrP7VYMkzbJudsQLsMQlE7B1BCZ3M38uyFzE3BpLcX394HKfPsf6ceWV0rlNtTUGR7lm+T71lraYmYjrf3/f03gsmCcDU6zRkp0hBg3Y54Sr8d7P5+GluJQwqPK+pWRSNkGJqNfdHm0O8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884218; c=relaxed/simple;
	bh=dMLyxi3ZFHmlLzLLkoXrBjDFb2GdfgpeuKUhO3gyMfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IW03uHnNU/2NOyUothCGcB7qau8ByNaEN6s9j4SMg58BZ3MXAZNDVvlh37dngip4HJqpM5gk5sCEn11IqqujgYHQox2ecQmLFyXISYD6k28Tt6X3Iyl35AqTqoIY6Xk5mcRmDTdOKodd5NXLOUULd5eMSj3EZwmYZPG3MpXMmb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7/a5Veq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7/a5Veq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6677EC4CEF1;
	Tue, 16 Dec 2025 11:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884217;
	bh=dMLyxi3ZFHmlLzLLkoXrBjDFb2GdfgpeuKUhO3gyMfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7/a5VeqWTg/+q/vIPAZc+2ouE8jv+SS1Y47U+zBI7f9fxNyakeRIKPEZeuknS6Po
	 lcsy0E+8OLnLKIYZ9mhYmb0HRpk4SMF+gh+uGXcVUsMjH2YZc/OhWJkxlAT4tEQVcx
	 S/3tSAuDeMQDRAmDnRueISOh/hlMS2EDKql/pils=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/354] perf/x86/intel: Correct large PEBS flag check
Date: Tue, 16 Dec 2025 12:11:34 +0100
Message-ID: <20251216111325.523759924@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit 5e4e355ae7cdeb0fef5dbe908866e1f895abfacc ]

current large PEBS flag check only checks if sample_regs_user contains
unsupported GPRs but doesn't check if sample_regs_intr contains
unsupported GPRs.

Of course, currently PEBS HW supports to sample all perf supported GPRs,
the missed check doesn't cause real issue. But it won't be true any more
after the subsequent patches support to sample SSP register. SSP
sampling is not supported by adaptive PEBS HW and it would be supported
until arch-PEBS HW. So correct this issue.

Fixes: a47ba4d77e12 ("perf/x86: Enable free running PEBS for REGS_USER/INTR")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20251029102136.61364-5-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index acc0774519ce2..4a57a9948c745 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3872,7 +3872,9 @@ static unsigned long intel_pmu_large_pebs_flags(struct perf_event *event)
 	if (!event->attr.exclude_kernel)
 		flags &= ~PERF_SAMPLE_REGS_USER;
 	if (event->attr.sample_regs_user & ~PEBS_GP_REGS)
-		flags &= ~(PERF_SAMPLE_REGS_USER | PERF_SAMPLE_REGS_INTR);
+		flags &= ~PERF_SAMPLE_REGS_USER;
+	if (event->attr.sample_regs_intr & ~PEBS_GP_REGS)
+		flags &= ~PERF_SAMPLE_REGS_INTR;
 	return flags;
 }
 
-- 
2.51.0



