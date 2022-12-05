Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965EC15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181B4C433C1;
	Mon,  5 Dec 2022 19:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268941;
	bh=4vzBZ3rGMgQOS8003rQa4mmwbDvny3cwszOfEmgzzcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYwcgjOwwLR4npoet8Bm7IWMjfzZoFLR1QPu9Ex50OZNqYchSKIUczjmfKA8/3G3b
	 MnAH2+NjmQRZtMEgqW3SgzD6YTUAihHQHTpRjuy5+w4ciJ5S7JHKSHXlAUubpPXCTG
	 oGXOcZnqPEJVrCbSYeFiOHCQi/yd473X2azV/pYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 067/120] riscv: mm: Proper page permissions after initmem free
Date: Mon,  5 Dec 2022 20:10:07 +0100
Message-Id: <20221205190808.645050815@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Björn Töpel <bjorn@rivosinc.com>

commit 6fdd5d2f8c2f54b7fad4ff4df2a19542aeaf6102 upstream.

64-bit RISC-V kernels have the kernel image mapped separately to alias
the linear map. The linear map and the kernel image map are documented
as "direct mapping" and "kernel" respectively in [1].

At image load time, the linear map corresponding to the kernel image
is set to PAGE_READ permission, and the kernel image map is set to
PAGE_READ|PAGE_EXEC.

When the initmem is freed, the pages in the linear map should be
restored to PAGE_READ|PAGE_WRITE, whereas the corresponding pages in
the kernel image map should be restored to PAGE_READ, by removing the
PAGE_EXEC permission.

This is not the case. For 64-bit kernels, only the linear map is
restored to its proper page permissions at initmem free, and not the
kernel image map.

In practise this results in that the kernel can potentially jump to
dead __init code, and start executing invalid instructions, without
getting an exception.

Restore the freed initmem properly, by setting both the kernel image
map to the correct permissions.

[1] Documentation/riscv/vm-layout.rst

Fixes: e5c35fa04019 ("riscv: Map the kernel with correct permissions the first time")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alex@ghiti.fr>
Tested-by: Alexandre Ghiti <alex@ghiti.fr>
Link: https://lore.kernel.org/r/20221115090641.258476-1-bjorn@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/setup.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -331,10 +331,11 @@ subsys_initcall(topology_init);
 
 void free_initmem(void)
 {
-	if (IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
-		set_kernel_memory(lm_alias(__init_begin), lm_alias(__init_end),
-				  IS_ENABLED(CONFIG_64BIT) ?
-					set_memory_rw : set_memory_rw_nx);
+	if (IS_ENABLED(CONFIG_STRICT_KERNEL_RWX)) {
+		set_kernel_memory(lm_alias(__init_begin), lm_alias(__init_end), set_memory_rw_nx);
+		if (IS_ENABLED(CONFIG_64BIT))
+			set_kernel_memory(__init_begin, __init_end, set_memory_nx);
+	}
 
 	free_initmem_default(POISON_FREE_INITMEM);
 }


