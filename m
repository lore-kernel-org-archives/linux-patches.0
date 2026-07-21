Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE3F46EF8C;
	Tue, 21 Jul 2026 20:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664121; cv=none; b=okHyhkpgVddCupjjPAdHcT1cCQulwzq1PnKe+zkYYXpmMQls4PAS+vw7d2vlooR2FfDwRA2tO3UP+kVw1OPL8yrwB+spl+ha3iFjrC3TQkbg1FeT/LqhqheKQgTCoPU3gEXLhL35yv1AFaF0TZovPXPq0LpU5OJSyY5UsA/tgpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664121; c=relaxed/simple;
	bh=unsyA6oHTsPcUpSCAH9Wrh6AJ9P+sFORVnr+09PSElQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBm36z0qQpVM9DPtj4hHF8go5shI++eiaEDh9YPH4E6Wm6eqhvbo8JWqEfuIVpyrEzIZq/HVIcfuEPfMxxsse+j2x7WuiH0LN4AEqnXpqlczISPlT+9QxtwVvc3i8Rf80O3XXlw1vk4tNwgiRoQMYwpQcrPjgUEzo6cH8UtbjWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDwMUOJy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDwMUOJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967681F000E9;
	Tue, 21 Jul 2026 20:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664120;
	bh=vkjzV4fln35PBBIGpMHoO5xaZzPZCdl5PsksP0uNf64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yDwMUOJyruH1gdx/xMzWGmcNn47jt4V+6UWoADMhO/ZQnGkqwBY7T4wlZhkQhg9VX
	 vHl7du/+wE1oIBIjtF1pgnAPRucfJg9PLl53YU7UGhxMhMnEyXyBv6j8GG/r8CEk0t
	 FSP8I8oNh+cywyw0mMcW84m6ajf+G9ofgiPrkKIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 1080/1276] tracing/probes: Fix double addition of offset for @+FOFFSET
Date: Tue, 21 Jul 2026 17:25:23 +0200
Message-ID: <20260721152510.155135674@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -1105,6 +1105,7 @@ parse_probe_arg(char *arg, const struct
 
 			code->op = FETCH_OP_FOFFS;
 			code->immediate = (unsigned long)offset;  // imm64?
+			offset = 0;
 		} else {
 			/* uprobes don't support symbols */
 			if (!(ctx->flags & TPARG_FL_KERNEL)) {


