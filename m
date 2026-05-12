Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05A936A374;
	Tue, 12 May 2026 18:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609430; cv=none; b=SodoDZ1X+xIBJn3hdTMXK2tTTXe0aAlRRf/NNXFxQP22PIzRgh8zi/QgbkPqZhXQ085/khc54+617DHVqFQa+yBUexca323UTZ6gpa0ivxxE+x7coHVNOvO6dwR/la26sBx4jstaE1V2PYT1PHidkBOGbVW9vPFyt5oEXaDvqJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609430; c=relaxed/simple;
	bh=4TcoJ1MbuvxMDwNbvt5JiHEK5U/PLgnhqc0KnKfxiqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCsgRiMkf9WFTFw+E7YUBllPosrfssZuZyn0ZsQxxkLgdhzePU5dAaKdOh4iEYZKSFATg0AITBMGoAikXsbfr8tpwLNP5Oo8xacPIxhuFLpdKJUdMQL+xdQwAzS/dnTgDrvZ3CQPLVHI5AWPgtrJXwKVZuXyjVbZJS5PWUZFrFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RsuHPgQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RsuHPgQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F5CC2BCB0;
	Tue, 12 May 2026 18:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609429;
	bh=4TcoJ1MbuvxMDwNbvt5JiHEK5U/PLgnhqc0KnKfxiqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RsuHPgQTvvwSUydeh2UnPhmndF4Pi8hctKT9Dy1SiN9BOzhX2eEL3KnACpRh1q8Fm
	 G7YG2DXXI59iZbBsl3A4pRFxclQlnrciFVy/HP1xsapBMz4KZLDluAGGAaEX2EV2Za
	 3Z5xLjo22T5cuzTdaBFKZWg/wRqmgWc4AiI9USug=
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
Subject: [PATCH 7.0 191/307] iommufd: Fix return value of iommufd_fault_fops_write()
Date: Tue, 12 May 2026 19:39:46 +0200
Message-ID: <20260512173944.148402908@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


