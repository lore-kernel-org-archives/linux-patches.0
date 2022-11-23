Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9B21C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5718CC433C1;
	Wed, 23 Nov 2022 09:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195928;
	bh=oWs3w9zt/d0RNVKLhNxAd9+8zd5bWXyzfBcS66LyqMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGTtel7FNl65/smiCr0OJRNkJBxBuQV8B0HW2iiy9+9uSWkjfMzEr15vgOoDWPvBP
	 ZBjKv/LD1owwaBNV3DKt6yIKdd3s4Zg9DtfsdR1R4/RgodeVWsbVH6sRVdm3Jj6rT8
	 pyrzOb81a0x6Ka00E05fGA8WMTABVKZ5nRI9/tD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/181] ata: libata-transport: fix error handling in ata_tport_add()
Date: Wed, 23 Nov 2022 09:50:35 +0100
Message-Id: <20221123084605.470956531@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 3613dbe3909dcc637fe6be00e4dc43b4aa0470ee ]

In ata_tport_add(), the return value of transport_add_device() is
not checked. As a result, it causes null-ptr-deref while removing
the module, because transport_remove_device() is called to remove
the device that was not added.

Unable to handle kernel NULL pointer dereference at virtual address 00000000000000d0
CPU: 12 PID: 13605 Comm: rmmod Kdump: loaded Tainted: G        W          6.1.0-rc3+ #8
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : device_del+0x48/0x39c
lr : device_del+0x44/0x39c
Call trace:
 device_del+0x48/0x39c
 attribute_container_class_device_del+0x28/0x40
 transport_remove_classdev+0x60/0x7c
 attribute_container_device_trigger+0x118/0x120
 transport_remove_device+0x20/0x30
 ata_tport_delete+0x34/0x60 [libata]
 ata_port_detach+0x148/0x1b0 [libata]
 ata_pci_remove_one+0x50/0x80 [libata]
 ahci_remove_one+0x4c/0x8c [ahci]

Fix this by checking and handling return value of transport_add_device()
in ata_tport_add().

Fixes: d9027470b886 ("[libata] Add ATA transport class")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-transport.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index 2b1e3403570c..3dd3b2543086 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -301,7 +301,9 @@ int ata_tport_add(struct device *parent,
 	pm_runtime_enable(dev);
 	pm_runtime_forbid(dev);
 
-	transport_add_device(dev);
+	error = transport_add_device(dev);
+	if (error)
+		goto tport_transport_add_err;
 	transport_configure_device(dev);
 
 	error = ata_tlink_add(&ap->link);
@@ -312,6 +314,7 @@ int ata_tport_add(struct device *parent,
 
  tport_link_err:
 	transport_remove_device(dev);
+ tport_transport_add_err:
 	device_del(dev);
 
  tport_err:
-- 
2.35.1



