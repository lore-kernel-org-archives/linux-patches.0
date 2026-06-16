Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A0C478E3E;
	Tue, 16 Jun 2026 17:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630856; cv=none; b=K1CwtNPkuGgNMBW0lWET7lLR61E8GbOkGXWFrBp4vjm6fa+M1NRlQ2kdNs7HpiJKTETdLKaGD1ryxEXs8mgF7v0w4jhzb0/MJc3iSq0ax0JeRiZ7WeK3FTGazS5jv/ZDocC7VSZCLjfdStboxqM62rM3/DGpPOvERwaoc4c+8FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630856; c=relaxed/simple;
	bh=dbK5CfGht7309movEJ8+nRUXLLV3erUQmBZD/z42130=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LE5b4CZ+fnWDvcllohX6kaC0QRiEjMDstg5IzCdbgTvJpfdesWmuwy8Cm/XcmcEAvGxd/EgG27dldNw4gdCU6Q3skLJDe26Oxg+1nhN8mTaeds0iVziDClG/E02waZlTKBxkE+n3+AcC1kEdxypW4dRu4w+sfzfwbBhwdMwQniw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmsEw+ZT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmsEw+ZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399F61F000E9;
	Tue, 16 Jun 2026 17:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630854;
	bh=LCNJdNmdOV6w67jYq2ybi8Wo/k+tApBOLO8VOFRlVoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmsEw+ZTfVhJENjDbnH65WRKhgZOl6FOEh015skras55V3pUDEf3Uw4dbTsVvNdAV
	 UjERUw0uWF+LmYpqnlkkQ+lTyK1m3gvNn31HtYjpUXD0kAjxBMoQwdt/h1T8Y749W4
	 iXZ/k90aOi8IRm/Lz69I+e3F3KeCaxmgkou7SdBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.1 110/522] iio: temperature: tsys01: fix broken PROM checksum validation
Date: Tue, 16 Jun 2026 20:24:17 +0530
Message-ID: <20260616145131.092337487@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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


