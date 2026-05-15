Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0C83E0090;
	Fri, 15 May 2026 16:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861657; cv=none; b=hR6Gpz/DsvwS6/2cWa0pq/R9i/KpCUXOyUlZCPj6P0EdAuCxmPHhvX/Zj8xEZ/rmjk/4hepUxPK11Ia7iHMCelwXglof6IyAbjcvUam93PbVQAOgKAjjSTSyGdl7duZDxtR/qkXnGn3ng+ngoXTDaGz/EY6Bi0KS5WJR17QmIWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861657; c=relaxed/simple;
	bh=ytPqvQlBQ1tMvd/kmz/Jig+4ud2EIMAXpkGzv0E3emA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBZy83pE5ufid3GwTxCrcZh/H//sC/pV2cMCL+CcsVAZZgboQWTKtbJRgn0ubMZnB3L5SozmLNPC+CDoQa4Q0EihPakg1U1+1yiTVU3pKAeuR7G7q677B7HTXDzTQiUvcnYGPxjfjS0m5KB0N62R1QGI2jzi+MAoCpJy8abEY5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cie34h8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cie34h8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75223C2BCB3;
	Fri, 15 May 2026 16:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861657;
	bh=ytPqvQlBQ1tMvd/kmz/Jig+4ud2EIMAXpkGzv0E3emA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cie34h8uZWgltwLnYoYyskLveNVUpw9geSLYsZsIMWCXDgZlBUFT0Ulp8IkRpytAA
	 bF7EZGt76RA/I5d+0a5F/jzUVHkzSpdPTTk5l32hF9TZGN7JFTWg/AnUs+vqPswX1p
	 FW4IE1d/ngU6GeKcu6hwH1tkBXRvKl6cD4UsTKMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Carlier <devnexen@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 412/474] tracepoint: balance regfunc() on func_add() failure in tracepoint_add_func()
Date: Fri, 15 May 2026 17:48:41 +0200
Message-ID: <20260515154723.969897741@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit fad217e16fded7f3c09f8637b0f6a224d58b5f2e ]

When a tracepoint goes through the 0 -> 1 transition, tracepoint_add_func()
invokes the subsystem's ext->regfunc() before attempting to install the
new probe via func_add(). If func_add() then fails (for example, when
allocate_probes() cannot allocate a new probe array under memory pressure
and returns -ENOMEM), the function returns the error without calling the
matching ext->unregfunc(), leaving the side effects of regfunc() behind
with no installed probe to justify them.

For syscall tracepoints this is particularly unpleasant: syscall_regfunc()
bumps sys_tracepoint_refcount and sets SYSCALL_TRACEPOINT on every task.
After a leaked failure, the refcount is stuck at a non-zero value with no
consumer, and every task continues paying the syscall trace entry/exit
overhead until reboot. Other subsystems providing regfunc()/unregfunc()
pairs exhibit similarly scoped persistent state.

Mirror the existing 1 -> 0 cleanup and call ext->unregfunc() in the
func_add() error path, gated on the same condition used there so the
unwind is symmetric with the registration.

Fixes: 8cf868affdc4 ("tracing: Have the reg function allow to fail")
Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://patch.msgid.link/20260413190601.21993-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
[ changed `tp->ext->unregfunc` to `tp->unregfunc` to match older struct layout ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/tracepoint.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -337,6 +337,8 @@ static int tracepoint_add_func(struct tr
 			lockdep_is_held(&tracepoints_mutex));
 	old = func_add(&tp_funcs, func, prio);
 	if (IS_ERR(old)) {
+		if (tp->unregfunc && !static_key_enabled(&tp->key))
+			tp->unregfunc();
 		WARN_ON_ONCE(warn && PTR_ERR(old) != -ENOMEM);
 		return PTR_ERR(old);
 	}


