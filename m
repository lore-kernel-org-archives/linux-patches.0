Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E9118DF9D;
	Tue, 26 Aug 2025 11:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208555; cv=none; b=cIRR3p01fHlfi47xb08SypAFl7L/l04ANsCiIWCJy5FUJv8tXbscu9JNsV/7xYG4F4U4mCdO6kyBPCb/EQ+Y/ug1j0G7a127OdrcaCH6iTXSZjJ3c6NRO6aeewYJ2fkphf/H3tRJWj97/QL3pGOSiarBERqEr2ElLyKeOZpd2MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208555; c=relaxed/simple;
	bh=ld61A2SoNqmX+xGjsbmn3iJ8hz6AHEGCNe/cqaiGaG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MF0TnCUji2Xn9yLY8MwDyKCJ+SmIe0xAYWmK2lTzWebUm5RjqSARJ9T08ixujCrW8vXc//g92DPpoEV+4Jhiy9XTSjyX6JSEsxZOL/v1Vp1ZTeG3Fm+XusWAqDAcIhvXetdIZb5ysju3OZN7g33q6I7dENxSdS++SQ9QkyguOyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPhH4FpS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPhH4FpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637D7C4CEF1;
	Tue, 26 Aug 2025 11:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208555;
	bh=ld61A2SoNqmX+xGjsbmn3iJ8hz6AHEGCNe/cqaiGaG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rPhH4FpSsYc6AgYNlmBVDU+nqMU2El0xoJTeJKNdb22m+LTWn7PM7XdT/sPnRKkW4
	 rgIOfgVAUQGLUXjvRmcvFr0WUXsfoJV95KbKI1QsC16ShA38z1aVADWlvMsPelsjWv
	 wvZuABF3yG63Af1moGfrjfrNjsF2406MT9nUT1dA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Joerg Roedel <joerg.roedel@amd.com>,
	stable@kernel.org
Subject: [PATCH 6.12 139/322] x86/sev: Ensure SVSM reserved fields in a page validation entry are initialized to zero
Date: Tue, 26 Aug 2025 13:09:14 +0200
Message-ID: <20250826110919.236991859@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Lendacky <thomas.lendacky@amd.com>

commit 3ee9cebd0a5e7ea47eb35cec95eaa1a866af982d upstream.

In order to support future versions of the SVSM_CORE_PVALIDATE call, all
reserved fields within a PVALIDATE entry must be set to zero as an SVSM should
be ensuring all reserved fields are zero in order to support future usage of
reserved areas based on the protocol version.

Fixes: fcd042e86422 ("x86/sev: Perform PVALIDATE using the SVSM when not at VMPL0")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/7cde412f8b057ea13a646fb166b1ca023f6a5031.1755098819.git.thomas.lendacky@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/sev/shared.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/coco/sev/shared.c
+++ b/arch/x86/coco/sev/shared.c
@@ -1285,6 +1285,7 @@ static void svsm_pval_4k_page(unsigned l
 	pc->entry[0].page_size = RMP_PG_SIZE_4K;
 	pc->entry[0].action    = validate;
 	pc->entry[0].ignore_cf = 0;
+	pc->entry[0].rsvd      = 0;
 	pc->entry[0].pfn       = paddr >> PAGE_SHIFT;
 
 	/* Protocol 0, Call ID 1 */
@@ -1373,6 +1374,7 @@ static u64 svsm_build_ca_from_pfn_range(
 		pe->page_size = RMP_PG_SIZE_4K;
 		pe->action    = action;
 		pe->ignore_cf = 0;
+		pe->rsvd      = 0;
 		pe->pfn       = pfn;
 
 		pe++;
@@ -1403,6 +1405,7 @@ static int svsm_build_ca_from_psc_desc(s
 		pe->page_size = e->pagesize ? RMP_PG_SIZE_2M : RMP_PG_SIZE_4K;
 		pe->action    = e->operation == SNP_PAGE_STATE_PRIVATE;
 		pe->ignore_cf = 0;
+		pe->rsvd      = 0;
 		pe->pfn       = e->gfn;
 
 		pe++;


