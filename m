Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FED31E5B71;
	Mon, 23 Jun 2025 21:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714187; cv=none; b=XDeyau8dZ9eR+dcwzFHzmGN1w+GHjegHPR+gjiaa9V34XdDWEBB37T6HhdKXnposqGMKmjSz2RA2sOPj01R5faZSdumHOTrvop1W47L7iTjhgzCXEMpn45UMhIUcIfeIAcSEMRT8ngOiXET3nrr/67FGqW2NYrT+gd5PuWpEpnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714187; c=relaxed/simple;
	bh=0t4Yl9+7i26pnsVytwoiacGZRAKb8tXusMArdJt7/P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXo9wTTUkI4TSh/IniUzuu9Sn3SHWtpTe4M7A65EKvTYMIDXabK6fYSmL0adW9UG3FyW4KsXytBvSd7NPzilZ5L+3w8Ho5hEsBsy04AAshkvoxNPnsfNreQXxaLlP5HFksg6Ag91wMEvYNlOJwutApsPVc+HO+3Q0Bhb/OegmIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXLGqrOT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXLGqrOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA5DC4CEEA;
	Mon, 23 Jun 2025 21:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714186;
	bh=0t4Yl9+7i26pnsVytwoiacGZRAKb8tXusMArdJt7/P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXLGqrOThwc3hHulobO96+B3VIn6wPpZyPRfp2UdZZOlNJ8GzTn5yCFqQJ6+kIPIm
	 e17KILNJ1sTk8/5ckUufXkdHeCyw0xyKFbNsAmXuTMnwLPYmqmG6vZgF+wsL5aEcXh
	 cIyKfAr5c7lhnoxEyP0k4PeTmnRk8lAQsVkcTVFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Angelo Dureghello <adureghello@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 211/355] iio: adc: ad7606_spi: fix reg write value mask
Date: Mon, 23 Jun 2025 15:06:52 +0200
Message-ID: <20250623130633.086937868@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 89944d88f8795c6c89b9514cb365998145511cd4 upstream.

Fix incorrect value mask for register write. Register values are 8-bit,
not 9. If this function was called with a value > 0xFF and an even addr,
it would cause writing to the next register.

Fixes: f2a22e1e172f ("iio: adc: ad7606: Add support for software mode for ad7616")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Angelo Dureghello <adureghello@baylibre.com>
Link: https://patch.msgid.link/20250428-iio-adc-ad7606_spi-fix-write-value-mask-v1-1-a2d5e85a809f@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7606_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7606_spi.c
+++ b/drivers/iio/adc/ad7606_spi.c
@@ -151,7 +151,7 @@ static int ad7606_spi_reg_write(struct a
 	struct spi_device *spi = to_spi_device(st->dev);
 
 	st->d16[0] = cpu_to_be16((st->bops->rd_wr_cmd(addr, 1) << 8) |
-				  (val & 0x1FF));
+				  (val & 0xFF));
 
 	return spi_write(spi, &st->d16[0], sizeof(st->d16[0]));
 }


