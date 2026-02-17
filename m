Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2460027979A;
	Tue, 17 Feb 2026 20:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361166; cv=none; b=Cye7rkuPu1Ch10OnsNc9Paip54xGF7KjL5C2Jgk3dpMGNApJyHIkDKGiPsK9c3716wwAOLuE1FZJJkZw7gfnMa+KoKFH/4NbSQMl8IumLLf7CmLAcHVbvT24GOH10f4sDW38VJzgfM2haikiq95jLuWBdNfW1csPHp4nh1xr4qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361166; c=relaxed/simple;
	bh=QJK/62o5a1hr0QBT/qguKV/diaA21hfbgDFwO9OAWJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jt/Su7hhhvTGmVpqsIEEG9HoKQxjB5tO548scDu852oWxsbMvrEodZdayc4ttGhjQ/Yk7NZJ0XfGvzw/VEWJTvwZ174IQRhVAOuHkPQtrZYhf4vRKtsjjcJ3V6LQfRPY0o1FIgO4FF/icmQYMBpz5sRhizuF9yi+LXwcTBlaz2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxPZO3+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxPZO3+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39621C4CEF7;
	Tue, 17 Feb 2026 20:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361165;
	bh=QJK/62o5a1hr0QBT/qguKV/diaA21hfbgDFwO9OAWJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZxPZO3+KpBH1aO9f+dPuGf8+S7uuCWfFGjBycIZyOnWvV6uAeELCSn4r0HpzLRIgZ
	 bdjvd1k8Ed/Bngi1V3uqyEbEgPWK5QRiWnVpVDCYp/3jq4ccbgo8dyB7x9MGieOGPT
	 F25D6mKcnaPTHahebOw/dqO2jwjD2No7ct4RCOM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Song <liu.song13@zte.com.cn>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 20/64] PCI: endpoint: Avoid creating sub-groups asynchronously
Date: Tue, 17 Feb 2026 21:31:16 +0100
Message-ID: <20260217200008.275491024@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Song <liu.song13@zte.com.cn>

[ Upstream commit 7c5c7d06bd1f86d2c3ebe62be903a4ba42db4d2c ]

The asynchronous creation of sub-groups by a delayed work could lead to a
NULL pointer dereference when the driver directory is removed before the
work completes.

The crash can be easily reproduced with the following commands:

  # cd /sys/kernel/config/pci_ep/functions/pci_epf_test
  # for i in {1..20}; do mkdir test && rmdir test; done

  BUG: kernel NULL pointer dereference, address: 0000000000000088
  ...
  Call Trace:
   configfs_register_group+0x3d/0x190
   pci_epf_cfs_work+0x41/0x110
   process_one_work+0x18f/0x350
   worker_thread+0x25a/0x3a0

Fix this issue by using configfs_add_default_group() API which does not
have the deadlock problem as configfs_register_group() and does not require
the delayed work handler.

Fixes: e85a2d783762 ("PCI: endpoint: Add support in configfs to associate two EPCs with EPF")
Signed-off-by: Liu Song <liu.song13@zte.com.cn>
[mani: slightly reworded the description and added stable list]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@kernel.org
Link: https://patch.msgid.link/20250710143845409gLM6JdlwPhlHG9iX3F6jK@zte.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/endpoint/pci-ep-cfs.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/drivers/pci/endpoint/pci-ep-cfs.c
+++ b/drivers/pci/endpoint/pci-ep-cfs.c
@@ -23,7 +23,6 @@ struct pci_epf_group {
 	struct config_group group;
 	struct config_group primary_epc_group;
 	struct config_group secondary_epc_group;
-	struct delayed_work cfs_work;
 	struct pci_epf *epf;
 	int index;
 };
@@ -100,7 +99,7 @@ static struct config_group
 	secondary_epc_group = &epf_group->secondary_epc_group;
 	config_group_init_type_name(secondary_epc_group, "secondary",
 				    &pci_secondary_epc_type);
-	configfs_register_group(&epf_group->group, secondary_epc_group);
+	configfs_add_default_group(secondary_epc_group, &epf_group->group);
 
 	return secondary_epc_group;
 }
@@ -160,7 +159,7 @@ static struct config_group
 
 	config_group_init_type_name(primary_epc_group, "primary",
 				    &pci_primary_epc_type);
-	configfs_register_group(&epf_group->group, primary_epc_group);
+	configfs_add_default_group(primary_epc_group, &epf_group->group);
 
 	return primary_epc_group;
 }
@@ -522,15 +521,13 @@ static void pci_ep_cfs_add_type_group(st
 		return;
 	}
 
-	configfs_register_group(&epf_group->group, group);
+	configfs_add_default_group(group, &epf_group->group);
 }
 
-static void pci_epf_cfs_work(struct work_struct *work)
+static void pci_epf_cfs_add_sub_groups(struct pci_epf_group *epf_group)
 {
-	struct pci_epf_group *epf_group;
 	struct config_group *group;
 
-	epf_group = container_of(work, struct pci_epf_group, cfs_work.work);
 	group = pci_ep_cfs_add_primary_group(epf_group);
 	if (IS_ERR(group)) {
 		pr_err("failed to create 'primary' EPC interface\n");
@@ -589,9 +586,7 @@ static struct config_group *pci_epf_make
 
 	kfree(epf_name);
 
-	INIT_DELAYED_WORK(&epf_group->cfs_work, pci_epf_cfs_work);
-	queue_delayed_work(system_wq, &epf_group->cfs_work,
-			   msecs_to_jiffies(1));
+	pci_epf_cfs_add_sub_groups(epf_group);
 
 	return &epf_group->group;
 


