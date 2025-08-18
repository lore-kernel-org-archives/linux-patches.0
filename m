Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B5814E2E2;
	Mon, 18 Aug 2025 14:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525624; cv=none; b=MsK2MuKOKIjPFE7AVwLI1+8ENZeQWuPG3r9biftoHBvRWELeb6/BOcsnrIN+fqR5ZAbyUV/fABdBKOJPZQnd9mW9fIASqRp5HwtdyyjeQej7yeG2uZThEUkFfERxQMA+8RDI9DAgplySj6VDoMzPYievY4OyvChVZd6k0cGttYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525624; c=relaxed/simple;
	bh=v8e/GxU9o9R9DiUJaW6x9G73THr9rW10Xh86dsATC20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZjKuz+bckoIqrbfBBsiq7CIs1sWPwW9BeuZDocQJcvLQ+mcQDivBwrrhtiZtROmJx8frKArfvioZ7NMrRdNc+t8ajikrnn849j966txsph1btyscbcVEUg1Jvoaz8fOI/QAPGEqMu/ebC6VbR49sKpKp/SgmFiA8zbuyFrwpsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6Ilyckz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6Ilyckz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2406AC4CEEB;
	Mon, 18 Aug 2025 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525624;
	bh=v8e/GxU9o9R9DiUJaW6x9G73THr9rW10Xh86dsATC20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6Ilyckzs19MQSjhxOAJqP5DfXkuGIrsFPsphEhmBVgJt0HNyEAV58wOcyPg0qMKR
	 R7T9Ja++7B+mqp2ZH+fmnSWgJsd7Yu6iJ0cUtc1mfbQD6Oy5FODCBTdIHCfM52KKYP
	 WE5EHBisbhRng+GhMZT2dFbAwk92/JJHKC+9RwvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Andrea della Porta <andrea.porta@suse.com>,
	Breno Leitao <leitao@debian.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Song Liu <song@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 319/570] arm64: stacktrace: Check kretprobe_find_ret_addr() return value
Date: Mon, 18 Aug 2025 14:45:06 +0200
Message-ID: <20250818124518.149278320@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit beecfd6a88a675e20987e70ec532ba734b230fa4 ]

If kretprobe_find_ret_addr() fails to find the original return address,
it returns 0. Check for this case so that a reliable stacktrace won't
silently ignore it.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andrea della Porta <andrea.porta@suse.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Song Liu <song@kernel.org>
Cc: Will Deacon <will@kernel.org>
Reviewed-and-tested-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20250521111000.2237470-2-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/stacktrace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 1d9d51d7627f..f6494c094214 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -152,6 +152,8 @@ kunwind_recover_return_address(struct kunwind_state *state)
 		orig_pc = kretprobe_find_ret_addr(state->task,
 						  (void *)state->common.fp,
 						  &state->kr_cur);
+		if (!orig_pc)
+			return -EINVAL;
 		state->common.pc = orig_pc;
 		state->flags.kretprobe = 1;
 	}
-- 
2.39.5



