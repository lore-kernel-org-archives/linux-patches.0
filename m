Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9EF3AFAF4;
	Sat, 12 Sep 2026 08:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201286; cv=none; b=fLfh3OGeJyMYLZc+4hOwuyfWmKYYEa52N6mkIYWCr1SCxjgl1BjkrhZmPq1tKWTfrEy2DvMj5F9DRGINqQQFOZrc8d7RFmptgeEnptgjBZG+PfY/cC252JwkulGLidno9ql/RzD6rpta0Yke6D74MUOIf5u7I89TUPV/yjNTfa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201286; c=relaxed/simple;
	bh=PXhVx/B3RukeIbQZl6KBogUEa6EkyoNkkEWpVnB7KJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwPnV9/rGtYoMiVt6qJT1S8E/LPFLBHWTVvnq+VIIs9Q80KnczwN8Mu/Hkim/WenrjSvdh2iWUBVseX+ZL7Ng06vVo33UJpcB1ZdWmtmZ5HvY8eUf6f/uwJ5TyiB1q8aI4faIWkRZcyFfO5dLTzNm+5FfV7ogE1RgEvhEy2p6LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I78sKtfY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I78sKtfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7041F00893;
	Sat, 12 Sep 2026 08:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201284;
	bh=QzLh9mc/FqDDIadL/snD5dr2jxuWs+V+/YLsZLM0nEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I78sKtfYszRCO1nH2fYfEqUG/7/h48OKcqSGyYF/lgrpGfPUGTvdQSQyF23vUYXgA
	 KUDnlRx/bCMjhVgFjOneMCCM9gfGdyhIiSCjQRyD/p5uJYMhtNStP3CPIvLPgJDjYN
	 1tbOBIXIuKrB3GGgl85ystTyXje6Lna3xFIhrby4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0958/1815] arm64/fpsimd: ptrace: Fix inactive SVE and SSVE regsets
Date: Sat, 12 Sep 2026 08:45:08 +0200
Message-ID: <20260912065711.460691939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit c3f83d021162571bcd87b062ec9e587828d2b7f3 ]

sve_init_header_from_task() takes header as a pointer, so for the
inactive mode

	header->size = sizeof(header);

stores 8 rather than sizeof(struct user_sve_header), which is 16.
Userspace sees an impossible size smaller than the header it
describes.

The inactive-mode check in sve_get_common() compares header.size
against sizeof(header) as well, but there header is a struct, so the
check can never fire. Reads of NT_ARM_SVE and NT_ARM_SSVE for the
inactive mode therefore still return the other mode's FPSIMD data,
exactly the situation the check was added to prevent.

Fix the size, and make the check return the remaining membuf space
instead of 0, which regset_get() would interpret as the entire
(zero-filled) buffer having been populated.

Fixes: b93e685ecff7 ("arm64/fpsimd: ptrace: Do not present register data for inactive mode")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/ptrace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 4d08598e2891d..2a72c61a8af9c 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -801,7 +801,7 @@ static void sve_init_header_from_task(struct user_sve_header *header,
 	if (active)
 		header->size = SVE_PT_SIZE(vq, header->flags);
 	else
-		header->size = sizeof(header);
+		header->size = sizeof(*header);
 	header->max_size = SVE_PT_SIZE(sve_vq_from_vl(header->max_vl),
 				      SVE_PT_REGS_SVE);
 }
@@ -837,7 +837,7 @@ static int sve_get_common(struct task_struct *target,
 	 * from the other mode to userspace.
 	 */
 	if (header.size == sizeof(header))
-		return 0;
+		return to.left;
 
 	switch ((header.flags & SVE_PT_REGS_MASK)) {
 	case SVE_PT_REGS_FPSIMD:
-- 
2.53.0



