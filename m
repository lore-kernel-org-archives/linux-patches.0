Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8133806B8;
	Tue, 10 Mar 2026 11:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140785; cv=none; b=ZD+XZck8JLnmmKK8HTrAFmVSl0IeEkFG/T2CGn6fHGMcj4wZYNuX0lPRY1HQCbRwnt5YCQ5TGj9D7RWg8H+mutfDSc5CMWAkOIAD7rjXBA5E7uZjvFO4rcQIqSHOGiBg8J08JtNILx5slu/qCAljVqM+wji5IWpFbkDm3oHbvFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140785; c=relaxed/simple;
	bh=r3mOLKiOQjnFFesyvagRnaMvjEsk9V3jp/5PnvP3tNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxzNbHXom3eK7xLz/uqaaVR0+Y+L9RW+3pnF8gJth1L7+ipS1OhqHqxHtyHClWH3JaTz8rwGESJCvSOojJ7Eoho65WtAVMF20dDrGavoBu2hODQTJsQcgt8uca6GvXuSTsFk0LFCc/gno4KQNepT4cN62HMlo0lXN1v/lGwfDS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Orl/PZwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Orl/PZwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAAFC2BCAF;
	Tue, 10 Mar 2026 11:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140785;
	bh=r3mOLKiOQjnFFesyvagRnaMvjEsk9V3jp/5PnvP3tNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Orl/PZwcGD5hGTLBNCMkjDa3HWeR0fmbEnt6PA8iQZE4DzAV1XkuTQr2YF7z7FYxm
	 rGaACpsfskXXiMaEHpItPqkVqsjcnA0gclKES+Ch43btTzw+x0gY/1VdTZIScCTLUb
	 /KzW82fRQ+c1hdLj5nqEeD+h2HgztHSToMPUqdac6gDobdGgkBj2hGlRGJ+2eCT6F/
	 +D1IzD5ZGZuvC1T+hhPMJLY3se8xY6kd5s1Ze2tB4zP3iAJWbvKjhIcVeFSV2n9B39
	 u3v7OC57kEkwGGcNRT7TN2b19FL2hf6D2cWrEs0YKbNy7p8xHEq8ZGSirrxdHDVmlu
	 SiY4okkkO+HwA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andrew Cooper <andrew.cooper3@citrix.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 020/311] x86/fred: Correct speculative safety in fred_extint()
Date: Tue, 10 Mar 2026 07:01:07 -0400
Message-ID: <e3c9cee4bb4fe3f3a6d013acfa68cf8ca2eb4c25.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 94e626cc6a074..4fc5b176d3edb 100644
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

