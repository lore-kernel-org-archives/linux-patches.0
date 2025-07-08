Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC86A2E5B04;
	Tue,  8 Jul 2025 16:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993345; cv=none; b=djPyY9HPBNtfnKbVlqBeDFO7PFTszUAJKYJWzpqsJg1cCNnANyT7z32HG6b8bvM0aS2XnzIEvRU9xIBhRSJSLc/0PyvTuq0Zj2RPvOHiAQAJxXmxNcXQ1tzQ9OPYK7Sx7CRM26af4HbGYZSkl62ZvY3Ddk8+fLrGJKkGNLvSWdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993345; c=relaxed/simple;
	bh=MiS07JNwzep9YymZsGSE0GyZMoYLr86kzhSFnfzonHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7/nLhJuqpxwPWxyHDaZykRrSW86RXwIXFw4180TAzH7jwhf2iN/EJAxVLyVpRivLv28F+AvjeH/8HKWrmcUAMDJZ2o2b18adsGHpbh38ebJCtj7B2yKE26CvzaoLu/56bqnc24ocgEmTUd0tnhjxy+C8bSVW31p0wpvolBAYl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqcLVvQK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqcLVvQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682F2C4CEED;
	Tue,  8 Jul 2025 16:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993344;
	bh=MiS07JNwzep9YymZsGSE0GyZMoYLr86kzhSFnfzonHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aqcLVvQKAQhq2S8RLGy4NJXqIV3GZOOSODbOKcIN164991nTsjDjmwZfnc0V1xXnZ
	 LnJKjRWC2LlQRoFUDu2p0xaSzaT/9C7By4sY5OSL/wXWAQmtUr3As3mpjk949AYsm/
	 uLYRmqzE8y6VU3Y1DOXEqIpn98fU8StenxhAHZi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH 6.15 011/178] iommufd/selftest: Add missing close(mfd) in memfd_mmap()
Date: Tue,  8 Jul 2025 18:20:48 +0200
Message-ID: <20250708162236.842605402@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 4b75e3babb85238912f50bbe0647bae08242a9b6 upstream.

Do not forget to close mfd in the error paths, since none of the callers
would close it when ASSERT_NE(MAP_FAILED, buf) fails.

Fixes: 0bcceb1f51c7 ("iommufd: Selftest coverage for IOMMU_IOAS_MAP_FILE")
Link: https://patch.msgid.link/r/a363a69dbf453d4bc1bde276f3b16778620488e1.1750787928.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/iommu/iommufd_utils.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -60,13 +60,18 @@ static inline void *memfd_mmap(size_t le
 {
 	int mfd_flags = (flags & MAP_HUGETLB) ? MFD_HUGETLB : 0;
 	int mfd = memfd_create("buffer", mfd_flags);
+	void *buf = MAP_FAILED;
 
 	if (mfd <= 0)
 		return MAP_FAILED;
 	if (ftruncate(mfd, length))
-		return MAP_FAILED;
+		goto out;
 	*mfd_p = mfd;
-	return mmap(0, length, prot, flags, mfd, 0);
+	buf = mmap(0, length, prot, flags, mfd, 0);
+out:
+	if (buf == MAP_FAILED)
+		close(mfd);
+	return buf;
 }
 
 /*


