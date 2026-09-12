Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B551035C6A9;
	Sat, 12 Sep 2026 10:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209376; cv=none; b=L2P9NTO8TK10/d3IC3wcryKHd+SS/dwgDuaFyCiVBsoB1nGSVC+njFOSjIZLdpqOMBtjcGfPs8q4D7uAmsukZICQ7N1Yf+O+UHeebB7SRmlnEcUYMUz14uY/6KXvjBDeb6ScHkCgXG/qMaXfgV7iZ4UZwU5xi6Zx5btcL4Umtj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209376; c=relaxed/simple;
	bh=1eXdRh9in0da3GxdjzYMCDfSi5fFO7N+rFlpriDiEl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxeTI/afzfYDQY7vP3nUnCLIA0QJ0aDOO5d+Ua0YgaoD/ZrMZ8TRjH3jOed/T7DipSIuZSXUOUayHyWBFQQtRVPYTBB6W9YXr9p8RcC+GI7S+nVBN6Iq8sTzFBuyQTQdA83q4I4p5JxTN5YilMSkHQQ6kqfnslQIgEkk1CmcPvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6KHw9/M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6KHw9/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546861F000FF;
	Sat, 12 Sep 2026 10:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209375;
	bh=MKjitZ4iceK/gAfY5vfjpOT84ipRcnTwLH7T5iSUh6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k6KHw9/MdwFILqQq305UD6aSZ1zX35kDWYOgSVRVWCyiABQi4wTVfudIAVzuP4WXv
	 5BEIOkxMOR5JjXq3p1RlfBvHR4QfNVj9Al4H+SUsyZkBrvanYWtdEM/z+6n/BnraNf
	 +gry1tqLYOvIWxEnjNjbLX762nxxO+h3cBmNMoqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0808/1518] arm64/fpsimd: ptrace: Fix inactive SVE and SSVE regsets
Date: Sat, 12 Sep 2026 08:49:37 +0200
Message-ID: <20260912065641.715006331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 2acc2c3dd033e..ceb047e7d49f2 100644
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



