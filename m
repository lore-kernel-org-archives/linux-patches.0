Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD3336B055;
	Wed,  3 Dec 2025 16:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779486; cv=none; b=auiSABhF5hCx0GnNmWgCfD3DCxwIFgRW76rKyKzQ8Jbu1yL47W+wZwPjRXceTV9OkqxfSiHf3JQXf/eUDV9vjZM7UdEyVyZgEp6eE0bx+7j499n1zns95NX/TUATqB5Qkfq+ZNIhGI3drHLduA8GynaI8wnuWc6YSSrkULT4/HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779486; c=relaxed/simple;
	bh=41qAnP7CPhwXwcOEqoG4PnhGFsp1y9XiX1XPgA+4o48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ub1o5jA2ipte5jdXwisr1eJw2bcHZWhIZk+bAgKa5/199Mxka1sd+Uqq5vdzjQvgNSaCszr7geM3PeAIG3xjwGX0dXYRRSjelgVQRuIZ3Aa4PgKrhvgc8uTFc6AxdYXqTDo6tHpzj83W2EfQdkO/oXRZmwtez3FR6oycDNP8yDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=naoxgZNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="naoxgZNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185DCC4CEF5;
	Wed,  3 Dec 2025 16:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779486;
	bh=41qAnP7CPhwXwcOEqoG4PnhGFsp1y9XiX1XPgA+4o48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=naoxgZNpajcSqQ8hT585eGPC8p0sTRPOqyk9hLScFm8yUD84Hsp8rKSe/GgC4x86V
	 FMJLBpOkjbr2bLxu7IuKhkrYVcKv7Z0MNMLl8QmYLRtNuAJtNXqcXEV94ygi73qFpb
	 HUCDrZEvLwdFywUWki9rRhSwxEFn9vOYx4vzogkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 271/568] ftrace: Fix softlockup in ftrace_module_enable
Date: Wed,  3 Dec 2025 16:24:33 +0100
Message-ID: <20251203152450.638283269@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cebed90b2e16f..a46e2f32ee5fc 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -7065,6 +7065,8 @@ void ftrace_module_enable(struct module *mod)
 		    !within_module_init(rec->ip, mod))
 			break;
 
+		cond_resched();
+
 		/* Weak functions should still be ignored */
 		if (!test_for_valid_rec(rec)) {
 			/* Clear all other flags. Should not be enabled anyway */
-- 
2.51.0



