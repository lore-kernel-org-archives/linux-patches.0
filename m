Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2625330B2D;
	Thu, 28 May 2026 19:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998228; cv=none; b=jDNiSM77Bi40IVz/2jdElsHKSTvhj/Wzg4c5/mm5/Um2KtrgnNG4NcGZa5g18gX7LZKfIykXTlmSMp7igdWUIKPBX6uBTctfiKJDnIya8owVQskFend5xumZHSqiR/AatwLB6q+Dpbv4qiZls/MgYq1HIsavUb8sI9C1BOdkqlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998228; c=relaxed/simple;
	bh=BiRgfPOBVWnQerJcRkKS+pw6TQTjJHkWK2Kfm+Cthao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjNhDW3uL9VmqAC8Npu07uAXE0pDyuCmeYvIL3HdRNCMKUK5eY1R6HfvFsZxJCXBr0iQtPihuErLDGHpC9xKXbelqmkcR80AlROFkS0+s9zO+42iQtSiKys9ZStHxmNWmGZ8DK2CuwRR3gNZ4AIDRV+ANDuA8oA6OiXeKqFuCr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pC2wy2sq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pC2wy2sq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D03C1F000E9;
	Thu, 28 May 2026 19:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998227;
	bh=uYpPEDV/Ff+fYQB+ChSNDfHvWlQitU1RhPC2euI9+kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pC2wy2sqP+FdJHAuZbbXv2VJg7a5LY/el1eL9cotZx26KfqBfrioKz5KQFhGaQtzg
	 Tuz7ca4nJA/mzT6fmTi6l9NDTkevfNnzig4hqwhiYygpQT2K5RX3b1tnGv2qfCsX8G
	 gAUD+8WxtfzwXZmvliPxksU65vnZ88zBNUoFTFlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7.0 099/461] arm64: probes: Handle probes on hinted conditional branch instructions
Date: Thu, 28 May 2026 21:43:48 +0200
Message-ID: <20260528194649.817283958@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Murzin <vladimir.murzin@arm.com>

commit 2ccd8ff980b50e842481bae71102fa3883fc4377 upstream.

BC.cond instructions introduced by FEAT_HBC cannot be executed
out-of-line, like other branch instructions. However, they can be
simulated in the same way as B.cond instructions.

Extend the B.cond decoder mask to match BC.cond instructions as well,
and handle them using the existing B.cond simulation path.

Fixes: 7f86d128e437 ("arm64: add HWCAP for FEAT_HBC (hinted conditional branches)")
Cc: <stable@vger.kernel.org>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/insn.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -409,7 +409,7 @@ __AARCH64_INSN_FUNCS(cbz,	0x7F000000, 0x
 __AARCH64_INSN_FUNCS(cbnz,	0x7F000000, 0x35000000)
 __AARCH64_INSN_FUNCS(tbz,	0x7F000000, 0x36000000)
 __AARCH64_INSN_FUNCS(tbnz,	0x7F000000, 0x37000000)
-__AARCH64_INSN_FUNCS(bcond,	0xFF000010, 0x54000000)
+__AARCH64_INSN_FUNCS(bcond,	0xFF000000, 0x54000000)
 __AARCH64_INSN_FUNCS(svc,	0xFFE0001F, 0xD4000001)
 __AARCH64_INSN_FUNCS(hvc,	0xFFE0001F, 0xD4000002)
 __AARCH64_INSN_FUNCS(smc,	0xFFE0001F, 0xD4000003)


