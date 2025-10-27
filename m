Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D683254A8;
	Mon, 27 Oct 2025 18:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591294; cv=none; b=Z+NX71gjY6B9MX+FMz611mZjvaGOGxc01GA5W/UANhF6tBZ1ucQGfo7nJVfpN+OWl1ND4OuCxonj6hgugCCiYhyOrp+yosgeF9oFpfPwmuejOsL3zDvKPwyNCki/f+9iuzl6rZWN6Ld8vIgBVCNRHq4m8QZAC0Yefo6++OkrNfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591294; c=relaxed/simple;
	bh=J+IG4f447A1L9tB7CdxjnWYdtNRETrH1uMfKWqJJoIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PFuVSCTAol2YUs6CzHZR86NRg3wQA1LvZRz74VQYeZPUTx37A94pTVb5CVynteSibqV94FkCE2fNhOClCHiTnUqjEMqbgmbzFT0qSY/YjRXUA0DMO6XC7JjmUHh4xGVMqCUf8Fudf6W1SrbsNrVTFxudAup8vuP3FM+2NzPEHOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7T+elXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7T+elXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE220C4CEF1;
	Mon, 27 Oct 2025 18:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591294;
	bh=J+IG4f447A1L9tB7CdxjnWYdtNRETrH1uMfKWqJJoIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7T+elXYIciO+/Gx4xeBdNiV5MMboFVc9BCcjKOUPJUgyj1uxTEq4VGF5u9AbQn9X
	 JumIidUMBy1YgyRq6b1+auIiUxkK37CY5J7Lutby0KH0yWgIjWKm3106ksITq52rbi
	 6bGUmv6aEHc1o2Dec2V4iw0NMUxAyLFnEv6Llfi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Hennerich <michael.hennerich@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Andy Shevchenko <andy@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 141/332] iio: frequency: adf4350: Fix prescaler usage.
Date: Mon, 27 Oct 2025 19:33:14 +0100
Message-ID: <20251027183528.358007853@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Hennerich <michael.hennerich@analog.com>

commit 33d7ecbf69aa7dd4145e3b77962bcb8759eede3d upstream.

The ADF4350/1 features a programmable dual-modulus prescaler of 4/5 or 8/9.
When set to 4/5, the maximum RF frequency allowed is 3 GHz.
Therefore, when operating the ADF4351 above 3 GHz, this must be set to 8/9.
In this context not the RF output frequency is meant
- it's the VCO frequency.

Therefore move the prescaler selection after we derived the VCO frequency
from the desired RF output frequency.

This BUG may have caused PLL lock instabilities when operating the VCO at
the very high range close to 4.4 GHz.

Fixes: e31166f0fd48 ("iio: frequency: New driver for Analog Devices ADF4350/ADF4351 Wideband Synthesizers")
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://patch.msgid.link/20250829-adf4350-fix-v2-1-0bf543ba797d@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/frequency/adf4350.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/iio/frequency/adf4350.c
+++ b/drivers/iio/frequency/adf4350.c
@@ -143,6 +143,19 @@ static int adf4350_set_freq(struct adf43
 	if (freq > ADF4350_MAX_OUT_FREQ || freq < st->min_out_freq)
 		return -EINVAL;
 
+	st->r4_rf_div_sel = 0;
+
+	/*
+	 * !\TODO: The below computation is making sure we get a power of 2
+	 * shift (st->r4_rf_div_sel) so that freq becomes higher or equal to
+	 * ADF4350_MIN_VCO_FREQ. This might be simplified with fls()/fls_long()
+	 * and friends.
+	 */
+	while (freq < ADF4350_MIN_VCO_FREQ) {
+		freq <<= 1;
+		st->r4_rf_div_sel++;
+	}
+
 	if (freq > ADF4350_MAX_FREQ_45_PRESC) {
 		prescaler = ADF4350_REG1_PRESCALER;
 		mdiv = 75;
@@ -151,13 +164,6 @@ static int adf4350_set_freq(struct adf43
 		mdiv = 23;
 	}
 
-	st->r4_rf_div_sel = 0;
-
-	while (freq < ADF4350_MIN_VCO_FREQ) {
-		freq <<= 1;
-		st->r4_rf_div_sel++;
-	}
-
 	/*
 	 * Allow a predefined reference division factor
 	 * if not set, compute our own


