Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28812367B89;
	Thu, 30 Jul 2026 14:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422823; cv=none; b=PLk+HioLW9qFBQkUkarwe2vdAXQ2sam0iEKRG9FXiWjSoJyuU/4PmtVIn40LY45cOw4DIMXp+ak+QNEuZ84wPoNaUJPE7WgNm9v9uC5lumcz364IQ1711/sELePLvgbOg1izQcGrqq8e07zYJW0xhGkeMbg9b3OurnrEUGcqNVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422823; c=relaxed/simple;
	bh=C9jB+Wp2uof0pQrDxrJhVzsnqciojOgXSqZxhQFIdco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tu62uwlBVlN4lQUTOb73gaSfrBQX79j91aGw2IKbL3WTUOW1cTuZ3Sbv0ERv3rsqmWcK1ToQ7IdXyZCkskwUYNcn74YgT8BgpYsqEc+/ME5qBQZdFJJTNtair9lxzfETognZPcayimPFtoNVKqS5XFPAHFkvNmm+5d4JSkYH/MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRy7j0iP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRy7j0iP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6EC1F000E9;
	Thu, 30 Jul 2026 14:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422822;
	bh=ooenWb6o9cr5iAmNM13ExFQE65+ZWaJ/sLDcdLoG/0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MRy7j0iPobh5E/1+h4hUXUOrKFG7c7bt1VOcXqUgBT8/v2s15P8iEx9HICWzQzl3G
	 7P/xDCe6sJaqloKMQLwAJa5ESdCJKQLbP1ovC1W4hm+UQfYIRh0fBEZ3Ypp+JfIyIr
	 KXwcr1UcELdKLnqkgkqv1dr+AvrCdh2YFKmVy98g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kexin Liu <liukexin@kylinos.cn>,
	George Guo <guodongtai@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.1 569/744] LoongArch: Fix address space mismatch in kexec command line lookup
Date: Thu, 30 Jul 2026 16:14:02 +0200
Message-ID: <20260730141456.379857556@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: George Guo <guodongtai@kylinos.cn>

commit 485ed44db5694d8d2e5027f63ad608e705286f30 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/machine_kexec.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kernel/machine_kexec.c
+++ b/arch/loongarch/kernel/machine_kexec.c
@@ -42,6 +42,7 @@ static unsigned long first_ind_entry;
 int machine_kexec_prepare(struct kimage *kimage)
 {
 	int i;
+	char head[8];
 	char *bootloader = "kexec";
 	void *cmdline_ptr = (void *)KEXEC_CMDLINE_ADDR;
 
@@ -59,7 +60,9 @@ int machine_kexec_prepare(struct kimage
 	} else {
 		/* Find the command line */
 		for (i = 0; i < kimage->nr_segments; i++) {
-			if (!strncmp(bootloader, (char __user *)kimage->segment[i].buf, strlen(bootloader))) {
+			if (copy_from_user(head, kimage->segment[i].buf, strlen(bootloader)))
+				continue;
+			if (!strncmp(bootloader, head, strlen(bootloader))) {
 				if (!copy_from_user(cmdline_ptr, kimage->segment[i].buf, COMMAND_LINE_SIZE))
 					kimage->arch.cmdline_ptr = (unsigned long)cmdline_ptr;
 				break;


