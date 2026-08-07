Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D2F470458;
	Fri,  7 Aug 2026 15:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115162; cv=none; b=BJTUQRnFvmPY13Y9pjqDJwHSf9qejIs4EN7X/StG4pt31KpQjpVzqfuAvx3DNCH8pKBxaun5JKCfFSI2fF24ImAdJAlNOL8Z4A0wogC1jsoUgwp4DsuAxcmYSJxpONDC2XCVANjmj8f2hfkuV3fFnO+1A1Lbl03mzxahiQaOJ3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115162; c=relaxed/simple;
	bh=D2fuskp5E/bGvWXUjwKmeR7MdJIl+ZYzMolZ0h4vP2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klDW3AdYsLmGU9YEhj4mWbanLH3a13J5Kdo4xXKC3VzM2OxpjbNCACtDM/zUM/jpsPzHTXP9AKGcat2xu15vNK6WoycpWdEfOjQu5w7BUyGnCvYpxE831guL3XIXNDO9sVGow+LropI8kgr5W/ecQu/7dl51BhdBeXxdSWtXwns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlOcTAOU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlOcTAOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B322A1F00A3D;
	Fri,  7 Aug 2026 15:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115155;
	bh=JZPKLJPAN4Q3FeNFQJGBfOVh/8PVUkGwG5eh9JwXlJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlOcTAOU0MBFZQHYZ06SFTeaJtxNTqXGxAo3HOoDmPQgZK/cOJtJu4dkHtGz6ZlYm
	 pc9ZxIFW+E+ttnT9iBF3lctPZ+l7yGbE7i0NgXTkArGsTGrrh5TaXDnnLLDlqefidQ
	 O0m9mSCjkC3wrpHk1mFYTspU83sQMFvHK2StMRFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raushan Patel <raushan.jhon@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 176/396] tracing/probes: Reject $arg0 in meta argument expansion
Date: Fri,  7 Aug 2026 16:35:36 +0200
Message-ID: <20260807143428.094800271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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


