Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E0A34C98C;
	Sat, 17 Oct 2026 17:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259237; cv=none; b=U6A7/WjsRY1R8tLNx3SbaRlwNmIZIOxcY9RVJrhmYsjT2hHMKhOgceZGtgZdit8iu2C/mioNsbi66VDp3Y7Ynha/ZIZjYO9F/YU8ZEnv0fjXFBj0OnLV1hMVRgt7dHE8Bjctm5gzAAAQWM/uufa8i5/+YCW82aouvmX8CQNiaSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259237; c=relaxed/simple;
	bh=SWZeAHuZJyIEl/BxTY9Gu8eRk5/txDsfeCfRVX9Ewj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUX42VPiyA1jUCea9HZjbn1Tw//wQf8a4GSEk0Bw85Em+cd1lZOH7n/3HGM07q7CLOUZznCNtb+r8GntKHknAJC1YZoT4ew8iSeU/nLn0VZTQEAGJxpCHE/Q+Ba1ziqFtG2oJ69I0H0O2blcq3tF+K1M+efKxfSGJ4pcbpq8CbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0FHP+lQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0FHP+lQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5521F000C4;
	Sat, 17 Oct 2026 17:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259236;
	bh=lJpXLDfIFz+opm6VW/XZTi+TDNlOxoJjlvtGSG0jCd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0FHP+lQXbPR6fA55IYIjqACnLWpjN1l36xsxPVfoK4LUATc9MXPEXu24sqDV9SD5
	 9A7WbAFZqe5XJuSA9PBwuiB/UOeQcELz7X9ZCKl8iLLM9U+sQsC5YcSRi08YY3oEWw
	 XfDFyN6JGnWoCioYNRiIWURxS73e5xWVF8H1UF4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kexin Liu <liukexin@kylinos.cn>,
	George Guo <guodongtai@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1108/1674] LoongArch: Fix address space mismatch in kexec command line lookup
Date: Sat, 17 Oct 2026 17:56:20 +0200
Message-ID: <20261017160459.566574565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Guo <guodongtai@kylinos.cn>

[ Upstream commit 485ed44db5694d8d2e5027f63ad608e705286f30 ]

When searching the loaded segments for the "kexec" command line marker,
the kexec_load(2) path (file_mode == 0) passes the user-space segment
buffer straight to strncmp() through a bogus (char __user *) cast. This
dereferences a user pointer in kernel context, which is wrong and is
flagged by sparse:

  arch/loongarch/kernel/machine_kexec.c:84:51: sparse: incorrect type in
  argument 2 (different address spaces) @@ expected char const * @@ got
  char [noderef] __user *

Here copy the marker-sized prefix of each segment into a small on-stack
buffer with copy_from_user() before comparing, and skip segments that
fault. The subsequent copy_from_user() that stages the full command line
into the safe area is left unchanged.

Cc: stable@vger.kernel.org
Fixes: 4a03b2ac06a5 ("LoongArch: Add kexec support")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605051639.aEPioXdD-lkp@intel.com/
Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/machine_kexec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/machine_kexec.c b/arch/loongarch/kernel/machine_kexec.c
index ce4e132ac1373..7c93e9d1f020b 100644
--- a/arch/loongarch/kernel/machine_kexec.c
+++ b/arch/loongarch/kernel/machine_kexec.c
@@ -62,6 +62,7 @@ static void kexec_image_info(const struct kimage *kimage)
 int machine_kexec_prepare(struct kimage *kimage)
 {
 	int i;
+	char head[8];
 	char *bootloader = "kexec";
 	void *cmdline_ptr = (void *)KEXEC_CMDLINE_ADDR;
 
@@ -72,7 +73,9 @@ int machine_kexec_prepare(struct kimage *kimage)
 
 	/* Find the command line */
 	for (i = 0; i < kimage->nr_segments; i++) {
-		if (!strncmp(bootloader, (char __user *)kimage->segment[i].buf, strlen(bootloader))) {
+		if (copy_from_user(head, kimage->segment[i].buf, strlen(bootloader)))
+			continue;
+		if (!strncmp(bootloader, head, strlen(bootloader))) {
 			if (!copy_from_user(cmdline_ptr, kimage->segment[i].buf, COMMAND_LINE_SIZE))
 				kimage->arch.cmdline_ptr = (unsigned long)cmdline_ptr;
 			break;
-- 
2.53.0



