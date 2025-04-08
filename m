Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE61265CD3;
	Tue,  8 Apr 2025 12:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114421; cv=none; b=jb7QNrQeBUyxdGjaAscClPq9A2IdB1f4BGQfMXEToh3zdWh+BJRWaYf5mCowXM53+NvkZBowrU+bYgxiHVTxlinpm4FMQEUSRAcHkMv57QbhkLlckK+weFhdLOSXH2Tm4o1quU/wbGCE9FpQEBedR33GuG3dCnQdDL83Ki+sP9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114421; c=relaxed/simple;
	bh=AHQLtpcAK3OJg1gwYowjCvpFtTrg1SMAUJL75SfrMBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C76jSzGzNVuTdBTLbdE7o18OOrBPL8GLpMoz1b7hb7uCcrdCIWSKMqLw/Zwkf23ybSo3GemVVfWiHWYs3PPLXu3QcMp+HMuzvjtWy3a1x4XM/ThjfDjv7n7h7RsORVebF2qiHxgEjvgPegRx7PhiGsK/mUW5B6g1I2FV6sZFbKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sIaz/ctE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sIaz/ctE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CD4C4CEE5;
	Tue,  8 Apr 2025 12:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114421;
	bh=AHQLtpcAK3OJg1gwYowjCvpFtTrg1SMAUJL75SfrMBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sIaz/ctEgx5G6TiO3gb2CY4caCzlmThg8T6JUFpY+kQOxXrC2gfsDKsasUgUMzx/N
	 D8/zYd4JlDYWERJ31I+YNjKHkkWYWNrw5JwO93/+meR7Lkiv25VtpNqDjVk9FZGxN1
	 GfiFXsTMwVnUSSRri/fTjOM9/fRoNjs7hfKvVGlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 101/499] powerpc/kexec: fix physical address calculation in clear_utlb_entry()
Date: Tue,  8 Apr 2025 12:45:13 +0200
Message-ID: <20250408104853.732336767@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 861efb8a48ee8b73ae4e8817509cd4e82fd52bc4 ]

In relocate_32.S, function clear_utlb_entry() goes into real mode. To
do so, it has to calculate the physical address based on the virtual
address. To get the virtual address it uses 'bl' which is problematic
(see commit c974809a26a1 ("powerpc/vdso: Avoid link stack corruption
in __get_datapage()")). In addition, the calculation is done on a
wrong address because 'bl' loads LR with the address of the following
instruction, not the address of the target. So when the target is not
the instruction following the 'bl' instruction, it may lead to
unexpected behaviour.

Fix it by re-writing the code so that is goes via another path which
is based 'bcl 20,31,.+4' which is the right instruction to use for that.

Fixes: 683430200315 ("powerpc/47x: Kernel support for KEXEC")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/dc4f9616fba9c05c5dbf9b4b5480eb1c362adc17.1741256651.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/relocate_32.S | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kexec/relocate_32.S b/arch/powerpc/kexec/relocate_32.S
index 104c9911f4061..dd86e338307d3 100644
--- a/arch/powerpc/kexec/relocate_32.S
+++ b/arch/powerpc/kexec/relocate_32.S
@@ -348,16 +348,13 @@ write_utlb:
 	rlwinm	r10, r24, 0, 22, 27
 
 	cmpwi	r10, PPC47x_TLB0_4K
-	bne	0f
 	li	r10, 0x1000			/* r10 = 4k */
-	ANNOTATE_INTRA_FUNCTION_CALL
-	bl	1f
+	beq	0f
 
-0:
 	/* Defaults to 256M */
 	lis	r10, 0x1000
 
-	bcl	20,31,$+4
+0:	bcl	20,31,$+4
 1:	mflr	r4
 	addi	r4, r4, (2f-1b)			/* virtual address  of 2f */
 
-- 
2.39.5



