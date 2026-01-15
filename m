Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8611A42049;
	Thu, 15 Jan 2026 16:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495932; cv=none; b=M9E32LxqrSHSw4UqCFbzIiCwMRod4Z7OncPdFcBDdihW5/SXDCsGM6klk9CCquOu14dOo3n7namN9VxeSNmM29BjusCcagzoXRnBoisNCyFB/gjG9vQoZ34rmaUbgt+sAULDMZ4L587bLLEKbCx3QywXSATJySZEZhLMqyfvOyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495932; c=relaxed/simple;
	bh=xwwI3amhTv9gpdkTVW06cTGmH9hQ1qxha5Cm81wsbeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHbe2PCatWvZ1h/3lXzeH6oAwWYlFGrlFnEMazkZDdu/4G3VH76OL5q+FgBfRRo1VaEs4E5aDPq4kQYU5CgRAD6V0tV+oTD0/i8RvaSNTfe09Wer9P1F4osU0QoO/HutwHKP2d/+nvl0sUtg7gVuHYZOXA55PqGMT3KGPeKwc6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qrEhfGsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrEhfGsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD843C116D0;
	Thu, 15 Jan 2026 16:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495932;
	bh=xwwI3amhTv9gpdkTVW06cTGmH9hQ1qxha5Cm81wsbeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrEhfGsRvmTYNIrcbsqyCV8AxyorcaApF0wYhQ1H9+1XiwwDoakHL+DwUp3Z3gyLZ
	 nPEp6h+DS4uVa1qsw6AYNjIAueiG4hMLgUkVihCbDt6PBcNd8laGjcCgsXDk6rsdb6
	 I5fTpUlRstppyBfCAkhK+QBvMjDkCKyTJq61yuwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Nathan Chancellor <nathan@kernel.org>,
	Han Gao <gaohan@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.18 019/181] riscv: boot: Always make Image from vmlinux, not vmlinux.unstripped
Date: Thu, 15 Jan 2026 17:45:56 +0100
Message-ID: <20260115164203.016352697@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Vivian Wang <wangruikang@iscas.ac.cn>

commit 66562b66dcbc8f93c1e28632299f449bb2f5c47d upstream.

Since commit 4b47a3aefb29 ("kbuild: Restore pattern to avoid stripping
.rela.dyn from vmlinux") vmlinux has .rel*.dyn preserved. Therefore, use
vmlinux to produce Image, not vmlinux.unstripped.

Doing so fixes booting a RELOCATABLE=y Image with kexec. The problem is
caused by this chain of events:

- Since commit 3e86e4d74c04 ("kbuild: keep .modinfo section in
  vmlinux.unstripped"), vmlinux.unstripped gets a .modinfo section.
- The .modinfo section has SHF_ALLOC, so it ends up in Image, at the end
  of it.
- The Image header's image_size field does not expect to include
  .modinfo and does not account for it, since it should not be in Image.
- If .modinfo is large enough, the file size of Image ends up larger
  than image_size, which eventually leads to it failing
  sanity_check_segment_list().

Using vmlinux instead of vmlinux.unstripped means that the unexpected
.modinfo section is gone from Image, fixing the file size problem.

Cc: stable@vger.kernel.org
Fixes: 3e86e4d74c04 ("kbuild: keep .modinfo section in vmlinux.unstripped")
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Han Gao <gaohan@iscas.ac.cn>
Link: https://patch.msgid.link/20251230-riscv-vmlinux-not-unstripped-v1-1-15f49df880df@iscas.ac.cn
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/Makefile | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/riscv/boot/Makefile b/arch/riscv/boot/Makefile
index bfc3d0b75b9b..5301adf5f3f5 100644
--- a/arch/riscv/boot/Makefile
+++ b/arch/riscv/boot/Makefile
@@ -31,11 +31,7 @@ $(obj)/xipImage: vmlinux FORCE
 
 endif
 
-ifdef CONFIG_RELOCATABLE
-$(obj)/Image: vmlinux.unstripped FORCE
-else
 $(obj)/Image: vmlinux FORCE
-endif
 	$(call if_changed,objcopy)
 
 $(obj)/Image.gz: $(obj)/Image FORCE
-- 
2.52.0



