Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90CB2641CC;
	Tue,  8 Apr 2025 11:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113543; cv=none; b=UWCC5GU8H3xiKQkBe0Wbi3/5EjTqwHvUDHB1LjnrTxUMUqAXbRLWS92kr6PAQBREfDHPoyDlbjlr88SDFHBo7NfkFLuXdJajUhsB27DqiBL8Z2326Cxkjnti3AqiArGHjdV9kX9tn1IHftwC+1qqIwoJVgLOG3xBSgIqnc0h7Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113543; c=relaxed/simple;
	bh=B2P4qChi8sDVTZchGY6+TCOtwOW5UM6/Ab79ficaAKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCvEeyd/BARxqWK4ROVDJWs44+g29VJUGAMCBiHJPBm1nr79LK4HS6Yv8owqH2vw+0oiX84zLBPyUaDTymsSKpsOFa9RFtPwSHZAClnn5QiJYuae8QjLc2F14tJebsutQg9jyu2agQ8yNTeVrFcXNjq6APqzWRgxUdbtr7mLaT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jG5GuiEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jG5GuiEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1E1C4CEE5;
	Tue,  8 Apr 2025 11:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113542;
	bh=B2P4qChi8sDVTZchGY6+TCOtwOW5UM6/Ab79ficaAKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jG5GuiEx+SckjNhUdmmTWrX1eeOWT+va3a3hm5OFOGCMadd5mShb0c6qmLIQ56Nnx
	 SF0S4+3CIaR5AmcjOWWMD74WyuYbXISnCFeCsKIvXDHOQRnmsZYcxARvd6IUJFLTCG
	 bBTsZ3CyNBMR/6jYrMSqUOlklIRJaP4FR8XEuSQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/268] objtool: Fix verbose disassembly if CROSS_COMPILE isnt set
Date: Tue,  8 Apr 2025 12:49:29 +0200
Message-ID: <20250408104832.804236409@linuxfoundation.org>
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

From: David Laight <david.laight.linux@gmail.com>

[ Upstream commit e77956e4e5c11218e60a1fe8cdbccd02476f2e56 ]

In verbose mode, when printing the disassembly of affected functions, if
CROSS_COMPILE isn't set, the objdump command string gets prefixed with
"(null)".

Somehow this worked before.  Maybe some versions of glibc return an
empty string instead of NULL.  Fix it regardless.

[ jpoimboe: Rewrite commit log. ]

Fixes: ca653464dd097 ("objtool: Add verbose option for disassembling affected functions")
Signed-off-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20250215142321.14081-1-david.laight.linux@gmail.com
Link: https://lore.kernel.org/r/b931a4786bc0127aa4c94e8b35ed617dcbd3d3da.1743481539.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 36412f1881e61..9102ad5985cc0 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4550,6 +4550,8 @@ static int disas_funcs(const char *funcs)
 	char *cmd;
 
 	cross_compile = getenv("CROSS_COMPILE");
+	if (!cross_compile)
+		cross_compile = "";
 
 	objdump_str = "%sobjdump -wdr %s | gawk -M -v _funcs='%s' '"
 			"BEGIN { split(_funcs, funcs); }"
-- 
2.39.5



