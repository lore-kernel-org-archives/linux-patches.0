Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774259;
	b=oVnP+5VXof7QgoJEarzklUVl3tXLKGGLTQZqJwMg1OrRSC+CG+8gDCb4+rog0byTFXmz
	 7udmkd7fA7pMSg8XuTyyGPTbJGuotPYOxbNOKtjuR80aahsm1Gn7NLkjZQ7DnOxO++WVu
	 ZyCyiiz08wh7L8zpHdtVFDQfJzW2IOEjHldpSrwfUM2+dVMRAlRMCCCqfmQccFlWpLeJt
	 Zd2wOsESqw9Onfc2Gh3PlAnRaH9fHlTbqxnYmrhNisuAypcnd3s91DgYfsM7RJhpZP0+Q
	 HKeGHlfnR4kwzTG95g58501An1QFYS73GYSL38M+yAC5JpNmfzjs3v+3plUMk7FMQHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=62WF9CBnlkUbOtfneh+X/n2H/QB5Rc/e4bkdu57XVPs=;
	b=xuH4U8sbcGchqpLiyBcAEdAOvmaj+BqoIcr0DNvVwu7E4yJYJ4rf2ChV1y44fRoNgkoy
	 1pOTgkSjT0TU1Fv/Kr543rslol0MbG1MUmkJU+azHSCW6TfJKEHMouxaT7xzAZ0viD7Yn
	 37imBnkSSaUGNIQw9G+yFFHmjedyllUDtVgFkCVhOEd5WhmBJ6LJaR8VCDIn16KwjN3qo
	 VGiHihkOHfn5rtO/R7yH1sb3v8jsy79itVqbti0hemVECdcqI2MyBbroWBCcsn2EsXSAD
	 ehvXFMCkYcqboVwidpDE5vRFKzacsFvOdgeEoYKalAAGILpsCRXaUTp8SyLe5h7Q8GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SrV18yMg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA36606A32D;
	Fri, 23 Oct 2026 16:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SrV18yMg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686CA1F01829;
	Fri, 23 Oct 2026 16:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774259;
	bh=62WF9CBnlkUbOtfneh+X/n2H/QB5Rc/e4bkdu57XVPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SrV18yMgl0N1aIE/Q9n4y/QMBU24dPMnZubUsTZWR9OuKMumLIqq0/flB67TxxsnC
	 HQyQvufFooQnc50SXIpCk5UWCjnlJZnoDeheyu3orHiwwurplnm+SNnfX+TU6fKK9t
	 s8x/eTCbkWtGNULk8zZbqB59Z2UWQ7+/kqR5jO14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 173/193] tracing: Bound histogram expression strings with seq_buf
Date: Fri, 23 Oct 2026 18:37:30 +0200
Message-ID: <20261023163718.308563751@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 935601a4276f28105498609f7f98aa66e86e9c96 ]

expr_str() allocates a fixed MAX_FILTER_STR_VAL buffer and then builds
expression names with a series of raw strcat() appends. Nested operands,
constants, field flags, and generated field names can push the rendered
string past that fixed limit before the name is attached to the hist
field.

Build expression strings with seq_buf and return -E2BIG when the
rendered name would exceed MAX_FILTER_STR_VAL. This keeps the existing
tracing-side limit while replacing the raw append logic with bounded
construction.

