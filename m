Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AD32DEA8F;
	Sat, 17 Oct 2026 07:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792222323; cv=none; b=YOOCqQWf0pHLrGI2lKn8Ea8pQp/nGmKiTCckAV/M4AnxB91MksvAkxVKBOY5Su6k+4xhWDEYWEqx0MHnyFV1DKMqtj5t8J2EZnJROQkkOvZrV6n4hem5zPrcCfpSwItLtREZyPEtBZ5hPAzmHbhOLujGV9ctxACC+EZWZRu1yAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792222323; c=relaxed/simple;
	bh=5+2HuqMO14tT8732mu90KJH6LejO7lEnur/pgVkxt/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MdACaeHJVXAAfLMCv2S7QmT5AGNKhaaXB9nCUbiGDWuq2TN6tpCDhSRc8NcwL7cSDPCYhoAUkVD8aEb5NJ5489Vlqx5Yb2ZtO6Y0LQcX9ns9Lcggq6ehvSgzyo6aHTx8yipqSWzrm71njcpd0EYYG85b3HKbxRO6dyCVy8AVfrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=okKKzcLp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="okKKzcLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFEB1F000C4;
	Sat, 17 Oct 2026 07:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792222321;
	bh=Ex4T0etRl1oAFON/E9c9QiIMMhngK6OQkQPQk4zkjYg=;
	h=From:To:Cc:Subject:Date;
	b=okKKzcLpghbXXAg8KF5H0WHxv/WNLgfk6o6yLB+5aGwSovS9hL5rI4LHNcRm0qLxQ
	 pN7Ks5csimO7JZMGwJ/QhuGBNtgg3N1reLlbDtjQYUb7rLovXmOe1hdUTpq5j6MRJi
	 GtCSqrhqDILB2ZA08LcvoI+xfDNzdhUqWoX0dfiywGea9sDbIQ1Eukh9s40TZhVe9R
	 8UTC5FyRWKjJWERD6FRXCLZULjG4A3WnZhU/GagLXuPT31fw3FRRoxut7c6eEYDTTo
	 60JWa4vm1F0VGlpdFeWS+0AinO7qK/eGnCRcGPnZLJxaufgPe9uy1stUXFmGQyLtUL
	 92iFHvjk8dkxQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Alex Williamson <alex@shazbot.org>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Will Deacon <will@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Fred Griffoul <griffoul@gmail.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: [RFC PATCH v2 00/13] KVM/VFIO: guest_memfd support for device MMIO resources
Date: Sat, 17 Oct 2026 13:01:36 +0530
Message-ID: <20261017073149.1303738-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds a guest_memfd device-resource framework for exposing PCI
BAR memory to guests. The intended use is confidential device assignment,
where KVM needs to coordinate private device mappings with shared access
through VFIO. The Arm CCA backend is provided separately; these patches
contain the guest_memfd, VFIO and IOMMUFD interfaces it uses.

The guest_memfd framework and Arm CCA backend are available together at:

  https://git.gitlab.arm.com/linux-arm/linux-cca.git cca/topics/cca-da-gmem-backend

Userspace creates a device-backed guest_memfd using the ordinary VFIO
device fd as resource_fd, with GUEST_MEMFD_FLAG_USE_RESOURCE and
GUEST_MEMFD_FLAG_INIT_SHARED. The resource mapping superblock selects its
provider; get_pfn identifies PFN-backed memory. Eligible BAR intervals are
registered as guest_memfd memslots. File offsets use the existing VFIO
region-offset namespace, allowing one guest_memfd to cover multiple BAR
intervals. The device-backed guest_memfd fd rejects mmap and fallocate;
shared guest faults obtain bare BAR PFNs from the provider instead of
resolving the memslot HVA or allocating folios.

IOMMUFD resolves and pins the device's existing vDEVICE after its backend
validates the VM association. Its MMIO mutex coordinates conversion and
device state changes. VFIO supplies BAR PFNs, validates eligible ranges
and excludes dma-buf exports while a guest_memfd provider is attached.

