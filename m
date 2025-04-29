Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDD620C488;
	Tue, 29 Apr 2025 18:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950021; cv=none; b=FFylarFtDjEqfKMAoeto1QncDoQJ1A6OxW8wMgZpp5KXvstfw8nsAAeuAS4y4riq1x32MXo+KAwZDF5ZG72awYq3WStOAawNYqhgywe32NgVMeiyie0DFsA654bQJZIQ0AgpUwq/UzwGPGH63TT6VGI706Tm6g+wXM95XP1iLt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950021; c=relaxed/simple;
	bh=+xpH7Olh84OO+b4p+lH+XYW5n5Uad8gzdEx/iChBm9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQuOM+/+rze+kFp7mf0d/IYteaPk7xtJocMJiBBV9VZXbEBAuZO7SNmFeYOL1WXWL0LSeWvoW5dTBi1LAHt4oDYYvwgawYF4Zp172eMvZdARSpvQu7eZW9+uatqPp2hc6Y6MwS/SwjNXM19zyYfXRl4enqdzJ56GkCf5lax+wKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VoL0K6ze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VoL0K6ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA742C4CEE3;
	Tue, 29 Apr 2025 18:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950021;
	bh=+xpH7Olh84OO+b4p+lH+XYW5n5Uad8gzdEx/iChBm9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VoL0K6ze3eOBmkLNNTWmOQyNhmjCa99T3lA06iK7Y6mhD/+63JzhaMWNw7CxV89Jv
	 YGJ1l7yAHjRR96UPzGVzr94Oyog8c0Srn+kkADTeS1fxKE2cBQP5ytgFEonPOT44QG
	 U8SSd307CiaYjn5s9aE4Xe8wdrrGyP0oguUwsWXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/167] objtool: Stop UNRET validation on UD2
Date: Tue, 29 Apr 2025 18:44:00 +0200
Message-ID: <20250429161057.076169065@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 9f9cc012c2cbac4833746a0182e06a8eec940d19 ]

In preparation for simplifying INSN_SYSCALL, make validate_unret()
terminate control flow on UD2 just like validate_branch() already does.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/ce841269e7e28c8b7f32064464a9821034d724ff.1744095216.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index b6c91bb5ce3e3..828c91aaf55bd 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3737,6 +3737,9 @@ static int validate_entry(struct objtool_file *file, struct instruction *insn)
 			break;
 		}
 
+		if (insn->dead_end)
+			return 0;
+
 		if (!next) {
 			WARN_FUNC("teh end!", insn->sec, insn->offset);
 			return -1;
-- 
2.39.5



