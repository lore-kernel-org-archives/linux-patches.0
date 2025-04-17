Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4745325525F;
	Thu, 17 Apr 2025 18:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913464; cv=none; b=sIpl3Vz51axIQphznm950S7Ih9veyLp8Bs2Mo5Lm6fxtLMaz4r7j6nxo2aQ6FH2bVrMuctLJX2PbWTZuN7NWk3orLtbG9SMkRhamwyja3v7y1qvslY6c8k/cRfw5lt1oK/PLvqYkyBHFnJS0w+mS417RoE545dCbvfQUcF/RAOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913464; c=relaxed/simple;
	bh=UetYPQ8pPalSj9wRfXCN1TgZotCUgJvBG+CoXvYllZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxe+708HD5b/QQ2GxFjVJ0JlSLZp8pYVtKHU4I17sefPGy96xSBXc8s9nVrRuUHW4G1Ij1/aU6DtPtUA6FQ7mJMpcROZXdrA3OjCVLAx4C3UVTiCQhYsArel0MzPox8vMm0FNNXwrpq9oWV/x1pxm8nlBc8/nQJ2RIS13G2QGnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vz5fEtc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vz5fEtc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53418C4CEE4;
	Thu, 17 Apr 2025 18:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913463;
	bh=UetYPQ8pPalSj9wRfXCN1TgZotCUgJvBG+CoXvYllZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vz5fEtcb5J388TWYUe0Oagxf8frVM05A3k1Sxx8TQRPYYBojXvr/pukulPmm6/Ma
	 ZqS/JQd6nbuar9WeZSI1amSJb33MY1QTt0fsWHgXcoBPw2IV9bjQ+8TWVzNiqpx0bd
	 yeOLhanLCuZGFDNIjMY3g7BeFgpuZ8VmhKetbHX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.14 347/449] iommufd: Fix uninitialized rc in iommufd_access_rw()
Date: Thu, 17 Apr 2025 19:50:35 +0200
Message-ID: <20250417175132.189816352@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit a05df03a88bc1088be8e9d958f208d6484691e43 upstream.

Reported by smatch:
drivers/iommu/iommufd/device.c:1392 iommufd_access_rw() error: uninitialized symbol 'rc'.

Fixes: 8d40205f6093 ("iommufd: Add kAPI toward external drivers for kernel access")
Link: https://patch.msgid.link/r/20250227200729.85030-1-nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202502271339.a2nWr9UA-lkp@intel.com/
[nicolinc: can't find an original report but only in "old smatch warnings"]
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -1127,7 +1127,7 @@ int iommufd_access_rw(struct iommufd_acc
 	struct io_pagetable *iopt;
 	struct iopt_area *area;
 	unsigned long last_iova;
-	int rc;
+	int rc = -EINVAL;
 
 	if (!length)
 		return -EINVAL;


