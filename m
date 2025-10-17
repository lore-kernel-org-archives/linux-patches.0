Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292953BB5A;
	Fri, 17 Oct 2025 15:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714774; cv=none; b=nhD2RS9iujRfot1HvSycQCNEMEqMFk1DYpR+UC6QdOT+Eo5m5LU11iHmGk0G8UWEWedOlR5Oy+/JKyr6pusCWs8f9NatHX2QdJVutr6prYLrwE9BOA9qTgCCIuts4aG+xC/k6jXslzDUOSdgTnjITFlh7Uquq5hsMgBong+arwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714774; c=relaxed/simple;
	bh=Uk1tJ1do6LXFJdqvJtZHXw66C6akSoIpJEDY2sELd3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9FMManmHPQNg/5h06Ya9P+IqBBjx3Om0a9xr6SNcO/GnTdrfW9/w6/0myXzmndlp+c9Cpo/fOSxtgt++lo4AJHlGzIC73wUYlQdtMzlc8OggJlI5UhGVfwGvK+Z0KEreTQXzhZgsVQd3tdtspT6RRaTFRU5LCzkJSltYk+IkV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7axWOmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7axWOmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77DBC4CEE7;
	Fri, 17 Oct 2025 15:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714774;
	bh=Uk1tJ1do6LXFJdqvJtZHXw66C6akSoIpJEDY2sELd3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7axWOmNZIlNgl54uR9GqYKBYUzhrd0KdP8U8EYqPYCYAaeZuOPykBAeyJ7jAZV3q
	 xUGjjA9EJrTHluaW5KnqnXzpWony98JpTnEAgeOOwJ3otg8GigW7Lln+bZLSyYoyjv
	 S62jsUUm8W2ffbFohCKRljXHnUb67+ev++tPnltM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.12 261/277] s390/bpf: Write back tail call counter for BPF_PSEUDO_CALL
Date: Fri, 17 Oct 2025 16:54:28 +0200
Message-ID: <20251017145156.690461709@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Ilya Leoshkevich <iii@linux.ibm.com>

commit c861a6b147137d10b5ff88a2c492ba376cd1b8b0 upstream.

The tailcall_bpf2bpf_hierarchy_1 test hangs on s390. Its call graph is
as follows:

  entry()
    subprog_tail()
      bpf_tail_call_static(0) -> entry + tail_call_start
    subprog_tail()
      bpf_tail_call_static(0) -> entry + tail_call_start

entry() copies its tail call counter to the subprog_tail()'s frame,
which then increments it. However, the incremented result is discarded,
leading to an astronomically large number of tail calls.

Fix by writing the incremented counter back to the entry()'s frame.

Fixes: dd691e847d28 ("s390/bpf: Implement bpf_jit_supports_subprog_tailcalls()")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20250813121016.163375-3-iii@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/net/bpf_jit_comp.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1789,13 +1789,6 @@ static noinline int bpf_jit_insn(struct
 		jit->seen |= SEEN_FUNC;
 		/*
 		 * Copy the tail call counter to where the callee expects it.
-		 *
-		 * Note 1: The callee can increment the tail call counter, but
-		 * we do not load it back, since the x86 JIT does not do this
-		 * either.
-		 *
-		 * Note 2: We assume that the verifier does not let us call the
-		 * main program, which clears the tail call counter on entry.
 		 */
 		/* mvc tail_call_cnt(4,%r15),frame_off+tail_call_cnt(%r15) */
 		_EMIT6(0xd203f000 | offsetof(struct prog_frame, tail_call_cnt),
@@ -1822,6 +1815,22 @@ static noinline int bpf_jit_insn(struct
 		call_r1(jit);
 		/* lgr %b0,%r2: load return value into %b0 */
 		EMIT4(0xb9040000, BPF_REG_0, REG_2);
+
+		/*
+		 * Copy the potentially updated tail call counter back.
+		 */
+
+		if (insn->src_reg == BPF_PSEUDO_CALL)
+			/*
+			 * mvc frame_off+tail_call_cnt(%r15),
+			 *     tail_call_cnt(4,%r15)
+			 */
+			_EMIT6(0xd203f000 | (jit->frame_off +
+					     offsetof(struct prog_frame,
+						      tail_call_cnt)),
+			       0xf000 | offsetof(struct prog_frame,
+						 tail_call_cnt));
+
 		break;
 	}
 	case BPF_JMP | BPF_TAIL_CALL: {


