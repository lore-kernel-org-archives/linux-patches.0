Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA5D32276C;
	Mon, 18 Aug 2025 13:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523961; cv=none; b=AuAC+P64SW9LJcUZXnKHjAYScHoqDr2coub8TsgY2Z2KiI61OKniMoj8aUyOSIjm2mXGy8xyjhXiSwZxPntMMHD1zvRbl3cocGL3ArBBfmuK6kFR49SFFADMa7xQbQS9tuquOdY0xRzQbF8Y1oVOmqgvkAkiwUgs3o7h2hN4Cro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523961; c=relaxed/simple;
	bh=oXPQ/D/xD2+dx4EgzW19BaNXtRYDgMDL6ZeiLfG1KIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIQL+LyBGel44KdMjY14TlWYXEyvrR8IpeP5qcOKR1pDEVsMh+69/dW+1oubOAKxYMvJFJk+viZFvN1JDAzKXuqV7bidtooM+ZQ1RW16j4H/bxUTxxemVPgRm/JAdwuG78konSX+mY5nUJg3C/nbi8FtwqSHc0R2lfeGLAdqUQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqIfA+Wy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqIfA+Wy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEF7C4CEEB;
	Mon, 18 Aug 2025 13:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523960;
	bh=oXPQ/D/xD2+dx4EgzW19BaNXtRYDgMDL6ZeiLfG1KIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqIfA+WyefVp5YP5PzyUe0m48WNe5aOITRUzDpihr3nv8/4ur3LDF11gp5Gnz2R42
	 RMiQp7h7QA3Jxt4zOTXBvTVKWru0JMYX2w8jWC8fsDL+POjWK034ZJs9a9MnGQ7MEA
	 uStJEGgYpTycYjDx4ZlwSIcxWF0Id8xSWsVSydlw=
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
Subject: [PATCH 6.15 293/515] arm64: stacktrace: Check kretprobe_find_ret_addr() return value
Date: Mon, 18 Aug 2025 14:44:39 +0200
Message-ID: <20250818124509.702446957@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



