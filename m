Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350652BD59A;
	Mon, 12 May 2025 18:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073118; cv=none; b=jQgTkBNIoZlyaNbRy2A7ophyZZWLn5wp3WXKITnLp4T+Uf1phzpCwOMsEV7v+2vGfcHxvW14zCfyYzDFoBy0f49EPnr6tCWnR5uqPIa2x512tZegwqsUo/vmyNI8yaBo8VEtffq8y2938oYfveFc8jy61GL6gLLWrbas6VAhwnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073118; c=relaxed/simple;
	bh=oLwuT6wgnOCD33RaKr4whM+9KP2D+ynkiTGkyFaTUK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEAN8w4voBisceSemTlF3wT/lDv9PnTF7UsH7o389tKoLo6PyO0JyCruU7v5cKlPvuBpocicPOEHvEulWOPHiDGCdYreIMuOFrar+xhdebRC3LHIYMfSvVGA2bh7ZdAtr/BZU3hjMvN1LbMApB211w4Ccq4qT8muHut/EI+G/To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILMySbWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILMySbWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42659C4CEE9;
	Mon, 12 May 2025 18:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073117;
	bh=oLwuT6wgnOCD33RaKr4whM+9KP2D+ynkiTGkyFaTUK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILMySbWeQuScgs425fBbWYPhUOZgiMq9benu9ZdxT5DYItiqk9azJGPyfZHNK8x/5
	 V7rAjubWUkB1hQPFqwkSHnB3YgsLb2r3YkdnTESfB/8r4ivgPg/PIw8+FLPYZ1bGpk
	 lNiAgc7STSYasyCzOVa7G28rcjKwJWqDIRoa+k8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lothar Rubusch <l.rubusch@gmail.com>,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 130/184] iio: accel: adxl367: fix setting odr for activity time update
Date: Mon, 12 May 2025 19:45:31 +0200
Message-ID: <20250512172047.112198689@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Lothar Rubusch <l.rubusch@gmail.com>

[ Upstream commit 38f67d0264929762e54ae5948703a21f841fe706 ]

Fix setting the odr value to update activity time based on frequency
derrived by recent odr, and not by obsolete odr value.

The [small] bug: When _adxl367_set_odr() is called with a new odr value,
it first writes the new odr value to the hardware register
ADXL367_REG_FILTER_CTL.
Second, it calls _adxl367_set_act_time_ms(), which calls
adxl367_time_ms_to_samples(). Here st->odr still holds the old odr value.
This st->odr member is used to derrive a frequency value, which is
applied to update ADXL367_REG_TIME_ACT. Hence, the idea is to update
activity time, based on possibilities and power consumption by the
current ODR rate.
Finally, when the function calls return, again in _adxl367_set_odr() the
new ODR is assigned to st->odr.

The fix: When setting a new ODR value is set to ADXL367_REG_FILTER_CTL,
also ADXL367_REG_TIME_ACT should probably be updated with a frequency
based on the recent ODR value and not the old one. Changing the location
of the assignment to st->odr fixes this.

Fixes: cbab791c5e2a5 ("iio: accel: add ADXL367 driver")
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
Reviewed-by: Marcelo Schmitt <marcelo.schmitt1@gmail.com>
Link: https://patch.msgid.link/20250309193515.2974-1-l.rubusch@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adxl367.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/accel/adxl367.c b/drivers/iio/accel/adxl367.c
index e790a66d86c79..d44d52e5a5140 100644
--- a/drivers/iio/accel/adxl367.c
+++ b/drivers/iio/accel/adxl367.c
@@ -604,18 +604,14 @@ static int _adxl367_set_odr(struct adxl367_state *st, enum adxl367_odr odr)
 	if (ret)
 		return ret;
 
+	st->odr = odr;
+
 	/* Activity timers depend on ODR */
 	ret = _adxl367_set_act_time_ms(st, st->act_time_ms);
 	if (ret)
 		return ret;
 
-	ret = _adxl367_set_inact_time_ms(st, st->inact_time_ms);
-	if (ret)
-		return ret;
-
-	st->odr = odr;
-
-	return 0;
+	return _adxl367_set_inact_time_ms(st, st->inact_time_ms);
 }
 
 static int adxl367_set_odr(struct iio_dev *indio_dev, enum adxl367_odr odr)
-- 
2.39.5



