Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B9A1C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A55BC433D7;
	Wed, 23 Nov 2022 09:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194103;
	bh=hiLYMyPW2D4iP5KTP6ogPeDTfnXA+eY98B09LNN8qsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZ+JVEsWcxEyCK3xccezkDy4wFurUrZ/qpaUNZeQxtJIkdDNdcMv+NVcGHgDx3MfN
	 Pp8cXabR8OEkXF7C8sQA3jRey9Ympl+PswVGgLnmI1nBXgVTknvBnr4s8GBv6sj8Bk
	 1oCHi9MLF9LD5WMY1MUOA+CsjVMPX4/5drLhH48M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 72/88] mmc: sdhci-pci: Fix possible memory leak caused by missing pci_dev_put()
Date: Wed, 23 Nov 2022 09:51:09 +0100
Message-Id: <20221123084551.159993125@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
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
@@ -1277,6 +1277,8 @@ static int amd_probe(struct sdhci_pci_ch
 		}
 	}
 
+	pci_dev_put(smbus_dev);
+
 	if (gen == AMD_CHIPSET_BEFORE_ML || gen == AMD_CHIPSET_CZ)
 		chip->quirks2 |= SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD;
 


