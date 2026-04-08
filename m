Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029C7B67E;
	Wed,  8 Apr 2026 18:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673645; cv=none; b=ue+cSCGeF2AkRkV8h1SM6IyIgCxXuhz9FkMju2gNi3YV58hH+IiY+QE/ggxkN1GtaNUjf+LxHtUTKsMEl7ZvRkGrdtgbOSYP3vsznseM4OP1h+xfyXXJKmgA+zhILS09+6EZLDfTFTcN1B8SiM1jV/dAzpYrJNYZqlX7MtEAfBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673645; c=relaxed/simple;
	bh=jOpTxYGa5I4nDAMa01321xvZibInbczCs3h4rZmoqP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Af23jsExaZ47OR2vrn374xdw8JvZSfS9rbWuhKeUC+XpkivXu0fFp1zJjohdVQvrM5PwJyFE7KI2oduSc5HL4lU8vjhdAzO0w+YfKR4JrwSK3FjhLml+I3R6Tci+7lCu6qxZNHFo7j0xc415A4w9c1ptL9njfxr4GWSGfXlDjoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLxw3tEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLxw3tEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C72FC19421;
	Wed,  8 Apr 2026 18:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673644;
	bh=jOpTxYGa5I4nDAMa01321xvZibInbczCs3h4rZmoqP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLxw3tEElntcm2UV0E7OgqzX6ZVp8izwWaNg/LOreKKCRG8+rlZKI2fPjcflxLHum
	 PtX6cKg2QWzhvQkqWUeFw0UNrIoNew3NeH8/RfKeIKNMZX/wBHbRKy+zEQMf26ymoz
	 nMqtF98S4uf5Xe3J7wx34GJ2YGVRscL6VGgefqWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/242] objtool: Fix Clang jump table detection
Date: Wed,  8 Apr 2026 20:01:13 +0200
Message-ID: <20260408175928.311514468@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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
index ad83bb3197225..b75ddb3fca0df 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2174,12 +2174,11 @@ static void mark_func_jump_tables(struct objtool_file *file,
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



