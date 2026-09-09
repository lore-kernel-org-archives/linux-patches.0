Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFE75616B5;
	Wed,  9 Sep 2026 13:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962391; cv=none; b=r7Y8eHgOF2gWO+Ety7JtJ0p65sLyNx01oeFf9kQuPgWmsa+NM1ozr4ckXmBplwujYpOp0l3s+scC05vutAz6aOkgA55A8+qVP00iYtD+Mh7QGeO+fEEMVQr7V2RqKXbqb3JXiTEGaEROlE2plfTLHKtGO3rMmTooRS0qGDEv56k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962391; c=relaxed/simple;
	bh=VZkhieDLoLil56nO4n3mnN3Nibi/HH3aTVXMkLwvQA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4EvWHmZ6e6B2Irto4923O2JhZLTeUfoIHMBrZ+r+6aqpBE7yYhzbyqyNXp0pr2EWADBoQONN7R4PofYeglThReBKZHQd9j/CFPwVYr80vH2qkY0WxNxm0Nlmxrq7k+5dTXI3Y7SxOVpVvmsB7AjCvWurZc/fTomCWTxa5wtsnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSzhnCGS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSzhnCGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772891F00A3A;
	Wed,  9 Sep 2026 13:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962390;
	bh=/xz6BTtJ3yyBXEZo9VYSyY45fS/lVMAd/NdFVwkS3CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSzhnCGS+757uHqK7zCjg6tt6zUYbBjqhClOn8kmQiCI26xeKGU7iVMZN25rUBlNn
	 WdDK0M4Fnlg3ed5sQc5yvmtfH0N+A5lmQ43zS7dDpDTjKxXqPSvST/Inz+a+Unyxsu
	 wSATq6djSAazjXtCO5BbBzG6C85MefxhMFUus0k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 274/556] iio: gyro: mpu3050: fix sign of raw angular velocity readings
Date: Wed,  9 Sep 2026 15:39:14 +0200
Message-ID: <20260909134240.255957994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


