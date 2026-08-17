Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596B943B6CF;
	Mon, 17 Aug 2026 13:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975193; cv=none; b=aqnFzkTT4tiZ99DrhSgvLtafy0UFprU3QBVihL5OaifwD2N+QZNI41aHUeJXZdFVrfl5z8BUJycesv7IqR8Ze6hAh2+srQL2m2ebcoHtSj/Kv2eWt+3/C59DG94te+tPsIMZM/Vu6ygKHMoY+fW1uNr/P2TzeoaakBOxUnntQpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975193; c=relaxed/simple;
	bh=0vH14OiPpNRm4koyXekHTKGnUXyP5Q+3T8YKvUtyiXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GULTx8OueqdDd4ZMdTGqWV588y4Yyxj4OYIbOQZRIo2bsxsvRwI/RIMoJQ79Nau5+o9DiX//whPWmYcUWOWy/lb++TtieY6Ds1od6TlroSQ2FdCCxmOiDk0/Zup9RF6wHPA/1vEaPzd9PJ7SINb0DG9WSB0bR5xpvGNBFA9riKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPeamjaO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPeamjaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAFA1F000E9;
	Mon, 17 Aug 2026 13:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975192;
	bh=UvOc7+z04hTAYi7LI+8Usyg5YuMAP8P+Ll6tYN8IuYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oPeamjaOu2NgyvNK7zVSYFRrfmlVVP0VIWXW30EF4RBP4wdgibKXPrb/+gt0+2pGk
	 nd+WSAipt+OXyPtwu0UTOuFXNA52fsfxJzm54IY0utb2m4Km+cbtNREuDs/g/gIyoK
	 dXS45oTT57RSWSe+kdVcqp+lKeV51OJMwihA38uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4d3143c8e28f6266c636@syzkaller.appspotmail.com,
	Hui Su <sh_def@163.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 193/250] tracing: Fix NULL pointer dereference in module event cache removal
Date: Mon, 17 Aug 2026 15:32:34 +0200
Message-ID: <20260817132544.445961960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

commit b69859204d4db3acd86c1c2dadcef0d77b451933 upstream.

A module-only event filter such as ":mod:foo" is cached with a NULL
event_mod->match when foo has not been loaded. If a later write tries to
remove a specific match from the same module, remove_cache_mod() passes
the NULL cached match to strcmp(), causing a NULL pointer dereference.

The issue can be reproduced from userspace:

  echo ':mod:trace_events_kunit_missing' > /sys/kernel/tracing/set_event
  echo '!foo_bar:mod:trace_events_kunit_missing' >> /sys/kernel/tracing/set_event

The second write must be a concatenation (">>") to not include O_TRUNC as
that would cause ftrace_clear_events() to clear the cached modules lines.

The crash was reproduced on x86_64 QEMU while KUnit workers contended on
the event tracing path:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor read access in kernel mode
  RIP: 0010:strcmp+0x10/0x30
  Call Trace:
   __ftrace_set_clr_event_nolock+0x373/0x4a0
   ftrace_set_clr_event+0xf0/0x180
   ftrace_event_write+0xdf/0x110
   vfs_write+0xf6/0x440
   ksys_write+0x68/0xe0
   do_syscall_64+0xf9/0x540
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Check event_mod->match before comparing it, consistent with the existing
NULL checks for the cached system and event fields. The mismatched removal
continues to return -EINVAL; a broad cached module filter is removed with
"!:mod:<module>".

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260811173902.1927376-2-sh_def@163.com
Fixes: b355247df104 ("tracing: Cache \":mod:\" events for modules not loaded yet")
Reported-by: syzbot+4d3143c8e28f6266c636@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/6a7a6b7f.9c11d2ce.289b96.00f8.GAE@google.com/
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -930,7 +930,7 @@ static int remove_cache_mod(struct trace
 		if (strcmp(event_mod->module, mod) != 0)
 			continue;
 
-		if (match && strcmp(event_mod->match, match) != 0)
+		if (match && (!event_mod->match || strcmp(event_mod->match, match) != 0))
 			continue;
 
 		if (system &&


