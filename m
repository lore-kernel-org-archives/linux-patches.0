Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DAC36B061;
	Tue, 16 Dec 2025 12:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887420; cv=none; b=SnnxHE9cl72kjTwMreThowGrSD9/6LYOGppyKGb1eJlg1A9FM4RaYTatsaSY1mos3S9tMuv9f7cyANUWCPFMWqQFb4WUtsgYUNoFPjysqjlD3k+Cpltl/UrQhxUHzoM8dg7MLFrPG3Lh0QKgzPfkCUkp2ZrxWdVb8JC8AnQCUwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887420; c=relaxed/simple;
	bh=++ChSNnrSQ4icIBFwd5ccNfy6iUE4nkoWDAko0CQ5Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3LzQD7SolG+VQRu89FEuRoFYcuNfGCEWA59zAIyZKW2E+aU/KKH7hDrjnRanvKA2NMP0R2IfGVizxze8EvskqAwbplqBAkpdEeNeEXz78BF2ozedvDJbE0fT6M0GP1cqtffp2bzsm/aKoGtW6jweSNcx1C11e/lJuJQ9ZL+wPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRzf34aP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRzf34aP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6049DC4CEF1;
	Tue, 16 Dec 2025 12:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887419;
	bh=++ChSNnrSQ4icIBFwd5ccNfy6iUE4nkoWDAko0CQ5Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRzf34aP9XbcUcZOrZ/ixcdkhc19XtQyw/cza+HAVmgXw/eyrVplaJJwelyj1gXHo
	 7DIPL582x4yzRxiAgW8Gu0UGms/kh7JG+AIXubpefjm+DYJ96PwW63D8GBNZR97G6+
	 ipk2E6vXmis64ijz9RK/rUdYl/o3mvVuGDuBEYS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 224/614] perf/x86/intel: Correct large PEBS flag check
Date: Tue, 16 Dec 2025 12:09:51 +0100
Message-ID: <20251216111409.488479234@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index fe65be0b9d9c4..9b824ed6fc1de 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4029,7 +4029,9 @@ static unsigned long intel_pmu_large_pebs_flags(struct perf_event *event)
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



