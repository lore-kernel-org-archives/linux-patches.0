Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7AD2C0F83;
	Thu, 15 Jan 2026 17:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499055; cv=none; b=OEzUYPXswgi+r2GKcePGrQIHmYkkzxw1XaWs1ouyECCgIJ8WgPksDAurNqnivHYp9o5RzkFI4bCcTCVEL7TCBWu1k2gbLPBq1b8PdGrIqfIyVhZp6iRbDiKg4/HP6YRPh/8t7nteliMRfybdPq4j4VpDVEB+935PfNbr+pzetXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499055; c=relaxed/simple;
	bh=dl3ujNY212/BcKKmCh0HHgs1lthFCiWJeomsrqTuC9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCT1CiR/uQJZNLh67ML0ycCg4A7+KdO1AdgnbJfsV/mue6o1DE8IkdACaN0LmVqQeKxSM6VOQuewCmnSQWt1oEAnHUT23gly7wMSY92na6Ojb5RVTeoSnKZRJlHyEQLcSGQCa8MRQVBRyg+YQJaUVv1pvxNVigzTPPsIl62njgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=co0AbqmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="co0AbqmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27338C116D0;
	Thu, 15 Jan 2026 17:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499055;
	bh=dl3ujNY212/BcKKmCh0HHgs1lthFCiWJeomsrqTuC9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=co0AbqmZT3ZAHYZIPrGHAeD3d5JiFTfXaHyFdhK6LueWizJ6txxodXPOO0/CNhOZh
	 DuynRTntY9FA9rh5A6bskWZJvY0VtUdEiUa9EVeAXUROwCd869PLY0iMt34RjAwpAB
	 pAxhKBv9srs6z5yj7caSmmcRloWtdcxOo26lCSE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/451] perf/x86/intel: Correct large PEBS flag check
Date: Thu, 15 Jan 2026 17:44:20 +0100
Message-ID: <20260115164233.034163841@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fb2e81fa62c45..73d1cebddee70 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3515,7 +3515,9 @@ static unsigned long intel_pmu_large_pebs_flags(struct perf_event *event)
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



