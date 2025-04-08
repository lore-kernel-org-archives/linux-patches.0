Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371D1269B1E;
	Tue,  8 Apr 2025 11:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110013; cv=none; b=Ov7QLbmNiiF16d6Wp6WnnDOB/dvA1uiegF65g6v9J455IZSiRdysXVawL3SZRQ0KUxb52biaRCwTOLoZuf7MgNPpXgud0c3e9N0xobFHRVMtNUmh1jGlJHM3b/jypPDuRf57H4h+Ckr18QM6JNtxhj4ez98kmWm2RQ60fy30Qsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110013; c=relaxed/simple;
	bh=ZUohXa2jAWBeAvcLVuXdl71SNzjOQwuwrygmxJrJxrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nk0LRY42xlK2iriMUJPelpVktpNqg3ANT+1XlhR3YOnnC9d5UVHPqNlEO91Kd7T4AVkfiRCKVpUa1oP731i1wkhFBFcuKX/JxZY3bFdx+ju9strjRk74rOzUPyuP+COmNEC8z1FpG6NkQQI4Nnz74PlGuoonnBzEcpma4L2tnjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sALJPjMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sALJPjMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2605AC4CEE5;
	Tue,  8 Apr 2025 11:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110012;
	bh=ZUohXa2jAWBeAvcLVuXdl71SNzjOQwuwrygmxJrJxrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sALJPjMYSGMLjwCraVbv6msQsywtoHtvW/whvGkJThoB5Ju+oXKwjyEj1Zdb2Ua7H
	 aimDqAVhrUKeT92pOHZcFymWujNpj9xZoMQLF5opxc7UaQEe+eQkwTlxG4XaS8a8+O
	 gtXc2UsS5b4rVOKMTubqLp43b1DKyTiJWi9N//mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/227] PCI: Remove stray put_device() in pci_register_host_bridge()
Date: Tue,  8 Apr 2025 12:48:35 +0200
Message-ID: <20250408104824.421024659@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 6e8d06e5096c80cbf41313b4a204f43071ca42be ]

This put_device() was accidentally left over from when we changed the code
from using device_register() to calling device_add().  Delete it.

Link: https://lore.kernel.org/r/55b24870-89fb-4c91-b85d-744e35db53c2@stanley.mountain
Fixes: 9885440b16b8 ("PCI: Fix pci_host_bridge struct device release/free handling")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 02a75f3b59208..84edae9ba2e66 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -918,10 +918,9 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 		goto free;
 
 	err = device_add(&bridge->dev);
-	if (err) {
-		put_device(&bridge->dev);
+	if (err)
 		goto free;
-	}
+
 	bus->bridge = get_device(&bridge->dev);
 	device_enable_async_suspend(bus->bridge);
 	pci_set_bus_of_node(bus);
-- 
2.39.5



