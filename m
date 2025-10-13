Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D962B30BB99;
	Mon, 13 Oct 2025 15:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368938; cv=none; b=ZyPN3Mhf+o7Ie7pZX3+84a8lAAPaJZ8RZr6f/Bl45bbbdn+jk2FzDEP9MNo2cmP6TJVUOti3iB6p05IdZKFlq3cTYNPZNkdLq2MG/ysGyI2UqAmoBBtCpo8Db3XBr4a0Mn64aMOYucFWkSDLHxpd1TzJHIRnG7YyRqAEDYo8UDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368938; c=relaxed/simple;
	bh=T5tbQ0rzt8VnnhR2WRZ2YyMCjxICOo4BFicHctVE8zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEUr1JmJKMRcrji0vAA1NepGGTaB67nSjrWL05Nnj1nqnkhbkgE+NZpZbvkjF8+iWQsZFvow4s3vpV4iqjc9mgs8XYGl9iMP19fYW8tzkylT5dNHaPR4/P9l+1DV9x6ND1TOjXtM6SXjeEjCxa9Op4MSGjY3kJOYce4JI3wfKIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAvHRqEm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAvHRqEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64790C4CEE7;
	Mon, 13 Oct 2025 15:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368938;
	bh=T5tbQ0rzt8VnnhR2WRZ2YyMCjxICOo4BFicHctVE8zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAvHRqEmYr1j45RaMr03IaxijDWUygJEZ6TVnHbIl190lS+6zQNe9rhkTTYm+CQAL
	 c8w3Zx9BlmixIzlz4GoIUaYYx6tiUoEA4dIlFdlYN6HkgXf+Nve8z0XLN6IynydyPq
	 xJSAGhuI7ffbFD7QxZ/0HWydpadZg8L+xFKkeQvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 054/563] s390/bpf: Do not write tail call counter into helper and kfunc frames
Date: Mon, 13 Oct 2025 16:38:35 +0200
Message-ID: <20251013144413.248848510@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit eada40e057fc1842358d9daca3abe5cacb21e8a1 ]

Only BPF functions make use of the tail call counter; helpers and
kfuncs ignore and most likely also clobber it. Writing it into these
functions' frames is pointless and misleading, so do not do it.

Fixes: dd691e847d28 ("s390/bpf: Implement bpf_jit_supports_subprog_tailcalls()")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20250813121016.163375-2-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index bb17efe29d657..bfac1ddf3447b 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1790,6 +1790,7 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 
 		REG_SET_SEEN(BPF_REG_5);
 		jit->seen |= SEEN_FUNC;
+
 		/*
 		 * Copy the tail call counter to where the callee expects it.
 		 *
@@ -1800,10 +1801,17 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 		 * Note 2: We assume that the verifier does not let us call the
 		 * main program, which clears the tail call counter on entry.
 		 */
-		/* mvc tail_call_cnt(4,%r15),frame_off+tail_call_cnt(%r15) */
-		_EMIT6(0xd203f000 | offsetof(struct prog_frame, tail_call_cnt),
-		       0xf000 | (jit->frame_off +
-				 offsetof(struct prog_frame, tail_call_cnt)));
+
+		if (insn->src_reg == BPF_PSEUDO_CALL)
+			/*
+			 * mvc tail_call_cnt(4,%r15),
+			 *     frame_off+tail_call_cnt(%r15)
+			 */
+			_EMIT6(0xd203f000 | offsetof(struct prog_frame,
+						     tail_call_cnt),
+			       0xf000 | (jit->frame_off +
+					 offsetof(struct prog_frame,
+						  tail_call_cnt)));
 
 		/* Sign-extend the kfunc arguments. */
 		if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL) {
-- 
2.51.0



