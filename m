Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C2B2DF3EA;
	Tue, 21 Jul 2026 18:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660013; cv=none; b=YEym4E0Y9aricjWC2KKknEEwxPyh4gxqUwpb4cOlKeCUcvmIpWs2qcbnASX4tZ7RxswbNXSEMenueOAoU+A6HBHrmOoDF41AGob5qdFJEo2OpwNgphp9b8bV1bDtHb5iKEoE3B8Hhklr3bvfaxNQdPennb8aZQ6g5Ude2t4MXdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660013; c=relaxed/simple;
	bh=uVCNJMYaou/A0J8R//r88UUmyjlzRJTBJUKtFeY62a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmQyeOUWLx5R6/V90ytXRRng5u8Y8QxbUyWYK56CaQzCZjEVWjkty9pz6IWgaf41xCLndr3J1rmDSRWUlDNtEjm3UZ/xHQcybhzOec/pDsvGS8kcXa0h413aR3E52V9Vg4lN+6Aa1WLVD/wdCgMVTz9uMrq80f2/OFvOnsTPA1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ph96eoG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ph96eoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3501F000E9;
	Tue, 21 Jul 2026 18:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660011;
	bh=wJc9q3yxkYwGFhG8vk/QeD81JmTDw4OgmFeGxUGjo/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ph96eoGLsEkeL7a/xCMSQIItpfHyentIUqfS9BGxBj0roFnAYFoghgB/f2uLfxKD
	 QoUaaNdetXwhSkP4WMIy/Di8AIjjyumnhozQqu+M/m90GTAEJYMBDDd25dtsnb5tqb
	 8Jry3M7kD2nZgye0ah3YHic9j5cQ9AcPoEVZYGK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0817/2077] RDMA/hns: Fix memory leak of bonding resources
Date: Tue, 21 Jul 2026 17:08:10 +0200
Message-ID: <20260721152612.059991969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit c0bd03b850d81a8914168d87ddf7f6ffa58875ef ]

In a corner case of concurrent driver removal and driver reset,
bonding resource is first released in hns_roce_hw_v2_exit() during
driver removal, and then is allocated again in hns_roce_register_device()
during driver reset. This leads to memory leak because the release
timing has already passed. This may also lead to a kernel panic
as below because of the leaked notifier callback:

Call trace:
  0xffffa20fccc04978 (P)
  raw_notifier_call_chain+0x20/0x38
  call_netdevice_notifiers_info+0x60/0xb8
  netdev_lower_state_changed+0x4c/0xb8

As Sashiko suggested, the teardown order of bonding resources should
be inverted to make sure the resources are released when the driver
is removed.

Fixes: b37ad2e290fc ("RDMA/hns: Initialize bonding resources")
Link: https://patch.msgid.link/r/20260613102045.811623-1-huangjunxian6@hisilicon.com
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 8810fa0b659731..60478382e82ff5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -7586,8 +7586,8 @@ static int __init hns_roce_hw_v2_init(void)
 
 static void __exit hns_roce_hw_v2_exit(void)
 {
-	hns_roce_dealloc_bond_grp();
 	hnae3_unregister_client(&hns_roce_hw_v2_client);
+	hns_roce_dealloc_bond_grp();
 	hns_roce_cleanup_debugfs();
 }
 
-- 
2.53.0



