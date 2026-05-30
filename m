Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E811D21E098;
	Sat, 30 May 2026 17:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163934; cv=none; b=tWnuxj1e/GrxCaPIoNeftjvS/I0lRCFvLpAoeSkshr1T5HHCPp73jKPuq9qtSyVUrLFCM8BQx/8X788pDE2GwfY6gWRIpW8o4alSYpVIGQMqCTicmQJjd1xJ7iOdWdRkbXJtr48MALX7IObJgAfPazN/SKswN2eSdiktB2daZ+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163934; c=relaxed/simple;
	bh=+YshV2LyNRPmnImfIRnswyd3wOh3IzD2mEzdvIilFN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rgSab4NhcLISDlBM8B12B89A5uaqHQ5BvxMz7rgXEBSgxuOqVfQfdl3rPSUEMup5oQKyKzwSqXoi03EFxihv2oOD6QwmUp2vD8atILWsj34m4B783sqzEuNso5Wj9RvY5IjqT/LP80J+bGvHp3N/aVy4RIk9V2fjxR/GYBY19nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKNrwYo0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKNrwYo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021161F00893;
	Sat, 30 May 2026 17:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163933;
	bh=oNL+X/kjVhHjgqYqi6inSJcd3n3ncSVfan9THNxrb40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PKNrwYo0DLeu9bUs4e5s3G11Cn6CJj8GO39xb/1De8eBnoyRIAuVgPJrTSCbZSPh1
	 xFi4JQFowkQ3zGQXWWe3ZbQxPS3IVr4yfdnJVmqKs09iYFD84ME06h9eTTIRMDBDJ+
	 7V9K2s4uKtSy2vX3cp0rVdVIpoVyEDdCjVaxHmPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Gupta <adityag@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 406/776] powerpc/crash: fix backup region offset update to elfcorehdr
Date: Sat, 30 May 2026 18:02:00 +0200
Message-ID: <20260530160250.991719827@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sourabh Jain <sourabhjain@linux.ibm.com>

[ Upstream commit 789335cacdf37da93bb7c70322dff8c7e82881df ]

update_backup_region_phdr() in file_load_64.c iterates over all the
program headers in the kdump kernel’s elfcorehdr and updates the
p_offset of the program header whose physical address starts at 0.

However, the loop logic is incorrect because the program header pointer
is not updated during iteration. Since elfcorehdr typically contains
PT_NOTE entries first, the PT_LOAD program header with physical address
0 is never reached. As a result, its p_offset is not updated to point to
the backup region.

Because of this behavior, the capture kernel exports the first 64 KB of
the crashed kernel’s memory at offset 0, even though that memory
actually lives in the backup region. When a crash happens, purgatory
copies the first 64 KB of the crashed kernel’s memory into the backup
region so the capture kernel can safely use it.

This has not caused problems so far because the first 64 KB is usually
identical in both the crashed and capture kernels. However, this is
just an assumption and is not guaranteed to always hold true.

Fix update_backup_region_phdr() to correctly update the p_offset of the
program header with a starting physical address of 0 by correcting the
logic used to iterate over the program headers.

Fixes: cb350c1f1f86 ("powerpc/kexec_file: Prepare elfcore header for crashing kernel")
Reviewed-by: Aditya Gupta <adityag@linux.ibm.com>
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Reviewed-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260312083051.1935737-2-sourabhjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/file_load_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index bce1bef0be899..ac8160cbcf673 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -766,7 +766,7 @@ static void update_backup_region_phdr(struct kimage *image, Elf64_Ehdr *ehdr)
 	unsigned int i;
 
 	phdr = (Elf64_Phdr *)(ehdr + 1);
-	for (i = 0; i < ehdr->e_phnum; i++) {
+	for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
 		if (phdr->p_paddr == BACKUP_SRC_START) {
 			phdr->p_offset = image->arch.backup_start;
 			pr_debug("Backup region offset updated to 0x%lx\n",
-- 
2.53.0



