Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34627153808;
	Mon, 24 Feb 2025 14:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408748; cv=none; b=V+XDcfnB7jRoyqigMKj6hxDaXv2XITWxm9HpbYHPXZmhAHpACOb7Mj6RTYAUJQhTn53OWfzFfR51ERB01T/ioR2ji7OUCHJ63M4PurR4FLs6fniJM9tvbP7NJAolWEzRsFHzex78Lmg/gKlZM6atvu7pMHvcUcl8bhWSfD6+FQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408748; c=relaxed/simple;
	bh=V8QQniWoF2lLZvDxXbxVsUmQB5Sa2jGLjBbG3RRDUsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fn4Xp8edmqKMPbGp2kvIglad8Dnu2I32p83pAbMF4SvBxOUgWCwoqt+Nm2AcyRD2Il8tRcW8K2K14n8Y5v5zcOXfnAXN/XsHYbLl/JABNepOqE4b9Zi9OCfJXaKOf54mvrq6y3+HIHoIJpr8euWAuJ9Gjoo1FtodyA/iiW/jhg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZrYEoQny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZrYEoQny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43434C4CED6;
	Mon, 24 Feb 2025 14:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408747;
	bh=V8QQniWoF2lLZvDxXbxVsUmQB5Sa2jGLjBbG3RRDUsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrYEoQnyLeTgCIi8mUGQUMQhDAGepjcZkt/FgntgC0sMiy8dJfJCcrg2np96gIW1u
	 HB+n6ifdGm6zoHoAG1t1eD0LOKDbVWOzmDOw9NnRJ/vMHEgbCjedMt+p03ouzbEYiW
	 YQ5HcoNM8dvFrfDtmzkT3gAYWYEN97223zkXqONk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 148/154] tracing: Fix using ret variable in tracing_set_tracer()
Date: Mon, 24 Feb 2025 15:35:47 +0100
Message-ID: <20250224142612.841199488@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6125,8 +6125,7 @@ int tracing_set_tracer(struct trace_arra
 	if (t->use_max_tr) {
 		local_irq_disable();
 		arch_spin_lock(&tr->max_lock);
-		if (tr->cond_snapshot)
-			ret = -EBUSY;
+		ret = tr->cond_snapshot ? -EBUSY : 0;
 		arch_spin_unlock(&tr->max_lock);
 		local_irq_enable();
 		if (ret)


