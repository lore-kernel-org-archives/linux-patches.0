Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD9A2FF178;
	Wed, 28 Jan 2026 15:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615701; cv=none; b=PajXfHsYWwYUYq3n5vizUlDb8N06LavW+qs2h6KmKBXZtsgyKSnYACidZ0gxreyYh0SD5v5QEF82W4/Ic30lm5HAUlCU9CfNeRoZGYMYVVR+9BbRwV7DgbtWyIxrUdTQz24tg4e92Zybr6xgCfyDPEtr+AVrxGeZ4hWPtlLYkwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615701; c=relaxed/simple;
	bh=Ojyd+J8/puOXYJyqCllhaZ2oB+cO07u3auoF8a3FI/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erYOSXpq/Rzq4a2jmKNNHHbK07iIaTfDvP9o7dX4DBMfsjoIMjRWihJEWdg0hibhf6CncrDCpg33Sz7QHC8/cMkWoIxJbprN4DBFIRIdTXzp0DwByU8hd/4tmKZlMZEnlnkSv5HBNyK4958a0npdNcLC6icW77gjxxS5Y4CYYXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XndNJwNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XndNJwNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2092DC4CEF1;
	Wed, 28 Jan 2026 15:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615701;
	bh=Ojyd+J8/puOXYJyqCllhaZ2oB+cO07u3auoF8a3FI/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XndNJwNFExrQqkLPcd1bj01Ed9L9+19W1bTbwqiPhwE8blmTwuhqPNB3LlNqZwiMW
	 C2J3oZ3qab+7OnLwl9utecy92dL4uZwjVIg1ryIQiE1Zf2aXzj5w4Tq7wPxe0Q3p3I
	 XSFzbAEKp+h7oTJLd2LG+iMHAAzEf7zTDU8DLKtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiko Shimizu <naohiko.shimizu@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 088/227] riscv: clocksource: Fix stimecmp update hazard on RV32
Date: Wed, 28 Jan 2026 16:22:13 +0100
Message-ID: <20260128145347.503736666@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiko Shimizu <naohiko.shimizu@gmail.com>

[ Upstream commit eaa9bb1d39d59e7c17b06cec12622b7c586ab629 ]

On RV32, updating the 64-bit stimecmp (or vstimecmp) CSR requires two
separate 32-bit writes. A race condition exists if the timer triggers
during these two writes.

The RISC-V Privileged Specification (e.g., Section 3.2.1 for mtimecmp)
recommends a specific 3-step sequence to avoid spurious interrupts
when updating 64-bit comparison registers on 32-bit systems:

1. Set the low-order bits (stimecmp) to all ones (ULONG_MAX).
2. Set the high-order bits (stimecmph) to the desired value.
3. Set the low-order bits (stimecmp) to the desired value.

Current implementation writes the LSB first without ensuring a future
value, which may lead to a transient state where the 64-bit comparison
is incorrectly evaluated as "expired" by the hardware. This results in
spurious timer interrupts.

This patch adopts the spec-recommended 3-step sequence to ensure the
intermediate 64-bit state is never smaller than the current time.

Fixes: 9f7a8ff6391f ("RISC-V: Prefer sstc extension if available")
Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://patch.msgid.link/20260104135938.524-2-naohiko.shimizu@gmail.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-riscv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index 4d7cf338824a3..cfc4d83c42c03 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -50,8 +50,9 @@ static int riscv_clock_next_event(unsigned long delta,
 
 	if (static_branch_likely(&riscv_sstc_available)) {
 #if defined(CONFIG_32BIT)
-		csr_write(CSR_STIMECMP, next_tval & 0xFFFFFFFF);
+		csr_write(CSR_STIMECMP, ULONG_MAX);
 		csr_write(CSR_STIMECMPH, next_tval >> 32);
+		csr_write(CSR_STIMECMP, next_tval & 0xFFFFFFFF);
 #else
 		csr_write(CSR_STIMECMP, next_tval);
 #endif
-- 
2.51.0



