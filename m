Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC61471264;
	Tue, 21 Jul 2026 18:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659341; cv=none; b=H+X6FVzDIn/RKWSEIgiNF3AOr/55W9OY4SSdl8iqgsVzGSCcYFozG5s1+V9YAuAY7sYgiGZnafN2Pat9sJFjBEEQeXwx/zK8/FPSIeAEhACwp3sHZKqDYZFbn5CTrvij2Ro5+8HxWKDg7BOeUZZicglYSJYm9J8FC3XTaBF8028=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659341; c=relaxed/simple;
	bh=jGvGKyIBdFZtyCaNU7+6w4W6D7OBmZf8V34URcb71wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ih1IrVhOe/eAsACMArLnSEvRY+Njy6vmGG57yNuMg4KYzRRBJvJTfEE0N0u1NwIF+ZIWotv68QyX5vTgx2ikQaHPb7nqarMcng2c2Tyk8xA/uMLM6CFAC/vO2BYaNsKlcBNjIG4TcBKqHfuF+B6ngfDUQbMzP1JnkUP0Z1MlSZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2QCIWzz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2QCIWzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112CD1F000E9;
	Tue, 21 Jul 2026 18:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659340;
	bh=yCG9VKYKrEwZ/MSvMjOj0IUCnmG+CxfcG2g5etfKUpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2QCIWzz/eXZpzySX2/RKAAuhXblZPYo+pkjLhTsS475LbSuIDCZNkcweV7h3QeAu
	 vJpW9dWrhd5HB7LBOBJ5x/if0ailMuFQUyv5qjbT3Kzz5N19DUixd0IdSIp5DZAH+k
	 YfT+h7SGCRC1j9dOO5J05QTWZSRy7mGuVvxxFbb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 1441/1611] tracing/probes: Fix double addition of offset for @+FOFFSET
Date: Tue, 21 Jul 2026 17:25:57 +0200
Message-ID: <20260721152547.859263433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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


