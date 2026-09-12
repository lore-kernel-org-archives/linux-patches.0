Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582DC331EC0;
	Sat, 12 Sep 2026 14:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223347; cv=none; b=gQfkTMrCE/Nj+FD05BlC6puaCAHaavdi1lJZ6Oz1PygLg0f8krQsJkmrVmhJqqJnkWX0skSTJzwOU5qNcgViSc0R3tFb+4H+uFU0Fy9auXsK3HnrP7pB9tAQDsGvPlMWGIPFpCT17JDUlJrrpDnkiCUWN90ADGcAP5+aa7HyvlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223347; c=relaxed/simple;
	bh=kOLa0xtu+RmWWCuv8Ow8QD05H7hKUAz1OiSaG1kkWfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+sghL4TMWemJ4grTwxCAfGZXHyrldylgKKkpFjMc/9X1LxAbvEhJWz57Y6Wr/5u/HAj0Vny085Jierx3Kw0dgaiuRqeR9dMODn3cTgmjUgrnib40w1lb2V5GdBdPkLSvXyR+FLZupDSINFgJaNKObkk61K4IYXNU767xI5vZz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0nIx8Lv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0nIx8Lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A861F000FF;
	Sat, 12 Sep 2026 14:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223346;
	bh=hIqCUAbYlenODax+68iqrwI4G8n4RPK7mQ1Skp/ifHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0nIx8LvPjCrAXkTROnKD4UvfRtBUKa/g+MXaDPC7jIKN98PrTEInnmFcKVWo7iDb
	 Oia/u6IyMkA5a+76N3gX4SAVaVBgREkdlHVaPAtWn2HkG78MUh3q2NZ6a1ezgLfVxp
	 4LQmaMTax/eEpwb+mnDA3oQ754T7lw8cYrdk/shI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0728/1424] RDMA/hfi1: Preserve unit 0 on allocation failure
Date: Sat, 12 Sep 2026 08:52:40 +0200
Message-ID: <20260912065623.593434607@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 6de37c5d7d273..070e5d6c78f43 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1228,8 +1228,9 @@ static struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev,
 			GFP_KERNEL);
 	if (ret < 0) {
 		dev_err(&pdev->dev,
-			"Could not allocate unit ID: error %d\n", -ret);
-		goto bail;
+			"Could not allocate unit ID: error %pe\n", ERR_PTR(ret));
+		rvt_dealloc_device(&dd->verbs_dev.rdi);
+		return ERR_PTR(ret);
 	}
 	rvt_set_ibdev_name(&dd->verbs_dev.rdi, "%s_%d", class_name(), dd->unit);
 	/*
-- 
2.53.0



