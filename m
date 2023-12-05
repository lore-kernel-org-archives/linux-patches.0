Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395416110;
	Tue,  5 Dec 2023 03:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6rz2l27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709AFC433C7;
	Tue,  5 Dec 2023 03:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746751;
	bh=YfhqTc/8qe+XBrebp05O5/yFvqA+1pU8BQu5NUL6Pj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6rz2l273EfT9aDEp5JtxDSZIZa2itKsqYH1lscv3JMu5+UR/ALUWaisH6K3pKGk7
	 iPY4+Nm410EJlR9tyRJ5SyDfLIDuxERYxbrJ5rBBv3+GNFCDsXYR0Jou1uhISz2Qzn
	 s1X1Mn+L05PDjj5rUADhp22OxpM7LUfNTS/aVZH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sean Christopherson <seanjc@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/134] vfio: Drop vfio_file_iommu_group() stub to fudge around a KVM wart
Date: Tue,  5 Dec 2023 12:16:46 +0900
Message-ID: <20231205031543.944552356@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 4ea95c04fa6b9043a1a301240996aeebe3cb28ec ]

Drop the vfio_file_iommu_group() stub and instead unconditionally declare
the function to fudge around a KVM wart where KVM tries to do symbol_get()
on vfio_file_iommu_group() (and other VFIO symbols) even if CONFIG_VFIO=n.

Ensuring the symbol is always declared fixes a PPC build error when
modules are also disabled, in which case symbol_get() simply points at the
address of the symbol (with some attributes shenanigans).  Because KVM
does symbol_get() instead of directly depending on VFIO, the lack of a
fully defined symbol is not problematic (ugly, but "fine").

   arch/powerpc/kvm/../../../virt/kvm/vfio.c:89:7:
   error: attribute declaration must precede definition [-Werror,-Wignored-attributes]
           fn = symbol_get(vfio_file_iommu_group);
                ^
   include/linux/module.h:805:60: note: expanded from macro 'symbol_get'
   #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak,visibility("hidden"))); &(x); })
                                                              ^
   include/linux/vfio.h:294:35: note: previous definition is here
   static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
                                     ^
   arch/powerpc/kvm/../../../virt/kvm/vfio.c:89:7:
   error: attribute declaration must precede definition [-Werror,-Wignored-attributes]
           fn = symbol_get(vfio_file_iommu_group);
                ^
   include/linux/module.h:805:65: note: expanded from macro 'symbol_get'
   #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak,visibility("hidden"))); &(x); })
                                                                   ^
   include/linux/vfio.h:294:35: note: previous definition is here
   static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
                                     ^
   2 errors generated.

Although KVM is firmly in the wrong (there is zero reason for KVM to build
virt/kvm/vfio.c when VFIO is disabled), fudge around the error in VFIO as
the stub is unnecessary and doesn't serve its intended purpose (KVM is the
only external user of vfio_file_iommu_group()), and there is an in-flight
series to clean up the entire KVM<->VFIO interaction, i.e. fixing this in
KVM would result in more churn in the long run, and the stub needs to go
away regardless.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202308251949.5IiaV0sz-lkp@intel.com
Closes: https://lore.kernel.org/oe-kbuild-all/202309030741.82aLACDG-lkp@intel.com
Closes: https://lore.kernel.org/oe-kbuild-all/202309110914.QLH0LU6L-lkp@intel.com
Link: https://lore.kernel.org/all/0-v1-08396538817d+13c5-vfio_kvm_kconfig_jgg@nvidia.com
Link: https://lore.kernel.org/all/20230916003118.2540661-1-seanjc@google.com
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Fixes: c1cce6d079b8 ("vfio: Compile vfio_group infrastructure optionally")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20231130001000.543240-1-seanjc@google.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/vfio.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 454e9295970c4..a65b2513f8cdc 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -289,16 +289,12 @@ void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
 /*
  * External user API
  */
-#if IS_ENABLED(CONFIG_VFIO_GROUP)
 struct iommu_group *vfio_file_iommu_group(struct file *file);
+
+#if IS_ENABLED(CONFIG_VFIO_GROUP)
 bool vfio_file_is_group(struct file *file);
 bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
 #else
-static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
-{
-	return NULL;
-}
-
 static inline bool vfio_file_is_group(struct file *file)
 {
 	return false;
-- 
2.42.0



