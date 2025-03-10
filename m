Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E498922B8BD;
	Mon, 10 Mar 2025 17:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627917; cv=none; b=OQKnPg83J7FA0WIKFx5nwX1A6lSpRLTFif17DklC5XiusAspR2toZspkZRuuf9tntkY9PEGPLfy+F3FORI2vSDLJgoJkcf9+0DVN7g/6Cz2ITvBVt5PPxNGgpyqz3NSprtvjbuMcVToT9zTkps2QMR7a5g0nIiQ0Hn0S6JbEGts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627917; c=relaxed/simple;
	bh=VDxsG4sfRdZyyvRTLfVBldk9p49cnAa2uUdPX6TY+c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pm3PanFntNjVazJrRa8dUXesJjJpi4OmphyCvSbrbWSjeK/Mxu+IIF+WruTf4e1m9WDC1cDpNgie4vsxKc8bCMohVz2SS3vi5AoWMHHsxQKpQdu4vOCvaqnhJ1XcKMGmGUcsv8L8AwX00C0ChYijkR9zlwVcHzWfRbZRTB8NTlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HDqaG8si; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HDqaG8si"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D452BC4CEE5;
	Mon, 10 Mar 2025 17:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627916;
	bh=VDxsG4sfRdZyyvRTLfVBldk9p49cnAa2uUdPX6TY+c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HDqaG8sigGQC+gRsIBJ3oslPSH8u/qlHUNUPEHBepMYqwgaLE0Fnd0AkW6tyt7IgH
	 tl9olTBefAXf4gk5z8gv5j5JCqmIQR9m5rMJgLZ7t+oac8iW16TP38sK2khLNvaE/o
	 M7JHLaWi+Pn+w+MYeTthYj6TNAvHu23uXfWg7acM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 024/145] tracing: tprobe-events: Fix a memory leak when tprobe with $retval
Date: Mon, 10 Mar 2025 18:05:18 +0100
Message-ID: <20250310170435.712389254@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit ac965d7d88fc36fb42e3d50225c0a44dd8326da4 upstream.

Fix a memory leak when a tprobe is defined with $retval. This
combination is not allowed, but the parse_symbol_and_return() does
not free the *symbol which should not be used if it returns the error.
Thus, it leaks the *symbol memory in that error path.

Link: https://lore.kernel.org/all/174055072650.4079315.3063014346697447838.stgit@mhiramat.tok.corp.google.com/

Fixes: ce51e6153f77 ("tracing: fprobe-event: Fix to check tracepoint event and return")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_fprobe.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -948,6 +948,8 @@ static int parse_symbol_and_return(int a
 			if (is_tracepoint) {
 				trace_probe_log_set_index(i);
 				trace_probe_log_err(tmp - argv[i], RETVAL_ON_PROBE);
+				kfree(*symbol);
+				*symbol = NULL;
 				return -EINVAL;
 			}
 			*is_return = true;


