Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFFA1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6D6C433D6;
	Wed, 23 Nov 2022 09:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196983;
	bh=NeKT4+ypP7mG+tJLszxiDLdC1jNFhcN2r7sRWpRO9M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=071cz1b5fPGvfaXQykYdFgvjySQPXwTFQ17ce6rZoSXCUom8CH//d+qhcCZzNrAv0
	 etVjtMKsnMbVwXmsCv4H468ClueEDma4fdBMyepW5nEfABgvGHbiSro8LbCfFO7WLH
	 Qsf++vsPeFarPKWH7xv9y2G/QRy3vCJ2NfCAyWnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 138/314] ata: libata-transport: fix error handling in ata_tport_add()
Date: Wed, 23 Nov 2022 09:49:43 +0100
Message-Id: <20221123084631.793569349@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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
index 105da3ec5eaa..ef53bdfbcbb2 100644
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



