Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273F825A321;
	Wed,  8 Apr 2026 18:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674227; cv=none; b=hJmhmGM9JrJ8WUOAO5TU8t1U1P+kBFuFGZSim4Tysidwqp+/ADQBMQGLFuJxQ5YqpttJ0xNaYzBGFNRqFxCSgNGJmP9FHWxFEvqdZpXOfWs0PljRiyuvwxawmAbqCyugjQPsiYMttQyDLRrsAiG6zSVPQIPG1pxpRU7+CoBeZnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674227; c=relaxed/simple;
	bh=ovbFBkR8KQMl+4jMRATitREmvavxwU1huB6J+fAyQVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGgEHijZDwoaQM6DuopittipFiSKYMFUmX5ky4IdEygClKbf2kybOunOA4T2XoHTBnxWQFfzphY81eWmtwRJZk0tkbLy/D2IMRY8cqkDABI5BvJsutkzoiSBS4pxqeYEKPX8ywlP5PnvDpThRRNNHYthQD15YrqmJni6m90RxlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBnkPF0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBnkPF0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B82C19421;
	Wed,  8 Apr 2026 18:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674226;
	bh=ovbFBkR8KQMl+4jMRATitREmvavxwU1huB6J+fAyQVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBnkPF0yp9epYcd2dINO8s6nHl17H2sWByyr+zMa6wXnnxC8MseYOtlhTRzObG8Ii
	 J8b717qbUF7CmZDF5KadVwzDwdaY+aKt8RwOaWOzb9bOGOTq4by09LB32rcvZb08d0
	 jAE8aAL9VRsqZUCruU4TcRMEpyBuHCQbW5HeHSPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 016/311] objtool: Fix Clang jump table detection
Date: Wed,  8 Apr 2026 20:00:16 +0200
Message-ID: <20260408175940.018703250@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 30609aed5d37e..2f63f938d0890 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2144,12 +2144,11 @@ static void mark_func_jump_tables(struct objtool_file *file,
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



