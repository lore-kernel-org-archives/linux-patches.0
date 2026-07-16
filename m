Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B350329D265;
	Thu, 16 Jul 2026 14:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210527; cv=none; b=NS7LwVdRS2LiKUKvpNFBuPLafaDOLa8axYJU4WkZzyJL5pyzp9rf20AOf1KrFXLaXw7Dpwq2Cr4CSxNdDv2S1F90nrByRqEJhc4CUQjh9EA7VpkWMj8oI1Ay/zmN2pqJAGBU5dm7EmrK7LFudnXhmSw8RxStF+GFGqtSLNFixk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210527; c=relaxed/simple;
	bh=8InIkKwi50IwiK8PfggOeIS7Ynqsk29lTUd4eEIye3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYlTXGYV6KDNIp7yXGI7Ix6imYcHNbRZJ2PvAJmtsQ8+oK2YjZzxCdzWWhPtidOb9yoKKcH+6erBXTuSEqfSr6KHyFa3k+f3JNUqwX1MiFFxH+s7JGFQVgcWi4xsS1vm8LUp30A2QJZ11LPPqDNluscR/u+tgOKqkaj6Bkbves0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1ON8vHl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1ON8vHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257171F000E9;
	Thu, 16 Jul 2026 14:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210526;
	bh=Z3tUEPhgQQ5iZhn/1E6fmrR82BbTi6JnaY6z53KoiOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1ON8vHlHNejAznn3+jCrPMUMt7t6o5Y1CQtsH+lUBTBYllL+4FLSQzFqqGKWqlUY
	 1oBAwwkVaiLW9O89g1SHqr1OCXldvVRCyAYSstd1Y2hiL+wr8dbhS2Yb4EpuK7JqZK
	 epB1RPDVqLKSboeIexKMIuRSJId13Rq6boYl8ezQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 080/480] iio: light: tsl2591: return actual error from probe IRQ failure
Date: Thu, 16 Jul 2026 15:27:07 +0200
Message-ID: <20260716133046.442419651@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Stepan Ionichev <sozdayvek@gmail.com>

commit a00ffd15674bfaf8b906503c1600e3d8709af56c upstream.

When devm_request_threaded_irq() fails, probe logs the error and
then returns -EINVAL, dropping the real error code and breaking the
deferred-probe flow for -EPROBE_DEFER.

Return ret directly; the IRQ subsystem already prints on failure.

Fixes: 2335f0d7c790 ("iio: light: Added AMS tsl2591 driver implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/tsl2591.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/iio/light/tsl2591.c
+++ b/drivers/iio/light/tsl2591.c
@@ -1137,10 +1137,8 @@ static int tsl2591_probe(struct i2c_clie
 						NULL, tsl2591_event_handler,
 						IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 						"tsl2591_irq", indio_dev);
-		if (ret) {
-			dev_err_probe(&client->dev, ret, "IRQ request error\n");
-			return -EINVAL;
-		}
+		if (ret)
+			return ret;
 		indio_dev->info = &tsl2591_info;
 	} else {
 		indio_dev->info = &tsl2591_info_no_irq;


