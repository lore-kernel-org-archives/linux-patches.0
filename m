Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7452686BC;
	Tue,  8 Apr 2025 12:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115295; cv=none; b=KPq71HB6i+uVC23MBZwM6zuSH3X8RvkPI9OjPpYT25aysnHkCETIDtE0SwLLquOIEPuUJkpm005xe98lKYLGKC6Fn1S6dvescyn0PMfjMyvuQyuFpclQa+joU1+ulsXwr7Xb0IRDQn2RX6ZmfxQ+3YmpMpLq1kQ2hBFYVvEAnoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115295; c=relaxed/simple;
	bh=iBlf7nxA1bn3MLcMnWLhMRqW7Ylod0jAUMZG+n8kpNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1ToMhBfMB8eiqd/juTMbjgnmy/3WWeQFxfuhRE7NBB/UrVNqEgigxdlmxlYSIZnbnfrrpQvQVkUb8DCZNr4UFIwQ4IQAgKi4/6judGgv8E3Yfcv5Ouz0ma7AM6iNowLGf+bemgiqe4AF0aMzD4vjuppUJQi4t3gWtrKlOmqp74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9gBNMl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9gBNMl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2A9C4CEE7;
	Tue,  8 Apr 2025 12:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115295;
	bh=iBlf7nxA1bn3MLcMnWLhMRqW7Ylod0jAUMZG+n8kpNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9gBNMl0MfbhCQ6Iic300A2PzjF6GyBemEcM0rj9nEl3k2HkIlxaNLjOa8/QUhG3b
	 ojkaLszY5wP3V6AQuwpxDw5r6/l5+CZAoTIQLWIMPH5ZZa2UhXEwJeVABRl69jsli0
	 wQJeiugHdUeZoSScv7UYGkcSPIINVvPT+0AHEQf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nihar Chaithanya <niharchaithanya@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 419/499] staging: gpib: Modify gpib_register_driver() to return error if it fails
Date: Tue,  8 Apr 2025 12:50:31 +0200
Message-ID: <20250408104901.676857095@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nihar Chaithanya <niharchaithanya@gmail.com>

[ Upstream commit e999bd2a897e7d70fa1fca6b80873529532322fe ]

The function gpib_register_driver() can fail if kmalloc() fails,
but it doesn't return any error if that happens.

Modify the function to return error i.e int. Return the appropriate
error code if it fails. Remove the pr_info() statement.

Signed-off-by: Nihar Chaithanya <niharchaithanya@gmail.com>
Link: https://lore.kernel.org/r/20241230185633.175690-2-niharchaithanya@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a239c6e91b66 ("staging: gpib: Fix Oops after disconnect in ni_usb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/common/gpib_os.c | 7 ++++---
 drivers/staging/gpib/include/gpibP.h  | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/gpib/common/gpib_os.c b/drivers/staging/gpib/common/gpib_os.c
index 0962729d7dfef..982a2fe68cf2a 100644
--- a/drivers/staging/gpib/common/gpib_os.c
+++ b/drivers/staging/gpib/common/gpib_os.c
@@ -2044,18 +2044,19 @@ void init_gpib_descriptor(gpib_descriptor_t *desc)
 	atomic_set(&desc->io_in_progress, 0);
 }
 
-void gpib_register_driver(gpib_interface_t *interface, struct module *provider_module)
+int gpib_register_driver(gpib_interface_t *interface, struct module *provider_module)
 {
 	struct gpib_interface_list_struct *entry;
 
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
-		return;
+		return -ENOMEM;
 
 	entry->interface = interface;
 	entry->module = provider_module;
 	list_add(&entry->list, &registered_drivers);
-	pr_info("gpib: registered %s interface\n", interface->name);
+
+	return 0;
 }
 EXPORT_SYMBOL(gpib_register_driver);
 
diff --git a/drivers/staging/gpib/include/gpibP.h b/drivers/staging/gpib/include/gpibP.h
index b97da577ba332..d35fdd391f7e1 100644
--- a/drivers/staging/gpib/include/gpibP.h
+++ b/drivers/staging/gpib/include/gpibP.h
@@ -18,7 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 
-void gpib_register_driver(gpib_interface_t *interface, struct module *mod);
+int gpib_register_driver(gpib_interface_t *interface, struct module *mod);
 void gpib_unregister_driver(gpib_interface_t *interface);
 struct pci_dev *gpib_pci_get_device(const gpib_board_config_t *config, unsigned int vendor_id,
 				    unsigned int device_id, struct pci_dev *from);
-- 
2.39.5



