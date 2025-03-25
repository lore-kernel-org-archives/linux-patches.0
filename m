Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF56E2571AC;
	Tue, 25 Mar 2025 12:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906103; cv=none; b=ItdAkUQLdL4EpPL57yvtUQ3SmOuwLRKYVNTDbMtemu1plTBnb9gXgMzzegbvr5O1cYKhtjfagUBmb8M/5b4X/NZ1jKv8KGDrAd3w/o32dnrY+Cs/OOWI3v/+wIyojAQ8UdM3tMa2/Yw9Oaj+rNU9Sf0NQm8ZV5vTAUYvHd40O5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906103; c=relaxed/simple;
	bh=Z2un9KLc5Ete6KMzEL1hv/ku1nAnyjlUCaBeApRx/B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6eX1V2Eo8y0smCIZk6KfpWeH0rpO57QyI9mKrWikoEZkFgUD8aZt3bvOAZEKhSOrZLQxl64JlwSgdhz+b+T6Nl84pxUdlM7Md3MXcGDliWwpn31QVYvB0OlVMiElMFPKyxa1Nfmj7DHceEcc++yHiwiw3wr9MOSD9kmSIQIkLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VzCtouzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VzCtouzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FCCC4CEE4;
	Tue, 25 Mar 2025 12:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906103;
	bh=Z2un9KLc5Ete6KMzEL1hv/ku1nAnyjlUCaBeApRx/B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzCtouzXb/1w3BJ1nhOlmSzEI8owHd0m5B/s7A3L7OeyTM2/olk+pMNE3j1CBG9Ef
	 gyxiKuTDfAQTHFJPRw7MTSdFwIGcVgplLc+3V6NcGd8/EoA/C8HoiwYQ57NHTceZ6K
	 5ALax42iBIeUzhQicr53kXcvn6hjgRaKdk226crw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 17/77] RDMA/hns: Fix a missing rollback in error path of hns_roce_create_qp_common()
Date: Tue, 25 Mar 2025 08:22:12 -0400
Message-ID: <20250325122144.796646380@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 444907dd45cbe62fd69398805b6e2c626fab5b3a ]

When ib_copy_to_udata() fails in hns_roce_create_qp_common(),
hns_roce_qp_remove() should be called in the error path to
clean up resources in hns_roce_qp_store().

Fixes: 0f00571f9433 ("RDMA/hns: Use new SQ doorbell register for HIP09")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250311084857.3803665-6-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 0b054b708d515..0cad6fc7bf32c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -1149,7 +1149,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 				       min(udata->outlen, sizeof(resp)));
 		if (ret) {
 			ibdev_err(ibdev, "copy qp resp failed!\n");
-			goto err_store;
+			goto err_flow_ctrl;
 		}
 	}
 
-- 
2.39.5



