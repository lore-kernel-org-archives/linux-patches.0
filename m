Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3068F2BDC00;
	Mon, 12 May 2025 18:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073121; cv=none; b=bKGA6dr8meYdjJcpJECH26BAsLyxH8tuyD1j6E7F6JwrMpxXdyFvzBrzR3rwmTl6VhzUU7aYc+c97gQjIsVGciso5h7fP0csJPC+V17bWE+JUaF9MB/hXJrus+B76jFgjzavbCA+4kdEb++o7+qdvLPz7nHLJBAYQ97YKOsYcFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073121; c=relaxed/simple;
	bh=ayWXNut7kRPcCdLbA1V3GVsMyKB9l1gP9VuhI2Ht4pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxKW4F/lkbSJ1aBNCus1LrOt8mamhxR0sqfnuC+OT+ZeoPIgKCe+uB34sQ/vMSg0TDAw76G2ytR0Gcb9jJrYkegNqJI7PWjwFuh3HiZsJzBljdEwC1JALtJOa0hfQKocuHLBR7NEyKALH9PsmAbENIdKrA3A7UL/g/QRoW3PYw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DacDPgmU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DacDPgmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCE9C4CEF0;
	Mon, 12 May 2025 18:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073120;
	bh=ayWXNut7kRPcCdLbA1V3GVsMyKB9l1gP9VuhI2Ht4pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DacDPgmU7g2gKIRlsDgcch8ay8YUlwUuhzsErTMyBtLCNjYUFaTWDhmbhATToWYTV
	 ufua0ityZykOaiXPcAnfbFFq8/Vq98k8QbOnmIX87al8G7DsxptwXSO96aSkRy23QV
	 ajvMUTpU9IHsxB1YCp/G9iesGtQSh8fualQEA/8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 131/184] iio: temp: maxim-thermocouple: Fix potential lack of DMA safe buffer.
Date: Mon, 12 May 2025 19:45:32 +0200
Message-ID: <20250512172047.152302948@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit f79aeb6c631b57395f37acbfbe59727e355a714c ]

The trick of using __aligned(IIO_DMA_MINALIGN) ensures that there is
no overlap between buffers used for DMA and those used for driver
state storage that are before the marking. It doesn't ensure
anything above state variables found after the marking. Hence
move this particular bit of state earlier in the structure.

Fixes: 10897f34309b ("iio: temp: maxim_thermocouple: Fix alignment for DMA safety")
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250413103443.2420727-14-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/temperature/maxim_thermocouple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/temperature/maxim_thermocouple.c b/drivers/iio/temperature/maxim_thermocouple.c
index c28a7a6dea5f1..555a61e2f3fdd 100644
--- a/drivers/iio/temperature/maxim_thermocouple.c
+++ b/drivers/iio/temperature/maxim_thermocouple.c
@@ -121,9 +121,9 @@ static const struct maxim_thermocouple_chip maxim_thermocouple_chips[] = {
 struct maxim_thermocouple_data {
 	struct spi_device *spi;
 	const struct maxim_thermocouple_chip *chip;
+	char tc_type;
 
 	u8 buffer[16] __aligned(IIO_DMA_MINALIGN);
-	char tc_type;
 };
 
 static int maxim_thermocouple_read(struct maxim_thermocouple_data *data,
-- 
2.39.5



