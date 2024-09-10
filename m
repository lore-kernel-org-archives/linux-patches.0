Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E13F18CBE9;
	Tue, 10 Sep 2024 10:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964526; cv=none; b=ZiWT8aiYG9qs1lK8kVMCopP5gYQHd4k9eWICWH5DTrbiochcmVJenpBgaIVgQd99QkyIy4FB79qfOERkF+ogxkdG3Z6MDLKMz2nxiLUq2XVU1/djmJqEfm/imKWIWtYiSYND4Cx3C0GPGIyPRjKiix3XVeNwm3gcZyP3Q0ML/NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964526; c=relaxed/simple;
	bh=QvVuqXpBd7vYQUpk9b/13aPrJKJgpVPh3p5iJoY0BRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzymX/tMmVtIsAFo12OeUhGozFa8oaak+25N9bUj7kg7L/OpaWyOpGbJOu5wf55EBWlQ6qkAsAgsT+V7xS75ugYMBflelROaLKl2QVj6x8+6HZn11PJPF8r1847pMUoFlIHB0Usj+FjXfiNKTqddoHSp0o80qJFyzVtFTq3h3M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NyCpjkRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NyCpjkRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D157C4CEC3;
	Tue, 10 Sep 2024 10:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964525;
	bh=QvVuqXpBd7vYQUpk9b/13aPrJKJgpVPh3p5iJoY0BRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NyCpjkRDJqXP0nBEMQTIVp76PNy9Pg/Cc5urmGVxz1Psn8sGaB6nggwerAwJWC3Xb
	 aWti4uLvb2yRSy3L4OgCbumZQKBsVDJzAXiTNN4HrLeiSGfutX0rrtMhVH/54LxuzJ
	 8NHKDA4597sYQw0KBWqcPV3068WYME4M3B1njvC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/269] LoongArch: Use correct API to map cmdline in relocate_kernel()
Date: Tue, 10 Sep 2024 11:32:42 +0200
Message-ID: <20240910092614.415313966@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 0124fbb4c6dba23dbdf80c829be68adbccde2722 ]

fw_arg1 is in memory space rather than I/O space, so we should use
early_memremap_ro() instead of early_ioremap() to map the cmdline.
Moreover, we should unmap it after using.

Suggested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/relocate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/relocate.c b/arch/loongarch/kernel/relocate.c
index 1acfa704c8d0..0eddd4a66b87 100644
--- a/arch/loongarch/kernel/relocate.c
+++ b/arch/loongarch/kernel/relocate.c
@@ -13,6 +13,7 @@
 #include <asm/bootinfo.h>
 #include <asm/early_ioremap.h>
 #include <asm/inst.h>
+#include <asm/io.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
 
@@ -170,7 +171,7 @@ unsigned long __init relocate_kernel(void)
 	unsigned long kernel_length;
 	unsigned long random_offset = 0;
 	void *location_new = _text; /* Default to original kernel start */
-	char *cmdline = early_ioremap(fw_arg1, COMMAND_LINE_SIZE); /* Boot command line is passed in fw_arg1 */
+	char *cmdline = early_memremap_ro(fw_arg1, COMMAND_LINE_SIZE); /* Boot command line is passed in fw_arg1 */
 
 	strscpy(boot_command_line, cmdline, COMMAND_LINE_SIZE);
 
@@ -182,6 +183,7 @@ unsigned long __init relocate_kernel(void)
 		random_offset = (unsigned long)location_new - (unsigned long)(_text);
 #endif
 	reloc_offset = (unsigned long)_text - VMLINUX_LOAD_ADDRESS;
+	early_memunmap(cmdline, COMMAND_LINE_SIZE);
 
 	if (random_offset) {
 		kernel_length = (long)(_end) - (long)(_text);
-- 
2.43.0



