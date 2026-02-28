Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C370313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301139; cv=none; b=rdNfSf9UOh6YVrMLofZQSG8REx62HllOTvKRfFCn+bh6kW0ThBfDTnQYf/ieap10ZCHm9r/Fa0F4hidub4vdg3H8gjf4t10z3oKNZAgjPyf/XLGd6CQmzylpHjyk6qspZFQPUL87tz7bw/k9prBzO+6p9tSQ+xg6nZsn7h2EvR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301139; c=relaxed/simple;
	bh=ZAbUtUiuPeNgdjaer6Dd5o9qvMAhc4bwmn0WHmk/DOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LglldTVHKNi6Jjf32beOjT7hYmxzKpUcjbVZhMQ/hcti9RCdEVcKdJwq6Fg5V9Q6NhbdD0flA9+jzQV59cyNfLjmhZXTedP4W5vv8pZJfJOXhwp9XMSce9EcCPemyvE87Ludm5k44JrNIevfUkso6BdPl8QmJc49RKW3hMUZkqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kr7ztuGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kr7ztuGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096FAC2BC9E;
	Sat, 28 Feb 2026 17:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301139;
	bh=ZAbUtUiuPeNgdjaer6Dd5o9qvMAhc4bwmn0WHmk/DOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kr7ztuGRD2iv+/xi7BwaRkOOPySBn438XZLLy3yevsrBpXc2ry4BTghZ1bDc+0nrz
	 R8KIHmh6r1kL1ZKQWw1iWH7CUO2sfp2SM7o3Pucl0ZDVr5Qopku0gjSTEgHqK9MIM6
	 mClRxyP6ntLRMmG3oKTedbvF1K/bQHbC/b4rvDEXyb5SQznF/atTcp4zn67Z+bKhz7
	 /mmKLeNfulgF2cVKr9Cozr81d/SXVEX7sWeOQUTL8/kj80IDDTvdZiMP/eAgI1ss7F
	 gisah9bwUc3shfIEpYUFO6iaBj6Z22+p8a8MyncINyocOcA5B46WcJw1/D+4Tg1Pb3
	 RHNzSuxJxwUxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Longfang Liu <liulongfang@huawei.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 300/752] hisi_acc_vfio_pci: fix the queue parameter anomaly issue
Date: Sat, 28 Feb 2026 12:40:11 -0500
Message-ID: <20260228174750.1542406-300-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Longfang Liu <liulongfang@huawei.com>

[ Upstream commit c3cbc276c2a33b04fc78a86cdb2ddce094cb3614 ]

When the number of QPs initialized by the device, as read via vft, is zero,
it indicates either an abnormal device configuration or an abnormal read
result.
Returning 0 directly in this case would allow the live migration operation
to complete successfully, leading to incorrect parameter configuration after
migration and preventing the service from recovering normal functionality.
Therefore, in such situations, an error should be returned to roll back the
live migration operation.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Link: https://lore.kernel.org/r/20260122020205.2884497-5-liulongfang@huawei.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index c7559f1d4e2f2..5950ae5222476 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -407,7 +407,7 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	ret = qm_get_vft(vf_qm, &vf_qm->qp_base);
 	if (ret <= 0) {
 		dev_err(dev, "failed to get vft qp nums\n");
-		return ret;
+		return ret < 0 ? ret : -EINVAL;
 	}
 
 	if (ret != vf_data->qp_num) {
-- 
2.51.0