Without GUEST_MEMFD_FLAG_MMAP, attachment rejects existing VFIO BAR VMAs,
and new VFIO mmap calls. With the flag, existing and new BAR VMAs are
allowed through the VFIO fd. Attachment invalidates existing BAR mappings,
including huge mappings. Subsequent faults use base-page mappings so each
page's shared-range attributes are checked separately. Mapping the
PFN-backed guest_memfd fd remains disabled (We can decide on this later).

VFIO BAR read/write, ioeventfd and userspace mapping faults check the
requested range's guest_memfd attributes.

This series depends on:
* Ackerley Tng's "Allow guest_memfd to be created using a resource (pool)
  fd" RFC, which provides the tmpfs resource-provider API:
  https://lore.kernel.org/all/20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com/
* The IOMMUFD/TSM series, which provides the vIOMMU and vDEVICE interfaces:
  https://lore.kernel.org/all/20261008055955.4014342-1-aneesh.kumar@kernel.org/

Notes:
* Codex assisted with implementation, review and series organization.

* Changes from v1:
https://lore.kernel.org/all/20261010072504.536230-1-aneesh.kumar@kernel.org
* Require GUEST_MEMFD_FLAG_MMAP to allow VFIO BAR mmap while a provider is
  attached; disable it by default.
* Use the common guest_memfd_provider_operations for folio and PFN
  providers. Select operations through the resource mapping superblock
  and forward VFIO operations to the device driver.

Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Alex Williamson <alex@shazbot.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Joerg Roedel (AMD)" <joro@8bytes.org>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com> 
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Fred Griffoul <griffoul@gmail.com> 
Cc: iommu@lists.linux.dev
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev

Aneesh Kumar K.V (Arm) (13):
  KVM: guest_memfd: Support PFN-backed resource providers
  KVM: guest_memfd: Support private/shared conversion of device memory
  iommufd: Support MMIO provider attachment to vDEVICEs
  KVM: guest_memfd: Add device provider access callbacks
  vfio/pci: Track userspace BAR mappings
  vfio: Dispatch guest_memfd provider operations through the filesystem
  vfio/pci: Restrict host BAR access for guest_memfd providers
  vfio/pci: Provide guest_memfd backing for PCI BARs
  KVM: guest_memfd: Add a provider detach callback
  vfio/pci: Detach guest_memfd access before teardown
  KVM: guest_memfd: Remove device mappings on final close
  KVM: Invalidate guest_memfd mappings before removing memslot bindings
  vfio/pci: Allow VFIO BAR mmap with an attached guest_memfd

 Documentation/virt/kvm/api.rst          |  26 +-
 drivers/iommu/iommufd/viommu.c          |  86 ++++
 drivers/vfio/pci/Kconfig                |  11 +
 drivers/vfio/pci/Makefile               |   2 +
 drivers/vfio/pci/vfio_pci.c             |   3 +
 drivers/vfio/pci/vfio_pci_core.c        |  34 ++
 drivers/vfio/pci/vfio_pci_dmabuf.c      |  10 +
 drivers/vfio/pci/vfio_pci_gmem.c        | 362 +++++++++++++++
 drivers/vfio/pci/vfio_pci_gmem.h        |  26 ++
 drivers/vfio/pci/vfio_pci_gmem_access.c | 135 ++++++
 drivers/vfio/pci/vfio_pci_rdwr.c        |  13 +-
 drivers/vfio/vfio_main.c                | 121 ++++-
 include/linux/guest_memfd.h             |  60 ++-
 include/linux/iommufd.h                 |  26 ++
 include/linux/kvm_host.h                |  11 +
 include/linux/vfio.h                    |   4 +
 include/linux/vfio_pci_core.h           |  30 ++
 mm/shmem.c                              |   3 +-
 virt/kvm/guest_memfd.c                  | 566 ++++++++++++++++++++++--
 virt/kvm/guest_memfd.h                  |   6 +
 virt/kvm/kvm_main.c                     |   4 +
 21 files changed, 1492 insertions(+), 47 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_gmem.c
 create mode 100644 drivers/vfio/pci/vfio_pci_gmem.h
 create mode 100644 drivers/vfio/pci/vfio_pci_gmem_access.c

-- 
2.43.0

