Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D81D26FD9B;
	Mon, 29 Dec 2025 16:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025200; cv=none; b=f80NmnitBo6YvytaGmayV1dG14P/DBZtKaKssuOeZwfslIvynNf6VEcOUYnoxaRbsXBVBLrmNTRsuyHJmFIKttohA0638vubkjtGP4WIDp/37a4+jBFX/3/zL6sm33Cjq2MyPGzivIh8UAxYNdxGKcpnOD0ePcIDGjoh1nKyLlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025200; c=relaxed/simple;
	bh=BrB8vFz4MbWv65ZTL4m2/5vmB/e5pMsbBFjPlLX8mng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HC8+n//ZY297RHnWdyG5UL5mz27waeqSZtY3XuK/wKPW0cLVTY6TR/P9oAfBB/eqbO4U3HcV2iNs3beO7DE0/HbrUPVNhKHXUCTqPTQPOChqGl4lI+E7dYrsqD/leR6rCQUo7BA1tus3SW9AkekGtmGLSNvu6EcV3Ow/5nck+Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYKVL1lq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYKVL1lq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F08C4CEF7;
	Mon, 29 Dec 2025 16:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025199;
	bh=BrB8vFz4MbWv65ZTL4m2/5vmB/e5pMsbBFjPlLX8mng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iYKVL1lqjGQoqiuiOisJv/4MeWZ/T9RWs4Me1ArWQUnRxk0R2IyeSgfXpIUrVf/f+
	 v2Xqn9xS3yxaXz6hZhWKPUHrIUnLHN0u74e5+ktMBBk7ERUiK289oWahEQHIdXRXKF
	 8HvMAvkZq2f17xnTEIAFUuytvXAy5C2Nlm7n7W9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianpeng Chang <jianpeng.chang.cn@windriver.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 128/430] arm64: kdump: Fix elfcorehdr overlap caused by reserved memory processing reorder
Date: Mon, 29 Dec 2025 17:08:50 +0100
Message-ID: <20251229160729.076801064@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Jianpeng Chang <jianpeng.chang.cn@windriver.com>

[ Upstream commit 3e8ade58b71b48913d21b647b2089e03e81f117e ]

Commit 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved
memory regions are processed") changed the processing order of reserved
memory regions, causing elfcorehdr to overlap with dynamically allocated
reserved memory regions during kdump kernel boot.

The issue occurs because:
1. kexec-tools allocates elfcorehdr in the last crashkernel reserved
   memory region and passes it to the second kernel
2. The problematic commit moved dynamic reserved memory allocation
   (like bman-fbpr) to occur during fdt_scan_reserved_mem(), before
   elfcorehdr reservation in fdt_reserve_elfcorehdr()
3. bman-fbpr with 16MB alignment requirement can get allocated at
   addresses that overlap with the elfcorehdr location
4. When fdt_reserve_elfcorehdr() tries to reserve elfcorehdr memory,
   overlap detection identifies the conflict and skips reservation
5. kdump kernel fails with "Unable to handle kernel paging request"
   because elfcorehdr memory is not properly reserved

The boot log:
Before 8a6e02d0c00e:
  OF: fdt: Reserving 1 KiB of memory at 0xf4fff000 for elfcorehdr
  OF: reserved mem: 0xf3000000..0xf3ffffff bman-fbpr

After 8a6e02d0c00e:
  OF: reserved mem: 0xf4000000..0xf4ffffff bman-fbpr
  OF: fdt: elfcorehdr is overlapped

Fix this by ensuring elfcorehdr reservation occurs before dynamic
reserved memory allocation.

Fixes: 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory regions are processed")
Signed-off-by: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
Link: https://patch.msgid.link/20251205015934.700016-1-jianpeng.chang.cn@windriver.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index fdaee4906836..3851ce244585 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -503,8 +503,8 @@ void __init early_init_fdt_scan_reserved_mem(void)
 	if (!initial_boot_params)
 		return;
 
-	fdt_scan_reserved_mem();
 	fdt_reserve_elfcorehdr();
+	fdt_scan_reserved_mem();
 
 	/* Process header /memreserve/ fields */
 	for (n = 0; ; n++) {
-- 
2.51.0



