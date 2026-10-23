Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775013;
	b=cb5nIrUk4e1a36+lZwRXCJoT5VtLWCvPecFgGDel3WqUoQUnx6/VfKE35PTBTKtb6dIG
	 XnZ3vxfjQJay6+Pc5ZnPoOvYJtHPZNNU3dKSBzL1Wx+ct95wlR0w+xZc2ik1WfArmP+MA
	 /fPsBTCxql1JgGCmzIgzCvSSEtnJaHHSiXALhXYaaONGpZP0Ie/4Hfa5XNYBwDI9CJrc1
	 66PCFnHE1iJIRGRLCpHdLHWno1AhX3rfjGSKt8MwomZeXE7wD5nS5/ucj5jROzzZJAGpt
	 nUeYWUVSSIt7B23dyuCRJlfkKQkN0kh0eHbPhcef/H6mcgg+Yi/JEgSvRi72I5IWPVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wHmBbl/rIdc4r47YvlBhaVU3y4UcioRsXE+XyeWQi64=;
	b=szl+zX2KUDJItKOEb2gte6bXjAvsV7QwB96rY4oYSxg42EwGINSTrhLAuT0461RfD06p
	 lmKlimwnlmTF1tR1OqWaFwpVtxIlGOtWIlB8bEI9FXpP9m7lr86JdACQ4RESrpJ7dHSVn
	 zUQF0aSM3h5Tk5NRP/cVKGkXWzUc+Ci99CT1HVq+zfgzXr8Uduk4uzN8Vc+D61sGw6Wb0
	 L15BOTdB1Sgjkvud61wqk1Mwm3xA19vA40+mU0AM8Cx81lcreQt6TfP/BBNr+2an8JTNi
	 nSfMEu5+H8Xel8TRU1MpiW7aYps5YdXNomtmef8+7obbHt2ili/WvNIw3wg4WKanYnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F01ib3Ko;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CCD606A31B;
	Fri, 23 Oct 2026 17:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F01ib3Ko
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72CC1F01825;
	Fri, 23 Oct 2026 17:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775013;
	bh=wHmBbl/rIdc4r47YvlBhaVU3y4UcioRsXE+XyeWQi64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F01ib3Ko4uT3vv06LXERmQqkhOMNfQfg5Zdjcd61tbDE59SBdvsQ5WzRlG/DKYYkx
	 F1P7BbZeTfievLClVo9LqmiQqae2Z20zuMIE75z41Zh0BDOF77mJXJXDz8LRBHu4al
	 SL7LUzvCpCaKCit86n39vWSku8CfIZfeaJnQbDyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 232/242] tracing: Use __free() for expr_str() buffer
Date: Fri, 23 Oct 2026 18:41:14 +0200
Message-ID: <20261023163719.334541721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1758,7 +1758,7 @@ static void expr_field_str(struct hist_f
 
 static char *expr_str(struct hist_field *field, unsigned int level)
 {
-	char *expr;
+	char *expr __free(kfree) = NULL;
 
 	if (level > 1)
 		return NULL;
@@ -1769,7 +1769,7 @@ static char *expr_str(struct hist_field
 
 	if (!field->operands[0]) {
 		expr_field_str(field, expr);
-		return expr;
+		return_ptr(expr);
 	}
 
 	if (field->operator == FIELD_OP_UNARY_MINUS) {
@@ -1777,16 +1777,15 @@ static char *expr_str(struct hist_field
 
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
@@ -1805,13 +1804,12 @@ static char *expr_str(struct hist_field
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


