Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BBC1D5AD4;
	Mon, 13 Apr 2026 16:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098228; cv=none; b=EzFMtLN7MA0eYWy8ttuRLN3/i4i+xx09nemopAV5beBFvvqd4wOHg+LR0A2LRAIiikAn5u0EOj+b0VjkD1GyNNHyfD4R63y1uu/+nlkkQxK7LsAutlyvReRaF2Shd8HlauI1r0F4W4rmYM92p7lFXtJHOv7Ve87PaF/fIjzMHgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098228; c=relaxed/simple;
	bh=GZirb8Bmxc7Vg1UnjSHFRoAvhL8D4GhEeyRGDbGw1xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFuDQ6FeUmttQNrYQ8k/a0hf8UW4evzD8b3652e7oq9RFsn9REdvWY8GhWdUgIOmuwf69QoyxXfdUvVuZtciMw4elEBv8h0k49DHJ3535iLNwn3dW/O5VEzxWOmBkf2Oj8vyVZD7T7zXkrIrqBPddcUzlQ4aMIhIQlc7omFH4js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZW0o65P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZW0o65P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96A3C2BCB3;
	Mon, 13 Apr 2026 16:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098228;
	bh=GZirb8Bmxc7Vg1UnjSHFRoAvhL8D4GhEeyRGDbGw1xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZW0o65PohwEHc8NPztUdsKjTtMIGTNltM7Gbvg4td6sFdf+TXK4Lbexvy8W6pt9C
	 ZgqZIECAcz9NOcgXgAv3Jnxq6zaqoBymR7yH+V21V7OwiyjD7jJou84nWgXrrodX8C
	 t8QtTj5Xxw41WdzM27bmxsDR9P80mAwB8cPNSM7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 401/570] objtool: Fix Clang jump table detection
Date: Mon, 13 Apr 2026 17:58:52 +0200
Message-ID: <20260413155845.491297961@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d2366ec61edc4..72a7e49dec276 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1759,12 +1759,11 @@ static void mark_func_jump_tables(struct objtool_file *file,
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



