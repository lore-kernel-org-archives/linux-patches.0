Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577A129B200;
	Thu, 15 Jan 2026 17:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497430; cv=none; b=lqK2J+s6IQLbMHnJrhRJhrsWjJRNOYlsaYATedNU5WxPFWTpueOAHwQ26bRpBGFhrwqYAi4dFttUI7FRgoxERgag0riy7ZZoDtgHmKhNE/XrBqOW+cEAc7WAjEPDKUMe2xAxgQk4pZh3l0H0fR1SXsGXV9FIDTG9C07mJwQe5IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497430; c=relaxed/simple;
	bh=NOYjxptg48Ru4Ey4gSn/yfLYyylmn+YRDTILqxFeh9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXpCylGL1xLFJKAmAniKMJ6CN3yb4gEr2vMBP0J4d3TX3/PuufYwuN5rjvrcSeRppOuKDLOPveOSUPbNJgU3xTeh2JqKjW8d+FhA5wI7v9vEkRO5Zu64fz/Ol2jhad/tCHDxL6z8oqc8HW3XlaT9A0YUN/qG5zQMGd5ruR3Sv80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcVh0uCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcVh0uCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EB3C116D0;
	Thu, 15 Jan 2026 17:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497430;
	bh=NOYjxptg48Ru4Ey4gSn/yfLYyylmn+YRDTILqxFeh9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcVh0uCf7WW3mAzlBMrd8j3aQFTnvxuS4SvoWIJVG0ZlkWHZLmAnPprVAT/mX/uNf
	 9j9eOen5yF0GSKsY7O3dFX8/A9k2iffuZiu7Ulb/rZwehupP8+hboRVkNbDcLCBk1d
	 ssyZ2Jm7N1gjxVr2g3sBT6RMDqtJo+taNy+/qWwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/554] perf/x86/intel: Correct large PEBS flag check
Date: Thu, 15 Jan 2026 17:42:25 +0100
Message-ID: <20260115164249.100537065@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 767c60af13be3..589c850fe4b00 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3639,7 +3639,9 @@ static unsigned long intel_pmu_large_pebs_flags(struct perf_event *event)
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



