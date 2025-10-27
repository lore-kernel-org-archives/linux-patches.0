Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F2F27FD62;
	Mon, 27 Oct 2025 19:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593128; cv=none; b=WiL9Ja1qhoj9p4r2YGZ+bsCs0JFhB4UNtUXRJsAfHJeYCOqBasa+1/ZKr3Wg3FtpnbBBF1rnRazsaiQsNWVaTGM5G/bQgkIgcpADQ6MEUW9ddwHlmqZZjXOMcU7S6LxSGy8JckjUqAKGBMziveVihTJBbGdnnlfGgUV9yb3rQM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593128; c=relaxed/simple;
	bh=o6kpFex0oGALyM6+jfs53DPbxdBkaT2y35j3umLqL9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRYZQveouB7w8sQUjZxnFLtULNFC9QLdRcFuaqnykSwArJ/xl3yNaO2/mF8DzH1L5a0FixC8IQbnPxHnXEO9J4RNfYqoqioN5DGHG469Q6sYAvY8gHz6kt6+yjvDRmpLhA5FbFNn/hPyRoPxmeDKydv3en5c3R8Y36WpmOQoAMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4F1yJ1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4F1yJ1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77FBC4CEF1;
	Mon, 27 Oct 2025 19:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593128;
	bh=o6kpFex0oGALyM6+jfs53DPbxdBkaT2y35j3umLqL9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4F1yJ1nzGaGdKXtm+C+N3up1n/9bFDMJfzTDXxmKFsfqPmCP3DCZfVy5eAXtZxkS
	 wgvKm0n6E9yKBjDchwfsenAxnF9iqrq2QjFH7iOr9YlxJQRk/y28gpPPDwTRFEfEvm
	 yQADVgV52wVc0tnJmyVMebaMlEF+CfAMI9LE7eVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Nutty Liu <liujingqi@lanxincomputing.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 023/184] riscv: mm: Return intended SATP mode for noXlvl options
Date: Mon, 27 Oct 2025 19:35:05 +0100
Message-ID: <20251027183515.553021041@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhui Liu <junhui.liu@pigmoral.tech>

[ Upstream commit f3243bed39c26ce0f13e6392a634f91d409b2d02 ]

Change the return value of match_noXlvl() to return the SATP mode that
will be used, rather than the mode being disabled. This enables unified
logic for return value judgement with the function that obtains mmu-type
from the fdt, avoiding extra conversion. This only changes the naming,
with no functional impact.

Signed-off-by: Junhui Liu <junhui.liu@pigmoral.tech>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Nutty Liu <liujingqi@lanxincomputing.com>
Link: https://lore.kernel.org/r/20250722-satp-from-fdt-v1-1-5ba22218fa5f@pigmoral.tech
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/pi/cmdline_early.c | 4 ++--
 arch/riscv/mm/init.c                 | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kernel/pi/cmdline_early.c b/arch/riscv/kernel/pi/cmdline_early.c
index fbcdc9e4e1432..389d086a07187 100644
--- a/arch/riscv/kernel/pi/cmdline_early.c
+++ b/arch/riscv/kernel/pi/cmdline_early.c
@@ -41,9 +41,9 @@ static char *get_early_cmdline(uintptr_t dtb_pa)
 static u64 match_noXlvl(char *cmdline)
 {
 	if (strstr(cmdline, "no4lvl"))
-		return SATP_MODE_48;
+		return SATP_MODE_39;
 	else if (strstr(cmdline, "no5lvl"))
-		return SATP_MODE_57;
+		return SATP_MODE_48;
 
 	return 0;
 }
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 15683ae13fa5d..054265b3f2680 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -864,9 +864,9 @@ static __init void set_satp_mode(uintptr_t dtb_pa)
 
 	kernel_map.page_offset = PAGE_OFFSET_L5;
 
-	if (satp_mode_cmdline == SATP_MODE_57) {
+	if (satp_mode_cmdline == SATP_MODE_48) {
 		disable_pgtable_l5();
-	} else if (satp_mode_cmdline == SATP_MODE_48) {
+	} else if (satp_mode_cmdline == SATP_MODE_39) {
 		disable_pgtable_l5();
 		disable_pgtable_l4();
 		return;
-- 
2.51.0



