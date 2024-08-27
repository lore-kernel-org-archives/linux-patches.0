Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF1F1E520;
	Tue, 27 Aug 2024 15:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771214; cv=none; b=ZG6kdrvvEin3gVVywIvLw1maZuYm+mMX9gik+rqeulZLk3SatoDJLXK0BGXWtLupPK+GCt5TJVghbjOwNju0Ep7GoDlFPZWzWDUok2MSkkopoJspJ41X0W8cyJiNS+ZxEupfagrb1Ltt+AkFeOO+v17kOZMQ3I0WbldzKvReA3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771214; c=relaxed/simple;
	bh=Cd9gJGlhn/eW5k3V27Vq7ACuDfKGPxJZEXHSh2QHm3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JG8bd+w20INRplF0vLi19BXtMWEVnMu9PA7TwNj2o8aeEkxQFuX8Vs6An6JgaKbBEqvMKr/8YNd8R0TPVH8Eg1Y9eo0UrIjPm9si95yDcnU344GESAQduYUDh01wLzfjdiQd1b+LU6wZSa+R9ejqmKfIOVUo9/AEHniWn+5Gl/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0caS9YEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0caS9YEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFB7C4AF55;
	Tue, 27 Aug 2024 15:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771214;
	bh=Cd9gJGlhn/eW5k3V27Vq7ACuDfKGPxJZEXHSh2QHm3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0caS9YEr/1XfckUu8ojrWQrJqbXE4s5iaL0Mf/i7K7AWJtDUMq6lYsTxHVqYZt//2
	 DnLXZXri1Al3RG6ax4nBjx4c7Ip5iKyfjH5vVpJh3FVx4ke8+U6RqRRrl2jS7ql8AF
	 5Wb+ZrXumHWgCY8Yy3ya4w6xa22iZecS0BGQ6+28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barak Biber <bbiber@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 121/273] iommu: Restore lost return in iommu_report_device_fault()
Date: Tue, 27 Aug 2024 16:37:25 +0200
Message-ID: <20240827143838.012792686@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Barak Biber <bbiber@nvidia.com>

[ Upstream commit fca5b78511e98bdff2cdd55c172b23200a7b3404 ]

When iommu_report_device_fault gets called with a partial fault it is
supposed to collect the fault into the group and then return.

Instead the return was accidently deleted which results in trying to
process the fault and an eventual crash.

Deleting the return was a typo, put it back.

Fixes: 3dfa64aecbaf ("iommu: Make iommu_report_device_fault() return void")
Signed-off-by: Barak Biber <bbiber@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/0-v1-e7153d9c8cee+1c6-iommu_fault_fix_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/io-pgfault.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 06d78fcc79fdb..f2c87c695a17c 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -192,6 +192,7 @@ void iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 		report_partial_fault(iopf_param, fault);
 		iopf_put_dev_fault_param(iopf_param);
 		/* A request that is not the last does not need to be ack'd */
+		return;
 	}
 
 	/*
-- 
2.43.0



