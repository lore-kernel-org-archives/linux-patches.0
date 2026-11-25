Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623259;
	b=Q9VG/I8o/msWWhsGjYMva25W0RL/a2sH6f+TeuE0yXsjfaIaNemW76uvpriOo1+50ljZ
	 XjuCQDHmcQ8B+WFVYalq/jOUl8wRvlD/xkQ0xlj8wcoETNerJFvym6yqjggmkgAyQ/1X5
	 Tk3u1MJ2Bytc/yoB7V4ecl8uEqV7iv6VaDKXZ/dOKrUpucBkJMocW0zD1z+3w2kHABoJd
	 5eIwFDni8SC/DE+5qL4IRnN8kUi1ySIZGNGzbFMnQP3EfE+J52EEnj/raMYfjgAjKbbMr
	 cIJJPbCunXid+fntsCa18/xd0Li5rBbzzearXEikL2aaPdoKS+Lv5gVwNrlmuw1eTbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0wzSm/U+uBdZdyL0lv6peh8+7cIxSmW4T5q4MxlrOL0=;
	b=dtUvagM71zGggy6WeB3KeqZO/2GtyohMxGWgO/ki5qOS6qAwacjJZzZvlKAklwdk4xwe
	 I1TL/YXFrVHfU3YTk4aBDw7ffJoEuZ5YMiVmgEp4Jg9judYP6vyOkU24r5F5fUWpl9pMJ
	 46JDQYWWuV+J+koMOOU6MvU1ue4MW53G8NJizIRLt+jKyUL6lcTbjBu5TjjCr/3oGJcjB
	 9eBNiaU/nmp+gFYim7uJ3cJB75I7PmIp6Bg7Xdf8N+08DVLAfQentUKuGSyd63wqd7ThO
	 SY0i2A34oeFun2O4mCO/KYW5AfuG2U/9Q6pVeiQJ5181b7m5iLb7DVI7k+Y/fyL4vfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LRsS9hhj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B722606A31E;
	Wed, 25 Nov 2026 16:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LRsS9hhj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597FD1F000EC;
	Wed, 25 Nov 2026 16:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623258;
	bh=0wzSm/U+uBdZdyL0lv6peh8+7cIxSmW4T5q4MxlrOL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRsS9hhjU34zEyNAYkJeV06N9ZzpezSQbMCgz9zmtjr6rRdkUAcMcUSIvH9KnHAlP
	 dca59y1AMkf35M82FqZYNa4Kf35pFgU49ceNkRwDkwqofNL+mKx8wS8s7iyzAVGJAN
	 kZhqqI8hfYMRlTUC8QaiUxP1cPgCcsHuf3vP7Wtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 802/990] tracing/eprobe: Fix 1-byte signed field fetch in get_event_field()
Date: Wed, 25 Nov 2026 15:36:09 +0100
Message-ID: <20261125143840.831418828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit a0f836eea463d4c468edb58eedb03911c9c0791d upstream.

Because the kernel is built with -funsigned-char, plain 'char' is
unsigned on all architectures. Reading 1-byte signed trace event fields
via *(char *)addr in get_event_field() therefore zero-extends instead of
sign-extending negative s8 values.

Use explicit fixed-width integer types (s8/u8, s16/u16, s32/u32) when
reading event fields.

Link: https://lore.kernel.org/all/179455852542.403392.15666310371702309464.stgit@devnote2/

Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -328,21 +328,21 @@ get_event_field(struct fetch_insn *code,
 	switch (field->size) {
 	case 1:
 		if (field->is_signed)
-			val = *(char *)addr;
+			val = *(s8 *)addr;
 		else
-			val = *(unsigned char *)addr;
+			val = *(u8 *)addr;
 		break;
 	case 2:
 		if (field->is_signed)
-			val = *(short *)addr;
+			val = *(s16 *)addr;
 		else
-			val = *(unsigned short *)addr;
+			val = *(u16 *)addr;
 		break;
 	case 4:
 		if (field->is_signed)
-			val = *(int *)addr;
+			val = *(s32 *)addr;
 		else
-			val = *(unsigned int *)addr;
+			val = *(u32 *)addr;
 		break;
 	default:
 		if (field->size == sizeof(long)) {


