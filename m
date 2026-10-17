Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784172248B3;
	Sat, 17 Oct 2026 16:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254333; cv=none; b=InHZKNfro87iDPKVB8iiHov9Xs64eHfVn+kd96akwtwgCUTugSRJ6AM1G5hDBdb1XM5EDsEIE3mpW3gEXvDmMLhvXoXCTG7TAudbYCLpD0kT/qx2Sj8hC3koO4nZN3i1VWQp8/96lOqPM2ooBrYKUPYyV2+sbuPPGlHIpglHI+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254333; c=relaxed/simple;
	bh=IHjE40o3Tq9uWmXsLdKzlpqPELbhkwFgMJhjHZljM/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAnTns+28G1NYVJxhalxUFjYq4sIwBQD5BmwN6lP4ros1wvKPfjGlGud5b1h+8JlqMoC1/zu5v3Npmnoh2xiPB1PyEfImO7KV5Zh222HRuL4uTJVThgM/oD3xcL9yQ3B+LABpWYiH4FB+0qpDdOdMQPQiZ5WWR31rPNl+7TKPkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2S4XSda; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2S4XSda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C569E1F000C4;
	Sat, 17 Oct 2026 16:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254332;
	bh=aWfNPUXLva0/oXbFSMQnbD8NXnEbaqL7Tu0GLxhg8Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2S4XSdatbo6SzE3Ow7umpNewerlaXXgo5ImEQX5YxC6bTGj0oeLjfPb7bdtU2pAb
	 LnvhBRKZdlIayPW1zySf4ZsLDGJbgrXThrTgIXq+plaNtQ/aTnQ1dEAA5GWcDBTTyZ
	 q7+Nj4KjCSA+lJ/qNRIpIPcfzrBBl2UIKDA0Kgoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kexin Liu <liukexin@kylinos.cn>,
	George Guo <guodongtai@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 411/869] LoongArch: Fix address space mismatch in kexec command line lookup
Date: Sat, 17 Oct 2026 17:54:12 +0200
Message-ID: <20261017160047.673372407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8ef4e4595d61a..182226c67970e 100644
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



