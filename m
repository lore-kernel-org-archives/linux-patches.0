Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD96731DD87;
	Mon, 27 Oct 2025 19:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593272; cv=none; b=i8Lp3lpB2DZilA/3sOZb5EbvUyY3NpFW0ucqeJhjvROvZza04/awzwJKPgbhwA2Bpdyta9KQbb2rRrPc3smyFWjo9DuYvhdQPWWPfsD3A1fjvPbwYKVI4cftwK/VC6STQsajecTF55QjPHL/oMvWADJUnDsKWoeXrkFzLBfFn38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593272; c=relaxed/simple;
	bh=wPWH7H/BuCqdhJxp1oTJ9s8rME0Elj+s/dTW5q08Frg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuHf6UwEmAYBfsCawSAZIf39n8ag4TisqXqFEQDhS9Q4QxfExIcIch6TUjNH/LpjSzLR8UQimsHB8zJ8b2r4a1n4P/MpARCCs4YBBNhC1OCFHiHG0jl8y0UDTRZzjZvq6/RWijT+5WVKWbmx3CUk8qQ6jNcemi83ypiQxF9rdyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERi1wHNi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERi1wHNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41383C4CEF1;
	Mon, 27 Oct 2025 19:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593272;
	bh=wPWH7H/BuCqdhJxp1oTJ9s8rME0Elj+s/dTW5q08Frg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERi1wHNiDKLLelYDlbXTft76MdlzfVGcIluEOCCc+BkZUZyYZDFKxYl9USzPiGiDs
	 hiwnwUvnCdpttlEbpRc6NdVskXRXQLeoR5vzhErmudAyw4TpnXcwrKXfNrkIDUkMOv
	 gMqFzs/uRpHvdzzBsZVzq72DMnlUFMl1G37moAno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.17 080/184] riscv: cpufeature: avoid uninitialized variable in has_thead_homogeneous_vlenb()
Date: Mon, 27 Oct 2025 19:36:02 +0100
Message-ID: <20251027183517.056089634@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Walmsley <pjw@kernel.org>

commit 2dc99ea2727640b2fe12f9aa0e38ea2fc3cbb92d upstream.

In has_thead_homogeneous_vlenb(), smatch detected that the vlenb variable
could be used while uninitialized.  It appears that this could happen if
no CPUs described in DT have the "thead,vlenb" property.

Fix by initializing vlenb to 0, which will keep thead_vlenb_of set to 0
(as it was statically initialized).  This in turn will cause
riscv_v_setup_vsize() to fall back to CSR probing - the desired result if
thead,vlenb isn't provided in the DT data.

While here, fix a nearby comment typo.

Cc: stable@vger.kernel.org
Cc: Charlie Jenkins <charlie@rivosinc.com>
Fixes: 377be47f90e41 ("riscv: vector: Use vlenb from DT for thead")
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Link: https://lore.kernel.org/r/22674afb-2fe8-2a83-1818-4c37bd554579@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/cpufeature.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -932,9 +932,9 @@ static int has_thead_homogeneous_vlenb(v
 {
 	int cpu;
 	u32 prev_vlenb = 0;
-	u32 vlenb;
+	u32 vlenb = 0;
 
-	/* Ignore thead,vlenb property if xtheavector is not enabled in the kernel */
+	/* Ignore thead,vlenb property if xtheadvector is not enabled in the kernel */
 	if (!IS_ENABLED(CONFIG_RISCV_ISA_XTHEADVECTOR))
 		return 0;
 


