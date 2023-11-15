Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006133A8F4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djoGbKFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A651CC433C7;
	Wed, 15 Nov 2023 19:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077945;
	bh=j0VGvbK+o+/o1RtSWGn3tYocUkhxf6Fn+lHIfwLEayg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djoGbKFcv2tzsLY7B/BIFsbj4grD8lV/5ssGNtNdLP1eT6SJ9u9j2njJJ2fadps/o
	 qIg0+ZCRvWtwm3EH8yQSeW+hc9Ww/jX4gx7+ljrOqx56PQs9Nv17Hb8+sKpq0jIroL
	 HeKinMe1ADCbenO9AvTU3RIaMoZQ9tr2mW2cCGgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Adam Dunlap <acdunlap@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jacob Xu <jacobhxu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/379] x86/sev-es: Allow copy_from_kernel_nofault() in earlier boot
Date: Wed, 15 Nov 2023 14:21:29 -0500
Message-ID: <20231115192646.004758661@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Dunlap <acdunlap@google.com>

[ Upstream commit f79936545fb122856bd78b189d3c7ee59928c751 ]

Previously, if copy_from_kernel_nofault() was called before
boot_cpu_data.x86_virt_bits was set up, then it would trigger undefined
behavior due to a shift by 64.

This ended up causing boot failures in the latest version of ubuntu2204
in the gcp project when using SEV-SNP.

Specifically, this function is called during an early #VC handler which
is triggered by a CPUID to check if NX is implemented.

Fixes: 1aa9aa8ee517 ("x86/sev-es: Setup GHCB-based boot #VC handler")
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Adam Dunlap <acdunlap@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Jacob Xu <jacobhxu@google.com>
Link: https://lore.kernel.org/r/20230912002703.3924521-2-acdunlap@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/maccess.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/maccess.c b/arch/x86/mm/maccess.c
index 5a53c2cc169cc..6993f026adec9 100644
--- a/arch/x86/mm/maccess.c
+++ b/arch/x86/mm/maccess.c
@@ -9,12 +9,21 @@ bool copy_from_kernel_nofault_allowed(const void *unsafe_src, size_t size)
 	unsigned long vaddr = (unsigned long)unsafe_src;
 
 	/*
-	 * Range covering the highest possible canonical userspace address
-	 * as well as non-canonical address range. For the canonical range
-	 * we also need to include the userspace guard page.
+	 * Do not allow userspace addresses.  This disallows
+	 * normal userspace and the userspace guard page:
 	 */
-	return vaddr >= TASK_SIZE_MAX + PAGE_SIZE &&
-	       __is_canonical_address(vaddr, boot_cpu_data.x86_virt_bits);
+	if (vaddr < TASK_SIZE_MAX + PAGE_SIZE)
+		return false;
+
+	/*
+	 * Allow everything during early boot before 'x86_virt_bits'
+	 * is initialized.  Needed for instruction decoding in early
+	 * exception handlers.
+	 */
+	if (!boot_cpu_data.x86_virt_bits)
+		return true;
+
+	return __is_canonical_address(vaddr, boot_cpu_data.x86_virt_bits);
 }
 #else
 bool copy_from_kernel_nofault_allowed(const void *unsafe_src, size_t size)
-- 
2.42.0



