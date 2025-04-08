Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4504C26B089;
	Tue,  8 Apr 2025 12:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116092; cv=none; b=B01LwNX7xvmwy1IaIuW6f0Vqgt48EtlMhMmqoQa/bDzCR4+JUw19UVW28PBIV+x4K+BZBiB9nNDfVX+mqlzc2Q8Jys8DR2tztYVu42kCOYy7WaQpZUK0ROzcIJUSBRlkIeHfSPskgZovyXF6DXpoOZYPbp470Ii4iaa8ndIEihQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116092; c=relaxed/simple;
	bh=fm0xxESJiCSNXHUAF6zMQFjZV3uF/+fe10WWcCsJMMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBnqIP04gIo7QDcV0zGzSjXSHV42RmE/IkF+dnPLShjEW1GNnayTSKqFcZI93ZFhVSD+QhrMbsFsoHDbiTyEgGsHe+UjIdY1QOKrv+X7DKPemBDZeZaM5TeT1n3tvj0rUAAILvcQ4JDLSReoOKYffp2ADcd7vm6moIMyO8X2oO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7hjT9R6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7hjT9R6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2774C4CEE5;
	Tue,  8 Apr 2025 12:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116092;
	bh=fm0xxESJiCSNXHUAF6zMQFjZV3uF/+fe10WWcCsJMMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7hjT9R6tx4F3iBLVAQaW3QJsZ144dL4t0cB+dlqknPPw1ydOTjnYdPr0AWJLHyZC
	 9Tvg8r02jIw59WDm8txALjzDovZ22qiGAGdb19u4ay5Ls7UDPtp4oJQz1bng7td2D+
	 MELzsRj1VRMzwUNkgWf2kXHoAYxVrzILgrk68vK4=
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
Subject: [PATCH 6.12 013/423] x86/sev: Add missing RIP_REL_REF() invocations during sme_enable()
Date: Tue,  8 Apr 2025 12:45:39 +0200
Message-ID: <20250408104846.036165251@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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
index ac33b2263a434..b922b9fea6b64 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -562,7 +562,7 @@ void __head sme_enable(struct boot_params *bp)
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



