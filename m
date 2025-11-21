Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE6630EF7F;
	Fri, 21 Nov 2025 13:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732932; cv=none; b=GksRA1Po0jNcisCUIFNV+paK6pOo2Jg8rSvNMobOb5Qljh8pOg+Cj6R3wPM6vtO+PEG0sIqPvU+xvwIzwKkDI79Y+8ceIxHL98u7a03kmAPW43mBVXu3Py/HgWEismENtjYCKqerzfpiSTNNPuuy27i8csgKNhMJHJqJJV6ytAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732932; c=relaxed/simple;
	bh=vGktwZ4KHByPOjJQEVlpoQXas4arj/JEstQX61EhSpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hI1FxeWNvDpoyYanJ0aViOzvx4/rUlDHYoPFgzWck96i8k2gN5ID+vYDvllDALKT+FuKsszX32TEhbAvd8WyAu0I4R7A+A9CdlCsg7a/GltQsJcyMJ4UcKMS3fKR8CQPxvosHz/jJcWlumgJIyn0LVIHRaMhbkzgPI6wVSd+Xxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVJGt53a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVJGt53a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED990C4CEF1;
	Fri, 21 Nov 2025 13:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732932;
	bh=vGktwZ4KHByPOjJQEVlpoQXas4arj/JEstQX61EhSpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVJGt53aGa82HgesWBIy2ARWTFO5ezgHdu/iRryciIVbJfa/k4jWhmQ9BQSlrWJLM
	 NjCCneab+4DZ1aPW1QsP7Fh/fBYz/2+LBFR+aZ5HXX2I0bcks3J2/SyIEC2FLi1lk5
	 cjiT0KDrBPhta65zn47+zMjdrE53iP6apnCE5sCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 294/529] ftrace: Fix softlockup in ftrace_module_enable
Date: Fri, 21 Nov 2025 14:09:53 +0100
Message-ID: <20251121130241.488982044@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 15785a729a0cd..398992597685b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6873,6 +6873,8 @@ void ftrace_module_enable(struct module *mod)
 		if (!within_module(rec->ip, mod))
 			break;
 
+		cond_resched();
+
 		/* Weak functions should still be ignored */
 		if (!test_for_valid_rec(rec)) {
 			/* Clear all other flags. Should not be enabled anyway */
-- 
2.51.0



