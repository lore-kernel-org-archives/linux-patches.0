Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4520D37B3FD;
	Mon, 19 Jan 2026 14:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768832697; cv=none; b=JgfQlVPM8+ooKJB2gEWIwKTudthIc2OTDwn28VIa68wDopnKFHzJutvQPiF1X0pdMvgkdVtyNmj3e421h+4+YgfovSpnh5uIED7rgM69/W842r71BABqOTaMG9bgtxkYSIb/Lz8ormiJgFd3XxYTyzmMeKQSkXzn2vuLDmEyuRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768832697; c=relaxed/simple;
	bh=wNeKi6j82dbnM7fQoJ4uMc+HpcMGH000iz3AbHKbBK4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=SBtr+HTbmg5B8hu08vl3LwyOjJ8eH7X8MiSiOfS+5gebsxZ1xJtkDqP7w4vCnSTzsO0x5kchJC3eMhovSsU3gUzfIK/GdnXKTQJxQ1DEeOas5RaC/cz1rGCJWDsOlp9jnP3NkA23JmkmkxwPavZdNJaKmrZNvw2eYd54Zi28gHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TiNNyWi5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TiNNyWi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A31C19423;
	Mon, 19 Jan 2026 14:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768832697;
	bh=wNeKi6j82dbnM7fQoJ4uMc+HpcMGH000iz3AbHKbBK4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=TiNNyWi5WhMQW+msa2UoKApyOBNB6SCXAYxwAjnCrIi9YxjcfXeDapSQ5ieVO+vNt
	 MV85qWjUKu0NLqro5J2/1I1dTrMnNR0n8qspvCXmYNaot7hm0lpl4lnfkyVdM8viL5
	 m2wrochU5IR16IMiwSMGaVnRsi0dSHOb7Jhgav9ECAb4HSjPsRzh2IjNeBHFGc0klX
	 hvX6ONtv04AH9cPpF7luKa14MhLIt7bDh/UXwuYP/rmekvnumtc2qA+lJOK4WFAGOJ
	 Cal/+aAwWFH6W/oCk89W5MLEJRCx01XVmsUgICf/rHxesl6uMxGphLd8LLWB6Lsvod
	 0mVgrVLHJdaKw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F16553A55FAF;
	Mon, 19 Jan 2026 14:21:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] riscv: Use 64-bit variable for output in
 __get_user_asm
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <176883248678.1426077.647982484224558012.git-patchwork-notify@kernel.org>
Date: Mon, 19 Jan 2026 14:21:26 +0000
References: 
 <20260116-riscv-wa-llvm-asm-goto-outputs-assertion-failure-v3-1-55b5775f989b@kernel.org>
In-Reply-To: 
 <20260116-riscv-wa-llvm-asm-goto-outputs-assertion-failure-v3-1-55b5775f989b@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: linux-riscv@lists.infradead.org, pjw@kernel.org, alex@ghiti.fr,
 palmer@dabbelt.com, nick.desaulniers+lkml@gmail.com, morbo@google.com,
 justinstitt@google.com, craig.topper@sifive.com, llvm@lists.linux.dev,
 patches@lists.linux.dev

Hello:

This patch was applied to riscv/linux.git (fixes)
by Paul Walmsley <pjw@kernel.org>:

On Fri, 16 Jan 2026 15:44:34 -0700 you wrote:
> After commit f6bff7827a48 ("riscv: uaccess: use 'asm_goto_output' for
> get_user()"), which was the first commit that started using asm goto
> with outputs on RISC-V, builds of clang built with assertions enabled
> start crashing in certain files that use get_user() with:
> 
>   clang: llvm/lib/CodeGen/SelectionDAG/SelectionDAGBuilder.cpp:12743: Register FollowCopyChain(MachineRegisterInfo &, Register): Assertion `MI->getOpcode() == TargetOpcode::COPY && "start of copy chain MUST be COPY"' failed.
> 
> [...]

Here is the summary with links:
  - [v3] riscv: Use 64-bit variable for output in __get_user_asm
    https://git.kernel.org/riscv/c/bdce162f2e57

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


