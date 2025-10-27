Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664742C11DF;
	Mon, 27 Oct 2025 19:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592116; cv=none; b=Xn1ZosDN15B4Bvj5dTp2yc6qnWyhbdV9ITTPSsY0s2H1KCItqnvZ9PTp5m39AA5EheSBFpVxjczeRAj6JMp2KjuBC/lWPqSBpcGmXrWpCQ/sylsHhcdWBzHc60ZEFN55CHIGALfXuXCS6aqb3fI79r45xVAe3Ns6NAelCkhY1Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592116; c=relaxed/simple;
	bh=yoU/DdN1dcdDWsB8loECDLQllI7pMpQ3AK80EHC8FT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TyfcgQGNCeHvOdiWAYXp+HvpGTNPPwWKUGkhoPzLGoqjtJHPo5UgIes0wiz+jRb3W6Qq6EL8wBMNr5A2lmimWYmypPQwt0DwinYtgDJ5NbhUNnflKRpzQ7I/voskbCcpeZnv7zBNPQi8pxSK4X8lTF1MXNFe2KCzKTqj7Y5ql+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LsR4SP28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LsR4SP28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC103C4CEF1;
	Mon, 27 Oct 2025 19:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592116;
	bh=yoU/DdN1dcdDWsB8loECDLQllI7pMpQ3AK80EHC8FT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LsR4SP28iHVf2KqofPp3suaF5d2TSchxgkCN89DUvZPW9Hi7gYf8+ZcL29bR23Z1S
	 HGXrOU9l//qVTNXnravPavm9zgfnyDwcAp7R8oux6wb1R2RXrTQMfFto2mdJVYspUK
	 rh5HgDx+m9Kwu4A61hROOq55ERs+DmbZYdQAUzfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 123/123] RISC-V: Dont fail in riscv_of_parent_hartid() for disabled HARTs
Date: Mon, 27 Oct 2025 19:36:43 +0100
Message-ID: <20251027183449.672926685@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Patel <apatel@ventanamicro.com>

commit c4676f8dc1e12e68d6511f9ed89707fdad4c962c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/cpu.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@ -50,13 +50,14 @@ int riscv_of_processor_hartid(struct dev
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
 


