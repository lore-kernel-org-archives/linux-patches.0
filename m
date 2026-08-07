Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF8E27466A;
	Fri,  7 Aug 2026 15:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116052; cv=none; b=THft90c3YKLP/nOK5ma4oaZ44xKxtx/ktjj8RwMBU6K3wq8da+FK9SEkH3+ngPzcISSHt+0LKDfqOoXsSydeUqthoqZ9Llu4eCCeDSVUc2z3iVyp+JiOPaBwpQ75iz5N414AsWK63GmRg6shvi+vPEpNrjAlMf6Z9AJGsDLT/xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116052; c=relaxed/simple;
	bh=oE25t7p3K3GxfdAF/Z1KuIJxhCNMdowcZqiPRR1Ec/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKPerPflh32ORAt53J7fn6g4DlDnSFDQOrcQ4sXfzle/dPUtnb17x+cqkfFomA3biTFP4UeVTDyCymAz40CGRur+xNmq4eCDhFxRhQahsHBT66royXow5HFhH04v+DhKcA6YHa2lnoeGooyOdXfEstfAUdtVg0X+biQ7s+14XpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHSOzL2Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHSOzL2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D651F000E9;
	Fri,  7 Aug 2026 15:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116050;
	bh=9c0kMCWTFqFynGEstj2N1hf+kJQ+COUpq2nZJRttRKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHSOzL2ZVgkn9Lvxv6W9xYhD5raS8UyMJG3coexd9+LBIc3muJSY59JlMqcaLC9jc
	 aCfCisKXLu8LqSfC9iKABqL8g3D90Dsp7+JfDZBePi+zWL0cb3l6yu6FHN/h5Q7GHI
	 pbHK+0CjPvYeX4vVC2JJT78wXJQak1Gf1Waoe5sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raushan Patel <raushan.jhon@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 095/261] tracing/probes: Reject $arg0 in meta argument expansion
Date: Fri,  7 Aug 2026 16:37:32 +0200
Message-ID: <20260807143417.434454264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
@@ -1721,7 +1721,11 @@ const char **traceprobe_expand_meta_args
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


