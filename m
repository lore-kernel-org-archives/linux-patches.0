Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9657A24678E;
	Mon, 23 Jun 2025 13:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685026; cv=none; b=swuyvjXc0eLiKBG7xSio6+5ucl+jEh1dg1MmSWr49pBFSClARaN9FgfBRHLf/A7Cd/uA8I95wa+etRReYhTYJD9Bc/NEZUerRfoI6k1yJDY4pVJM/+xlBr6WuBbv9vCET5UHapwvAEtUx1JRJJ1IE0rHiuhm8DWGWSA9NrSqvus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685026; c=relaxed/simple;
	bh=55fnX2XtS+vfdMxD3qoZ8gBLrYup7p8/G7IIZ3E/YHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qo6d72AbrlIuMQ3h0Jx15hlnLhPE4T8CkT7k7Hhdl2t4MUm5LeIM7u2p5F4LQmUU+0lUqnf7yKHMaTLRsaQkdxWIE5NMHSXasplfjzgIgMFh91cy7aHYfLOY+rbrNwrW+Qgg1NcHNEuNzFNJhybW9IAskbsamGUmtNN75g0A9Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhwhgSe1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhwhgSe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22350C4CEEA;
	Mon, 23 Jun 2025 13:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685026;
	bh=55fnX2XtS+vfdMxD3qoZ8gBLrYup7p8/G7IIZ3E/YHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhwhgSe1qCAZqO61GvT2m3omty6l9sakdBa3aMRp0X1xEA9M4LWjRYosbqYGVIn4r
	 zmnoqgnQ9E9UxStbMCq2KjW60NlHmSH30gy/PNtxbs1inXE851uamWOYkT9jUt0yEp
	 gg0U9n4TroAhG5Q4WqYwkiJm6kqUwQMKc1k1A3oA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Angelo Dureghello <adureghello@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.15 203/592] iio: adc: ad7606_spi: fix reg write value mask
Date: Mon, 23 Jun 2025 15:02:41 +0200
Message-ID: <20250623130705.117413223@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -155,7 +155,7 @@ static int ad7606_spi_reg_write(struct a
 	struct spi_device *spi = to_spi_device(st->dev);
 
 	st->d16[0] = cpu_to_be16((st->bops->rd_wr_cmd(addr, 1) << 8) |
-				  (val & 0x1FF));
+				  (val & 0xFF));
 
 	return spi_write(spi, &st->d16[0], sizeof(st->d16[0]));
 }


