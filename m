Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774256;
	b=fzzb4m8M46qsQZLM8g2hQgaZO9RF8tshnjUJi5UuKGXLnKfLvZiaxDBGJU44jTYns7JG
	 6Q7xE09uLssza43f1uaQ4HREEGjTGTuunETI+HCTCvjXFSVqN9gumnKyxkartJmdH5JE+
	 Wgzi/fHMmPr2nEnD+3c3kCiYMV8oQDOaGBha5TTyfvd/APnk+qIVkh8o/DLbZAarMpOC5
	 NkSOcRRdKthaTz8GSRSM1fqjE0/+hmoYalMPNulP6P6ULJsXjDWHV1/Po1dtc1TNfymc/
	 iMtR/1Rfs64Bxm+zEx5zj2+QKcD/g5xmoSSO1PoA4dwZeeZdPXAYoPvzwB43dtz490Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9tcNGPBFiY3M4LRiSyeztWVqbKDw08vo57iNCCQ/MWQ=;
	b=jgJPsdSww4R2hdPDYMlYy8rPK3YByS2xTnpUkClE8kyOX2+fvBSTTrVqrZkoLyAYvBVA
	 nz9jzdCboL7jSNUi7yP55Bnd7PxsVUsVMFQE2V0p0/sQciSZtvBYEkc1X2W847cefYKxX
	 QgOaV20UzAP7QdUPGior9XjBCXqFcFre73/sO6OCYGPSqVIEl8eeVylX5dr4qn0WWMBra
	 bqXz0NFl9xEZXAsL8xYxsSEl2uravcm1K2e2qFaaiiBtBmwg/Thu5czgFijS9BPq35FGK
	 IMYHFEKGJv8FJrLg1HJ89oG+EEZ0o6fBBQU/HfpYSEs0Dy3AI+21fztULUg0W5q//lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lBg19Fj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E135606A31F;
	Fri, 23 Oct 2026 16:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lBg19Fj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F681F01825;
	Fri, 23 Oct 2026 16:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774255;
	bh=9tcNGPBFiY3M4LRiSyeztWVqbKDw08vo57iNCCQ/MWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lBg19Fj8suG39YgzIEHgPKO0qm4WJ+uxxBIX/erB3Bi38pjOa38SIkWjFM4cz377
	 T3yGpGfLMPt0m3wHTgD9AWyIMJuUQEEQslultLdklEe7WOuljyoglH2svnHxsaqpCs
	 XXmo0Q7N5SQl8yA36T925b5JTwAwgBzSWpfMxHdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 172/193] tracing: Use __free() for expr_str() buffer
Date: Fri, 23 Oct 2026 18:37:29 +0200
Message-ID: <20261023163718.284761921@linuxfoundation.org>
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

[ Upstream commit 988995c0552b6213b6bf16cea57258d4842c1488 ]

expr_str() allocates a temporary expression buffer and manually frees it
on some error paths.

Convert the buffer to __free(kfree) and return it with return_ptr() on
success. This keeps ownership handling separate from the later ERR_PTR()
conversion and string-bound change.

Link: https://patch.msgid.link/20260611055945.22348-2-pengpeng@iscas.ac.cn
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Stable-dep-of: a0777b9e5315 ("tracing: Fix NULL dereference when copying keys for a field variable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1761,7 +1761,7 @@ static void expr_field_str(struct hist_f
 
 static char *expr_str(struct hist_field *field, unsigned int level)
 {
-	char *expr;
+	char *expr __free(kfree) = NULL;
 
 	if (level > 1)
 		return NULL;
@@ -1772,7 +1772,7 @@ static char *expr_str(struct hist_field
 
 	if (!field->operands[0]) {
 		expr_field_str(field, expr);
-		return expr;
+		return_ptr(expr);
 	}
 
 	if (field->operator == FIELD_OP_UNARY_MINUS) {
@@ -1780,16 +1780,15 @@ static char *expr_str(struct hist_field
 
 		strcat(expr, "-(");
 		subexpr = expr_str(field->operands[0], ++level);
-		if (!subexpr) {
-			kfree(expr);
+		if (!subexpr)
 			return NULL;
-		}
+
 		strcat(expr, subexpr);
 		strcat(expr, ")");
 
 		kfree(subexpr);
 
-		return expr;
+		return_ptr(expr);
 	}
 
 	expr_field_str(field->operands[0], expr);
@@ -1808,13 +1807,12 @@ static char *expr_str(struct hist_field
 		strcat(expr, "*");
 		break;
 	default:
-		kfree(expr);
 		return NULL;
 	}
 
 	expr_field_str(field->operands[1], expr);
 
-	return expr;
+	return_ptr(expr);
 }
 
 /*


