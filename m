Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C857637A82E;
	Sat, 17 Oct 2026 07:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792222392; cv=none; b=tKTN153YEhyDM2skyLAhCSxEpHYHRN2ZpYbm6DkdVcIRdcf8OSTlqylbv6y0ymef92SmndINpHmOuz8bikAtN9cQeoAp83gStBrm5AGKngzPoLOXfvulrsI8iWsPg7cyo5uTmUEdibybz1yIRVthEW2OtoOqdOiw9Qf02ev9xOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792222392; c=relaxed/simple;
	bh=xBuy5CuQTW3p/GqZYcyHdZAu5H0uazIoNGhNgT62dME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAu0rYUfGAwnC3O1Yd4hWJL7xYwltekohEcxb4wuE8Ifx1BXAvmg6u7QZ2aMvOxT1dqrW3hjibKVdAGoEgpF7V6BoXJ+w2U3nwJuzsCBKlDHnIVQ9LggCXMu++VgO8jj08gLVsyFxDTtIqhb4XmkOREUclGxQRm/Bt3yBuqcd4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2g7hrso; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2g7hrso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FFA1F000C5;
	Sat, 17 Oct 2026 07:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792222391;
	bh=/XYEEMiYFQNAIdM/tZb2Un4znvi86p9TOVyeBDQeGNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2g7hrsoGO+9kooqABzKPAHbIzAEYBYkdrWUdiAKcpO4tCHMbPqeh/1i+685/NZem
	 gbO8cmnwDIcW5q5maIPE57V6+aGzM3JfQua+AXl8jYMl+JhanBfcDwOd1YComXpVrc
	 J0oZkQACKGjYlR2Eh0aymaogZhkB1wpCgOpHngWU5rx4TOyu2rHwpIcWq8LxYaGsbt
	 4NqjVq4FxGZFX4PDjEHNc1f/PRmaAeXoJiytDj5+6K+YayduCgdGa2938MRxHNhM2u
	 J1PsniMdNyF1ZWsWuiIQX473gaLwBGCkWqT9iZUAjv2r22RxyUGYCJZR364IW6rknW
	 ElsmKWmLYNX1w==
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
Subject: [RFC PATCH v2 09/13] KVM: guest_memfd: Add a provider detach callback
Date: Sat, 17 Oct 2026 13:01:45 +0530
Message-ID: <20261017073149.1303738-10-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261017073149.1303738-1-aneesh.kumar@kernel.org>
References: <20261017073149.1303738-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add detach() to the guest_memfd provider operations. Providers must disable
new bindings and private requests and stop and drain callbacks that access
the VM before returning.

This separates quiescing VM access from release(), which may run after
the guest_memfd file and its VM reference have been released.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index f0c62889f823..cfc26294d7ea 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -47,6 +47,8 @@ struct guest_memfd {
  * @get_pfn: Resolve a shared resource offset without taking a folio reference.
  * @prepare_conversion: Prepare protected PFN conversion; NULL request shares.
  * @finish_conversion: Finish conversion after attribute publication.
+ * @detach: Disable new bindings and private requests before final cleanup.
+ *          Stop and drain callbacks that access the VM before returning.
  *
  * Provider operations supply exactly one of alloc_folio() and get_pfn().
  * PFN providers start shared and require the bind and conversion callbacks
@@ -65,6 +67,7 @@ struct guest_memfd_provider_operations {
 		const struct guest_memfd_device_request *req);
 	void (*finish_conversion)(void *provider,
 		const struct guest_memfd_device_request *req);
+	void (*detach)(void *provider);
 };
 
 #endif /* _LINUX_GUEST_MEMFD_H */
-- 
2.43.0

