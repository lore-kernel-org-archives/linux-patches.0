Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5961821A447
	for <patches@lists.linux.dev>; Sat, 25 Oct 2025 19:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761420358; cv=none; b=FzvPZahZEgeIkCUDsFJ0yNILZ8HMRYxNKPxUyka0vaFGY7I93ZFyLe9ODPeJixz07e6wyqgq5cPBp269OUQDhXopeLBXw1w56Kdi8+BSGmnDHcs61hU4cmY7Lf/O2pimLXmpOToGeaaR1EwTXoEMbyMYWPsCfGroag22ZmC+K9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761420358; c=relaxed/simple;
	bh=XMqi7Bh1BNLZKfN+KZrTPFp8zjrMA4E+wj7kNBhSdh8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C0qiTV40rHTQl7u4sSxzx9s0OMzQbO8MwQi2f85irQP+1XdYYMM3hsvJtVsTt5WPQe1aEZEqTVW8ledrVtOg/rkEZJRUoXf/aS29P8+LfofWxVi6yuZmcDEFKk0NhAQsGw3OOLmCAS7asSqn2hgbsnk4/9CO+bRgtwWEYSMmhhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ACD0B129347;
	Sat, 25 Oct 2025 19:25:48 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 7F4FC2000D;
	Sat, 25 Oct 2025 19:25:46 +0000 (UTC)
Date: Sat, 25 Oct 2025 15:25:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, Vladimir Riabchun
 <ferr.lambarginio@gmail.com>, mhiramat@kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.17-6.1] ftrace: Fix softlockup in
 ftrace_module_enable
Message-ID: <20251025152545.534cb450@batman.local.home>
In-Reply-To: <20251025160905.3857885-385-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
	<20251025160905.3857885-385-sashal@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 7F4FC2000D
X-Stat-Signature: 6yzqks5de9frsbsiwds9bwsbas7hfgd9
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19Xb9xl1QfjMzJ0FPDKue1X1sp4w9TAnjA=
X-HE-Tag: 1761420346-248664
X-HE-Meta: U2FsdGVkX18ELnPSb5L3NDlysnvw/R0s3/WOQlBy9kZTIosIrZ+9IV6rFjTPeDLJMTGvk5Y5PtiMLyuk1RFcckxgwX9jPYHWZ2Ybi13GKOwUpkQRYGORVb/WWVh4W0I7veCeBx188jIZqTU8qmUhWKRk0qPWi/TcHx6YtRfIcyOmMcYAAx5ELsUjxdM/QOnet7d+jdDa6Mh7+Fe09PXtSU4+yUa+peHpMQ8mlY0heTarLu4bX5IA71KcRe6z9yCRpEC4v8WYX4/rJJ0+w0/Kr5qTC8BFK4hpAoctCKWVtg4nwVRJ8eXWoocFK+elYX1wdpzFg0jWhQDwIbaPPLa+BLDsGdZHWFW8

On Sat, 25 Oct 2025 12:00:16 -0400
Sasha Levin <sashal@kernel.org> wrote:

> - The change inserts `cond_resched()` inside the inner iteration over
>   every ftrace record (`kernel/trace/ftrace.c:7538`). That loop holds
>   the ftrace mutex and, for each record, invokes heavy helpers like
>   `test_for_valid_rec()` which in turn calls `kallsyms_lookup()`
>   (`kernel/trace/ftrace.c:4289`). On huge modules (e.g. amdgpu) this can
>   run for tens of milliseconds with preemption disabled, triggering the

It got the "preemption disabled" wrong. Well maybe when running
PREEMPT_NONE it is, but the description doesn't imply that.

-- Steve


>   documented soft lockup/panic during module load.
> - `ftrace_module_enable()` runs only in process context via
>   `prepare_coming_module()` (`kernel/module/main.c:3279`), so adding a
>   voluntary reschedule point is safe; the same pattern already exists in
>   other long-running ftrace loops (see commits d0b24b4e91fc and
>   42ea22e754ba), so this brings consistency without changing control
>   flow or semantics.
> - No data structures or interfaces change, and the code still executes
>   under the same locking (`ftrace_lock`, `text_mutex` when the arch
>   overrides `ftrace_arch_code_modify_prepare()`), so the risk of
>   regression is minimal: the new call simply yields CPU if needed while
>   keeping the locks held, preventing watchdog-induced crashes but
>   otherwise behaving identically.

