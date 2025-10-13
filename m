Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F70F30BF6A;
	Mon, 13 Oct 2025 15:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367787; cv=none; b=dT2KtqhKVv1fp9eDX5OzQvCiqRap1ONuX46MlWHsWO7ABtB6FgChaxYS3atfWa300fhPBi5fqAzW5D0gKl3bvir+sBX5Gm52zMK9G26099bzeLBpyMauDJ9LJytcj5eIi92qd+XJLft+W4J9sErCeTLW/uyfWAP/oEIwonlW4ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367787; c=relaxed/simple;
	bh=Bysf+n9wa5oTKKDL+eObHE+LrPKKcnuOCXQGy2rhTIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFnq0LdCjbgIwnkAUdIBA0r+NXrU172Knv5NazY73SaXtmQIytK+H5o8UB8ocsMBYAbjItdHAsTGxr97hopR1R5dvO/C0R2wSLF2MIIGc75uvPPPO/7pn/VF1PKT/mPqkvJh+racHgnwhQWrSc7i+lJDzBTR8htKnENkB7lQRwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EaQkM3E/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EaQkM3E/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842FCC116D0;
	Mon, 13 Oct 2025 15:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367786;
	bh=Bysf+n9wa5oTKKDL+eObHE+LrPKKcnuOCXQGy2rhTIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EaQkM3E/tdYlONOgx0tnyfzqrr9JY5rnQfZOiR9aGMDlsSgElA+yEPxCxNq/oVzkf
	 8xEdxQUBFR8KdsKJcfNZm1dyYVkWOTzo56Ic20RKyfqOy4hCuETCbjEoeh+M4fQnii
	 3rndNlaNpQxCKlmWEAstKGCaXCHKu1DUrZ2eQNVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Subject: [PATCH 6.6 132/196] sparc: fix accurate exception reporting in copy_to_user for Niagara 4
Date: Mon, 13 Oct 2025 16:45:23 +0200
Message-ID: <20251013144320.087632801@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>

[ Upstream commit 5a746c1a2c7980de6c888b6373299f751ad7790b ]

The referenced commit introduced exception handlers on user-space memory
references in copy_from_user and copy_to_user. These handlers return from
the respective function and calculate the remaining bytes left to copy
using the current register contents. This commit fixes a bad calculation.
This will fix the return value of copy_to_user in a specific faulting case.
The behaviour of memcpy stays unchanged.

Fixes: 957077048009 ("sparc64: Convert NG4copy_{from,to}_user to accurate exception reporting.")
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de> # on Oracle SPARC T4-1
Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20250905-memcpy_series-v4-4-1ca72dda195b@mkarcher.dialup.fu-berlin.de
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/lib/NG4memcpy.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/lib/NG4memcpy.S b/arch/sparc/lib/NG4memcpy.S
index 7ad58ebe0d009..df0ec1bd19489 100644
--- a/arch/sparc/lib/NG4memcpy.S
+++ b/arch/sparc/lib/NG4memcpy.S
@@ -281,7 +281,7 @@ FUNC_NAME:	/* %o0=dst, %o1=src, %o2=len */
 	subcc		%o5, 0x20, %o5
 	EX_ST(STORE(stx, %g1, %o0 + 0x00), memcpy_retl_o2_plus_o5_plus_32)
 	EX_ST(STORE(stx, %g2, %o0 + 0x08), memcpy_retl_o2_plus_o5_plus_24)
-	EX_ST(STORE(stx, GLOBAL_SPARE, %o0 + 0x10), memcpy_retl_o2_plus_o5_plus_24)
+	EX_ST(STORE(stx, GLOBAL_SPARE, %o0 + 0x10), memcpy_retl_o2_plus_o5_plus_16)
 	EX_ST(STORE(stx, %o4, %o0 + 0x18), memcpy_retl_o2_plus_o5_plus_8)
 	bne,pt		%icc, 1b
 	 add		%o0, 0x20, %o0
-- 
2.51.0



