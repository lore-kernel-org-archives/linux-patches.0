Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C3F34B433;
	Fri, 21 Nov 2025 13:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730988; cv=none; b=BMg+vuApMjNv2NV2vWHsp+YNHhwNvPBKux5ajjxCt99QTDM03se4amHF98OMUtjDmXUxhOoU7yx6Xwad3BLU4ybs2DKgzPG/R6qHMmMZVXYwPvuansmX/qBeSkrKQRnwpOm6xNu3o39tR2BzBFCV7tgPoe6YtlNFRkT2X/U6l1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730988; c=relaxed/simple;
	bh=al0RvQMqj/C+TNDcqjivEQhTxz8dp6b/RSvO6I4cETg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9bnlLonlGfcbTaO/x+LXFdByxJA577ImU8XeXZZ5fjJBvoxDHf+zpdbZaPCpze2Bs/SIcFRT8bUEVjUsZCGY3uk8KyZvgustbrXey+WhoLjBPKhkYOuaHkfu6afT5g7TeooiOeQMjxv9BZKOfwByYdSwDbMxctCCCdJnRz8HsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWYqBbaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWYqBbaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA7CC4CEFB;
	Fri, 21 Nov 2025 13:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730987;
	bh=al0RvQMqj/C+TNDcqjivEQhTxz8dp6b/RSvO6I4cETg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWYqBbaGtKbCR0uxw8CPv1UnelZXVVBe0ISBt9NpWRcPCvxHj88Xinj/5MeTPJ7P/
	 TegZtwTj+sHf7GPVX7ziScDPeS9ZzF3B9IQq9X3+ldcCCp4xaILtKYZZvptNm6GfLR
	 Ce3Jv7otAobzM8rl7rjAXrH0sCQYA3Ox/dyVYIDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Alex Mastro <amastro@fb.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 008/247] iommufd: Make vfio_compats unmap succeed if the range is already empty
Date: Fri, 21 Nov 2025 14:09:15 +0100
Message-ID: <20251121130154.897321808@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit afb47765f9235181fddc61c8633b5a8cfae29fd2 ]

iommufd returns ENOENT when attempting to unmap a range that is already
empty, while vfio type1 returns success. Fix vfio_compat to match.

Fixes: d624d6652a65 ("iommufd: vfio container FD ioctl compatibility")
Link: https://patch.msgid.link/r/0-v1-76be45eff0be+5d-iommufd_unmap_compat_jgg@nvidia.com
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Alex Mastro <amastro@fb.com>
Reported-by: Alex Mastro <amastro@fb.com>
Closes: https://lore.kernel.org/r/aP0S5ZF9l3sWkJ1G@devgpu012.nha5.facebook.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/io_pagetable.c    | 12 +++---------
 drivers/iommu/iommufd/ioas.c            |  4 ++++
 tools/testing/selftests/iommu/iommufd.c |  2 ++
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index c0360c450880b..75d60f2ad9008 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -707,7 +707,8 @@ static int iopt_unmap_iova_range(struct io_pagetable *iopt, unsigned long start,
 	struct iopt_area *area;
 	unsigned long unmapped_bytes = 0;
 	unsigned int tries = 0;
-	int rc = -ENOENT;
+	/* If there are no mapped entries then success */
+	int rc = 0;
 
 	/*
 	 * The domains_rwsem must be held in read mode any time any area->pages
@@ -777,8 +778,6 @@ static int iopt_unmap_iova_range(struct io_pagetable *iopt, unsigned long start,
 
 		down_write(&iopt->iova_rwsem);
 	}
-	if (unmapped_bytes)
-		rc = 0;
 
 out_unlock_iova:
 	up_write(&iopt->iova_rwsem);
@@ -815,13 +814,8 @@ int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
 
 int iopt_unmap_all(struct io_pagetable *iopt, unsigned long *unmapped)
 {
-	int rc;
-
-	rc = iopt_unmap_iova_range(iopt, 0, ULONG_MAX, unmapped);
 	/* If the IOVAs are empty then unmap all succeeds */
-	if (rc == -ENOENT)
-		return 0;
-	return rc;
+	return iopt_unmap_iova_range(iopt, 0, ULONG_MAX, unmapped);
 }
 
 /* The caller must always free all the nodes in the allowed_iova rb_root. */
diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
index 1542c5fd10a85..459a7c5169154 100644
--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -367,6 +367,10 @@ int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
 				     &unmapped);
 		if (rc)
 			goto out_put;
+		if (!unmapped) {
+			rc = -ENOENT;
+			goto out_put;
+		}
 	}
 
 	cmd->length = unmapped;
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 3eebf5e3b974f..bb4d33dde3c89 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -2638,6 +2638,8 @@ TEST_F(vfio_compat_mock_domain, map)
 	ASSERT_EQ(0, ioctl(self->fd, VFIO_IOMMU_MAP_DMA, &map_cmd));
 	ASSERT_EQ(0, ioctl(self->fd, VFIO_IOMMU_UNMAP_DMA, &unmap_cmd));
 	ASSERT_EQ(BUFFER_SIZE, unmap_cmd.size);
+	/* Unmap of empty is success */
+	ASSERT_EQ(0, ioctl(self->fd, VFIO_IOMMU_UNMAP_DMA, &unmap_cmd));
 
 	/* UNMAP_FLAG_ALL requires 0 iova/size */
 	ASSERT_EQ(0, ioctl(self->fd, VFIO_IOMMU_MAP_DMA, &map_cmd));
-- 
2.51.0



