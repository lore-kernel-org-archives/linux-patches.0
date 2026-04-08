Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CB43A16A0;
	Wed,  8 Apr 2026 18:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672496; cv=none; b=Zt+M5NuZf4HRNrQPt7uqAXJvT8TAonywZQLrpdZ3Le9pkqJuhK+aKpAH5cNWo0GbFBHUKhpn5CR3iVGuMSZ+hyJPaM6j7xgrX/HvliQrvtG3fEgCKvKjmGa+cGayy1M2wwPPUERGZh823+rD71qhyfxR859LRGF21q/we0y/11c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672496; c=relaxed/simple;
	bh=D1c5wGfhh/DXW5BUD+GKlOqA/ePCEQMcB1385MFBXjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMzlCS+7R3pc7qXqmdQO9d7+kkBzCim77Asr16xnYWYUc7zEayAjWnqk3F8NM5ojLY4bTLGjh2MktsR2STSClwhGSBmKONBxAmD4a5SnZxWyuK5x1wGcGa3l4HPL7juNEfM8A9Llbtqow/IlD4qefqWRuPD1Xk94SmLq3gh/0tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cfd/fuH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cfd/fuH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4BCC19421;
	Wed,  8 Apr 2026 18:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672496;
	bh=D1c5wGfhh/DXW5BUD+GKlOqA/ePCEQMcB1385MFBXjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cfd/fuH47wpyqkzDvoHIKk0ukiECdTW+S6UvitVvz8uLcHS1mVv/V07Pkf4Ovuj/v
	 XLsbSz5Qu+ptFu/171y0+Sg/hSgVrtQTwpTIXHY7lxj0QivAF6OKKm7YzKFfPJLafp
	 OD6DcrEKynQ0437cnvG3CUMPEGYbYQLP+1KP5Gq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/160] objtool: Fix Clang jump table detection
Date: Wed,  8 Apr 2026 20:01:33 +0200
Message-ID: <20260408175913.422032879@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6497c80fd6f77..2c7b09c8415f0 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2136,12 +2136,11 @@ static void mark_func_jump_tables(struct objtool_file *file,
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



