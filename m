Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C1D26988E;
	Tue,  8 Apr 2025 12:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114194; cv=none; b=hbkRIErIvtLwLIk0FDouLgIGS3GtBmmKSWaOtverIbsa1fVpoCCDK9/2n1KvqtL7Y5/NoQySskwvvKYqMwPzjoDwqJ3msxtHB+Konzy8QPwD9tnyPTS4Brw+Odz8GSHV1+zOJ7H+2GPe6dgYuloPFUTB+YotpNt6aWLD1WFCHRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114194; c=relaxed/simple;
	bh=lwNa2bvvPXAURct3BstxR+lviHfKyoDlukV85mSOk1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtZEC62qu11DbXXW5uDzBHGuvYLU64w8wY+iur3HFVte99rlQri+IJ4XxMV6fmOtr2JALUMWZe5ZRo1Yon9jVmvff2JAzALC1JeM4RN7MYjqZjVACHAS7gTKB4+/F/xO8acsThV9Syqv6QIH6RzBoiFYjGM/jj7eNF/lKy4I2KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUksRCie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUksRCie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0ADC4CEEA;
	Tue,  8 Apr 2025 12:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114194;
	bh=lwNa2bvvPXAURct3BstxR+lviHfKyoDlukV85mSOk1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUksRCie10EdUPOwBXbE+AgdWW4IDX6nj+EHVZvorcGGbk3qAMRxBtkKKJLr3ZgJs
	 lak3o8EZmHv1NpA9iEpNlzGt+08cHGrtESg1VDjBz+83WyMIjHrxNSipJZqeUtdws/
	 SHbGhzP+/jgdnd255w+LV5P1ou5VOFagYPVDerRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Loughlin <kevinloughlin@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 017/499] x86/sev: Add missing RIP_REL_REF() invocations during sme_enable()
Date: Tue,  8 Apr 2025 12:43:49 +0200
Message-ID: <20250408104851.684109129@linuxfoundation.org>
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

From: Kevin Loughlin <kevinloughlin@google.com>

[ Upstream commit 72dafb567760320f2de7447cd6e979bf9d4e5d17 ]

The following commit:

  1c811d403afd ("x86/sev: Fix position dependent variable references in startup code")

introduced RIP_REL_REF() to force RIP-relative accesses to global variables,
as needed to prevent crashes during early SEV/SME startup code.

For completeness, RIP_REL_REF() should be used with additional variables during
sme_enable():

  https://lore.kernel.org/all/CAMj1kXHnA0fJu6zh634=fbJswp59kSRAbhW+ubDGj1+NYwZJ-Q@mail.gmail.com/

Access these vars with RIP_REL_REF() to prevent problem reoccurence.

Fixes: 1c811d403afd ("x86/sev: Fix position dependent variable references in startup code")
Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/r/20241122202322.977678-1-kevinloughlin@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/mem_encrypt_identity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index e6c7686f443a0..9fce5b87b8c50 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -565,7 +565,7 @@ void __head sme_enable(struct boot_params *bp)
 	}
 
 	RIP_REL_REF(sme_me_mask) = me_mask;
-	physical_mask &= ~me_mask;
-	cc_vendor = CC_VENDOR_AMD;
+	RIP_REL_REF(physical_mask) &= ~me_mask;
+	RIP_REL_REF(cc_vendor) = CC_VENDOR_AMD;
 	cc_set_mask(me_mask);
 }
-- 
2.39.5



