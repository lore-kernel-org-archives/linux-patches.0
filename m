Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB961474AF;
	Fri,  6 Dec 2024 14:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496637; cv=none; b=jWdX0N0Nx8+ZKwcqJNsQr4U08q5g+U9b3Ay5k8MGR8bbRHp/XInbr1wn/fa14DC9EOnAE+kZBTUYbnA/UsJmaSVqXH34tyOF8Vud+4PevBVp/SdlONwqraf6lu7tL4XgPHeaPKgHPrqk6wOZtpcWFldes5t/qdOJ06+MZ5LSPHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496637; c=relaxed/simple;
	bh=3/XCrhz7KbgP0TEDI6E8U2HpspwixXYausjnNrIWbIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmHmuFU6OhrjKwfoCzup9b5upUHU2vvLjRWjwqF6yB6ndxB/R06MdSTtufmZ5kidxOde3QHeYxbJmaOvGQIxZQDYfIIRwe7h+aN4sjlYWLB8+Vj+JbOBWmgRfD1ZmAvp73pQR7dYjVTUOnQXqzKnJ5D6339Knsv6pgbp1HLCWco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKi7/e7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKi7/e7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B749C4CED1;
	Fri,  6 Dec 2024 14:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496636;
	bh=3/XCrhz7KbgP0TEDI6E8U2HpspwixXYausjnNrIWbIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKi7/e7sNZEdKAuJ3/Q5aI+MJzGlXR5ctWbUxu1y7g+GUR3L2ndUaaLoXb6RSAI9Y
	 NA3B3WEThCEmaKhpDtsYJ1XOI3kuNjW8bLOULvR7ZS+brgKLbPMkiLGUUFusbI2fiv
	 6ONVzq/g6WSkLBV9zxTr7rQpscNoCoZ95Uh/SaDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/676] m68k: mvme147: Fix SCSI controller IRQ numbers
Date: Fri,  6 Dec 2024 15:28:00 +0100
Message-ID: <20241206143655.746761885@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Palmer <daniel@0x0f.com>

[ Upstream commit 47bc874427382018fa2e3e982480e156271eee70 ]

Sometime long ago the m68k IRQ code was refactored and the interrupt
numbers for SCSI controller on this board ended up wrong, and it hasn't
worked since.

The PCC adds 0x40 to the vector for its interrupts so they end up in
the user interrupt range. Hence, the kernel number should be the kernel
offset for user interrupt range + the PCC interrupt number.

Fixes: 200a3d352cd5 ("[PATCH] m68k: convert VME irq code")
Signed-off-by: Daniel Palmer <daniel@0x0f.com>
Reviewed-by: Finn Thain <fthain@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/0e7636a21a0274eea35bfd5d874459d5078e97cc.1727926187.git.fthain@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/mvme147hw.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/include/asm/mvme147hw.h b/arch/m68k/include/asm/mvme147hw.h
index e28eb1c0e0bfb..dbf88059e47a4 100644
--- a/arch/m68k/include/asm/mvme147hw.h
+++ b/arch/m68k/include/asm/mvme147hw.h
@@ -93,8 +93,8 @@ struct pcc_regs {
 #define M147_SCC_B_ADDR		0xfffe3000
 #define M147_SCC_PCLK		5000000
 
-#define MVME147_IRQ_SCSI_PORT	(IRQ_USER+0x45)
-#define MVME147_IRQ_SCSI_DMA	(IRQ_USER+0x46)
+#define MVME147_IRQ_SCSI_PORT	(IRQ_USER + 5)
+#define MVME147_IRQ_SCSI_DMA	(IRQ_USER + 6)
 
 /* SCC interrupts, for MVME147 */
 
-- 
2.43.0



