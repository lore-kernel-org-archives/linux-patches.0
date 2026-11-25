Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623279;
	b=nDjT16xombBKCCP6D2bDdNWJC/q5O7nYm90wrNdPjN0BrXJ9lPkPnASmc9SEP64yyTOF
	 91fihfGCnUIAslODfpH5FapetHLF/ONnfDMUgymBnh2ovOXsPHwtvjt8hhPdECtTQS2bu
	 WGH85jtsKXz3D/9HEJF/S7KgLFSXBNRBNcRh/CNwYCaZ5FWPP8iU8mU6b7/A1Z9gGZFm8
	 Adj+N5Js+bAC8KCDsp7/8P3Td0+xRwpD81f8L45I1kBaKOnrUIKxKcDjKEoBeN8oQm7PW
	 6Bpoth9iIRzdl3KD3oJ2xn1tggKWEbvrbrJ8mOfANREWy26V7iNbGwmzn446oBVjeow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vQgLWQNwwvUDYwQd5K/SDVbx0c30ynssEfzcKeFLg5c=;
	b=sdQA7Ihny5QIzCr0Ug8XhNRuWnbOua6ABpyadQFu7YiOR8jj+S9mMOIOABKC0O2tTDUE
	 eGmVi68LMEtfTj3goJOdHYQgmremGkL9OV7ZDWuEXa1H886OJSS3ABAac45PQRwzoDAWT
	 nkU4oOEWlqWIabHSkdsqh40OPLf+7mErbbQa+ur3a9IosL8UhGVU4q/0SOVj7/XkYyMlL
	 nlTFCRS3m5ICshEl1U8yNgQbfQGX+9w26dCZ/4E6NB4X+lgu65kjTv4TE4GYmIXWHXx47
	 Z5F2jVSoZflF937EbBUucvdYWk4rCfv2onqCD49UJdPxSULRC5HkV+4mpmsaCBZSR8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FjRBR0dW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDDA606A323;
	Wed, 25 Nov 2026 16:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FjRBR0dW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBF31F000CA;
	Wed, 25 Nov 2026 16:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623278;
	bh=vQgLWQNwwvUDYwQd5K/SDVbx0c30ynssEfzcKeFLg5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FjRBR0dWwws1suLS4haY4LJ/kNme92dV0+9rUwW5uFr7zqXWcbbShMpU7MKf62u3k
	 B7ez5TPlvUKs+JNemvoxQWXvDee5HV3NiLvH50yLZffbBoS5az1FwRoBxzLWFUnPPF
	 5edI96Tx4XH3e2/MkeQfq5/tHkwRz4a2LiRSqaqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 807/990] tracing/probes: Fix user-space dereference string array store type
Date: Wed, 25 Nov 2026 15:36:14 +0100
Message-ID: <20261125143840.948323933@linuxfoundation.org>
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

commit 2721573e6c6faaba2e31f352f2c02ec5f3ecf5e9 upstream.

When finalizing a string array argument (e.g. +0u(%reg):string[N]),
finalize_fetch_insn() advances the instruction pointer to a new slot
for the store operation before checking whether the preceding operation
was FETCH_OP_UDEREF. As a result, user-space dereference string arrays
with type "string" emit FETCH_OP_ST_STRING (kernel memory read) instead
of FETCH_OP_ST_USTRING.

Check for FETCH_OP_UDEREF before advancing the instruction pointer.

Link: https://lore.kernel.org/all/179455854396.403392.18073771811100192405.stgit@devnote2/

Fixes: e65f7ae7f4da ("tracing/probe: Support user-space dereference")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1484,6 +1484,8 @@ static int finalize_fetch_insn(struct fe
 
 	/* Store operation */
 	if (parg->type->is_string) {
+		bool is_uderef;
+
 		/* Check bad combination of the type and the last fetch_insn. */
 		if (!strcmp(parg->type->name, "symstr")) {
 			if (code->op != FETCH_OP_REG && code->op != FETCH_OP_STACK &&
@@ -1503,6 +1505,7 @@ static int finalize_fetch_insn(struct fe
 			}
 		}
 
+		is_uderef = (code->op == FETCH_OP_UDEREF);
 		if (!strcmp(parg->type->name, "symstr") ||
 		    (code->op == FETCH_OP_IMM || code->op == FETCH_OP_COMM ||
 		     code->op == FETCH_OP_DATA) || code->op == FETCH_OP_TP_ARG ||
@@ -1523,8 +1526,7 @@ static int finalize_fetch_insn(struct fe
 		}
 
 		/* If op == DEREF, replace it with STRING */
-		if (!strcmp(parg->type->name, "ustring") ||
-		    code->op == FETCH_OP_UDEREF)
+		if (!strcmp(parg->type->name, "ustring") || is_uderef)
 			code->op = FETCH_OP_ST_USTRING;
 		else if (!strcmp(parg->type->name, "symstr"))
 			code->op = FETCH_OP_ST_SYMSTR;


