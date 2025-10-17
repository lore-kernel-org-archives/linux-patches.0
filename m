Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7417F337100;
	Fri, 17 Oct 2025 14:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713191; cv=none; b=O2OvnsS7neh+Fm8/1H7C5Nt5D8A2WJnWM7SrDBO0FZCA+MibolID3ihXspEej30JS8qEBXu2kI9uFl+ADON+iWCrI5oh0CS9mYzi7YeLkBj4Kqma8UqyHFk/RXiEb7D8d0sINvCXNtOH3JUH55oMeSYf6vNdR/P/DU5mBFtua0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713191; c=relaxed/simple;
	bh=d4E9WAZFSvLYoAc0hr2q3hKetWsW3KFaAqx3OE/nU9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KH2JauTY8vrQ1XQDDUJelVI1pTbTmSclvOyvjDsHN64zM6264rGcy+LAUHIAa0JvcouzTidsOd5SY4Zd5CurmVT4ENNfTK3GogSUcQrgXlj85u1nbQ+c99hnA5CroJb9qiwt5WVAsRlA8+/GqAQ4CNYdr9iFp2n9ZmsVXgB7fAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kC/kZPfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kC/kZPfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0063C4CEF9;
	Fri, 17 Oct 2025 14:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713191;
	bh=d4E9WAZFSvLYoAc0hr2q3hKetWsW3KFaAqx3OE/nU9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kC/kZPfX1VxDX5/P1Rm8bolVPdwcAzR+Pw8fWz46Io1/ByXizgLI7YEuaTMdo4AI4
	 Amc0tWS0+WnAY/TfDgHIR39t6HrsuTjpbexp/ea9goeZjMbVLLnbW8MciENBSQ7tDL
	 OngZ1TqRmP2D3hzD88VDBh6nwsLk+P5Gj3cZ1DMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Hennerich <michael.hennerich@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Andy Shevchenko <andy@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 079/168] iio: frequency: adf4350: Fix prescaler usage.
Date: Fri, 17 Oct 2025 16:52:38 +0200
Message-ID: <20251017145131.937881925@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


