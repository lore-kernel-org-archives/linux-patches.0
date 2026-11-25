Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625924;
	b=1f+aPecphI6O8OYCTA4lEb6zjU+q8vdC91J+7BRNegQ44l3clSBmvQS1fWEJap+Zk9Rl
	 WepMIVBSA0zHx84rkkk0CWbmdqi0kC3BCU9hJTs1FExxCIt0lYFXiqaWLZpSijPKQKRlR
	 Uwm2BfiCHqIGJBPRLulTgQRYBDO/kBt6MNqGENPpRngUloCqj2s+yEzd63lBeEZJGp4j0
	 T5nQ0EoCxVUxur1dchgekLL8Nf9cdR9cpu/WLtoOSik1zh2caNtaDlti52pZQUIGoOe8s
	 kBju4FbmMRuW98H6lEPyxNTtagtFbJyj1qA+uG1/LIHvI8snGLwJUiX2dxDd4lY8aaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MdoJiwT0HHfhzRY7lxW5aeBnofqqeQWR00zUZKh9LAU=;
	b=d9qjH1fWWRv/KsFHZVX+Et9a8txfP42fHENRt6PM7iY1sGu7a/dXBNb3Pv8nHlNUtYsr
	 0DS3Oe4BDikvcgMH/GJdcaiM4siolw3OWWqtCwj268NA3/6XCYPiCOZFTR+11IZSJ3u7l
	 pfsd8njWks01Px6wjIvNTGPHpXDGkbO2rBqUQbx8R+pB/GbK97F9KrOHfI4AU1pTWFoKF
	 MXlC1y7tRkdPQQ0FBhiyhBUFiY2xTGoD1+Z8cafjB0aWyMbeIjiQOqrGKJZp2T0BjMt69
	 VtD+rjJmqPQzTYgzRJ4B9dn46RUylue4d0NPg953KsCBT/2RgIW0eqjxtQLmRhT5TGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nhkw/FFn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96D0606A31E;
	Wed, 25 Nov 2026 16:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nhkw/FFn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30A51F000C0;
	Wed, 25 Nov 2026 16:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625923;
	bh=MdoJiwT0HHfhzRY7lxW5aeBnofqqeQWR00zUZKh9LAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nhkw/FFnz5nBVvl6DsMVrV1HydDOOY2JI11HPbUl1SDQ2ngM3FVYTQOH6pDUC6kqq
	 ho+BYw/PrZOYGGLArXIzNjGMXp3M81ZH25k9QdEGJozsOJjwxcDuMBTj5AkoWyEakc
	 BATXIeSBEj9oudOgt93MbtQyzoCt0PIcRD6G06co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 657/816] tracing/probes: Fix user-space dereference string array store type
Date: Wed, 25 Nov 2026 15:36:45 +0100
Message-ID: <20261125143904.387099848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1333,6 +1333,8 @@ static int finalize_fetch_insn(struct fe
 
 	/* Store operation */
 	if (parg->type->is_string) {
+		bool is_uderef;
+
 		/* Check bad combination of the type and the last fetch_insn. */
 		if (!strcmp(parg->type->name, "symstr")) {
 			if (code->op != FETCH_OP_REG && code->op != FETCH_OP_STACK &&
@@ -1352,6 +1354,7 @@ static int finalize_fetch_insn(struct fe
 			}
 		}
 
+		is_uderef = (code->op == FETCH_OP_UDEREF);
 		if (!strcmp(parg->type->name, "symstr") ||
 		    (code->op == FETCH_OP_IMM || code->op == FETCH_OP_COMM ||
 		     code->op == FETCH_OP_DATA) || code->op == FETCH_OP_TP_ARG ||
@@ -1372,8 +1375,7 @@ static int finalize_fetch_insn(struct fe
 		}
 
 		/* If op == DEREF, replace it with STRING */
-		if (!strcmp(parg->type->name, "ustring") ||
-		    code->op == FETCH_OP_UDEREF)
+		if (!strcmp(parg->type->name, "ustring") || is_uderef)
 			code->op = FETCH_OP_ST_USTRING;
 		else if (!strcmp(parg->type->name, "symstr"))
 			code->op = FETCH_OP_ST_SYMSTR;


