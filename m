Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858B93EDE74;
	Tue, 12 May 2026 17:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608644; cv=none; b=eWL19yTwLZMB+QiKI5dTSKiLhltnq4Aj5dBdfV6SooZLYtMxfjpVnu3Rht6wzdco6fIXhKIITvFnN7xKX89jNGQ4FXhPKs7YSv82PNz72+za0Rwy8P82NOUcIGwRU4Khl/5RXXntwJfL8bfim8w/CyJqlUzQijVKVHCeVM8i+04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608644; c=relaxed/simple;
	bh=+/DgjqEBnZTxGRvUVZ1yU5djRShv2RVOP/9fOo4aobQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbjfVx8g3tNkLtC0YnCqASgYE4Jp9DkSJgTEt/ypRPbMNEsoXALBNy/pWbsZb0of+4MXY7iFvcg97BRNKboTC+eX3nHJqNit9YRRMhAiGza7uSqM8bHxpd5BL84FSKSfm0fVbMtJewDvGi9iYX+UwGiWToQcZzdoxZH2/2GEWWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2OvzHUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2OvzHUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C30EC2BCB0;
	Tue, 12 May 2026 17:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608644;
	bh=+/DgjqEBnZTxGRvUVZ1yU5djRShv2RVOP/9fOo4aobQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2OvzHUXr7C0kdxKdGobLEHw89FHZ/h191ai5ebWUpITxN8SBumycJLqOJ5iWrrs7
	 tx0lZXmOe0vLkp+Genr/AxCgQIzUGfOqoDa1h7A+4gsF+X+sgh2S9bno9I3t0UjVO9
	 CFVAVLhADuTRmRelmcqchrCqczRzPDV5pUQhk63U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 158/270] iommufd: Fix return value of iommufd_fault_fops_write()
Date: Tue, 12 May 2026 19:39:19 +0200
Message-ID: <20260512173941.773617773@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

commit aaca2aa92785a6ab8e3183e7184bca447a99cd76 upstream.

copy_from_user() may return number of bytes failed to copy, we should
not pass over this number to user space to cheat that write() succeed.
Instead, -EFAULT should be returned.

Link: https://patch.msgid.link/r/20260330030755.12856-1-zhenzhong.duan@intel.com
Cc: stable@vger.kernel.org
Fixes: 07838f7fd529 ("iommufd: Add iommufd fault object")
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/eventq.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iommu/iommufd/eventq.c
+++ b/drivers/iommu/iommufd/eventq.c
@@ -187,9 +187,10 @@ static ssize_t iommufd_fault_fops_write(
 
 	mutex_lock(&fault->mutex);
 	while (count > done) {
-		rc = copy_from_user(&response, buf + done, response_size);
-		if (rc)
+		if (copy_from_user(&response, buf + done, response_size)) {
+			rc = -EFAULT;
 			break;
+		}
 
 		static_assert((int)IOMMUFD_PAGE_RESP_SUCCESS ==
 			      (int)IOMMU_PAGE_RESP_SUCCESS);


