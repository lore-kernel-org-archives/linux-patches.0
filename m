Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620062;
	b=iM536Cs5l8cn9rM7qSSVMj6x7K0BPC8ZQZ0vR25NDfdaAYJ9Ij5vyH9c3tEeNmaevZFF
	 PQPLyQOsenx26bP2VluBdgOsjrglqueOAETOtqhUZweqMpe7phqYWeI8GXqtagZjOmmOm
	 NTu+RLQC+paQMNSHEbCcc2UaP7BTJELF/c7B2LeVU8VGQIknmq5fc2dBVMiKrqo7yuWvA
	 XFGoaYuGr/TLcgvnHMm/4LisQjOHdRwYdmeXqdlq66MrQCNwfcAnf77bVcZ7MmHsmPqwl
	 eDmzV1wVMw1G+iyBktL//SUE97ni4MBequ3zESSYEHcSMKvV4bZvE+6/z07z4ducuGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q+lsCqzAy2Vfh83TVHfdwf4kHKAs1KOU83MMVveU3us=;
	b=LJAY9tHScYv6EpY2m7kuJRn8tYrS7VPK3oSoYf0CSn89g4fK6sOtYD0GNEZ9obC5wprA
	 z5oCNEfr5+SLo0PgcgSh63DuJR5B7c97pqvv+RfcExNgLGQ8qUd8akbfHgDkLe0IrwP47
	 VX3UepTfjtXuX51sN927InQ61XWdOmnacF53tmNjl5F5CrPcjC1Y6TZFjcK2H5wbPC5N4
	 YTgSYb+fFKKNFpQvl+HilVowajM9m/+nMTGTyAfIlFFY3yxsl4NhQ1TeYvj+ffkbqcjWV
	 OuMCZ/4/OslrAx9EYh8TagsnRTuxoqxdXylQjinWAOm8NO6eKfVXf7um2DzEG4PS8bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="W1lFSI/6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1451606A321;
	Wed, 25 Nov 2026 15:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W1lFSI/6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D2E1F000E1;
	Wed, 25 Nov 2026 15:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620061;
	bh=Q+lsCqzAy2Vfh83TVHfdwf4kHKAs1KOU83MMVveU3us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1lFSI/6Quwa/B9QF8DpQ3PrVR18mKJWYGUke00div1xVvc5y6q1G7SlJyv6TIkHY
	 fRERBd/ToeHEuYliN0A3vLj1vcyyljUalUQN6E102A2j2CGPuT5AaJMujxb6WYNZh+
	 Tj3NVqwxvzMfbvDaJacC7oE7ynK3IAQiGLB1talM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.3 0789/1005] tracing/probes: Fix user-space dereference string array store type
Date: Wed, 25 Nov 2026 15:35:27 +0100
Message-ID: <20261125143840.222077521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1956,6 +1956,8 @@ static int finalize_fetch_insn(struct fe
 
 	/* Store operation */
 	if (parg->type->is_string) {
+		bool is_uderef;
+
 		/* Check bad combination of the type and the last fetch_insn. */
 		if (!strcmp(parg->type->name, "symstr")) {
 			if (code->op != FETCH_OP_REG && code->op != FETCH_OP_STACK &&
@@ -1975,6 +1977,7 @@ static int finalize_fetch_insn(struct fe
 			}
 		}
 
+		is_uderef = (code->op == FETCH_OP_UDEREF);
 		if (!strcmp(parg->type->name, "symstr") ||
 		    (code->op == FETCH_OP_IMM || code->op == FETCH_OP_COMM ||
 		     code->op == FETCH_OP_IMMSTR) || code->op == FETCH_OP_TP_ARG ||
@@ -1995,8 +1998,7 @@ static int finalize_fetch_insn(struct fe
 		}
 
 		/* If op == DEREF, replace it with STRING */
-		if (!strcmp(parg->type->name, "ustring") ||
-		    code->op == FETCH_OP_UDEREF)
+		if (!strcmp(parg->type->name, "ustring") || is_uderef)
 			code->op = FETCH_OP_ST_USTRING;
 		else if (!strcmp(parg->type->name, "symstr"))
 			code->op = FETCH_OP_ST_SYMSTR;


