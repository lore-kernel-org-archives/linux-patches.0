Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2452319F424;
	Tue, 29 Apr 2025 18:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949617; cv=none; b=NPFPT0RuDSIQl+ZNNbL50A3+5IJ9aKTusGgSLcaPTtZpp8jxERgijZY6k2II8p4KxKmrSDLyisEtbHxPWKuVTWhtHPckTKZB2stW/kZRdDLBkRY9khwlnCc6V7A6HoP2ye332NrdJcTV2D8vw+/I4H+t/HEUyW6IwC7eg6WKL1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949617; c=relaxed/simple;
	bh=94cckmOd9kGqLoqH9Vesf+Bpffgk8RkmsWEp/t26nEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aN4k/mkbWr4rVkKlsZk0oSwnRsABqJYMsRbItxvA4LeZDcnPOjac+T9DxpjgQS1bCsO26VhA3RgChMJeFmd1S1g2BNu8QY68huqfptnyJdkaxnzMqQeHz9pBKpG1dPj0ZzrTBSNtkPEst0pG2gLVJ20NSv2o+lilMVfVesnUYkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrFGuMcn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrFGuMcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87442C4CEE3;
	Tue, 29 Apr 2025 18:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949617;
	bh=94cckmOd9kGqLoqH9Vesf+Bpffgk8RkmsWEp/t26nEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrFGuMcn+DF00JvuJAkppsufy/a99KAbdMCeKJU0m8k1jLz0zqid7zpLLIFBllwhz
	 9DigTOR1JhaZpfP5KDDsPALNVJbszehEJKM7A/Y1h+bqrh0CMLBr7sH+7uchvdmCs2
	 MGCTm5ZUdYF5Rh62MTGqyB/5V53QtRhMjW3RymzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 347/373] objtool: Stop UNRET validation on UD2
Date: Tue, 29 Apr 2025 18:43:44 +0200
Message-ID: <20250429161137.405933972@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c2596b1e1fb1e..d2366ec61edc4 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3416,6 +3416,9 @@ static int validate_entry(struct objtool_file *file, struct instruction *insn)
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



