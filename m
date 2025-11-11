Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C0330748C;
	Tue, 11 Nov 2025 01:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825557; cv=none; b=oIExqmldSJPsJhjNzKXuc8T1Lk7cKLrhweiTYBv9AsxTi2Eu4lV43N+96/EWlSPyudiV+LOHrL5SMxcTrd1FMhs6SvSfYi88mdIk6unBYkqHeVZfZABXxm3SkEkb3WX4+yjGC69YATmL6iXrvXnrNz0wg+Q+MrywqRRN+7H4caA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825557; c=relaxed/simple;
	bh=0V8kim3T1KGIlQIUBgKfUCU7lP3WV/WLZnWWPT0c81c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzydJKX8pKU3MvTvFsKIOZl0KbhwakBimbO6ndH4nq1sw0zBC3Tah4jOHA/4FioaMc8mK8/LVOUm0ZwBOcpUin54LTHMSapzYSVuTeBuOmU7pJrGwCFf66+rRoLswcrWvUrFc6MMhXJzI25QISRNkgF+/GTiEk7spuDxoHimfWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pE5C8YrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pE5C8YrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56ADC16AAE;
	Tue, 11 Nov 2025 01:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825557;
	bh=0V8kim3T1KGIlQIUBgKfUCU7lP3WV/WLZnWWPT0c81c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pE5C8YrMBO48W/a+MtfxL9U5kTVy+GKZebycTTKTGyJ6X/i0DJsozjGra6O3Bg0gS
	 5/KAnz0PwOGxsoRP8MdvmOcDygHDko1aa4/QtgU35Fn4Z/GIFal1l7JzzhR1lwDfGk
	 RYDrmIwctXUQzHPlPxnxLgRfvBnfnVNTF38wZy1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	syzbot+093a8a8b859472e6c257@syzkaller.appspotmail.com,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.17 810/849] iommufd: Dont overflow during division for dirty tracking
Date: Tue, 11 Nov 2025 09:46:20 +0900
Message-ID: <20251111004556.009086214@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

commit cb30dfa75d55eced379a42fd67bd5fb7ec38555e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/iova_bitmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -130,9 +130,8 @@ struct iova_bitmap {
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


