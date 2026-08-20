Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C71D37E5FF;
	Thu, 20 Aug 2026 15:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238534; cv=none; b=m7Lt0XxDn0slkMw5B6El00oyH0Do8SiH27JmYeoA9J2GGIreDUAaB+QDb//RS9AsXvkN0BXloLtJdjWyqoQXqvDHokM6+jfvv4uerMKBG+c0K7OxIqLQMiG2kHPa7JEHD0mGlYZnfTHODbG9WF9ocoeRE+s6NolbWai3uSPEQUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238534; c=relaxed/simple;
	bh=T5+6y5t0i7YtzCElDfpR1BkxHHeFG1SusS1Of9rfH4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhK4xjPINNU1FJz4YPBMWH8yM5OwUgqjABzrcO6iLu/PttvsOFu8Sintb0qF61446fBb05MmVxool2AfY6htoDSmjkIbiE1LO5TPhiO6hcf0q5yGdVDo89UDv+Rl12lZ+9a3OhPOLuG9psrb0+M27HsdcLFgqEQfKmKoy32Z0LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blTFy+LG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blTFy+LG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F136D1F000E9;
	Thu, 20 Aug 2026 15:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238533;
	bh=3/jnBX0kVtB3yJzoUoaMMgX1l72eAjYL8omkWxkWZNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=blTFy+LGF5bhll6dDo8k6xrgKbPuqVkdLGrv5Iwrm3wXQTmFtjwdj1enA3+E4rD2Q
	 zCDxQ6Rtt8rohysYonwk5+kCRPTz+RD8kqW4gc4hYkH1YBWoeX/GwFc2o7VcdhCGHu
	 FgHqoNxMQbEudMXmmLQGjLUmpRYXSENOImQ7kAkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Neuling <mikey@neuling.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 180/228] riscv: lib: Fix ZBB strnlen reading past count boundary
Date: Thu, 20 Aug 2026 16:55:22 +0200
Message-ID: <20260820145250.158849490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

[ Upstream commit 5d588c684833e678a0008eb69c33190f01a65f4b ]

The ZBB-optimized strnlen loop loads one word ahead before checking the
aligned boundary:

    REG_L   t1, SZREG(t0)       // load next word
    addi    t0, t0, SZREG       // advance
    orc.b   t1, t1
    bgeu    t0, t4, 4f          // boundary check AFTER load

where t4 = (s + count) & -SZREG.  When s is aligned and count is a
multiple of SZREG, t4 equals s + count and the loop loads a full word
starting at exactly s + count.  If s + count falls on a page boundary
with the next page unmapped, this faults.

Fix by computing the aligned boundary from the last valid byte
(s + count - 1) instead of s + count.  This makes the loop stop at the
word containing the last valid byte rather than potentially loading the
word after it.  The count == 0 case is already handled by the beqz
early exit.

Also add a pre-loop guard (bgeu t0, t4) for the case where all valid
bytes fit within the first word.  With the adjusted boundary, t4 can
equal t0, and entering the loop with stale register state from the
first-word processing would produce incorrect results.

The final minu clamp ensures the result is still correct when the last
loaded word extends past s + count - 1 within the same aligned word.

Fixes: 5ba15d419fab ("riscv: lib: add strnlen() implementation")
Signed-off-by: Michael Neuling <mikey@neuling.org>
Assisted-by: Claude Opus4.6 High Thinking
Link: https://patch.msgid.link/20260413010738.1622423-1-mikey@neuling.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/lib/strnlen.S | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/lib/strnlen.S b/arch/riscv/lib/strnlen.S
index 53afa7b5b314d..a8911605c2480 100644
--- a/arch/riscv/lib/strnlen.S
+++ b/arch/riscv/lib/strnlen.S
@@ -83,8 +83,13 @@ strnlen_zbb:
 	sub	t3, t3, t2
 	slli	t2, t2, 3
 
-	/* Aligned boundary. */
+	/*
+	 * Aligned boundary.  Use the address of the last valid byte
+	 * (s + count - 1) to avoid loading a word past the count
+	 * boundary in the loop below.  count == 0 is handled above.
+	 */
 	add	t4, a0, a1
+	addi	t4, t4, -1
 	andi	t4, t4, -SZREG
 
 	/* Get the first word.  */
@@ -120,6 +125,9 @@ strnlen_zbb:
 
 	bgtu	t3, a0, 2f
 
+	/* All remaining bytes are in the first word, no loop needed. */
+	bgeu	t0, t4, 2f
+
 	/* Prepare for the word comparison loop. */
 	addi	t2, t0, SZREG
 	li	t3, -1
-- 
2.53.0



