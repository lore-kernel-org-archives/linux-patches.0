Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28A83FE67B;
	Tue, 21 Jul 2026 17:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655106; cv=none; b=rhb1rNxUHAZrtQ0n+0eCm4Ada2TolZhdXr+pUHzNshFc/0pEmLy09r6WqPRrp+Um00/wYZerZ0Lhxoq33nOu0mGXJsZ11JsEWG9nF8SKaC3AEmnRPUJAgUrVlBfB+ccIqQPuGKj7sjMuwvHy2dixA6OVtVqwwHxqoGGtGzyhqsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655106; c=relaxed/simple;
	bh=STX95yzDJrl58x3z/0LPeVq8HnJKt3Jbdv5z9xKCsr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCtKTVybct1p/rMJtZrwsXUQQ9b/fNtEIxenvB4IDCKS3Dq5MnoZDTM3OQUgkrdX5ahcd4zdeygaUdtVB5gJy4KQdT3cVyv49L+Tfwt5hrLuLNqD0A5fHLLzvFbhlTZhnoJu28QLG4cvnEMlZsf7HbOcH08m17ho9Q3/O9G6dwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7Qi6c2G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7Qi6c2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EFE1F000E9;
	Tue, 21 Jul 2026 17:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655105;
	bh=E+2zUsqccs4bfudoUlT1ukTyW/CDfbNipg6ggTpZJw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7Qi6c2GPu0N9CY6Z1Cpe1bmmPoCGFNGEwlRCblUx9CyD5j1q/UmVS5m7CdzuXiRu
	 DMqaDYdO++k0VzaRt23W/Y+u41HQVZbN0BuUe6j2KE1LOQrV+FokG8wl2Jn9BEY9qH
	 dVNke2gfNJ57XpVRVVKwqnr1+Ly9QeafSS5ifyW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.1 1958/2077] tracing/probes: Fix double addition of offset for @+FOFFSET
Date: Tue, 21 Jul 2026 17:27:11 +0200
Message-ID: <20260721152638.891883080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
@@ -1248,6 +1248,7 @@ parse_probe_arg(char *arg, const struct
 
 			code->op = FETCH_OP_FOFFS;
 			code->immediate = (unsigned long)offset;  // imm64?
+			offset = 0;
 		} else {
 			/* uprobes don't support symbols */
 			if (!(ctx->flags & TPARG_FL_KERNEL)) {


