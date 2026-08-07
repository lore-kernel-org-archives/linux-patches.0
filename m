Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A1F381AE4;
	Fri,  7 Aug 2026 14:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114084; cv=none; b=PeP5YRO90ONfl9kRev1Y4YamcrnfA/ICn8nCk483GxsGp6XrzWXQoq0MROl6KIL3NsMEF3D0iO18Qr66I+o4BUM9onXxWQrGANHvdqZEGZSpnRLeqmwvZP4SgfpNU6sSKGJAOvJMZ2oXDKDNvk2OOi7yxh9xgIyKwPE7uws4Gfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114084; c=relaxed/simple;
	bh=hlx3y4Mm/l3qeOg1Wi/mZCU6Yb/1dl4yCXh+2XeBsN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gujTHH1yoPBXdWDdztumTq2laXAnAgu3jCE6Vnpae25dzD6Whzwi4APF2pPtGNWpPKPVq2zqHwVlcvE0SwpKf3ZmroaxYkqocLkxLsPQ8uFr4t7gWZAi7GWWiR7U0VeOL2iwK5lvtPjAX6LIpPSns69lUqb3e6tUeXrbfRvv+rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/IPLBmF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/IPLBmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25151F000E9;
	Fri,  7 Aug 2026 14:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114082;
	bh=HPntIiSko5l8FYmoLyzF8Iypvfgcfuf8LzwmO1hUeoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F/IPLBmF1K9wMAm95vVQezz1brkdOZzZ54igm0coucmIxKhFc/png5ApfdH/l2xFK
	 TWzvkXf5AsnrxkWjOfObMJ/RxJy+eBbljYbQE0XqNik/LII5vzr6SQALttmmqS+vbM
	 y2QLce1kUYcJiiyaCHKbL8xfRQPkcu3tC4AROxzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raushan Patel <raushan.jhon@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 139/337] tracing/probes: Reject $arg0 in meta argument expansion
Date: Fri,  7 Aug 2026 16:35:42 +0200
Message-ID: <20260807143421.548391164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1766,7 +1766,11 @@ const char **traceprobe_expand_meta_args
 				ret = -ENOENT;
 				goto error;
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


