Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED30A21D00A;
	Sat, 12 Sep 2026 11:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213759; cv=none; b=OWZXCT/BlgO4uBp5jxz1SnTI64Y9Q7axug14HKbKheHkv9GFtkE0AtVo9eEBXNhCJ7cufnDvoVT1UA8rQuSJ7tBmutuHOrNzbpPiUD+kHvMvsLW8AOSbN1TfvtghYqkFB1uIzjzOeNPkZaVdAuc7lxwIAui28/g74iKPypozGQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213759; c=relaxed/simple;
	bh=jg7EUknjExCgXy6Lo3kLgrOP/vjtOCzZFy+IP9UsHgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6Lgd9h8b0IaF/R0E82PPOuUS9p0dku+935AxfOiZGVFQsLI2ZexXYeBkEI14ba8zrRhQmPt9yTxyuCbQTOGFawjmdNZSY16ClqtZO9u69pCwYCHz3k3VflfYoDT5BPH5/FZZ9rgmIfYsQKruAr5M8/TFattFnvfCq7wJw4cW5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2HovzkM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2HovzkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B571F000FF;
	Sat, 12 Sep 2026 11:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213757;
	bh=mzr9qvujwKo5B6Zqng/o7gKaLbuiR+8XMfqAc/Vui3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w2HovzkMfumodrJvcE9pGVn89qCx5iIVgfZIVyXIbNHdKfmetICnWbIYHJ+wPcWYA
	 wkgi1UmquPMzUstdo+F5RBCLkY61BttJAAMqVVX81tvrUotsX29cdn4InDQTKHs54U
	 ftx7LbRIAWMZhhw5/eWaHx1y34sdC4pBfIiStWnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 0143/1376] iio: gyro: mpu3050: fix sign of raw angular velocity readings
Date: Sat, 12 Sep 2026 08:42:49 +0200
Message-ID: <20260912065610.740882044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

commit 06fab97602fe400bea843176f485bbac07a668e2 upstream.

The MPU-3050 gyroscope output registers hold 16-bit two's complement
values; the angular velocity channels are declared with .sign = 's'.
When mpu3050_read_raw() handles IIO_CHAN_INFO_RAW it reads the register
via a big-endian regmap_bulk_read() and assigns it with:

	*val = be16_to_cpu(raw_val);

be16_to_cpu() yields an unsigned 16-bit quantity, so negative rates
(bit 15 set) are reported to userspace as large positive integers
(e.g. -1 becomes 65535) instead of the correct negative value.

Cast to s16 before the assignment, matching the temperature channel a
few lines above which already handles the sign correctly.

Fixes: 3904b28efb2c ("iio: gyro: Add driver for the MPU-3050 gyroscope")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/mpu3050-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -356,7 +356,7 @@ static int mpu3050_read_raw(struct iio_d
 				goto out_read_raw_unlock;
 			}
 
-			*val = be16_to_cpu(raw_val);
+			*val = (s16)be16_to_cpu(raw_val);
 			ret = IIO_VAL_INT;
 
 			goto out_read_raw_unlock;


