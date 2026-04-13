Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A22A32F765;
	Mon, 13 Apr 2026 16:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099468; cv=none; b=AE8JX8OZsu3fEBLg4sG2LHNfdPfVUifCHqZk30qi9+RBB4qhSo6bT6u1pEfwZ0oAtBeYKiFUEb7tRetkgkwSIEWblbJBu5HZAmFNnCYSp7UXHONJu2FXXIzD1Llal8dhfjmlJfzixSDp+QJ9btAJR4LShtoBnyPS2BS1sZjqPlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099468; c=relaxed/simple;
	bh=fuutDTY1MhZaQ+DiAbVEVCk4789OTFGk5vThvwTpRzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjbXpWl2rbIreS7gMEi97wCelKQAyAJzPwtvcoVzcaZ7OuOC5BhlYOUP/e4+1so1M0YLPDljn4lmyTbRcWDEIe7I62b4jycPvsUs18WFZovBxPb15d98o6C+Bth6ghr0idm1I5F/C6C8QHw+Cxo+ZX2I3gHqEdKDLgRrTVbtGUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dALedSor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dALedSor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE337C2BCAF;
	Mon, 13 Apr 2026 16:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099468;
	bh=fuutDTY1MhZaQ+DiAbVEVCk4789OTFGk5vThvwTpRzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dALedSor9jy2jRP27swE1hajy4RSimiZajmhGon/QvoXd7RtL8UYKFsS944+AJeBO
	 qa5ZGBsTLhmpK8wT4xIBtTS/Ba4cZBWPWYUTuXexCEFAtGzj+X9ZY/tFxOD3w0TIEp
	 3/5G4OSDtoq6z8H2dfAxju+2qf30dH9h6de7TD74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 319/491] objtool: Fix Clang jump table detection
Date: Mon, 13 Apr 2026 17:59:24 +0200
Message-ID: <20260413155830.986998201@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 20ccdd60353be..ac4bd2d4fdda6 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1664,12 +1664,11 @@ static void mark_func_jump_tables(struct objtool_file *file,
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



