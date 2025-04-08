Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A0B20CCD8;
	Tue,  8 Apr 2025 11:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113436; cv=none; b=F4W79bvM689Yubapyxi7AVIOghzE+YHxFffrMewPQZE2R04yagq8FfEplxYrq9TS72Z6GdUQhYQWU15jqEiNdruJUrnQmtInQOuxzW/xYrlhAvMRyxlGbPqD9atOQgbwOjx/8PJ7Vl6S/WLpfTJGsdYxKCu2sjUNo2HzanEQjmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113436; c=relaxed/simple;
	bh=3zEmpOKXv69onhUWWoMM54uMOcRtYaZhVX9KeUXrCrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHysdiCezaAMZ/UrtGkCIn2562zZ/CgHxdXGLcp0yzTbozXcO39p4Wll3CbXTWwvuopHVvfMfJ0AwZfzGc8I4akHK2BoS4WUoA+2HGjI2ygrFTWY0l5RhPW2l8kCIawzLvHAr2mPRKUJ2MbxoLBE7Pklj1ysDj0L4GBY+CzN9Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3/PfiJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3/PfiJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79812C4CEE5;
	Tue,  8 Apr 2025 11:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113435;
	bh=3zEmpOKXv69onhUWWoMM54uMOcRtYaZhVX9KeUXrCrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3/PfiJVrGJVEgGm8v4hW2O3vMoGqr7XaPJ4pLQ2mrEEQD3UDtEakgvlWRd15yqDR
	 /pt9xEVAeYjHJGkzuVFGwqCB5GmZOF1pozSEozkzV5WHgy1Hm1hnTUYwoxolX0cUJx
	 5fYqJjd5l22DCK4POhx2H0waIuQLTUrOy1luUMVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/268] sched/smt: Always inline sched_smt_active()
Date: Tue,  8 Apr 2025 12:49:30 +0200
Message-ID: <20250408104832.837994897@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 09f37f2d7b21ff35b8b533f9ab8cfad2fe8f72f6 ]

sched_smt_active() can be called from noinstr code, so it should always
be inlined.  The CONFIG_SCHED_SMT version already has __always_inline.
Do the same for its !CONFIG_SCHED_SMT counterpart.

Fixes the following warning:

  vmlinux.o: error: objtool: intel_idle_ibrs+0x13: call to sched_smt_active() leaves .noinstr.text section

Fixes: 321a874a7ef8 ("sched/smt: Expose sched_smt_present static key")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/1d03907b0a247cf7fb5c1d518de378864f603060.1743481539.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/r/202503311434.lyw2Tveh-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/smt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched/smt.h b/include/linux/sched/smt.h
index 59d3736c454cf..737b50f40137b 100644
--- a/include/linux/sched/smt.h
+++ b/include/linux/sched/smt.h
@@ -12,7 +12,7 @@ static __always_inline bool sched_smt_active(void)
 	return static_branch_likely(&sched_smt_present);
 }
 #else
-static inline bool sched_smt_active(void) { return false; }
+static __always_inline bool sched_smt_active(void) { return false; }
 #endif
 
 void arch_smt_update(void);
-- 
2.39.5



