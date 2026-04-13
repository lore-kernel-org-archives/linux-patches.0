Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7227424E4A1;
	Mon, 13 Apr 2026 16:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098494; cv=none; b=E9FT2r8ujo/cNSRpaeaTB0sbTAHGJFysrf6MqAkdOSysblgtHPoPN2aeYS4oF/6pik9AtGSwUJ3eEpRP+0wK3TNKDslNDSu4BEaq+lm79Suv9jg0wspZ9y/m4kqBjs4pX6AsvCnvcv/m9lVz23G8mcPhiRn/t2LQlYF7wXEXspc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098494; c=relaxed/simple;
	bh=Oqwl8CPCGIiNim+vhxSUIy7M7sOMOlkP4e6dlNKLs1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IeRe4Dh38FSzBGnsjw2//EGVj/bpno2fdixAi2jUpeq/P1NpX8z1/C/nmLcncmlAYGb0RztEsrYEbgRHyB+Z6wzlws5Ty7NnzEY1ZiUngWb0FCj05PnHr3OiGOx6wgcW9aCMqyTf7BdlPgtBZ9KLbf9QLn6MTAWsp+nuxztjrcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2S0hpIox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2S0hpIox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037F1C2BCAF;
	Mon, 13 Apr 2026 16:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098494;
	bh=Oqwl8CPCGIiNim+vhxSUIy7M7sOMOlkP4e6dlNKLs1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2S0hpIoxuMcKERbciKt+Qiy3y63J1rd+Kq0mK1qr0SYlMS1QQOkpQYO+H7SZtgupG
	 1YBw99KYbnluoZmAP48KLMfziqeKVrWVTJaoMTVUT3ehCxmNQYmzrkEJrflxMCLwYc
	 9/cBkDDpNqPyKJ6grTsnOtJ44O2+qPjv9zK/CVSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Zicheng Qu <quzicheng@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Robert Garcia <rob_garcia@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 514/570] iio: adc: ad7923: Fix buffer overflow for tx_buf and ring_xfer
Date: Mon, 13 Apr 2026 18:00:45 +0200
Message-ID: <20260413155849.702805105@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit 3a4187ec454e19903fd15f6e1825a4b84e59a4cd ]

The AD7923 was updated to support devices with 8 channels, but the size
of tx_buf and ring_xfer was not increased accordingly, leading to a
potential buffer overflow in ad7923_update_scan_mode().

Fixes: 851644a60d20 ("iio: adc: ad7923: Add support for the ad7908/ad7918/ad7928")
Cc: stable@vger.kernel.org
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Link: https://patch.msgid.link/20241029134637.2261336-1-quzicheng@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[ Context change fixed. ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7923.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ad7923.c b/drivers/iio/adc/ad7923.c
index b8cc94b7dd80a..a8e59fd2dcf3c 100644
--- a/drivers/iio/adc/ad7923.c
+++ b/drivers/iio/adc/ad7923.c
@@ -47,7 +47,7 @@
 
 struct ad7923_state {
 	struct spi_device		*spi;
-	struct spi_transfer		ring_xfer[5];
+	struct spi_transfer		ring_xfer[9];
 	struct spi_transfer		scan_single_xfer[2];
 	struct spi_message		ring_msg;
 	struct spi_message		scan_single_msg;
@@ -63,7 +63,7 @@ struct ad7923_state {
 	 * Length = 8 channels + 4 extra for 8 byte timestamp
 	 */
 	__be16				rx_buf[12] ____cacheline_aligned;
-	__be16				tx_buf[4];
+	__be16				tx_buf[8];
 };
 
 struct ad7923_chip_info {
-- 
2.53.0



