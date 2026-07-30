Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920AD386567;
	Thu, 30 Jul 2026 16:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427790; cv=none; b=E7gA48jFCCDmdbjLkgqfTVEnMzRdo2p9EXAAWRrhotMj1bgMB8FNB7CLkyvmkEqFbSdAIR7I3dt8cGIL+HXNjlo/MtxYXMQsBpl8ROEY/sN9vv9cCGB1eDdpXk5d4drldTr9LCNXAMIZtKBTI6te/roqNqHuDO7HmwscD7l4p4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427790; c=relaxed/simple;
	bh=jZerhRWLcl0HwlzXbqciUx4M+/xk3dCYIgqAIMcH+WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ds+1c1PpzWkUOnu1HDOHJbGx19aAFkpIi0B8ktGcjX0MjqlFPcBUOWeFvabsIIRUnMI1vAQnkuIs0ZQaS+QVunPrPxTbIJAcEQ+PV0v04U4xcIgcrzVank+PUrIcaG6oSMc4CCGPsGHLuQnUwl/DwYQ91SDzg3C3xAYdcN3NeBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yF611Kyi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yF611Kyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB871F000E9;
	Thu, 30 Jul 2026 16:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427789;
	bh=STSnxFX2PUuQuHo28ENYqGRdGlQKPywM+8VvRcWakJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yF611Kyi36ouI6BbzJqANOYrTpnoaIAqTp6P3YyCPQgUI+KoqKx/e2VmJFqJF5BGu
	 +aE/jt17ockXf9xE3lHW0FS9Pc75UbPPSZsSmziQVR74nroTgYXWuASLgaTe7dznWw
	 DzF+pfP1z6w+v1a44Wdj00x/xKWDIBqXdF/gF9Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 294/484] tracing/probes: Avoid temporary buffer truncation in trace_probe_match_command_args()
Date: Thu, 30 Jul 2026 16:13:11 +0200
Message-ID: <20260730141429.882022229@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 15f197856d68882af9416fc97516bb55079b7677 upstream.

In trace_probe_match_command_args(), a stack buffer buf[MAX_ARGSTR_LEN + 1]
(256 bytes) is used to format "<name>=<comm>". However, since name can
be up to 32 bytes (MAX_ARG_NAME_LEN) and comm up to 255 bytes
(MAX_ARGSTR_LEN), the formatted string can exceed 256 bytes and get
truncated by snprintf(), causing spurious argument matching failures.

Instead of formatting into a temporary buffer on stack, compare the
argument name, the '=' delimiter, and the comm expression directly.

Link: https://lore.kernel.org/all/178454233010.290363.10428767141343428804.stgit@devnote2/

Fixes: eb5bf81330a7 ("tracing/kprobe: Add per-probe delete from event")
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -2105,16 +2105,17 @@ int trace_probe_compare_arg_type(struct
 bool trace_probe_match_command_args(struct trace_probe *tp,
 				    int argc, const char **argv)
 {
-	char buf[MAX_ARGSTR_LEN + 1];
 	int i;
 
 	if (tp->nr_args < argc)
 		return false;
 
 	for (i = 0; i < argc; i++) {
-		snprintf(buf, sizeof(buf), "%s=%s",
-			 tp->args[i].name, tp->args[i].comm);
-		if (strcmp(buf, argv[i]))
+		int len = strlen(tp->args[i].name);
+
+		if (strncmp(argv[i], tp->args[i].name, len) ||
+		    argv[i][len] != '=' ||
+		    strcmp(argv[i] + len + 1, tp->args[i].comm))
 			return false;
 	}
 	return true;


