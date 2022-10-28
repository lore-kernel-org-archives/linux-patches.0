Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6725023A3
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 12:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DFCC433C1;
	Fri, 28 Oct 2022 12:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666958802;
	bh=sd7y5klKN2/PT2z4ZKkozoAYeLYWjZU79dg5afzW3DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JyeUo/lQYISJ7BkSTX2x4BfUQxIY3H1Z7iYMUmY+/0aDZhs2npuTVMm9EnEcXllOU
	 D2RiceWfaW5zJ0gZTHdjBZsuB/G2gYQnfrvdJuFHlr9q8fO2vKXa7KXmUUPdbHmYIs
	 FLDfN/pXbJFt86QXvpjgZIaj/k+8cps3G8OQ5tts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Atish Patra <atish.patra@wdc.com>,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 57/73] riscv: Add machine name to kernel boot log and stack dump output
Date: Fri, 28 Oct 2022 14:03:54 +0200
Message-Id: <20221028120234.859351069@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 46ad48e8a28da7cc37a16c7e7fc632ecf906e4bf ]

Add the machine name to kernel boot-up log, and install
the machine name to stack dump for DT boot mode.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Stable-dep-of: 10f6913c548b ("riscv: always honor the CONFIG_CMDLINE_FORCE when parsing dtb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/setup.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 117f3212a8e4..5d17d3ce36fd 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -54,8 +54,15 @@ static DEFINE_PER_CPU(struct cpu, cpu_devices);
 static void __init parse_dtb(void)
 {
 	/* Early scan of device tree from init memory */
-	if (early_init_dt_scan(dtb_early_va))
+	if (early_init_dt_scan(dtb_early_va)) {
+		const char *name = of_flat_dt_get_machine_name();
+
+		if (name) {
+			pr_info("Machine model: %s\n", name);
+			dump_stack_set_arch_desc("%s (DT)", name);
+		}
 		return;
+	}
 
 	pr_err("No DTB passed to the kernel\n");
 #ifdef CONFIG_CMDLINE_FORCE
-- 
2.35.1



