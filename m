Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F31E2F9D82;
	Sat, 12 Sep 2026 07:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198356; cv=none; b=TCv5R7qOCpmk2Ru6wDlumHKv6y7PBMpU4zOKbAZjOovU8t1vzkmHrasS0Lr5chfhftVtVZGmt+fFOxLNFs7dVuiL3dhoNySKpa98PAnXWTvvveik28u7Aqt2VASwmkAeuoHOkNNkCBwkX3mv8jDQHRswdKcGwrAOnqcIUVjmSlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198356; c=relaxed/simple;
	bh=AcQbpfB1VPS8+Z11QxcnmxD0CzsQHa5JyZHmAAQhOs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEijC000cG/S8fDbkNIoeLN7dM5JXLRT3yuGokpp+huia9eJYrA4C74RHqIJe2+ZeG4UpFHQEDoXCeL3RKZRy7dCu7OcNbDK4mQPyg/WvsyR18kCgW2pdhBcu0Pc4K3wT9tXUWqbx1OwGxIBzPMBVenxf2VWM5cvDJs32Ao2TeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9qZKtrQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9qZKtrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB6B1F000FF;
	Sat, 12 Sep 2026 07:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198355;
	bh=AREWB19Fz0g6yFIQkfsZq6PZlJ1nQKtxnS58t2PZqKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9qZKtrQGEx8eHm79ekmtSmyYoMe2LZ91eF7FvdNJjK3+xmLOjZt7EeDSQYSkL2y1
	 WRH72nO495en/LxBu3jxLqlVkQYgFJkSk01ZDSJ99h8R47wbbKexoEcwK1CapG8AcB
	 EVLQX3i7Zu0XDozZVbaDYv/EiLVDZ6kdhpNzQrOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0361/1815] RDMA/hfi1: Preserve unit 0 on allocation failure
Date: Sat, 12 Sep 2026 08:35:11 +0200
Message-ID: <20260912065657.381388391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 2e3809ad8911f5d5581b3f046bd628417bface76 ]

hfi1_free_devdata() assumes that the device was inserted into the unit
table and unconditionally erases dd->unit. If xa_alloc_irq() fails, the
zero-initialized unit remains zero, so full cleanup can remove an
unrelated device from index 0.

Release only the rdmavt allocation and return immediately while the unit
table has not acquired the device.

Fixes: 03b92789e5cf ("hfi1: Convert hfi1_unit_table to XArray")
Link: https://patch.msgid.link/20260708-clean-init-one-hfi1-v1-2-b9e9641268a5@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/init.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index b7fd8b1fbbbde..3a408399f9ab8 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1225,8 +1225,9 @@ static struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev,
 			GFP_KERNEL);
 	if (ret < 0) {
 		dev_err(&pdev->dev,
-			"Could not allocate unit ID: error %d\n", -ret);
-		goto bail;
+			"Could not allocate unit ID: error %pe\n", ERR_PTR(ret));
+		rvt_dealloc_device(&dd->verbs_dev.rdi);
+		return ERR_PTR(ret);
 	}
 
 	/*
-- 
2.53.0



