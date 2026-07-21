Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28186443AA0;
	Tue, 21 Jul 2026 22:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672633; cv=none; b=NqYbUv/Gy3Gtk01fOhb7y5jveUC6g191rCA2Pt3G7gKdKQTxuNPe4vithmJe0xv48XRx4nSnHxjcFpSs5QzigSF0DbJZ+GBfgK4HHZ7wEmCtLiwQlXZGToCB1DmRbbucrflNuiDdpnase3rkXeT+Wa8ZnkIzGPUBCdJdZqxsjBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672633; c=relaxed/simple;
	bh=Me1lQ8itqQcagsKXOLyOkEiifzbklsgYHAhi10TNkuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbVyQi5/5BZjMl5eLh5fhgEvbjSIM1NPoQI+ts2ArMXYdnyakPA8nZExs/+b+fX6Km1mzVJXP6I1sVGN3riSgXxoQIrv91n86ZbC99MOA0hRc/APmW8RTw0EZuQM1hPFEWbNlSyIi3UXE1h6VNF6ua33d8xzmEzk0HSjxP2fZBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUPHtpSK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUPHtpSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E39E1F000E9;
	Tue, 21 Jul 2026 22:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672632;
	bh=MC33nqje6vVwFEhKofQyU040wB++lLK/6PtG4lNRu1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uUPHtpSKVEuQS36BbKceeU7OD2AR4FkhnT4Vbe0qiNTO67A050GQMTO0eMnBFOgx+
	 lfFNRDmCcIKgzT+JdYCn/NMOxdSTtTPB6irvdTj2Ce3J5PrFW2M1vZOprSW+KtOt3k
	 k2coqvom8nczbq66pufp22kIiVbUl6QtofAuRcS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.15 698/843] tracing/probes: Fix double addition of offset for @+FOFFSET
Date: Tue, 21 Jul 2026 17:25:33 +0200
Message-ID: <20260721152421.753959064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 9a667b7750dda88cbf1cca96a53a2163b2ee71f7 upstream.

Since commit 533059281ee5 ("tracing: probeevent: Introduce new argument
 fetching code") wrongly use @offset local variable during the parsing,
the offset value is added twice when dereferencing.
Reset the @offset after setting it in FETCH_OP_FOFFS.

Link: https://lore.kernel.org/all/178217905962.643090.1978577464942171332.stgit@devnote2/

Fixes: 533059281ee5 ("tracing: probeevent: Introduce new argument fetching code")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -429,6 +429,7 @@ parse_probe_arg(char *arg, const struct
 
 			code->op = FETCH_OP_FOFFS;
 			code->immediate = (unsigned long)offset;  // imm64?
+			offset = 0;
 		} else {
 			/* uprobes don't support symbols */
 			if (!(flags & TPARG_FL_KERNEL)) {


