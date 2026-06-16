Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB7447A0A6;
	Tue, 16 Jun 2026 16:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628709; cv=none; b=a7eBzPh+PQduURJDMjlCMU+352q+8O4KAQLPygJJoBa7Qc2SYpam+Re1JjYys6bd7eiPCcgAOjQ6vKRtOqkyyuPfTtr4ppdY6SHo8BJQvUnV79SwoxTmiKoH9/+sl1hOWkELVSykPPSqav5QvuPDs61a8XOLU58rnbSfHNtJrjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628709; c=relaxed/simple;
	bh=vxuqhgk/noas0NUre/T+3uta0dV/Zl5geeKMt+w7tD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+WYw+mE/MyGnPangMD7ToJ/Z+aJ8lMvnxuKPQC+W9riWEkSkEqYpCUX550ByEB5Ejt+gU/cuuHq2Hg29//XgLaTRV6lCjxD2+bgyHTCTQR/ZSovVLNCGm9UxfhZNpt+gv4EcGEB//L5qCR/oZ0nwRTsrQf+jplFq8MCdpvj9mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vsk4PbOX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsk4PbOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB5E1F000E9;
	Tue, 16 Jun 2026 16:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628708;
	bh=boGE8+iVfRihsnNTvBBuna3JrUiewHEsRm63OnGBFIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vsk4PbOX365godvp+7wU98A05XR5Md5VC2B9YrxqJCNivGXPcZFnv5a1m3QcJhuMV
	 yU/i4TMbQiH9d6poM1+BUv7uW10uWa+4bYG+3hotMlWkBmLT18plye1Gx7e7HZRom3
	 /8KASUkKv1rLfHE1YK9MfOQJmP/mW1ihM5BnPhZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.6 115/452] iio: temperature: tsys01: fix broken PROM checksum validation
Date: Tue, 16 Jun 2026 20:25:42 +0530
Message-ID: <20260616145123.758349719@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


