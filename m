Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2705F1BDA95;
	Thu, 30 Jan 2025 14:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246865; cv=none; b=aQWIdXqpb9JkkX8ZJqGxKgl4NQUGwQqOWK2WaagbWs6eHHXMjkkvc7u7y65GisCKTN/dZZZoOefz58+kb2I/hkwILwXvAC7mayshmkFS6bN8HtdL/Z2QpvFUGFdDJtqnSspWM4nDqMlCIl5L7YR4ILBvsi32m23DU9BsFQJzBCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246865; c=relaxed/simple;
	bh=MSDa1hTBuo5GXDoiZ4cw0zZox9l8e3RJirIRxjOVn/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lm3Yrz50KtOJiy/wBac6Oz/2wPKFHrpZPVZJOFsOFAPu3RJzzJQ6MlRqqTSPDxD9/KmJh3JWh7cbcH+HeXlCsKGT+SU5UtKmlKJFLU4B5Pr45632YsV8IQ+x2h81DzucETtRSEdigiWNrhM5sb6wd/Lez/6m6YdrgzFGJF4HVgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M93uF6aU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M93uF6aU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7184C4CED2;
	Thu, 30 Jan 2025 14:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246865;
	bh=MSDa1hTBuo5GXDoiZ4cw0zZox9l8e3RJirIRxjOVn/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M93uF6aUFW4FyUQbj/3orYnvnuuK8UXmfo+nxmqVmpkqFBzEE64k4HCH759VmF40p
	 y9wLcBipytar03BbCRgYDbnkhJT7DdSwh44DMneaHnSwptDOvZOOWPpkpBvzHibjbK
	 EII7awcfehXA3ns+5AszAXh0/tDXAORAh4uXAUDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5.4 79/91] m68k: Update ->thread.esp0 before calling syscall_trace() in ret_from_signal
Date: Thu, 30 Jan 2025 15:01:38 +0100
Message-ID: <20250130140136.857486717@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 50e43a57334400668952f8e551c9d87d3ed2dfef upstream.

We get there when sigreturn has performed obscene acts on kernel stack;
in particular, the location of pt_regs has shifted.  We are about to call
syscall_trace(), which might stop for tracer.  If that happens, we'd better
have task_pt_regs() returning correct result...

Fucked-up-by: Al Viro <viro@zeniv.linux.org.uk>
Fixes: bd6f56a75bb2 ("m68k: Missing syscall_trace() on sigreturn")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Reviewed-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Finn Thain <fthain@linux-m68k.org>
Link: https://lore.kernel.org/r/YP2dMWeV1LkHiOpr@zeniv-ca.linux.org.uk
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/m68k/kernel/entry.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -182,6 +182,8 @@ ENTRY(ret_from_signal)
 	movel	%curptr@(TASK_STACK),%a1
 	tstb	%a1@(TINFO_FLAGS+2)
 	jge	1f
+	lea	%sp@(SWITCH_STACK_SIZE),%a1
+	movel	%a1,%curptr@(TASK_THREAD+THREAD_ESP0)
 	jbsr	syscall_trace
 1:	RESTORE_SWITCH_STACK
 	addql	#4,%sp


