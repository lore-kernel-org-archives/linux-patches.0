Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DF51A6192;
	Tue, 30 Jul 2024 17:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359062; cv=none; b=oC++6vDhvtJt4K/3KXxshSCrwC3ohc9IE4M72luhTl04ktOF84BS8y+Cw/yuOy2e3sc9FU+Fb3+263mKykc6w5sky1TikC9vFUecE57eXetQPM3Qb5xaQIbWpQrRSyB2YsfP9gYy2CxdBwl1bxGMe/jkT3881n3RWvPtO7NDfLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359062; c=relaxed/simple;
	bh=ATp5fJ6a9wBXcUPnx9yfJQQCZ/TcFOlrzUe+ebXqagY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meLP+VgWr7RajpiNuZGvUM2ib0of5n+y4rT+58cQB4xrg1gx9N1mm+9U94bgQ0Go/EvjOzzfuffIrNageJWngh6ZijkhHcvIqbee87eLGixtsIoL/1Jklp741vKG3GAkRtzbzyxidZfSdsFHOL858+LtGV7N1swd4TOXbr5Ffmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJvrcHXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJvrcHXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850F8C32782;
	Tue, 30 Jul 2024 17:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359062;
	bh=ATp5fJ6a9wBXcUPnx9yfJQQCZ/TcFOlrzUe+ebXqagY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJvrcHXAcy1apDPQd3jIHf9ah2pztW65EuB+GkWzMGfJ9jXBqxuxK/wrrLgrqSxO7
	 iMV1CjA4ZuEMW1GjsPCWpefD4KqMGsSDDKm9W7ETCKvwgJS4CdaCF5IVlsjxp6wpys
	 dMtsEZXfUySPrifZChDtH0CJ6XPn+dWBUMSCL1DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Ochs <mochs@nvidia.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 428/809] iommufd/selftest: Fix dirty bitmap tests with u8 bitmaps
Date: Tue, 30 Jul 2024 17:45:04 +0200
Message-ID: <20240730151741.603431444@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joao Martins <joao.m.martins@oracle.com>

[ Upstream commit ec61f820a2ff07d1717583bd57d6ee45d2763a6e ]

With 64k base pages, the first 128k iova length test requires less than a
byte for a bitmap, exposing a bug in the tests that assume that bitmaps are
at least a byte.

Rather than dealing with bytes, have _test_mock_dirty_bitmaps() pass the
number of bits. The caller functions are adjusted to also use bits as well,
and converting to bytes when clearing, allocating and freeing the bitmap.

Link: https://lore.kernel.org/r/20240627110105.62325-2-joao.m.martins@oracle.com
Reported-by: Matt Ochs <mochs@nvidia.com>
Fixes: a9af47e382a4 ("iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_BITMAP")
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Matt Ochs <mochs@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/iommu/iommufd.c       | 10 +++++-----
 tools/testing/selftests/iommu/iommufd_utils.h |  6 ++++--
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index edf1c99c9936c..0b04d782a19fc 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1722,6 +1722,7 @@ FIXTURE_VARIANT(iommufd_dirty_tracking)
 
 FIXTURE_SETUP(iommufd_dirty_tracking)
 {
+	unsigned long size;
 	int mmap_flags;
 	void *vrc;
 	int rc;
@@ -1749,12 +1750,11 @@ FIXTURE_SETUP(iommufd_dirty_tracking)
 	assert(vrc == self->buffer);
 
 	self->page_size = MOCK_PAGE_SIZE;
-	self->bitmap_size =
-		variant->buffer_size / self->page_size / BITS_PER_BYTE;
+	self->bitmap_size = variant->buffer_size / self->page_size;
 
 	/* Provision with an extra (PAGE_SIZE) for the unaligned case */
-	rc = posix_memalign(&self->bitmap, PAGE_SIZE,
-			    self->bitmap_size + PAGE_SIZE);
+	size = DIV_ROUND_UP(self->bitmap_size, BITS_PER_BYTE);
+	rc = posix_memalign(&self->bitmap, PAGE_SIZE, size + PAGE_SIZE);
 	assert(!rc);
 	assert(self->bitmap);
 	assert((uintptr_t)self->bitmap % PAGE_SIZE == 0);
@@ -1775,7 +1775,7 @@ FIXTURE_SETUP(iommufd_dirty_tracking)
 FIXTURE_TEARDOWN(iommufd_dirty_tracking)
 {
 	munmap(self->buffer, variant->buffer_size);
-	munmap(self->bitmap, self->bitmap_size);
+	munmap(self->bitmap, DIV_ROUND_UP(self->bitmap_size, BITS_PER_BYTE));
 	teardown_iommufd(self->fd, _metadata);
 }
 
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index 8d2b46b2114da..c612fbf0195ba 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -22,6 +22,8 @@
 #define BIT_MASK(nr) (1UL << ((nr) % __BITS_PER_LONG))
 #define BIT_WORD(nr) ((nr) / __BITS_PER_LONG)
 
+#define DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+
 static inline void set_bit(unsigned int nr, unsigned long *addr)
 {
 	unsigned long mask = BIT_MASK(nr);
@@ -346,12 +348,12 @@ static int _test_cmd_mock_domain_set_dirty(int fd, __u32 hwpt_id, size_t length,
 static int _test_mock_dirty_bitmaps(int fd, __u32 hwpt_id, size_t length,
 				    __u64 iova, size_t page_size,
 				    size_t pte_page_size, __u64 *bitmap,
-				    __u64 bitmap_size, __u32 flags,
+				    __u64 nbits, __u32 flags,
 				    struct __test_metadata *_metadata)
 {
 	unsigned long npte = pte_page_size / page_size, pteset = 2 * npte;
-	unsigned long nbits = bitmap_size * BITS_PER_BYTE;
 	unsigned long j, i, nr = nbits / pteset ?: 1;
+	unsigned long bitmap_size = DIV_ROUND_UP(nbits, BITS_PER_BYTE);
 	__u64 out_dirty = 0;
 
 	/* Mark all even bits as dirty in the mock domain */
-- 
2.43.0



