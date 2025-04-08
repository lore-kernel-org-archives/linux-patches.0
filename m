Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268202063FD;
	Tue,  8 Apr 2025 12:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114969; cv=none; b=JVHt5Ox71t2vsxqH2QBlfZpQesGgn7T6zHi1tPd+FBWQ2Excu3z7dMBo48WyPMoD98A9VJW5GIj2SuyQPXqfvOqxehy4L69a9AhI6nMgvm2BrFCQp6ltXIr5TrjJ8OxF1VRBET7FDNrwLGw1xb60+cu8HBWOp1Y0l6qpr5xxo6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114969; c=relaxed/simple;
	bh=1BhMN6KT3jcbFs0Xmk9csUqMFX3jnK5Wpr+EGn+AGBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPJmoSclzGwpjzrGIm607mXMey98RONKYXeTQqoQ+9OCtNW3Ni9KeLFVsjBbrakId3spz8mwY4FxqtYthXR8jBcIcyjAQob9NHt/qleI1qmOO4+isdJQd16ClwKlhaH2pJSPZdOEZCAJ+UlrL3yaYCTtNjtMnt0Nokplghjv2wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DViuu6DH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DViuu6DH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BB0C4CEE5;
	Tue,  8 Apr 2025 12:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114969;
	bh=1BhMN6KT3jcbFs0Xmk9csUqMFX3jnK5Wpr+EGn+AGBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DViuu6DHju3kJw2f9kuhflfZekuBxL77SVCUTjfxT+50HNLQ7OKdRYBAEiWQ+1Sc5
	 8k/uWQRHkGPO9vm/3iYDiBQ/2HWSn9FiuGIfYfwbZGlqPVFbmNMuf3lfIf0ZuEKkmR
	 Fc5c5hiLe8HtJxE8gKAJa5dzLZ8C/PaqPkAp1T4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 294/499] objtool: Fix verbose disassembly if CROSS_COMPILE isnt set
Date: Tue,  8 Apr 2025 12:48:26 +0200
Message-ID: <20250408104858.546853987@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 8785c9fff8234..9c7e60f71327d 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4633,6 +4633,8 @@ static int disas_funcs(const char *funcs)
 	char *cmd;
 
 	cross_compile = getenv("CROSS_COMPILE");
+	if (!cross_compile)
+		cross_compile = "";
 
 	objdump_str = "%sobjdump -wdr %s | gawk -M -v _funcs='%s' '"
 			"BEGIN { split(_funcs, funcs); }"
-- 
2.39.5



