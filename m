Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B536E296FBC;
	Mon, 12 May 2025 18:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073576; cv=none; b=HMsZLGI0EvOGBZJY6GHjnNYGXPP82nWEgiQfeJhRDyaITxxPjGpt7G4HBQcri2MvlrZWqUOpJSt+VV4zP0nRlzNSrU5cOrRA9h1Sn6pnkliNMEvY4wJAr+A9fLQS+yE7xqfYZPnYG7MLpcoeoH/SJQfi0Wr/S5jHeuzQLp1/rMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073576; c=relaxed/simple;
	bh=CXSxlSmtTUCJV8FjDRHQd2DiNeTBbqFNgkUcMQf0gto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FigymIzzMGRbeD41XUEyPnPRh/RItjO8ZCt89jLDeZVwHF3UrUFxmLfJq+5yeTazT3J4Z3vNFRyi2ubwV6Mrdme2AymX8O+eUNaKUTdw+kvAJpIUF3xp4TSEHTDfIghuqqyigAxKP0RQiw1MyWQtAKlIMyDoRJVqy9hWiR3ysRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxTfDKmi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxTfDKmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA2BC4CEE9;
	Mon, 12 May 2025 18:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073576;
	bh=CXSxlSmtTUCJV8FjDRHQd2DiNeTBbqFNgkUcMQf0gto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxTfDKmiwsHrYkgq8cgdGJcor6jx3iT0o1YjzIUj3PQlooCyg3jiEXdirZu+52yBV
	 kgWwjrRp3ChHtF7FUGMTt4SaYEjnyvyacKFbziLU0IWiBRp1GhhI3Ul6UEGvdaEHAX
	 7NBb9iQKPR/ZtWFcbNjiCqP3zS6vyvzaswhiRlWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/113] iio: temp: maxim-thermocouple: Fix potential lack of DMA safe buffer.
Date: Mon, 12 May 2025 19:46:09 +0200
Message-ID: <20250512172030.941256040@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



