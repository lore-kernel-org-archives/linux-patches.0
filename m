Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C41306754;
	Fri,  7 Aug 2026 15:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117169; cv=none; b=kDKkplM7JJRkGKnwRJO/id+Q5W6MZBpJtOLwJgf+yhjYtTUn3AWluf/HTSi4hJtvx+P2ibGG4WdvupDa/PgLmyN4kxkfHDaYdq7LlwkTfb+Nyc9/BqegPcZbev76qj7f7KaOY0WNZenVToKIz69T6QCoKdmt7Rj2xxETW9yAz88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117169; c=relaxed/simple;
	bh=XHNEhPnlBgqCwSZ94xhOHoQ6Qm2BprrJ2nJcEFFrjyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=am/8rHmtUvja24RLUWyJEjVsSLReQxypXWqosVmJQURk0zd4u5MfBuhBErJM6MDKbLLZ3+JQTo5FYmGGHDjtdJFxevq2HYDCghQt4frDNFvWGtrhOk4ZM2f/syNLiOMSp7lvEEoKwKxLStEDnbWQOYzC1TPNU11foSS1TRwU1yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=upSOnQ8O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="upSOnQ8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B435D1F000E9;
	Fri,  7 Aug 2026 15:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117168;
	bh=AUvNxeTt5jJs5BaO+NdlPJKfgXKcamqDBhyvDQkliNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=upSOnQ8OtG/LXKUh4CzyImz9St4+eGSzfHiCKW1MWxcvRpQv+2QxQa/gRpQKIu6Up
	 JZse8tHngC2rn5mJqD1ueiWKeAjlqgNJCP8CDV8SMEr2AZ9cdqQYYJ221sq6uYrQnc
	 UAFrNqk3qaSmLDc5QJykQCgAES37FqJ4n8tiQg4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raushan Patel <raushan.jhon@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.1 225/438] tracing/probes: Reject $arg0 in meta argument expansion
Date: Fri,  7 Aug 2026 16:37:01 +0200
Message-ID: <20260807143432.801330686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raushan Patel <raushan.jhon@gmail.com>

commit 00a8ce2a2a9fa17674e1feec4d9105c1a5d6a419 upstream.

traceprobe_expand_meta_args() parses $argN with simple_strtoul() and
calls sprint_nth_btf_arg(n - 1, ...). For $arg0, n is 0 so the index is
-1. Because ctx->nr_params is signed, the "idx >= nr_params" guard in
sprint_nth_btf_arg() does not catch the negative index, and
ctx->params[-1].name_off is read out of bounds.

The normal per-argument path (parse_probe_vars()) already rejects
$arg0 via its argument-number check, but meta-argument expansion runs
before per-argument parsing and substitutes the value first, bypassing
that check.

Reject $arg0 explicitly during expansion.

Link: https://lore.kernel.org/all/20260724054435.146279-1-raushan.jhon@gmail.com/

Fixes: 18b1e870a496 ("tracing/probes: Add $arg* meta argument for all function args")
Cc: stable@vger.kernel.org
Signed-off-by: Raushan Patel <raushan.jhon@gmail.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1906,7 +1906,11 @@ const char **traceprobe_expand_meta_args
 				trace_probe_log_err(0, BAD_VAR);
 				return ERR_PTR(-ENOENT);
 			}
-			/* Note: $argN starts from $arg1 */
+			/* Note: $argN starts from $arg1, so $arg0 is invalid. */
+			if (n == 0) {
+				trace_probe_log_err(0, BAD_ARG_NUM);
+				return ERR_PTR(-EINVAL);
+			}
 			ret = sprint_nth_btf_arg(n - 1, type, buf + used,
 						 bufsize - used, ctx);
 			if (ret < 0)


