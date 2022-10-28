Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C9423A3
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 12:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB09C433D6;
	Fri, 28 Oct 2022 12:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666958804;
	bh=5lg8zGz9Oa+LVtfdkFdBU0V0zAwOBzGlWIu/mZ3zvTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3pDHpqSOb3RS9AjpIVE0fFIzsfZtPrBeDLSDguwi6C55rI7BQBctqlbUEbTJNzbV
	 o+s/OmFDUnSkI8jKkBkqW7UOtitr4CCVxn16q9oyR3mAHZ0LcTecAEUROLktf57+tt
	 sKT0cLcRdo0toEUPw2mj7PBOSRtNavEBJLUETwrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenting Zhang <zephray@outlook.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 58/73] riscv: always honor the CONFIG_CMDLINE_FORCE when parsing dtb
Date: Fri, 28 Oct 2022 14:03:55 +0200
Message-Id: <20221028120234.906805493@linuxfoundation.org>
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

From: Wenting Zhang <zephray@outlook.com>

[ Upstream commit 10f6913c548b32ecb73801a16b120e761c6957ea ]

When CONFIG_CMDLINE_FORCE is enabled, cmdline provided by
CONFIG_CMDLINE are always used. This allows CONFIG_CMDLINE to be
used regardless of the result of device tree scanning.

This especially fixes the case where a device tree without the
chosen node is supplied to the kernel. In such cases,
early_init_dt_scan would return true. But inside
early_init_dt_scan_chosen, the cmdline won't be updated as there
is no chosen node in the device tree. As a result, CONFIG_CMDLINE
is not copied into boot_command_line even if CONFIG_CMDLINE_FORCE
is enabled. This commit allows properly update boot_command_line
in this situation.

Fixes: 8fd6e05c7463 ("arch: riscv: support kernel command line forcing when no DTB passed")
Signed-off-by: Wenting Zhang <zephray@outlook.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/PSBPR04MB399135DFC54928AB958D0638B1829@PSBPR04MB3991.apcprd04.prod.outlook.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 5d17d3ce36fd..cc85858f7fe8 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -61,10 +61,10 @@ static void __init parse_dtb(void)
 			pr_info("Machine model: %s\n", name);
 			dump_stack_set_arch_desc("%s (DT)", name);
 		}
-		return;
+	} else {
+		pr_err("No DTB passed to the kernel\n");
 	}
 
-	pr_err("No DTB passed to the kernel\n");
 #ifdef CONFIG_CMDLINE_FORCE
 	strlcpy(boot_command_line, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
 	pr_info("Forcing kernel command line to: %s\n", boot_command_line);
-- 
2.35.1



