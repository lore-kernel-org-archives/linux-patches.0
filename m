Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C7E3195FD;
	Sun,  7 Jun 2026 10:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828833; cv=none; b=dsI6Ow6gHpCsRyQ4Y3NRJZXOUZE7+wdeROd0PNvlLaTSEVF1uYekEf1bwoSwE5mawLCv0w5Mth5a7ZilappCiphznvGxrTlC+cFHplnYCdGeUBYQ2VV7NHNEmxHVMocq9SbZeqBckL+POLyDt8n2MMPV3sy6/K80jnCTzMzAyiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828833; c=relaxed/simple;
	bh=XOAbIzgVLcbhJKvrKaTRQahCmPKiwzog6Wlyoj5lzdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAhxpdOibgnNFblxmntI1g1JojP91C4tKgLklElNjm5Fy28ylw+Bwg93whrXpOqQ+GwdtbgE4h+OANQzXJ9Ni1GM/JYZRyZIONI0hKVvZJUeYF1Z0d0ig3w7CW7l2qiWqxQIpBbZO9OBPC4+O6Bct0SRh8XLofCjaUlhxUb+QHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPc2b8DZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPc2b8DZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624BE1F00893;
	Sun,  7 Jun 2026 10:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828832;
	bh=fj10uKCpPrFS3leCU3UuAsOS1msa5jwhwkavcYLT95Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JPc2b8DZDVB7J44A6mtGE9pcgNpwqJTZCv6ZkMlN/75Fi6jZbcMGnEgMTrOKTZ9yI
	 v3VUsAVnvuXHo/nvqfZTkUaobu734xW+Vq5QnnG43KXmNRp4QtvwOmQlHdHVsERvQH
	 dT1fcJrW/LqWzmh5C/utAgtg1nFE+uh1hk6ItmvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 172/307] iio: temperature: tsys01: fix broken PROM checksum validation
Date: Sun,  7 Jun 2026 11:59:29 +0200
Message-ID: <20260607095734.035705484@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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


