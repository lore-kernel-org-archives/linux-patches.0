Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3799C22333D;
	Thu, 17 Apr 2025 18:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914831; cv=none; b=MGSkhA2GS/cOnOOquSCkcw0F4pKxsVI90g0rdkvburbgOcqf5Fc6RkLiH4i8lXBhAiO0kfjefCpNRZkqSo3KimLiwEooDq5J+OYwejEB5LtpaT1Bt/OhlgVm3DcIv4t1d9d6Q4wqF95k4ptN9wKVGowymib+BFP6K+EMH8MY5Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914831; c=relaxed/simple;
	bh=IAR0ofx3xKqxLR5a1Dofm4az7EjIW/Ycv3Xgeoraoog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsSJCwX/RCO+j4SDwAc+qu415aVUbfN52jPgT2FctXY6bgvlnPEnU6LQm9TAyMCuAdRuda3exA6BWBrf8qsPoyB2vOAYaOkRc2tWVOtvLskiF8zGa8dPvkI87GUw+ZMvUZuPMFU5momfrX5ftID2unN8Dwc5Io5MEk244erNwFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBi+iEN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBi+iEN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9414AC4CEE4;
	Thu, 17 Apr 2025 18:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914831;
	bh=IAR0ofx3xKqxLR5a1Dofm4az7EjIW/Ycv3Xgeoraoog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBi+iEN8YnOt9QoHBe7UnJ+xjCMYCzs/7UybJrlhEYn4+ixvc525/oM+w946MDMFS
	 yWXgRxRJVqt+9Q/uBkhtcfGcGreWq+yUBSnjXHL0097COHbHTWpFzYc+PFPLdI4tgr
	 gWxx8PZbNDCNOTkvdElzAWMWFVkAAw/GKJMH+peU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.13 316/414] iommufd: Fix uninitialized rc in iommufd_access_rw()
Date: Thu, 17 Apr 2025 19:51:14 +0200
Message-ID: <20250417175124.147427156@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


