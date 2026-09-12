Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAAF3AC17;
	Sat, 12 Sep 2026 15:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228236; cv=none; b=AYJ0QZuYLOMAjIspPbr0f3hsZscK5O1vfzEs30cKGaSs9Der64YL7L6XZeIEqdIMCPwLJIAlTG7RUD5JKtzCrrQODqztfemUwCjMagguAhfheWejY43q0MutJe2teWYJdlEgVYRjq44z/bVyKeiJxr9Sb3VwuLcLiMf8NvesnI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228236; c=relaxed/simple;
	bh=KwsZXyo5+8TRIlvSeS6AOz5G0QxAnr5pu3CGRAeN648=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyIpo8A8c38oD0mu1dLIJbU7OjNWoFnWfBJrbWRzo0cjTLgbBp2XXBXpmIUJ1I1PscSKC6Z6Tg7v6Y91CIOPOdN3iyraaKWtlAOgAHL88lLC5e0Pywfvy1z6cHwFNbms8PmPrHv0CS2hA/AtZUuvPTOm+rqjv5xeqeADyQQiSSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9A++EvW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9A++EvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779241F000FF;
	Sat, 12 Sep 2026 15:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228235;
	bh=eIv+eq+3ceW4zVNGIaOMA33SYlshOAzlJT1wAVpIoZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T9A++EvWdn8QNdVmRSFtZdkkkwFdN8lntuXKL3IflCwYbl24RVs7m7NMwWYk9MUzs
	 /XrQcxCFqru8z4ohuKpWIsIUSV4CM4xOqvZVHykgxX+5JIaEeRXVvm1h389MWXZ5bN
	 QXOqIJ7w2L4Sjt5FnMIoyiX2oeNc71Rcn614o2aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0345/1191] iio: gyro: mpu3050: fix sign of raw angular velocity readings
Date: Sat, 12 Sep 2026 08:51:13 +0200
Message-ID: <20260912065555.976360416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


