Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4FA254863;
	Mon, 12 May 2025 17:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072594; cv=none; b=C1HcAjkAFLK2pZx+gNowcu7j6Zd3Xmfy++cYPtYQp7wCZ977OIotGfpXhP7oh1yMPBNqwoX3NzLrkpDVvNPoV1VnGL5+RTUFkqtRaXP2yCfnS5/u1YqXasBLCnCVHFzBS2U7mtt+pcMQlW5G59M9FvEh6EMZN4mbAnViGqj9hM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072594; c=relaxed/simple;
	bh=W/cghf+fz8pahzwDEFiFIP3wsVY09sa8ZfHJ3X+YhTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIzzvit+Z1iabA3FjJ0O+rhkH4Bb2rfj9RXe9hHkd7FcfG1/2AlK/PGn7Tpey0n86jZsHaHZQCry9r2qomA6OCsMJ8ZBz1CuRpNWK8v0J4eCgRyl4BzQAoUceRH3UY9BoyGYrhqLMe53li21X0i8E8LQZdMSSbmGrFWfspYDowo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrZq2rkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrZq2rkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B63C4CEE7;
	Mon, 12 May 2025 17:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072594;
	bh=W/cghf+fz8pahzwDEFiFIP3wsVY09sa8ZfHJ3X+YhTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrZq2rkhM5b68mVXzldH+cAVkCbRij/d++2bQzFrxu0UrF/m/43UgOLMY9AcCvM/B
	 Qj/MIsEqcxZftSGMLYP2oEfWTdbKLeOOEst326wQveMOuMa1zCSEni2394Gpa68YbU
	 sXh2af3BosAIRaEyrAtjVsaMxM02bhSlv/I7ESVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lothar Rubusch <l.rubusch@gmail.com>,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 60/92] iio: accel: adxl367: fix setting odr for activity time update
Date: Mon, 12 May 2025 19:45:35 +0200
Message-ID: <20250512172025.558024722@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f1a41b92543af..af0ad4e5e4a58 100644
--- a/drivers/iio/accel/adxl367.c
+++ b/drivers/iio/accel/adxl367.c
@@ -622,18 +622,14 @@ static int _adxl367_set_odr(struct adxl367_state *st, enum adxl367_odr odr)
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



