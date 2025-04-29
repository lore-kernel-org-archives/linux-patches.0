Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58A4242902;
	Tue, 29 Apr 2025 17:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946491; cv=none; b=O7oOFOMnX5X0eMUMiCUGixkCbt4wHyn1VMTgpRq9wCi+97hurLepfIAzD2QhojJPRm4S6JsWgJcISDrluGAyKAw4v422Y0wsVfzHVSY8zNrNrMwkEDheTIJSAySPKbxKOfaCgaqTqYhAHze0pvVUOWpSxBmdlZ2j4uz/3Sg2Iho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946491; c=relaxed/simple;
	bh=LBs6WnlVjkD6yPY9QxQKtbiO73tNE1eSE8czxu04xfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WszHdB//8kr3qOl/6fHwksX//+a63a2YXXT+lYfiICNyiNGX68gyWaXFy3T5Rl7n9ygJsVtjwUaccKtSVOFC9XqRMZ/dkCbrjY13Fq7maNYWToRygbJ7pUqH+Kg1HogJMiCAud68EVSndpzbA0WeGuexfrP/XRSp+3YIsAIhJVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlB1eiVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlB1eiVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2251EC4CEE3;
	Tue, 29 Apr 2025 17:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946491;
	bh=LBs6WnlVjkD6yPY9QxQKtbiO73tNE1eSE8czxu04xfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlB1eiViZOIQQ8iChggaXrSvVVVD3WB0WfF+hBF4couau05k3ruEUbz8Uqu/GWEIh
	 ongdwt4puOk4HPxtULraDhHl4rObLECsgj1dUXmIQV/G0a7jZ4QsPuMGVQeqRvvQ5Y
	 HkUHadcDP8/R6zO5M11eVU+DFpihhYXJkSpwXu/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 255/311] objtool: Stop UNRET validation on UD2
Date: Tue, 29 Apr 2025 18:41:32 +0200
Message-ID: <20250429161131.469079842@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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
index bbfd81f49802e..eb9109b4aaf35 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3870,6 +3870,9 @@ static int validate_unret(struct objtool_file *file, struct instruction *insn)
 			break;
 		}
 
+		if (insn->dead_end)
+			return 0;
+
 		if (!next) {
 			WARN_INSN(insn, "teh end!");
 			return -1;
-- 
2.39.5



