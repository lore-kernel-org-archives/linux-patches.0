Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6862E155C81;
	Mon, 27 May 2024 19:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837566; cv=none; b=shHrJe2qUoVCaR3lxVcqz6847hDkkXqVkT/1/34XmGu2VkFFWyG3DkmC9Bayo06SUr01exV++vhMBnkRux4Ad88g3yuX6x3yH9JKqntUzk37aGh4A8MaumkpmmiHdoNDXUENIUUN9n47Za42ry760zbmaPRsU1U8ffE4YYshj5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837566; c=relaxed/simple;
	bh=cvV8bWzgtlq9rUk4n2TooPdK23frjRd8BRMmacPFV2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VkFuzqsvkoZgd0y3u2KFWAf0gOvbIJ0efZ9yYmiJMArWcqy3huy/RH8X4bK5m9icnoShRKTIjB2Z1VwBiQtxaKdQA+5Cg/4oCEVrD+1pjjgEQnIweIGQNW3cKIR/Iy9YrKschN+LRnwiCOnkSpKkUbtK2p+hbqT7sdYjiZsyHcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkOxS1TH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkOxS1TH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA89C2BBFC;
	Mon, 27 May 2024 19:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837566;
	bh=cvV8bWzgtlq9rUk4n2TooPdK23frjRd8BRMmacPFV2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkOxS1THzPnx1Qi8qa2Vre7QmTJObleNGyR7YtnHQCmmTTfqCmpX7QB74JFDkZxo/
	 1Qcgg/wKOzwQaKPDmelhsutCTUU4asGwo71kTAvbgVNROb07EnjyWXEOsHiJu4plp4
	 2MYUifKa56B8tOldQtSGXEGWbIY7s8SRfoJMSscA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	=?UTF-8?q?Christoph=20M=C3=BCllner?= <christoph.muellner@vrull.eu>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 060/493] riscv: T-Head: Test availability bit before enabling MAE errata
Date: Mon, 27 May 2024 20:51:02 +0200
Message-ID: <20240527185631.450864324@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Müllner <christoph.muellner@vrull.eu>

[ Upstream commit 65b71cc35cc6631cb0a5b24f961fe64c085cb40b ]

T-Head's memory attribute extension (XTheadMae) (non-compatible
equivalent of RVI's Svpbmt) is currently assumed for all T-Head harts.
However, QEMU recently decided to drop acceptance of guests that write
reserved bits in PTEs.
As XTheadMae uses reserved bits in PTEs and Linux applies the MAE errata
for all T-Head harts, this broke the Linux startup on QEMU emulations
of the C906 emulation.

This patch attempts to address this issue by testing the MAE-enable bit
in the th.sxstatus CSR. This CSR is available in HW and can be
emulated in QEMU.

This patch also makes the XTheadMae probing mechanism reliable, because
a test for the right combination of mvendorid, marchid, and mimpid
is not sufficient to enable MAE.

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Christoph Müllner <christoph.muellner@vrull.eu>
Link: https://lore.kernel.org/r/20240407213236.2121592-3-christoph.muellner@vrull.eu
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/errata/thead/errata.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/errata/thead/errata.c b/arch/riscv/errata/thead/errata.c
index 6e7ee1f16bee3..bf6a0a6318ee3 100644
--- a/arch/riscv/errata/thead/errata.c
+++ b/arch/riscv/errata/thead/errata.c
@@ -19,6 +19,9 @@
 #include <asm/patch.h>
 #include <asm/vendorid_list.h>
 
+#define CSR_TH_SXSTATUS		0x5c0
+#define SXSTATUS_MAEE		_AC(0x200000, UL)
+
 static bool errata_probe_mae(unsigned int stage,
 			     unsigned long arch_id, unsigned long impid)
 {
@@ -28,11 +31,14 @@ static bool errata_probe_mae(unsigned int stage,
 	if (arch_id != 0 || impid != 0)
 		return false;
 
-	if (stage == RISCV_ALTERNATIVES_EARLY_BOOT ||
-	    stage == RISCV_ALTERNATIVES_MODULE)
-		return true;
+	if (stage != RISCV_ALTERNATIVES_EARLY_BOOT &&
+	    stage != RISCV_ALTERNATIVES_MODULE)
+		return false;
 
-	return false;
+	if (!(csr_read(CSR_TH_SXSTATUS) & SXSTATUS_MAEE))
+		return false;
+
+	return true;
 }
 
 /*
-- 
2.43.0



