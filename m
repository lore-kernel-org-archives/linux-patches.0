Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD371C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E2FC433C1;
	Wed, 23 Nov 2022 09:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194505;
	bh=TDWJo+/Q0HmTyJ5NlMkhdnd/YOSlhX4ihMxZwGXkQv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDCoIvNBcH/gzO75/dH64+Whs05schwthwHLQXuIL0+yVmWb472+f2p5Z8oVYB2Ym
	 MMo9QhNzAdi8k0mDDE+Ei/x3m6WS2WBSAQoWZcS+hfJFoqCoHBuy9azh/OEs9ms5i2
	 eyOAjcgy7bL7fcEckDeNj56vZe94nUPp0prYwQbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 096/114] mmc: sdhci-pci: Fix possible memory leak caused by missing pci_dev_put()
Date: Wed, 23 Nov 2022 09:51:23 +0100
Message-Id: <20221123084555.619688271@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

commit 222cfa0118aa68687ace74aab8fdf77ce8fbd7e6 upstream.

pci_get_device() will increase the reference count for the returned
pci_dev. We need to use pci_dev_put() to decrease the reference count
before amd_probe() returns. There is no problem for the 'smbus_dev ==
NULL' branch because pci_dev_put() can also handle the NULL input
parameter case.

Fixes: 659c9bc114a8 ("mmc: sdhci-pci: Build o2micro support in the same module")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221114083100.149200-1-wangxiongfeng2@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -1532,6 +1532,8 @@ static int amd_probe(struct sdhci_pci_ch
 		}
 	}
 
+	pci_dev_put(smbus_dev);
+
 	if (gen == AMD_CHIPSET_BEFORE_ML || gen == AMD_CHIPSET_CZ)
 		chip->quirks2 |= SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD;
 


