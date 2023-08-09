Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F52847D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF9CC433C9;
	Wed,  9 Aug 2023 10:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578159;
	bh=xvYD1dep1YWhzvTQn6m/GySYPcIrno23nZcZoGGRNKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2khPX9V7JG/PekarjiqJUXHaL2lfSAz8ReB9salUDyWVa9lO8vIfOWS0afRgjGgO
	 39TBer2/zhuGOEiqSQ+ZQqArfbUKBKDgji8MBidE11QQ46IiFb0ahRp2zjfU1Dkbp/
	 IE4tFEkNtlAIZGtlcrVmca1px3MQEA8Ng7uSHNco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.4 125/165] arm64/ptrace: Flush FP state when setting ZT0
Date: Wed,  9 Aug 2023 12:40:56 +0200
Message-ID: <20230809103646.889060040@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

commit 89a65c3f170e5c3b05a626046c68354e2afd7912 upstream.

When setting ZT0 via ptrace we do not currently force a reload of the
floating point register state from memory, do that to ensure that the newly
set value gets loaded into the registers on next task execution.

The function was templated off the function for FPSIMD which due to our
providing the option of embedding a FPSIMD regset within the SVE regset
does not directly include the flush.

Fixes: f90b529bcbe5 ("arm64/sme: Implement ZT0 ptrace support")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230803-arm64-fix-ptrace-zt0-flush-v1-1-72e854eaf96e@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/ptrace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index d7f4f0d1ae12..740e81e9db04 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1180,6 +1180,8 @@ static int zt_set(struct task_struct *target,
 	if (ret == 0)
 		target->thread.svcr |= SVCR_ZA_MASK;
 
+	fpsimd_flush_task_state(target);
+
 	return ret;
 }
 
-- 
2.41.0



