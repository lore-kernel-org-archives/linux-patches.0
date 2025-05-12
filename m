Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3D31A08CA;
	Mon, 12 May 2025 17:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072598; cv=none; b=Yl5N902I/8j/WkUXGahJh8U6LSidr9fZXfpAXSQ1KOPrsLQcWCjFUzR6WVwm90bTqx7vspZdF0p46bt8/7+bzV4Kc3k3QvhamOwFHnpHil4jbjxXQrOyjdpgUeMEoCNUn8mmA9TaxQKY7yoQveYhDQCyXtZWSNgRg4KF4Krj1O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072598; c=relaxed/simple;
	bh=Gos3MNTNq/1HDa+HzwWXzrgZjKyOUPvbxLeWHrn6B3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCB+pMWUmTtbFNZkUpu7CYscBRd5gh93ysh41ol2Op9zRWeQtGinO0h71Og7une84FnkKMA6wLqA9SO3ZFL0ysUUUjvJkA2D/S2j3QA55Suh6tZ/ArsIlEfIMiClwbGCTLEJRv69mVP6w7y5G89R1K1A5srdyo5FsfrCkCuMSuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qf5oFZZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qf5oFZZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BBAC4CEE7;
	Mon, 12 May 2025 17:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072597;
	bh=Gos3MNTNq/1HDa+HzwWXzrgZjKyOUPvbxLeWHrn6B3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qf5oFZZnsXMi5AQLv8T12Z6t+G9g9FXrEIecoTYKYYaswG543yImxqOAJ8ajoAfXa
	 UKZ7P0NPRhm8Oeq4doXznilatlDOa0v93BfMV9cAsJUetbVLbrD29qSnuC3OqfIKc9
	 PKBO6LYvMSGHOd+QZH5YvFjPT++kt2Nni4Rg3KV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 61/92] iio: temp: maxim-thermocouple: Fix potential lack of DMA safe buffer.
Date: Mon, 12 May 2025 19:45:36 +0200
Message-ID: <20250512172025.598260229@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



