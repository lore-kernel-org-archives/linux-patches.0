Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20463009F1;
	Tue, 11 Nov 2025 01:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825129; cv=none; b=IxjMl6uW7pJR8Lg2EAAbZFDKo5mYlhTzXsYzL10yljYS70Xz3nbbegXyIk1Dcy4AxDXn4otLMsVJMzPpsAoiyzKgOe1eyWDfNIV0Aif7Hd5GkpnBho0+nqUUdx6ITk71Mu7ktQnp/wn7cgbGodpwPFJ0Hay21gmttrGyZTaSvJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825129; c=relaxed/simple;
	bh=DnUWpZaFlb7VqkW+Cmj8JVQ6vjdWelmI2uTjpQyo9C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxjJtJG/SR3EJdcmJfN1GwSm53xWasEgyWUrpd42/f+Q53525LabhCRxAiGlaJZ7wHd4DEeUifgfuvBlc9o3IOVGOoWUDpxJp0oh9eOIXidtinG+mf6BGqzral+065ea5KNvN3m35ggguO6a4HRFOndOrao0MVCgVawsiYfGy88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hq3tG1at; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hq3tG1at"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEC7C2BCAF;
	Tue, 11 Nov 2025 01:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825129;
	bh=DnUWpZaFlb7VqkW+Cmj8JVQ6vjdWelmI2uTjpQyo9C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hq3tG1atvcUF3el4tMXXr5yVT0krMeWLP1s5DcuypnBpjee38bFPcS8R3ZwYvqXyJ
	 rbFjyFIceD6opMq4zCTKM8kkSPMsFdF+lDJoBtF6/EK/20xCaxzENPQWJ7CHcdLRgg
	 2R5CgVYXE+yvFurm4LtmtMGzfpA1Twf4D9ou3/yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 674/849] ftrace: Fix softlockup in ftrace_module_enable
Date: Tue, 11 Nov 2025 09:44:04 +0900
Message-ID: <20251111004552.714729918@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Riabchun <ferr.lambarginio@gmail.com>

[ Upstream commit 4099b98203d6b33d990586542fa5beee408032a3 ]

A soft lockup was observed when loading amdgpu module.
If a module has a lot of tracable functions, multiple calls
to kallsyms_lookup can spend too much time in RCU critical
section and with disabled preemption, causing kernel panic.
This is the same issue that was fixed in
commit d0b24b4e91fc ("ftrace: Prevent RCU stall on PREEMPT_VOLUNTARY
kernels") and commit 42ea22e754ba ("ftrace: Add cond_resched() to
ftrace_graph_set_hash()").

Fix it the same way by adding cond_resched() in ftrace_module_enable.

Link: https://lore.kernel.org/aMQD9_lxYmphT-up@vova-pc
Signed-off-by: Vladimir Riabchun <ferr.lambarginio@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a69067367c296..42bd2ba68a821 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -7535,6 +7535,8 @@ void ftrace_module_enable(struct module *mod)
 		if (!within_module(rec->ip, mod))
 			break;
 
+		cond_resched();
+
 		/* Weak functions should still be ignored */
 		if (!test_for_valid_rec(rec)) {
 			/* Clear all other flags. Should not be enabled anyway */
-- 
2.51.0



