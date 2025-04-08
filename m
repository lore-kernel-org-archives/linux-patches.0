Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23086268FD8;
	Tue,  8 Apr 2025 11:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113492; cv=none; b=JUwuRNR2xHXCNCfdcCAuhk0cKdWDzfkVMBu4eGG89OMc7HfcIRVSe6TsPG3g2n0t+McT1VI0haJIfYk8vYX8UAuv5H5BSc9IkXTY03Rq0ZqA1/fPJ9QABlzcYGKf93uv6QMyimNB/MTG/0R+kw3+akwtE3fkl08EN0pviHrXTDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113492; c=relaxed/simple;
	bh=VBDezoYaYfV/K1g43OteqklpUFG6R52nYnZ8leL1iYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9MfeYdS45YWhtXRyYB2mZrFCg2CWrnOGB4eiik6vw5an8V/PyhBrVk+pa1++rNwlduFutjvEfCkeCtaVrmVsD5FK8P0bn1D511Qu6XitdThmExOhbjvTwSUimeNR1sLbergmR0KcDSDhRPxqjBDLZTOS9Qx/SlAKyipXnqsEsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUx4mRi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUx4mRi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8BAC4CEE5;
	Tue,  8 Apr 2025 11:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113492;
	bh=VBDezoYaYfV/K1g43OteqklpUFG6R52nYnZ8leL1iYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zUx4mRi+sRSOeZxQNhiXqZbhRNFVz1cYUzww9QjqzIEgXmNmbH9cRIBgdAU8uhkgS
	 SCnIL69+4pDQKQEpGi6tSYaw11n6QnPuM5WHI15hw5EOyyNUOJGjdo81EdAgggxo98
	 Rt2LZSunHHekcvoM8og3MXU/4rr9DZi+h6jTyl1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/268] objtool: Fix segfault in ignore_unreachable_insn()
Date: Tue,  8 Apr 2025 12:49:23 +0200
Message-ID: <20250408104832.638905054@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 69d41d6dafff0967565b971d950bd10443e4076c ]

Check 'prev_insn' before dereferencing it.

Fixes: bd841d6154f5 ("objtool: Fix CONFIG_UBSAN_TRAP unreachable warnings")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/5df4ff89c9e4b9e788b77b0531234ffa7ba03e9e.1743136205.git.jpoimboe@kernel.org

Closes: https://lore.kernel.org/d86b4cc6-0b97-4095-8793-a7384410b8ab@app.fastmail.com
Closes: https://lore.kernel.org/Z-V_rruKY0-36pqA@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 5824aa68ff961..36412f1881e61 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4089,7 +4089,7 @@ static bool ignore_unreachable_insn(struct objtool_file *file, struct instructio
 	 * It may also insert a UD2 after calling a __noreturn function.
 	 */
 	prev_insn = prev_insn_same_sec(file, insn);
-	if (prev_insn->dead_end &&
+	if (prev_insn && prev_insn->dead_end &&
 	    (insn->type == INSN_BUG ||
 	     (insn->type == INSN_JUMP_UNCONDITIONAL &&
 	      insn->jump_dest && insn->jump_dest->type == INSN_BUG)))
-- 
2.39.5



