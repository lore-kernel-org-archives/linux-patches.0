Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A869257855;
	Sun,  7 Jun 2026 10:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828491; cv=none; b=WiITw/xrPBC7cI7Paw1nLUmjvZy4JaOR5PcsIKPM3g7Yky+a0oE53Qa0FSyBhd3xiM01uqTcdkJ/5/4SAumV16s1R5EwzZZ1lhDfXudPjNyb/zGDDYMS4WUIKsXtDbbXaSFoL5hOhPODGnfPVkSMq0gTiD8oPK/4UqIDSt2K6Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828491; c=relaxed/simple;
	bh=3MDJpL8LPAsucxdLhf5yVasN3vYZQyQ1bxlPCcVGlDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+X5fQA/EgrTc3KrD8LClw5UCeU0EY9xi20qiOWF1jX2iYSZ+Qf7hNIJ+R3wrABGgAUpamfiK01AY9hYrzdyUlGLeRetPJqGWLfJv1oSgWIEcTBCHqwz7V0Clehh3PJqYsRVqQ2TadgbGXvPCAzklowOQSGbJQ+MEyW0Z3biwfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rh3ovM9Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rh3ovM9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F631F00893;
	Sun,  7 Jun 2026 10:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828490;
	bh=dY/+8KXdy3SItk5CkEwI4dDnE+J9n8xiAMDXLaay14w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rh3ovM9YnNEHN/+TCVkvo8uFeFFtB+6b37zngGQSioDhOfFrzEPL4YYSGmKqnEYp6
	 6dYXhylO0qqSeMLpEdrRpIiSrVJXT56z0oXDItBn7wUDqx5B8oV7GfoqFDz2unHDyY
	 Qr3p41ymb2dA8vIiltlgg5PMbqpb9KosNRoI0P0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 167/315] iio: temperature: tsys01: fix broken PROM checksum validation
Date: Sun,  7 Jun 2026 11:59:14 +0200
Message-ID: <20260607095733.729496804@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

commit 4701e471c16866e7aa8f5e6a3a6b0d31e097e2c9 upstream.

The current implementation of tsys01_crc_valid() incorrectly sums the
first word (n_prom[0]) repeatedly instead of iterating over the 8 words
retrieved from the PROM. This leads to a checksum mismatch and probe
failure on hardware.

According to the TSYS01 datasheet, the PROM consists of 8 words. A valid
check must iterate through all 8 words to verify the integrity of the
calibration data. The current driver only checks the first word 8 times.

Note: This fix was identified during a code audit and is based on
datasheet specifications. It has not been tested on real hardware.

Fixes: 43e53407f680 ("Add tsys01 meas-spec driver support")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/tsys01.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/temperature/tsys01.c
+++ b/drivers/iio/temperature/tsys01.c
@@ -119,7 +119,7 @@ static bool tsys01_crc_valid(u16 *n_prom
 	u8 sum = 0;
 
 	for (cnt = 0; cnt < TSYS01_PROM_WORDS_NB; cnt++)
-		sum += ((n_prom[0] >> 8) + (n_prom[0] & 0xFF));
+		sum += ((n_prom[cnt] >> 8) + (n_prom[cnt] & 0xFF));
 
 	return (sum == 0);
 }


