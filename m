Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4A73537EF;
	Wed,  8 Apr 2026 18:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672941; cv=none; b=etucqts1744ew2KdZc320OzUE8fxj+VPIc6rCpZVVRgLlr9OCqGCUxxEns92Coa7ombNYYEf4zNinDxEvpGoC8Z1g/eKfW7C3pUPFLuaAwYW7bcbHRulPC0FPTqiKhPeFbSxI3/4Uf52BsWEqUv8z19KHLKWMPkIeam3zvliZyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672941; c=relaxed/simple;
	bh=e+xZHHsqGquhm7hvv2x1jc3VnF8qIneK9SerrtNIs0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2V3FaUkGS8mvXLgTzmre0SLRJfGMS7FQbZiWzFL0CEdvaOxulXF89AgqzFiKQozeMCziUN2RuGfTc0kwFgUEr/BrhoPjDWJajGrYHtnWUqApIc1z7s3ySD9bR9ygjz8jjHn0KqMzCQBE38wv5dW7TrsdUalqL9lstyV8O6+vQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOFjKIzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOFjKIzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9145C19421;
	Wed,  8 Apr 2026 18:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672941;
	bh=e+xZHHsqGquhm7hvv2x1jc3VnF8qIneK9SerrtNIs0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOFjKIzTOvkMhsRtGX5v3lslK2eI85qmrwTBXGOaAFK1jVmjfzDNL41blSIm++Eyu
	 7OS98Q3f4kIE3odGLTb4ECm75/WFzQHAJOea2i9bZBLhLlz0lvWkOwc2wL6zuoF28K
	 165lYc1plnGQiZQlZWPU9uaCSnPZexKIUNlVjU1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 008/277] objtool: Fix Clang jump table detection
Date: Wed,  8 Apr 2026 19:59:53 +0200
Message-ID: <20260408175934.155898412@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bb34484046060..bbdc4be475b1b 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2118,12 +2118,11 @@ static void mark_func_jump_tables(struct objtool_file *file,
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



