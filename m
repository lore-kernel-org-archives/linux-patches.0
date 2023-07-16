Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E599A8F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15895C433C9;
	Sun, 16 Jul 2023 19:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537496;
	bh=9J53e3s1SoXI3z73Kc/TIi4bfGnh+1pgYecTykMruaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQ/V3KCvfKIw1ARXbbTepXfkWGW7xZYTnvo9pTaqzOZsrUzfOh1qt71LPwPSMKNSo
	 +HqccmX/bA+OAhc3gxAzxQTMiZ51QF4Gx/OE2wZy3PvsC/Lfarlf4hhpBXLQ6Xka4U
	 +o2rJjCYAnlY+IikvdazrORBvnbKtNO7lDt9Hqkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Michael Kelley <mikelley@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 089/800] x86/hyperv: Set MTRR state when running as SEV-SNP Hyper-V guest
Date: Sun, 16 Jul 2023 21:39:02 +0200
Message-ID: <20230716194951.176484676@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Juergen Gross <jgross@suse.com>

[ Upstream commit c957f1f3c498bcce85c04e92e60afbae1fd10cde ]

In order to avoid mappings using the UC- cache attribute, set the
MTRR state to use WB caching as the default.

This is needed in order to cope with the fact that PAT is enabled,
while MTRRs are not supported by the hypervisor.

Fixes: 90b926e68f50 ("x86/pat: Fix pat_x_mtrr_type() for MTRR disabled case")
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20230502120931.20719-5-jgross@suse.com
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/ivm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index cc92388b7a999..6f7c1b5606ad4 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -17,6 +17,7 @@
 #include <asm/mem_encrypt.h>
 #include <asm/mshyperv.h>
 #include <asm/hypervisor.h>
+#include <asm/mtrr.h>
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 
@@ -372,6 +373,9 @@ void __init hv_vtom_init(void)
 	x86_platform.guest.enc_cache_flush_required = hv_vtom_cache_flush_required;
 	x86_platform.guest.enc_tlb_flush_required = hv_vtom_tlb_flush_required;
 	x86_platform.guest.enc_status_change_finish = hv_vtom_set_host_visibility;
+
+	/* Set WB as the default cache mode. */
+	mtrr_overwrite_state(NULL, 0, MTRR_TYPE_WRBACK);
 }
 
 #endif /* CONFIG_AMD_MEM_ENCRYPT */
-- 
2.39.2



