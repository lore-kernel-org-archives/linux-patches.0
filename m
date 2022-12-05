Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735CF15C8A
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC231C433C1;
	Mon,  5 Dec 2022 19:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269316;
	bh=sWDEPS+XE4uOFWcJtdcBoXCYmrmL3IBAeODrz+tNdqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVaQwe6cHCVc901YLrkZBEX5KKW0Li/Bt5dTfGusvq9KTK5Y+IpCyETDJeyPU0GiB
	 4JO+ewbAAOOD9ss8pxQlC0stYYU3F5ITqAqFUII0MAQfmuz7/sykL7aSpVT2NBrTJQ
	 CbYud/vJCx4EQ9L40Rra30z/lKibQkiDQQscTBlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Rudolph <patrick.rudolph@9elements.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/153] firmware: google: Release devices before unregistering the bus
Date: Mon,  5 Dec 2022 20:09:39 +0100
Message-Id: <20221205190810.299562429@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Patrick Rudolph <patrick.rudolph@9elements.com>

[ Upstream commit cae0970ee9c4527f189aac378c50e2f0ed020418 ]

Fix a bug where the kernel module can't be loaded after it has been
unloaded as the devices are still present and conflicting with the
to be created coreboot devices.

Signed-off-by: Patrick Rudolph <patrick.rudolph@9elements.com>
Link: https://lore.kernel.org/r/20191118101934.22526-2-patrick.rudolph@9elements.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 65946690ed8d ("firmware: coreboot: Register bus in module init")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/google/coreboot_table.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/firmware/google/coreboot_table.c b/drivers/firmware/google/coreboot_table.c
index 8d132e4f008a..0205987a4fd4 100644
--- a/drivers/firmware/google/coreboot_table.c
+++ b/drivers/firmware/google/coreboot_table.c
@@ -163,8 +163,15 @@ static int coreboot_table_probe(struct platform_device *pdev)
 	return ret;
 }
 
+static int __cb_dev_unregister(struct device *dev, void *dummy)
+{
+	device_unregister(dev);
+	return 0;
+}
+
 static int coreboot_table_remove(struct platform_device *pdev)
 {
+	bus_for_each_dev(&coreboot_bus_type, NULL, NULL, __cb_dev_unregister);
 	bus_unregister(&coreboot_bus_type);
 	return 0;
 }
-- 
2.35.1



