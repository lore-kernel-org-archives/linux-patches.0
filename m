Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE19B1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E38C433C1;
	Wed, 23 Nov 2022 09:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195450;
	bh=B6ZsIzFNVc1hIi1Xu/sy1XrxnPud0tnjwQVloDLXRCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlzvHHbEAlgsUTagGFxbaCgGjwuHK9qs6IZLUMPC1CtZV8WBxLs75Gcgt31bEBzN3
	 xNllD9aoHK4uRViP3Zy4pwqoKRjy2B6cxi+citi6pcGdfnxXTSuFYEVgqi8SKk9aLA
	 H0En6fPdePxIcLu7ccRtpitLVSJQc+orAkqKp3Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/149] ata: libata-transport: fix error handling in ata_tlink_add()
Date: Wed, 23 Nov 2022 09:50:43 +0100
Message-Id: <20221123084600.087753720@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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

[ Upstream commit cf0816f6322c5c37ee52655f928e91ecf32da103 ]

In ata_tlink_add(), the return value of transport_add_device() is
not checked. As a result, it causes null-ptr-deref while removing
the module, because transport_remove_device() is called to remove
the device that was not added.

Unable to handle kernel NULL pointer dereference at virtual address 00000000000000d0
CPU: 33 PID: 13850 Comm: rmmod Kdump: loaded Tainted: G        W          6.1.0-rc3+ #12
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : device_del+0x48/0x39c
lr : device_del+0x44/0x39c
Call trace:
 device_del+0x48/0x39c
 attribute_container_class_device_del+0x28/0x40
 transport_remove_classdev+0x60/0x7c
 attribute_container_device_trigger+0x118/0x120
 transport_remove_device+0x20/0x30
 ata_tlink_delete+0x88/0xb0 [libata]
 ata_tport_delete+0x2c/0x60 [libata]
 ata_port_detach+0x148/0x1b0 [libata]
 ata_pci_remove_one+0x50/0x80 [libata]
 ahci_remove_one+0x4c/0x8c [ahci]

Fix this by checking and handling return value of transport_add_device()
in ata_tlink_add().

Fixes: d9027470b886 ("[libata] Add ATA transport class")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-transport.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index da1b144d8288..e386e5f35015 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -428,7 +428,9 @@ int ata_tlink_add(struct ata_link *link)
 		goto tlink_err;
 	}
 
-	transport_add_device(dev);
+	error = transport_add_device(dev);
+	if (error)
+		goto tlink_transport_err;
 	transport_configure_device(dev);
 
 	ata_for_each_dev(ata_dev, link, ALL) {
@@ -443,6 +445,7 @@ int ata_tlink_add(struct ata_link *link)
 		ata_tdev_delete(ata_dev);
 	}
 	transport_remove_device(dev);
+  tlink_transport_err:
 	device_del(dev);
   tlink_err:
 	transport_destroy_device(dev);
-- 
2.35.1



