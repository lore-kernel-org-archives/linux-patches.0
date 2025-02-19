Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784481A841F;
	Wed, 19 Feb 2025 08:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955511; cv=none; b=d8Qv+p7T8p+zXcttlct/mnOg0Pjk6QbS12D6E681Kve7jrK4g+S6vQIralcjouukIKXVw5SdHNrsQp+O5ryCqesXXSPgT2b4eh03MxMDm876fpp1KGuG0duPksF+VKv7gE7mDZqaFIwta1pr4GTg9Kb00XajTSVlXoILBmsMBXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955511; c=relaxed/simple;
	bh=dG3WPuJGNl/djPjBEDjbqqomI2+oSbIJ0+LbugfMNoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmeuHKbeUiBx8RxrJxY38Vl0lDHq4csV2YPJf6LNc+0TC3SUsoZIrEBm0NAGnKAzdDitEovbQpSztLTFhHx7eNdibTACaOx72shJIBQhWv6seYcNINgnd5t2ingZLNIfvUkeyVNZUca9YM3siEE8Q97GQrNO5ijxoDgzoEdp2Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaCLc/6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaCLc/6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB68C4CEE6;
	Wed, 19 Feb 2025 08:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955511;
	bh=dG3WPuJGNl/djPjBEDjbqqomI2+oSbIJ0+LbugfMNoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaCLc/6wZBAzBp/3zQrHMmEWBPcZ4ExkPxMWb+DwD1ZDTjnZ5t0E5gnMuE0I2kgyX
	 694odN+CKch55nMDS0lRFKnui72j1xJEq070dzl5IuCnEqTiaKFm9omi2o/vT36Uf8
	 ZVukMQ9RpmZsBm+19wENnZz9a86fC/tK+rjZ4kg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Ito <ito.kohei@socionext.com>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/152] spi: sn-f-ospi: Fix division by zero
Date: Wed, 19 Feb 2025 09:26:59 +0100
Message-ID: <20250219082550.277119781@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 3588b1c0fde2f58d166e3f94a5a58d64b893526c ]

When there is no dummy cycle in the spi-nor commands, both dummy bus cycle
bytes and width are zero. Because of the cpu's warning when divided by
zero, the warning should be avoided. Return just zero to avoid such
calculations.

Fixes: 1b74dd64c861 ("spi: Add Socionext F_OSPI SPI flash controller driver")
Co-developed-by: Kohei Ito <ito.kohei@socionext.com>
Signed-off-by: Kohei Ito <ito.kohei@socionext.com>
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://patch.msgid.link/20250206085747.3834148-1-hayashi.kunihiko@socionext.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sn-f-ospi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-sn-f-ospi.c b/drivers/spi/spi-sn-f-ospi.c
index a7c3b3923b4af..fd8c8eb37d01d 100644
--- a/drivers/spi/spi-sn-f-ospi.c
+++ b/drivers/spi/spi-sn-f-ospi.c
@@ -116,6 +116,9 @@ struct f_ospi {
 
 static u32 f_ospi_get_dummy_cycle(const struct spi_mem_op *op)
 {
+	if (!op->dummy.nbytes)
+		return 0;
+
 	return (op->dummy.nbytes * 8) / op->dummy.buswidth;
 }
 
-- 
2.39.5



