Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E082F34A31F;
	Tue, 26 Aug 2025 11:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207916; cv=none; b=eUjK168/MkgehXgMvxagkqMbaqdeUb53eqyy6ovVI7R+X8gZQJ22cbUd/6Nvi+0fl9mjaBXAUdfebu6CjTTqFNHr8V4lBqNbYQGeVMTbdLvENAVncnjPtgd/5wvmFCbul8CnKOfVB3hz//4SRIpx3U+svRsw/17g9i4ObpiX958=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207916; c=relaxed/simple;
	bh=ZwwLZV9HCCmqD8OhRnrNu2uZJDmp35eX1osRnoK+9RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lD4IUahbalErvbxiQxyUKniuwMq24N02MNVVFOKYTQFMMbc+NAOTrj38Je7A81NMrNT4XI0CCDviTkOJZCFfM8qv8W+YahFFUxutpgI1vxP0B8Wb49zHuiA0/j1nBTntr6ifSefODH1flqdRsmFLAkikWJ5sCiSMQwMLFDPBLbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TkS5FrM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TkS5FrM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7122BC4CEF1;
	Tue, 26 Aug 2025 11:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207915;
	bh=ZwwLZV9HCCmqD8OhRnrNu2uZJDmp35eX1osRnoK+9RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TkS5FrM4TaqXzl6vJ0sCRFYOLedQCSQYiDirmYZPn6brltp+/oCpfTxFvrnGAQY2m
	 HVu8VbCIxfGBbEK3/vhuv8G2E5cdxnarQbB8vtNAFvUKlwUYoy9nndD1agoDfI4fET
	 7Pr9LMEl3WAtSkC7ngp9eRp3LYQk/pqcj4PEBwtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 366/457] RDMA/hns: Fix dip entries leak on devices newer than hip09
Date: Tue, 26 Aug 2025 13:10:50 +0200
Message-ID: <20250826110946.350693992@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit fa2e2d31ee3b7212079323b4b09201ef68af3a97 ]

DIP algorithm is also supported on devices newer than hip09, so free
dip entries too.

Fixes: f91696f2f053 ("RDMA/hns: Support congestion control type selection according to the FW")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250812122602.3524602-1-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 256757f0ff65..b544ca024484 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3043,7 +3043,7 @@ static void hns_roce_v2_exit(struct hns_roce_dev *hr_dev)
 	if (!hr_dev->is_vf)
 		hns_roce_free_link_table(hr_dev);
 
-	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP09)
+	if (hr_dev->pci_dev->revision >= PCI_REVISION_ID_HIP09)
 		free_dip_entry(hr_dev);
 }
 
-- 
2.50.1



