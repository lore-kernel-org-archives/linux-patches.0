Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1032236F2;
	Thu, 30 Jul 2026 15:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424733; cv=none; b=mN4Mwm8rjh00wpyErJFRw05Y8aSCYnDlcGmRaqqCWy+cM3bTGxHqVyDvBCNWA7ctTB3XCyprsFQKuJ5wQA6W/qvAmY8FIY48CKPF1SNMl6CRp4Js3u3RP8m7acbgZrwk3KAsOpGMPy8mwngGiNBLqzR8yMh09nD+xdPD4axiOkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424733; c=relaxed/simple;
	bh=go3V8XyGQx4Lwcs+QRbGWAivxOyWMhSh44y54hH7964=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXvz1f7tZ28cFNETktqDesO5m239z4NhnSd2D97I9XTIk7QM4HaAXkxXmaw9992LD/bino5Fme1RwdF2Cg679GseDqOPc9uIdTyqwcaPqXx8Pis2HfG0sEMSamZ94JCSAyFvVMoO1lUbsNiOIQyiu/YVYqraN9Q4qAeqBP9RZMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2GPDl9x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2GPDl9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3571F000E9;
	Thu, 30 Jul 2026 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424731;
	bh=3IsEhGWW3Pcb/y10jxJTkm0Ft1WG/kTkpJhcynfKVNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2GPDl9xpaW1brS6COnaebDf9vYY81j+gSJhOR2kIUjodB4/nraxTvEbXtsOBCqfp
	 Vnur7WULHjm2+wu98iNYEwXvY/KrHhwGt8j5tnFHi48dXKLQUMogPIdvNSJTOPwlt6
	 MkLiYehISAUgEiWoZsGnO7tAsGbNQBmuiuZuEOJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 495/675] tracing/probes: Avoid temporary buffer truncation in trace_probe_match_command_args()
Date: Thu, 30 Jul 2026 16:13:45 +0200
Message-ID: <20260730141455.645211346@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -2344,16 +2344,17 @@ int trace_probe_compare_arg_type(struct
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


