Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208812627E9;
	Wed,  4 Jun 2025 01:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998903; cv=none; b=j336JdaO5v2ZxArtN4zwsU9q3j29IqVK6KRzr9npy8M+ixN6Jg6fl38+rUZmcD7BTpJcGvN/4S7IkZcfmIF5nNGaZ/RIPJgGBkjZmZjTTeSosdRPn/ZeUwks4bWEO/Znh4UaiY6DXzpQHWaZmuNFpQ78ICRIw7pmXgx+AdOD0oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998903; c=relaxed/simple;
	bh=qGVdidYM+I9XSTfz5b5fpLFbDWKQ/q1My/cwLBT0nrQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W1YB5UcCvHupVIdaQC81HPLwOAe463qqbP+7KQrTBiH0b1Cg3BxvnOXSHevQ6c+YDWbtfhjGYEtcxs9+uagDT5DqN4soMdlG2hz5SnC9JcXc48pX/0zY6LaFZMSznx3Tu+C4fLHCIWsyCVSnopiCOR1M7jVEPtqpphzBTAswgVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TrUzml9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TrUzml9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DFFC4CEED;
	Wed,  4 Jun 2025 01:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998903;
	bh=qGVdidYM+I9XSTfz5b5fpLFbDWKQ/q1My/cwLBT0nrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrUzml9zyH6DYJTtiOTlg7SRHlSZDSie01nz+es5ELmt1UoU/00b6gWSm8/aMsuK0
	 ah2cpb1tyUG1rdfBgjgCZx5V11Q9IxINXYVlO0+PfWIQ02utxRdMT0ZL/lSMVR1Yc8
	 XDQ2X5EW6LK9THeNIh2JzGZJ/iGg4fTrsmSQu0A3N+4+SWVg4RpwBBTgz3ouqjFt1A
	 dir8+InbUIdIRnT8f3V+eLkP4I3JKipQlwU0a6g/iOuJPPHlqBhtCE8bNHuOaPdB63
	 MuDvVUT03ErFiOIZE1+JO2F8wD9N4z4FVSgnv+DhwwBh7GlzFgupVnCQIFz8dwiW6X
	 SXuzaF6wx9LIg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zijun Hu <quic_zijuhu@quicinc.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	edumazet@google.com,
	pabeni@redhat.com,
	willemb@google.com
Subject: [PATCH AUTOSEL 6.12 79/93] sock: Correct error checking condition for (assign|release)_proto_idx()
Date: Tue,  3 Jun 2025 20:59:05 -0400
Message-Id: <20250604005919.4191884-79-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005919.4191884-1-sashal@kernel.org>
References: <20250604005919.4191884-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit faeefc173be40512341b102cf1568aa0b6571acd ]

(assign|release)_proto_idx() wrongly check find_first_zero_bit() failure
by condition '(prot->inuse_idx == PROTO_INUSE_NR - 1)' obviously.

Fix by correcting the condition to '(prot->inuse_idx == PROTO_INUSE_NR)'

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250410-fix_net-v2-1-d69e7c5739a4@quicinc.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the Linux kernel source code in the environment,
let me now provide a thorough evaluation: **YES** This commit should be
backported to stable kernel trees. Here's my detailed analysis: ##
Analysis of the Bug Fix ### The Core Issue The commit fixes a critical
off-by-one error in the error checking conditions within
`assign_proto_idx()` and `release_proto_idx()` functions in
`net/core/sock.c`. ### Current vs. Fixed Code Comparison **Before the
fix (incorrect):** ```c // In assign_proto_idx() if
(unlikely(prot->inuse_idx == PROTO_INUSE_NR - 1)) { // Wrong: checks for
63 pr_err("PROTO_INUSE_NR exhausted\n"); return -ENOSPC; } // In
release_proto_idx() if (prot->inuse_idx != PROTO_INUSE_NR - 1) // Wrong:
checks for 63 clear_bit(prot->inuse_idx, proto_inuse_idx); ``` **After
the fix (correct):** ```c // In assign_proto_idx() if
(unlikely(prot->inuse_idx == PROTO_INUSE_NR)) { // Correct: checks for
64 pr_err("PROTO_INUSE_NR exhausted\n"); return -ENOSPC; } // In
release_proto_idx() if (prot->inuse_idx != PROTO_INUSE_NR) // Correct:
checks for 64 clear_bit(prot->inuse_idx, proto_inuse_idx); ``` ###
Technical Analysis 1. **Understanding the Bug:** - `PROTO_INUSE_NR` is
defined as 64, creating a bitmap with valid indices 0-63 -
`find_first_zero_bit()` returns `PROTO_INUSE_NR` (64) when no free bits
are found - The original code incorrectly checked for `PROTO_INUSE_NR -
1` (63), which is actually a valid index - This meant the error
condition would never trigger, and the code would attempt to set bit 64,
causing undefined behavior 2. **Impact of the Bug:** - **Memory
corruption risk:** Setting bit 64 in a 64-bit bitmap accesses memory
beyond the allocated bitmap - **Resource exhaustion not detected:** The
system would not properly detect when all protocol slots are exhausted -
**Potential crashes:** Accessing invalid memory locations could cause
kernel panics 3. **Why This is Backport-Worthy:** - **Fixes a clear
bug:** The logic error is objectively wrong and could cause system
instability - **Minimal risk change:** The fix only changes two
comparison operators, with no architectural impact - **Important
subsystem:** Network protocol registration is core kernel functionality
- **Well-contained fix:** The change is localized to error checking
conditions without affecting normal operation paths ### Comparison with
Similar Commits Looking at the historical examples: - **Similar Commit
#2 (YES):** Fixed error checking in packet handling - similar pattern of
correcting error conditions - **Similar Commit #1 (NO):** More complex
memory leak fix with broader changes - **Similar Commit #3 (NO):**
Architectural change from BUG() to error returns - **Similar Commit #4
(NO):** API cleanup removing function pointers - **Similar Commit #5
(NO):** Validation fix in newer subsystem This commit most closely
resembles Similar Commit #2, which was marked for backporting due to its
focused bug fix nature. ### Stable Tree Criteria Met: - ✅ **Fixes
important bug:** Prevents potential memory corruption - ✅ **Small and
contained:** Only two line changes - ✅ **Low regression risk:** Pure bug
fix with no behavioral changes for normal cases - ✅ **Clear side
effects:** None beyond fixing the bug - ✅ **No architectural changes:**
Maintains existing API and behavior This is exactly the type of focused,
low-risk bug fix that stable trees are designed to include.

 net/core/sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 0842dc9189bf8..d06dc259d6296 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3930,7 +3930,7 @@ static int assign_proto_idx(struct proto *prot)
 {
 	prot->inuse_idx = find_first_zero_bit(proto_inuse_idx, PROTO_INUSE_NR);
 
-	if (unlikely(prot->inuse_idx == PROTO_INUSE_NR - 1)) {
+	if (unlikely(prot->inuse_idx == PROTO_INUSE_NR)) {
 		pr_err("PROTO_INUSE_NR exhausted\n");
 		return -ENOSPC;
 	}
@@ -3941,7 +3941,7 @@ static int assign_proto_idx(struct proto *prot)
 
 static void release_proto_idx(struct proto *prot)
 {
-	if (prot->inuse_idx != PROTO_INUSE_NR - 1)
+	if (prot->inuse_idx != PROTO_INUSE_NR)
 		clear_bit(prot->inuse_idx, proto_inuse_idx);
 }
 #else
-- 
2.39.5