Link: https://patch.msgid.link/20260611055945.22348-4-pengpeng@iscas.ac.cn
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Stable-dep-of: a0777b9e5315 ("tracing: Fix NULL dereference when copying keys for a field variable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |   57 ++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 24 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -94,7 +94,6 @@ typedef u64 (*hist_field_fn_t) (struct h
 #define HIST_FIELD_OPERANDS_MAX	2
 #define HIST_FIELDS_MAX		(TRACING_MAP_FIELDS_MAX + TRACING_MAP_VARS_MAX)
 #define HIST_ACTIONS_MAX	8
-#define HIST_CONST_DIGITS_MAX	21
 #define HIST_DIV_SHIFT		20  /* For optimizing division by constants */
 
 enum field_op_id {
@@ -1735,33 +1734,36 @@ static const char *get_hist_field_flags(
 	return flags_str;
 }
 
-static void expr_field_str(struct hist_field *field, char *expr)
+static bool expr_field_str(struct hist_field *field, struct seq_buf *s)
 {
+	const char *field_name;
+
 	if (field->flags & HIST_FIELD_FL_VAR_REF) {
 		if (!field->system)
-			strcat(expr, "$");
-	} else if (field->flags & HIST_FIELD_FL_CONST) {
-		char str[HIST_CONST_DIGITS_MAX];
+			seq_buf_putc(s, '$');
+	} else if (field->flags & HIST_FIELD_FL_CONST)
+		seq_buf_printf(s, "%llu", field->constant);
 
-		snprintf(str, HIST_CONST_DIGITS_MAX, "%llu", field->constant);
-		strcat(expr, str);
-	}
+	field_name = hist_field_name(field, 0);
+	if (!field_name)
+		return false;
 
-	strcat(expr, hist_field_name(field, 0));
+	seq_buf_puts(s, field_name);
 
 	if (field->flags && !(field->flags & HIST_FIELD_FL_VAR_REF)) {
 		const char *flags_str = get_hist_field_flags(field);
 
-		if (flags_str) {
-			strcat(expr, ".");
-			strcat(expr, flags_str);
-		}
+		if (flags_str)
+			seq_buf_printf(s, ".%s", flags_str);
 	}
+
+	return !seq_buf_has_overflowed(s);
 }
 
 static char *expr_str(struct hist_field *field, unsigned int level)
 {
 	char *expr __free(kfree) = NULL;
+	struct seq_buf s;
 
 	if (level > 1)
 		return NULL;
@@ -1770,47 +1772,54 @@ static char *expr_str(struct hist_field
 	if (!expr)
 		return NULL;
 
+	seq_buf_init(&s, expr, MAX_FILTER_STR_VAL);
+
 	if (!field->operands[0]) {
-		expr_field_str(field, expr);
+		if (!expr_field_str(field, &s))
+			return ERR_PTR(-E2BIG);
+
 		return_ptr(expr);
 	}
 
 	if (field->operator == FIELD_OP_UNARY_MINUS) {
 		char *subexpr;
 
-		strcat(expr, "-(");
 		subexpr = expr_str(field->operands[0], ++level);
 		if (!subexpr)
 			return NULL;
 
-		strcat(expr, subexpr);
-		strcat(expr, ")");
-
+		seq_buf_printf(&s, "-(%s)", subexpr);
 		kfree(subexpr);
 
+		if (seq_buf_has_overflowed(&s))
+			return ERR_PTR(-E2BIG);
+
 		return_ptr(expr);
 	}
 
-	expr_field_str(field->operands[0], expr);
+	if (!expr_field_str(field->operands[0], &s))
+		return ERR_PTR(-E2BIG);
 
 	switch (field->operator) {
 	case FIELD_OP_MINUS:
-		strcat(expr, "-");
+		seq_buf_putc(&s, '-');
 		break;
 	case FIELD_OP_PLUS:
-		strcat(expr, "+");
+		seq_buf_putc(&s, '+');
 		break;
 	case FIELD_OP_DIV:
-		strcat(expr, "/");
+		seq_buf_putc(&s, '/');
 		break;
 	case FIELD_OP_MULT:
-		strcat(expr, "*");
+		seq_buf_putc(&s, '*');
 		break;
 	default:
 		return NULL;
 	}
 
-	expr_field_str(field->operands[1], expr);
+	if (seq_buf_has_overflowed(&s) ||
+	    !expr_field_str(field->operands[1], &s))
+		return ERR_PTR(-E2BIG);
 
 	return_ptr(expr);
 }


