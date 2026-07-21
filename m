Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AF639733E;
	Tue, 21 Jul 2026 22:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674571; cv=none; b=n6Lq+04dKN/FhHu0lfz/ohjOLej+KXE24rc92yZ25k0yKNb8a4IYF+CIUozgFch8EUiKj0akbOOJvvukCDtEqTp82RcJH542OuQr/oQikW7OGwUOe7Lk2tPWjpuqEstLwyqOPct9buajL2Er6ykpEp2CX4yjbsxXgmZQyzB3KQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674571; c=relaxed/simple;
	bh=M8UC74cdDkyMm2IdL/0jsZD8Q+RZ02x0OoDDWVNmkfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GssmcZInRGtvxKlo3OaQqFjb9NEoJMC0FBJrrVTd0K5XxXWVt7qEtrlSaLIl1mBpfUklWgj9L0Sqod7tHRJPdkDWFG7OzC9r9jDOpAKIsr0s2tX+9tu55dPYL+xXeTrkz2CVIaQ0ehClqJDLn9prXFOzeDSS1xqgUzI5nly9uYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5Co1TgA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5Co1TgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C532E1F000E9;
	Tue, 21 Jul 2026 22:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674570;
	bh=7TOtKCS8P0YalpfwdD3rfRntBo51DgpkKJlRR/0OOms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5Co1TgAloy6jr+ur4PXyhXcs0s81Y5bbEqMif+z6Z80KgU1py2CJXubosoPLHAQB
	 fi2e10QMvB34emykbDZvPj5R+DD+wYVki/NoYpdN53zMqP8y0ladV/S6Ntrw1MXu+d
	 lyq6umfFs03UktM7u+R4ld457IxCYzVnK0OPe5F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.10 548/699] tracing/probes: Fix double addition of offset for @+FOFFSET
Date: Tue, 21 Jul 2026 17:25:07 +0200
Message-ID: <20260721152408.064004832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -401,6 +401,7 @@ parse_probe_arg(char *arg, const struct
 
 			code->op = FETCH_OP_FOFFS;
 			code->immediate = (unsigned long)offset;  // imm64?
+			offset = 0;
 		} else {
 			/* uprobes don't support symbols */
 			if (!(flags & TPARG_FL_KERNEL)) {


