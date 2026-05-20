Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0332036A352;
	Wed, 20 May 2026 16:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294699; cv=none; b=P1zzdG+7BlTmL9rnrxoW57ylTJeXi1XmAmF7PYfejkssnhvLDg8tQ0Q+ENOUPVAW2u57RHT3xnHXr/j+qnZrYuBaBukytlytPWUZYcx1DU1Bar7nSQjuDQRefVfc6RW0A3UwT0MW28SncThXOaM+B3UxSRqFhm/8uXYJwmboIms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294699; c=relaxed/simple;
	bh=TRwKEexaDKNNAX3ELrWHqmjZdd2twbS91TsIputCXGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OdAGSfmNMi3Kl1gAOsHwYBgnm8uv2fzuFLHnVVnLBE4my5xSHy8wt6gBbs8RnIY23qJ6/VVVZL7zfDWzoXf+nRFFjkakuLtUsAsWaKjY56eUIA1TllYWnP6tNaLCMM2dlcU1yK0HcvWaIcxII1ITwuzgl0bNsSVyja+RtJY3aeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8z4Y94a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8z4Y94a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB551F00894;
	Wed, 20 May 2026 16:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294697;
	bh=wFLZNB4YAGML7eGv5AHHPljoBiDnCQ4mAzwJQqp9RYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H8z4Y94acGrV08vLse1ttIQtdkV+P4KNpw+YxCPzy4BmaBE7uUz6sn0leDb21tqCF
	 vU7PmIDmGZr6ANeElugjqibS1ztbLMs7nMJAC8VOruMbVGjlzKwm/yx0e/cLjkNRis
	 XgTdEPlbHlupwwe26q67PNLcUBkzObeppib9nebk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Alex Williamson <alex@shazbot.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0139/1146] drivers/vfio_pci_core: Change PXD_ORDER check from switch case to if/else block
Date: Wed, 20 May 2026 18:06:29 +0200
Message-ID: <20260520162151.461152411@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

[ Upstream commit 948b71aa81cd89b222942db6055e8d9c51c54e78 ]

Architectures like PowerPC uses runtime defined values for
PMD_ORDER/PUD_ORDER. This is because it can use either RADIX or HASH MMU
at runtime using kernel cmdline. So the pXd_index_size is not known at
compile time. Without this fix, when we add huge pfn support on powerpc
in the next patch, vfio_pci_core driver compilation can fail with the
following errors.

  CC [M]  drivers/vfio/vfio_main.o
  CC [M]  drivers/vfio/group.o
  CC [M]  drivers/vfio/container.o
  CC [M]  drivers/vfio/virqfd.o
  CC [M]  drivers/vfio/vfio_iommu_spapr_tce.o
  CC [M]  drivers/vfio/pci/vfio_pci_core.o
  CC [M]  drivers/vfio/pci/vfio_pci_intrs.o
  CC [M]  drivers/vfio/pci/vfio_pci_rdwr.o
  CC [M]  drivers/vfio/pci/vfio_pci_config.o
  CC [M]  drivers/vfio/pci/vfio_pci.o
  AR      kernel/built-in.a
../drivers/vfio/pci/vfio_pci_core.c: In function ‘vfio_pci_vmf_insert_pfn’:
../drivers/vfio/pci/vfio_pci_core.c:1678:9: error: case label does not reduce to an integer constant
 1678 |         case PMD_ORDER:
      |         ^~~~
../drivers/vfio/pci/vfio_pci_core.c:1682:9: error: case label does not reduce to an integer constant
 1682 |         case PUD_ORDER:
      |         ^~~~
make[6]: *** [../scripts/Makefile.build:289: drivers/vfio/pci/vfio_pci_core.o] Error 1
make[6]: *** Waiting for unfinished jobs....
make[5]: *** [../scripts/Makefile.build:546: drivers/vfio/pci] Error 2
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [../scripts/Makefile.build:546: drivers/vfio] Error 2
make[3]: *** [../scripts/Makefile.build:546: drivers] Error 2

Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reviewed-by: Alex Williamson <alex@shazbot.org>
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 460852f79f29b..3fea064d00de2 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1670,21 +1670,16 @@ vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
 	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
 		return VM_FAULT_SIGBUS;
 
-	switch (order) {
-	case 0:
+	if (!order)
 		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
-	case PMD_ORDER:
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && order == PMD_ORDER)
 		return vmf_insert_pfn_pmd(vmf, pfn, false);
-#endif
-#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
-	case PUD_ORDER:
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order == PUD_ORDER)
 		return vmf_insert_pfn_pud(vmf, pfn, false);
-		break;
-#endif
-	default:
-		return VM_FAULT_FALLBACK;
-	}
+
+	return VM_FAULT_FALLBACK;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_vmf_insert_pfn);
 
-- 
2.53.0



