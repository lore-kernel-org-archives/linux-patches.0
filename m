Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D603715C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57505C433D6;
	Mon,  5 Dec 2022 19:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267649;
	bh=sUnxPNt+OUIRNGT3wcmqfqSUUtRuBhbbQTJ4YAUVwJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zeybyqJZdYjbw/MPrfILzL+bbI1oOytWlguQLWKMwhtUmeipoZwNuSAeL/sbjt2BG
	 uivpr4BAufgZC64k+px57TEXlUeJYqc7GyPcBDCjgnPYbGqtXxeRJMDeUJnmSRuj5e
	 msl/0UW/pcSYfEpDU62DqA4WCm8+eAMFGMjxKXQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 46/62] hwmon: (coretemp) fix pci device refcount leak in nv1a_ram_new()
Date: Mon,  5 Dec 2022 20:09:43 +0100
Message-Id: <20221205190759.834769455@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190758.073114639@linuxfoundation.org>
References: <20221205190758.073114639@linuxfoundation.org>
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

[ Upstream commit 7dec14537c5906b8bf40fd6fd6d9c3850f8df11d ]

As comment of pci_get_domain_bus_and_slot() says, it returns
a pci device with refcount increment, when finish using it,
the caller must decrement the reference count by calling
pci_dev_put(). So call it after using to avoid refcount leak.

Fixes: 14513ee696a0 ("hwmon: (coretemp) Use PCI host bridge ID to identify CPU if necessary")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221118093303.214163-1-yangyingliang@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 9e81842cff7d..7e796d68e23a 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -256,10 +256,13 @@ static int adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
 	 */
 	if (host_bridge && host_bridge->vendor == PCI_VENDOR_ID_INTEL) {
 		for (i = 0; i < ARRAY_SIZE(tjmax_pci_table); i++) {
-			if (host_bridge->device == tjmax_pci_table[i].device)
+			if (host_bridge->device == tjmax_pci_table[i].device) {
+				pci_dev_put(host_bridge);
 				return tjmax_pci_table[i].tjmax;
+			}
 		}
 	}
+	pci_dev_put(host_bridge);
 
 	for (i = 0; i < ARRAY_SIZE(tjmax_table); i++) {
 		if (strstr(c->x86_model_id, tjmax_table[i].id))
-- 
2.35.1



