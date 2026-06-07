Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832FE32ABC0;
	Sun,  7 Jun 2026 10:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828533; cv=none; b=VifDE7TX6PFSrNJJcRSOIkVXDE15fWK/3QEimelGpph4a6uV2Mqvu8/SJRwgokiir0+H91J2ez/D4GlpGG30KIHMDSTjTS3PNnfcHumTwTbWUuq5uSrSUh1uPwhtmBPbOsMukZigd368Ted9UnbgYHS5ukGpCh0CCpgJ5e2QPww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828533; c=relaxed/simple;
	bh=QB+6zbLl1eqZ+b0ZuzxtlZZ8gwQRa2WWIcap0I6lGU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfFyV2gLqkcmQxc60cYAmhmjD6u/hLV2TpuEb9tFl8/M05s1y43WlElsAQ/q+zsfIR2L1ux7HacIoYgZ0bbZx34t8CfFTx6+Awx7PRiGSx/Dc7Ccj2amK6bvdLKgdJm1WxvoVIXIud/ohvMrrTPT9DnalLbjwOoFysRseaiK/hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWq1YZvQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWq1YZvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EDE1F00893;
	Sun,  7 Jun 2026 10:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828532;
	bh=k8DouMujjVwOIDtWy8DQLHn+zoE/i9PRXgU8MXCQyy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kWq1YZvQz16V7UFkLNhb7oJ1dhae6mbzGZflD95pQD8IgOdn5eSaNMb44GOdZfe4I
	 xQJnH6/7/OAlxCa9YUzUX5fEt1GEF1oYZNoYWmYIi+xA/CDPliHtrpCf6gRCwk7pAn
	 XCFzfKkxwHsGWQX/fUzQ0sSmQ2m++V4xkt3PO51s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.0 191/332] iio: temperature: tsys01: fix broken PROM checksum validation
Date: Sun,  7 Jun 2026 11:59:20 +0200
Message-ID: <20260607095735.082999414@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


