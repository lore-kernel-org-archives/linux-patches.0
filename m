Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC81F3C461
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRojIw7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943A4C433C7;
	Wed, 15 Nov 2023 19:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077122;
	bh=cuiMbkjklB98gSaJFOyx5/N63dYMaRe6E6Xf/NWW0X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRojIw7IPgXzWA6Vclt8n+JR3BGLaryocWJ0goH7oZRJ/4t9FVP9aX5OoXDqii8QQ
	 ODXEjAXKZDQ0t0giXrYlKHZOJtVcajm7qB5sntd0adEJ85PbrJQW94h/lEOt73nC9g
	 xgjbM3kZ864rTrf/0SeOokWxMzpoLaYqULUsNups=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 529/550] RISC-V: Dont fail in riscv_of_parent_hartid() for disabled HARTs
Date: Wed, 15 Nov 2023 14:18:33 -0500
Message-ID: <20231115191637.605866043@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Patel <apatel@ventanamicro.com>

[ Upstream commit c4676f8dc1e12e68d6511f9ed89707fdad4c962c ]

The riscv_of_processor_hartid() used by riscv_of_parent_hartid() fails
for HARTs disabled in the DT. This results in the following warning
thrown by the RISC-V INTC driver for the E-core on SiFive boards:

[    0.000000] riscv-intc: unable to find hart id for /cpus/cpu@0/interrupt-controller

The riscv_of_parent_hartid() is only expected to read the hartid
from the DT so we directly call of_get_cpu_hwid() instead of calling
riscv_of_processor_hartid().

Fixes: ad635e723e17 ("riscv: cpu: Add 64bit hartid support on RV64")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Link: https://lore.kernel.org/r/20231027154254.355853-2-apatel@ventanamicro.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cpu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
index 35b854cf078ed..fa8bf78fa9c5a 100644
--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@ -88,13 +88,14 @@ int riscv_early_of_processor_hartid(struct device_node *node, unsigned long *har
  */
 int riscv_of_parent_hartid(struct device_node *node, unsigned long *hartid)
 {
-	int rc;
-
 	for (; node; node = node->parent) {
 		if (of_device_is_compatible(node, "riscv")) {
-			rc = riscv_of_processor_hartid(node, hartid);
-			if (!rc)
-				return 0;
+			*hartid = (unsigned long)of_get_cpu_hwid(node, 0);
+			if (*hartid == ~0UL) {
+				pr_warn("Found CPU without hart ID\n");
+				return -ENODEV;
+			}
+			return 0;
 		}
 	}
 
-- 
2.42.0



