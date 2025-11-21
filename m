Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D9234320A;
	Fri, 21 Nov 2025 14:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733610; cv=none; b=bK+WjhWl4/DzOY8VGuOfezY4SR7LT9xaWZHQz8wBBp6K3F4EYFRt/KMljSLgpbkjBoQ1EaG/llyLtmK15b8Q9d+RXmN0fT7zChZrNK1WRqw5oODMWcqgP8Jp9qKWYwBgma3UM0DaqcivWyjl3yz2h4S15AvPLsUU+zkCYBMFo90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733610; c=relaxed/simple;
	bh=SL3pE5aEhjKlVH7bspzdHUJplv3TRwLHsCzSpFNgiXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpioLgT+sB1aUXLpUTC11vvFzi03qEfeZeg+E96zM8K+zKQOvFiqzpl64uvu5/d91zpBx6oqIgWMN/hQzwUUsq+JwbB3EKIDGHx5hF2ipK0EGkf90o8nVBCRYG1bFFK48WG4/P4qjdsKxB0mvtk0qpHoGRy/xBM7+eVtJBNEEo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQQerSCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQQerSCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B104C4CEF1;
	Fri, 21 Nov 2025 14:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733610;
	bh=SL3pE5aEhjKlVH7bspzdHUJplv3TRwLHsCzSpFNgiXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQQerSCN3N9AKxaPsYFhSc08CE+OGPsU25QYOW3xBpi+sLszbnWRQP/2dwx+XZdvo
	 wT64ySxFNzoexwo6TOLJ1jt0BKBMNSVDyDs9pdKTstl/YzWL7GtwO+P+Ef/R7260/Q
	 IJ9DfdsS6ZS3U3bjLsmJnj6N1+/Tm+xkPj0JiEb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	syzbot+093a8a8b859472e6c257@syzkaller.appspotmail.com,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 495/529] iommufd: Dont overflow during division for dirty tracking
Date: Fri, 21 Nov 2025 14:13:14 +0100
Message-ID: <20251121130248.623893574@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@ziepe.ca>

[ Upstream commit cb30dfa75d55eced379a42fd67bd5fb7ec38555e ]

If pgshift is 63 then BITS_PER_TYPE(*bitmap->bitmap) * pgsize will overflow
to 0 and this triggers divide by 0.

In this case the index should just be 0, so reorganize things to divide
by shift and avoid hitting any overflows.

Link: https://patch.msgid.link/r/0-v1-663679b57226+172-iommufd_dirty_div0_jgg@nvidia.com
Cc: stable@vger.kernel.org
Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reported-by: syzbot+093a8a8b859472e6c257@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=093a8a8b859472e6c257
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ drivers/iommu/iommufd/iova_bitmap.c => drivers/vfio/iova_bitmap.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/iova_bitmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -127,9 +127,8 @@ struct iova_bitmap {
 static unsigned long iova_bitmap_offset_to_index(struct iova_bitmap *bitmap,
 						 unsigned long iova)
 {
-	unsigned long pgsize = 1UL << bitmap->mapped.pgshift;
-
-	return iova / (BITS_PER_TYPE(*bitmap->bitmap) * pgsize);
+	return (iova >> bitmap->mapped.pgshift) /
+	       BITS_PER_TYPE(*bitmap->bitmap);
 }
 
 /*


