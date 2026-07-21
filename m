Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170A9476061;
	Tue, 21 Jul 2026 21:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667680; cv=none; b=s5nm9qP9RmBSaHlPzpqgsVdeRHmes4gNsyfG5ECJuYcKCa5pRS9JSGuazzADnHBYAEX/VYXZZYVwG2391ea6Kbt0uouK5CD/H5BPXq7rJLuW6t6LXuNZHI1IGCKvVXCIQNA/9EwM7gO8LLW/tw4u71kOZpfQ/ca8N2lR3T2EIVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667680; c=relaxed/simple;
	bh=ovJsvNaoa+ycqj0fyj1JHuQIlSoQoiNUt5m0pGrvihU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBj2S1ziu0EYPlgV9AdtVpUkSCz44GeeQe63a1pccrtXaRZiiqU6KwOv1w0J2xVipuvFKEjaeR7LTlcAMUY4o4cUlAtISOPmJ8DT/2BRq0w92S/U4pNWc9fluwZXD5Tc6jXRhf5tIRnW1v/W7ACzvDx6Gf9yO3tEREpFBoCwct8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHDCH3qm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHDCH3qm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773EB1F000E9;
	Tue, 21 Jul 2026 21:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667679;
	bh=UzZr0Msw2V+mdoDdIFpfIisgvx94VAGoZkiCYfjV4fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oHDCH3qmtDspuy8+7pGtraMa8xHwH6UW86ZS7CrgsK+z+TY9mdCsTn+3LHy2mKxMS
	 qhGnb6GSYvu02j99QPujm8ROVSw4vGBu7QOS2XhiLy/jh/z5r1d6p06c1wcm7PIho8
	 hzI2/dJ9+Yd2sUTzPTOI7l8J/DYvAe8llOVgqH1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 1109/1266] tracing/probes: Fix double addition of offset for @+FOFFSET
Date: Tue, 21 Jul 2026 17:25:46 +0200
Message-ID: <20260721152506.618929325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -1104,6 +1104,7 @@ parse_probe_arg(char *arg, const struct
 
 			code->op = FETCH_OP_FOFFS;
 			code->immediate = (unsigned long)offset;  // imm64?
+			offset = 0;
 		} else {
 			/* uprobes don't support symbols */
 			if (!(ctx->flags & TPARG_FL_KERNEL)) {


