Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E56612D7;
	Tue, 20 Feb 2024 21:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463875; cv=none; b=S7K5pkBs07RK/E9a0RDvOySapFZKhzWpk+/2ojVYcERsJl94A0n+FXb9Y4Z2b5LPTNPRqTrAQSOIoQWa6p7i1hanTXC5VpUCByTaqqxwChAHrwWo2NQOyMxJF7W9GHyu1e/noDqtrtGOEVMCwHU4ocJPggZwuEqPECgUIsiTfLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463875; c=relaxed/simple;
	bh=e/fJYBdyQ64yV33CfczsvpMXvu8emRMdRYoXn/Z2lGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixxKQ8kt2ALQVseEyHLOixGWaVtA/kLoXuQ/vLrqT1mj2KBAXf01gSb2oCGe0rnGOeLngCDoy/m2D76KZBt5l4qG1pvFZDbXy5/kgevsRZj4s5wiacAP/stGuIHF972ZY6/4v89eQZ+/+HCH01IfHgXx/f2DTWiP44LM6u+bKXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TzBvfhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TzBvfhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF13C433F1;
	Tue, 20 Feb 2024 21:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463875;
	bh=e/fJYBdyQ64yV33CfczsvpMXvu8emRMdRYoXn/Z2lGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TzBvfhlDvK2lCJPzhNs6Drn9VUeZN4A/EDDF02emmiDZ9dewESW01GkrE0whiTMs
	 4Mrt2LsYVVGpaMc2aG6pmAg96P5NJ6+17ckViZvWK6ok/fla8c/+Qic2bTa+Rd+dF5
	 kPdgg0m8zsjscw2YvjdatGiFkhaJWOvDOxhL6AAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 152/331] tracing/probes: Fix to set arg size and fmt after setting type from BTF
Date: Tue, 20 Feb 2024 21:54:28 +0100
Message-ID: <20240220205642.315102204@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 9a571c1e275cedacd48c66a6bddd0c23f1dffdbf upstream.

Since the BTF type setting updates probe_arg::type, the type size
calculation and setting print-fmt should be done after that.
Without this fix, the argument size and print-fmt can be wrong.

Link: https://lore.kernel.org/all/170602218196.215583.6417859469540955777.stgit@devnote2/

Fixes: b576e09701c7 ("tracing/probes: Support function parameters if BTF is available")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index c6da5923e5b9..34289f9c6707 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1172,18 +1172,6 @@ static int traceprobe_parse_probe_arg_body(const char *argv, ssize_t *size,
 		trace_probe_log_err(ctx->offset + (t ? (t - arg) : 0), BAD_TYPE);
 		goto out;
 	}
-	parg->offset = *size;
-	*size += parg->type->size * (parg->count ?: 1);
-
-	ret = -ENOMEM;
-	if (parg->count) {
-		len = strlen(parg->type->fmttype) + 6;
-		parg->fmt = kmalloc(len, GFP_KERNEL);
-		if (!parg->fmt)
-			goto out;
-		snprintf(parg->fmt, len, "%s[%d]", parg->type->fmttype,
-			 parg->count);
-	}
 
 	code = tmp = kcalloc(FETCH_INSN_MAX, sizeof(*code), GFP_KERNEL);
 	if (!code)
@@ -1207,6 +1195,19 @@ static int traceprobe_parse_probe_arg_body(const char *argv, ssize_t *size,
 				goto fail;
 		}
 	}
+	parg->offset = *size;
+	*size += parg->type->size * (parg->count ?: 1);
+
+	if (parg->count) {
+		len = strlen(parg->type->fmttype) + 6;
+		parg->fmt = kmalloc(len, GFP_KERNEL);
+		if (!parg->fmt) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		snprintf(parg->fmt, len, "%s[%d]", parg->type->fmttype,
+			 parg->count);
+	}
 
 	ret = -EINVAL;
 	/* Store operation */
-- 
2.43.2



