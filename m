Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322A2347517;
	Wed,  8 Apr 2026 18:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671977; cv=none; b=Ske/Rr7sK7k9Jfm2kMdKIxoDfaVlMZedHTcNUPMV9NA4furfYhmsR1EuI7xS+S8I1NIMiBz7aC7ZPPi7b8zChS7FlKNLJn2ls4FEHlpPRLFYpfwCZnV8DA8tvaDtstc3YD/VlO0AZiukx3Xo3jUYER4cuwokdRpLoBn3D1C0PmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671977; c=relaxed/simple;
	bh=NFH3SOwC1n69KbNKrMpvVjdQp52s5NDpiwlT4MtrGXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfUD9Ifz/SxBp3+Q0vHVoF6afmTjpW504QlkW4i0jF5XV+C6PyDp0+SpLGBUwzGse6dsHKJRxAUgDwpqTXJiA6tiNqq2wcbEttLHs6rTnmas28GcJGiC2SpkM8yY4NZ1+1YR6y0mcqO4CeyQws5ANkGvh9gOmRiDjggxdrZrEpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uye9YzUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uye9YzUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEAAC19421;
	Wed,  8 Apr 2026 18:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671977;
	bh=NFH3SOwC1n69KbNKrMpvVjdQp52s5NDpiwlT4MtrGXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uye9YzUG0MHdsEa41PL3PsbzLPUxwpoZcnUMilc+G6uqS4goZTK1SOqZnJ9kJskrm
	 KFEwRhrMohBQe2SNh1gLUzMzFYLFwatJmutVa05y/IgrDIJuDHFDSHLbdldDm7bu41
	 MjJfdRSn4WYU4EQE1RI/rkkLhpWWZM1uSo3lKTnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/312] objtool: Fix Clang jump table detection
Date: Wed,  8 Apr 2026 20:00:58 +0200
Message-ID: <20260408175939.036742749@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 4e5019216402ad0b4a84cff457b662d26803f103 ]

With Clang, there can be a conditional forward jump between the load of
the jump table address and the indirect branch.

Fixes the following warning:

  vmlinux.o: warning: objtool: ___bpf_prog_run+0x1c5: sibling call from callable instruction with modified stack frame

Reported-by: Arnd Bergmann <arnd@arndb.de>
Closes: https://lore.kernel.org/a426d669-58bb-4be1-9eaa-6f3d83109e2d@app.fastmail.com
Link: https://patch.msgid.link/7d8600caed08901b6679767488acd639f6df9688.1773071992.git.jpoimboe@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index bf75628c5389a..2754e46f0e5ad 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1966,12 +1966,11 @@ static void mark_func_jump_tables(struct objtool_file *file,
 			last = insn;
 
 		/*
-		 * Store back-pointers for unconditional forward jumps such
+		 * Store back-pointers for forward jumps such
 		 * that find_jump_table() can back-track using those and
 		 * avoid some potentially confusing code.
 		 */
-		if (insn->type == INSN_JUMP_UNCONDITIONAL && insn->jump_dest &&
-		    insn->offset > last->offset &&
+		if (insn->jump_dest &&
 		    insn->jump_dest->offset > insn->offset &&
 		    !insn->jump_dest->first_jump_src) {
 
-- 
2.53.0



