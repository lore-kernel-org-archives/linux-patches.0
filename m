Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35830189BBB;
	Mon, 24 Feb 2025 15:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409266; cv=none; b=OjWO2slC8Ey85ZXMW21A7mPUG3iGz/eN3hF62ChMD2Q7Zp5/cpiQ7Ew200sGG+olchJ0lQnAgNefm0N9uVs426oKjJba/+gU9suMMp6L8nx+O2P6gSV5e8SSuSMimkdfXi6GMrqRpChMrIO1uU2Wdyx1nEM2ZPXEKH+Qsq29WfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409266; c=relaxed/simple;
	bh=rEuGArpgKcQPqAxK3FVkbL0RzXk65hqCKcVB+TeJQZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxpzLzy9i2ZiaA+G7Yf/Qf5LYFzNv3NMrBAzvl0Wz5t4RwQHYQ1mJj4cmHFl6dYZKTM6rt62XjU9whNPcIOkT3Vu14jmRJxo+LpqOHDnz+12iRfUrQVPaZsXpu+qBOqsu59ZYShA7D/BJCwlI6HhYpWM2L12Ly1tBCxicdm2ACw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvRsiJX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvRsiJX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3563FC4CEE6;
	Mon, 24 Feb 2025 15:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409265;
	bh=rEuGArpgKcQPqAxK3FVkbL0RzXk65hqCKcVB+TeJQZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvRsiJX3YKPRbCAXYNqi2ZxnYreMfscALqet2CNIPk8MrJqPe2DCXb/bzVtxTRd2/
	 1n7wBuEeOxt/y5qq47StoCn3BkOdVYEB97TRrPspVq4FVD5aziulOblKqf0IWjJdZI
	 4ZOppyyRTUn4biOjNfDfPA6Pks54hzaCeOrvB0EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.13 135/138] tracing: Fix using ret variable in tracing_set_tracer()
Date: Mon, 24 Feb 2025 15:36:05 +0100
Message-ID: <20250224142609.774996710@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 22bec11a569983f39c6061cb82279e7de9e3bdfc upstream.

When the function tracing_set_tracer() switched over to using the guard()
infrastructure, it did not need to save the 'ret' variable and would just
return the value when an error arised, instead of setting ret and jumping
to an out label.

When CONFIG_TRACER_SNAPSHOT is enabled, it had code that expected the
"ret" variable to be initialized to zero and had set 'ret' while holding
an arch_spin_lock() (not used by guard), and then upon releasing the lock
it would check 'ret' and exit if set. But because ret was only set when an
error occurred while holding the locks, 'ret' would be used uninitialized
if there was no error. The code in the CONFIG_TRACER_SNAPSHOT block should
be self contain. Make sure 'ret' is also set when no error occurred.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20250106111143.2f90ff65@gandalf.local.home
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202412271654.nJVBuwmF-lkp@intel.com/
Fixes: d33b10c0c73ad ("tracing: Switch trace.c code over to use guard()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6102,8 +6102,7 @@ int tracing_set_tracer(struct trace_arra
 	if (t->use_max_tr) {
 		local_irq_disable();
 		arch_spin_lock(&tr->max_lock);
-		if (tr->cond_snapshot)
-			ret = -EBUSY;
+		ret = tr->cond_snapshot ? -EBUSY : 0;
 		arch_spin_unlock(&tr->max_lock);
 		local_irq_enable();
 		if (ret)


