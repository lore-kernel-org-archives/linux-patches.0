Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89703A59;
	Tue,  5 Dec 2023 03:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGCGkKmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0515EC433C7;
	Tue,  5 Dec 2023 03:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746748;
	bh=w6ZTjOJPTZQXuoAWwyMtc/znKfNcGC1p6oeGUvZK6ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qGCGkKmIvbeF/cFXL5KSC+CfuHdJZLaAtxex5eDa4yfUJWzpNi5VSiftUIR+sBM8W
	 /E/oXVW9R0TT40I9KD/G9oOOzwjsvSZge7JlaYpWf6IRf2NlOVst/WJeBUDvRM+DOS
	 ZRb800CvUyzA3Z80w33Rzs0f64AbygCc7KST0VoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.con>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/134] x86/xen: fix percpu vcpu_info allocation
Date: Tue,  5 Dec 2023 12:16:45 +0900
Message-ID: <20231205031543.874411485@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit db2832309a82b9acc4b8cc33a1831d36507ec13e ]

Today the percpu struct vcpu_info is allocated via DEFINE_PER_CPU(),
meaning that it could cross a page boundary. In this case registering
it with the hypervisor will fail, resulting in a panic().

This can easily be fixed by using DEFINE_PER_CPU_ALIGNED() instead,
as struct vcpu_info is guaranteed to have a size of 64 bytes, matching
the cache line size of x86 64-bit processors (Xen doesn't support
32-bit processors).

Fixes: 5ead97c84fa7 ("xen: Core Xen implementation")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.con>
Link: https://lore.kernel.org/r/20231124074852.25161-1-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/enlighten.c | 6 +++++-
 arch/x86/xen/xen-ops.h   | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 0337392a31214..3c61bb98c10e2 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -33,9 +33,12 @@ EXPORT_SYMBOL_GPL(hypercall_page);
  * and xen_vcpu_setup for details. By default it points to share_info->vcpu_info
  * but during boot it is switched to point to xen_vcpu_info.
  * The pointer is used in xen_evtchn_do_upcall to acknowledge pending events.
+ * Make sure that xen_vcpu_info doesn't cross a page boundary by making it
+ * cache-line aligned (the struct is guaranteed to have a size of 64 bytes,
+ * which matches the cache line size of 64-bit x86 processors).
  */
 DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
-DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
+DEFINE_PER_CPU_ALIGNED(struct vcpu_info, xen_vcpu_info);
 
 /* Linux <-> Xen vCPU id mapping */
 DEFINE_PER_CPU(uint32_t, xen_vcpu_id);
@@ -160,6 +163,7 @@ void xen_vcpu_setup(int cpu)
 	int err;
 	struct vcpu_info *vcpup;
 
+	BUILD_BUG_ON(sizeof(*vcpup) > SMP_CACHE_BYTES);
 	BUG_ON(HYPERVISOR_shared_info == &xen_dummy_shared_info);
 
 	/*
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 408a2aa66c692..a87ab36889e76 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -21,7 +21,7 @@ extern void *xen_initial_gdt;
 struct trap_info;
 void xen_copy_trap_info(struct trap_info *traps);
 
-DECLARE_PER_CPU(struct vcpu_info, xen_vcpu_info);
+DECLARE_PER_CPU_ALIGNED(struct vcpu_info, xen_vcpu_info);
 DECLARE_PER_CPU(unsigned long, xen_cr3);
 DECLARE_PER_CPU(unsigned long, xen_current_cr3);
 
-- 
2.42.0



