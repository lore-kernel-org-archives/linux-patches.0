Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AED43876CE;
	Tue, 10 Mar 2026 11:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141651; cv=none; b=Dm6siY6rRAOu0CD/AUQ9T/kvdWgv1AKgir+JN2NR5LeltASRtOcJZ2CsjTQza/tpSa6gKoEfES66H0vG8yuqHgNrdsdZgAuD0BFBp5c4Ub5V1xWX97WMTOwBnbp9p8dv9Gh73vnscJKXE5FZ1f8BJgOX2gm6XxXPqmu9cl7QO9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141651; c=relaxed/simple;
	bh=FLQmd+mziEQPdWQi2bE3T48919em2eCIvinh3Qfo09w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9lT4kOXRfuINipTCCX90nHj9HjoHYXcNZE9rWucBCoetL4qV4YWk8mcq3ob86yVSSK96n/VjSxWGnvzG5Th9cnLTvVVdLHLd+S9zbxOdxXyUNDWSTk1noHKSbRQVSuUMtE7qHRexx7ZRfJlUMFTfZyjfFctuHafSN+7oOY+BNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fQWz2MkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fQWz2MkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B44C2BC86;
	Tue, 10 Mar 2026 11:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141651;
	bh=FLQmd+mziEQPdWQi2bE3T48919em2eCIvinh3Qfo09w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQWz2MkVqVdAC37U07N7bxTgx0QeeognZpiu4oG4jMIJN4oqSTeXwNP4HM9Tm2j0U
	 +pb7TFU/tD3wN6R4Lx+7KikaOb9zeyyVPPISAJkHS8/PPHq8QBpAndZJg3MRrco3Vd
	 JUMDh3ejJAdVbXt1Ysyz+8+oQ8/mGSYbXZY6Vlrid7aBpOGkmwkT1K10ZUZAdMPxoG
	 a5tmRs70MjNuno7m2oEuDY7vsmDz2qdI2MOm325lJYwdlMjxUb/OehveH2bPdg1JDH
	 89mCcLCzSKEkUn9IEzSWsxoL7QPjRswspto0n3vBfiEkCz9cOdBwTWO/v6yxQGVRkR
	 XxMXrZrvpD6cA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andrew Cooper <andrew.cooper3@citrix.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 017/314] x86/fred: Correct speculative safety in fred_extint()
Date: Tue, 10 Mar 2026 07:14:36 -0400
Message-ID: <dacf3023d1615394487b3c8159dbb1576d3a2ace.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Andrew Cooper <andrew.cooper3@citrix.com>

[ Upstream commit aa280a08e7d8fae58557acc345b36b3dc329d595 ]

array_index_nospec() is no use if the result gets spilled to the stack, as
it makes the believed safe-under-speculation value subject to memory
predictions.

For all practical purposes, this means array_index_nospec() must be used in
the expression that accesses the array.

As the code currently stands, it's the wrong side of irqentry_enter(), and
'index' is put into %ebp across the function call.

Remove the index variable and reposition array_index_nospec(), so it's
calculated immediately before the array access.

Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260106131504.679932-1-andrew.cooper3@citrix.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_fred.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
index f004a4dc74c2d..563e439b743f2 100644
--- a/arch/x86/entry/entry_fred.c
+++ b/arch/x86/entry/entry_fred.c
@@ -159,8 +159,6 @@ void __init fred_complete_exception_setup(void)
 static noinstr void fred_extint(struct pt_regs *regs)
 {
 	unsigned int vector = regs->fred_ss.vector;
-	unsigned int index = array_index_nospec(vector - FIRST_SYSTEM_VECTOR,
-						NR_SYSTEM_VECTORS);
 
 	if (WARN_ON_ONCE(vector < FIRST_EXTERNAL_VECTOR))
 		return;
@@ -169,7 +167,8 @@ static noinstr void fred_extint(struct pt_regs *regs)
 		irqentry_state_t state = irqentry_enter(regs);
 
 		instrumentation_begin();
-		sysvec_table[index](regs);
+		sysvec_table[array_index_nospec(vector - FIRST_SYSTEM_VECTOR,
+						NR_SYSTEM_VECTORS)](regs);
 		instrumentation_end();
 		irqentry_exit(regs, state);
 	} else {
-- 
2.51.0

