Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5713E49E0;
	Mon, 17 Aug 2026 14:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975920; cv=none; b=m11hf1EY/1DTvKWlWeqc9bg1Xuk2qI6mRbmaBXmGNj7okBef1m4N5hebdmZRlNY7YfEbjkpqnLhOcCi7l59d/28oIpFXAp+n1WWsE/mWe1L2xkD04/b7ugjC2eKwGOOss86HsRoUHbbz8W8zYXRG3TN5ZLlwqyoYGzJKR/y/NaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975920; c=relaxed/simple;
	bh=5ARbBSrsovBBZNMwXvCou4SO24HG+bobSVLBywFHsz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cm73EGiUlqFtK5YVFvTxaqO1Ipi7SBSZPc63yndi95EQnTSQuHe1H3QMvvmfdAbROm/md06Txaq1fkMub6DsUXjiRe6Nn0MlKAD6oB4htVBLJ20rUzxEZeOYuvbzJCaiB4L9OwUt0rinquCRW7i3Hzb1/2WOy82zdkzZxSJlW2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0E0idjd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0E0idjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62411F000E9;
	Mon, 17 Aug 2026 14:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975919;
	bh=u4LD9oqIdYq/d/9HBunoaHyxLlNrqdLJ7B4mpUp5wYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0E0idjd5UnVft8CgZwNWNnL7lbIz7Qz6IHogCDCGWNLjr2Q56SBoEYF7cTNDjS4u
	 uIGgJJuE+onaU5cV+ZZPLiUkE00W5I9ciE6/aBCJ82Pdxk6Fsnzs+DwQlkVzhrpzW9
	 yrsO5ejWvTTXCZUNa97FLLlmmbJcZoZwvo0urh04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.10 154/389] tracing/probes: Avoid temporary buffer truncation in trace_probe_match_command_args()
Date: Mon, 17 Aug 2026 15:29:53 +0200
Message-ID: <20260817132545.196443147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1150,16 +1150,17 @@ int trace_probe_compare_arg_type(struct
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


