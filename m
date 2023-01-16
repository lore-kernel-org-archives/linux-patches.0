Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AD46FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE1FC433EF;
	Mon, 16 Jan 2023 17:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888409;
	bh=Wsf48FTnFoc6MfWnMI1l+i377NIbwRaFcVgn8hx4Vtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqX9OApy4F8E+bKXdSpGU0EnBKE9S6pbqoQj5OKNoQehnQV2OECwWAyHO0QRB2BPw
	 TW+hzRpuBIlMBkt3x2FwOlWOSpc9tX8U7TW91saCUOJPtIc2SSAxupQc3u4w2Kc/vU
	 rbfUkrkj45ZFs4giNAZaIYuwbwydH0ZSvY4POWdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Ferry Toth <ftoth@exalondelft.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 490/521] usb: ulpi: defer ulpi_register on ulpi_read_id timeout
Date: Mon, 16 Jan 2023 16:52:32 +0100
Message-Id: <20230116154909.095775191@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ferry Toth <ftoth@exalondelft.nl>

[ Upstream commit 8a7b31d545d3a15f0e6f5984ae16f0ca4fd76aac ]

Since commit 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral
if extcon is present") Dual Role support on Intel Merrifield platform
broke due to rearranging the call to dwc3_get_extcon().

It appears to be caused by ulpi_read_id() on the first test write failing
with -ETIMEDOUT. Currently ulpi_read_id() expects to discover the phy via
DT when the test write fails and returns 0 in that case, even if DT does not
provide the phy. As a result usb probe completes without phy.

Make ulpi_read_id() return -ETIMEDOUT to its user if the first test write
fails. The user should then handle it appropriately. A follow up patch
will make dwc3_core_init() set -EPROBE_DEFER in this case and bail out.

Fixes: ef6a7bcfb01c ("usb: ulpi: Support device discovery via DT")
Cc: stable@vger.kernel.org
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
Link: https://lore.kernel.org/r/20221205201527.13525-2-ftoth@exalondelft.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/common/ulpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
index c42c152bbc33..94700c1d2f6e 100644
--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -207,7 +207,7 @@ static int ulpi_read_id(struct ulpi *ulpi)
 	/* Test the interface */
 	ret = ulpi_write(ulpi, ULPI_SCRATCH, 0xaa);
 	if (ret < 0)
-		goto err;
+		return ret;
 
 	ret = ulpi_read(ulpi, ULPI_SCRATCH);
 	if (ret < 0)
-- 
2.35.1



