Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC53E4776F;
	Mon,  1 Apr 2024 16:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987820; cv=none; b=G3W7GW6vPgbsUwvBDFV+qdcPgre2IJMYAgzLoWE07xjODUAVIi03qSF8+ocK51WSt8aX+O3FLsx0wTxuBWPKe9pGhU+VNqVh2hRJ7FyFMaImj04M55Vn+d3D9dvqyBdA1m2cD950D+XKMe5qGYmiNfYIvNiKnTsYYGEDRmylNqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987820; c=relaxed/simple;
	bh=tU5UjjQjdF4HWRUMp/Wkp3INbrURdKd0sjulyajjZe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4w7jKifSjLNdYRXe76MYedczrWlWA9/aQbozw0E0OWRPMgULZXOXMcpuBu/726nLCFDD8V9/5bZuSWMpCM4xMT7QM5kF9GD6PI4IopvbMzHIfVzbv8AKb3vmMVlmeAOO2hpf4pzR8+h+p7n+PIcx2SXG51N2pYrXTNvop/fR5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHUrCI+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHUrCI+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A16AC433F1;
	Mon,  1 Apr 2024 16:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987820;
	bh=tU5UjjQjdF4HWRUMp/Wkp3INbrURdKd0sjulyajjZe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHUrCI+vntwgBUPnPIZQJ8+5ROAv5o1rMmO7mN0kwFd6qvbgOASVvZJpWDLcos3bI
	 JiXh2GQkgiemHPitfPl7NkxOdLJ+8H9+3xxd1MifzgquCTJQM4PeB0Vu82FtJvtrRZ
	 caH9Zr3ZP0tZ93TansvSA7FF20J87FMYJ5ABFnnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.8 390/399] x86/bugs: Use fixed addressing for VERW operand
Date: Mon,  1 Apr 2024 17:45:56 +0200
Message-ID: <20240401152600.811703716@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 8009479ee919b9a91674f48050ccbff64eafedaa upstream.

The macro used for MDS mitigation executes VERW with relative
addressing for the operand. This was necessary in earlier versions of
the series. Now it is unnecessary and creates a problem for backports
on older kernels that don't support relocations in alternatives.
Relocation support was added by commit 270a69c4485d ("x86/alternative:
Support relocations in alternatives").  Also asm for fixed addressing
is much cleaner than relative RIP addressing.

Simplify the asm by using fixed addressing for VERW operand.

[ dhansen: tweak changelog ]

Closes: https://lore.kernel.org/lkml/20558f89-299b-472e-9a96-171403a83bd6@suse.com/
Fixes: baf8361e5455 ("x86/bugs: Add asm helpers for executing VERW")
Reported-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20240226-verw-arg-fix-v1-1-7b37ee6fd57d%40linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -332,7 +332,7 @@
  * Note: Only the memory operand variant of VERW clears the CPU buffers.
  */
 .macro CLEAR_CPU_BUFFERS
-	ALTERNATIVE "", __stringify(verw _ASM_RIP(mds_verw_sel)), X86_FEATURE_CLEAR_CPU_BUF
+	ALTERNATIVE "", __stringify(verw mds_verw_sel), X86_FEATURE_CLEAR_CPU_BUF
 .endm
 
 #else /* __ASSEMBLY__ */


