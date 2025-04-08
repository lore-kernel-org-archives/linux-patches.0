Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807AA224239;
	Tue,  8 Apr 2025 11:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111815; cv=none; b=YS44NQJDBNCq9CB3o8qyWTkc8AxQyytRg8n/AR9WgitCXmqwNbC+k3YIekfzp6vQgocUM4C1r4b5HarZHoBJzqc+5wQxsZLRITIpe+S0zJGwBAInSK2FvLAruIG0FL8dN4DQYFCMBGVPnOY9FAUKvL4XF3QAjkTflyZ4t3pICCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111815; c=relaxed/simple;
	bh=5jtySsG7qmAk9i97RO2zMvpRVfkMUonimiPFd9jwK/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MptTohszaihKKlxC+yBRXLYiYarpJ1r6ndi+nafqLO0asri+wTzdCrkdBwehqIfhKE3OWDdytdAsTFUq9xFVImsxnClBNt7pgHGb44hZG9SmjS9cQP5zKfig6ges/T4mY9E4WgbAwxZA4t9m1LFJSFg12Rwt9b8rWVZPArxvr08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AigI8bYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AigI8bYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6E7C4CEE5;
	Tue,  8 Apr 2025 11:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111815;
	bh=5jtySsG7qmAk9i97RO2zMvpRVfkMUonimiPFd9jwK/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AigI8bYdaC8uNf5eNIV1dYJ731aVn0c1qs5/qQ7gTcWRyvGVwU2uZ329DttK1D0OU
	 +rpuDHaqPXFbXPETLlCdAQvqSLdQ3OPM4cCz5uchx1Ynkb907cjobMNc7HYSfwfLsw
	 0Z31m2KUonStiRJeXfYiB8a0ZdX4fXTIkba2FeS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 570/731] objtool: Fix verbose disassembly if CROSS_COMPILE isnt set
Date: Tue,  8 Apr 2025 12:47:47 +0200
Message-ID: <20250408104927.531714145@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index aa071017c325c..159fb130e2827 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4489,6 +4489,8 @@ static int disas_funcs(const char *funcs)
 	char *cmd;
 
 	cross_compile = getenv("CROSS_COMPILE");
+	if (!cross_compile)
+		cross_compile = "";
 
 	objdump_str = "%sobjdump -wdr %s | gawk -M -v _funcs='%s' '"
 			"BEGIN { split(_funcs, funcs); }"
-- 
2.39.5



