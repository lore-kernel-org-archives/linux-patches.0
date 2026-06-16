Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19D635CB87;
	Tue, 16 Jun 2026 17:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630275; cv=none; b=V2dAay7IsfMMQsgzkPAOaXuJznUTU5PuHyy7Eb+4n5Cd7PCOeTw/3rc4Kqdq3/EUfwFE6JzD+Q44yKV+wDEz6QZQw2e3jOOrngnWgOKLd9EvNjoLShU6Ygvgu9v72PCEJtWu2mJWR6tOHc/veJtdu2VmtiGSya28ZXCn47LcPNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630275; c=relaxed/simple;
	bh=IqLDJ6oLuCzt0DnoP/Y5NVU1mf241zw52O6rpfpWUJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUn1H3izK8tQ7UZqjRABlKTQX9lcl0YcDDdQRRpq8pLnoAXDX0Qe7bJuHH8/+eSogCjqgnzMQ6A2IcHcuV7HtBrQL2upztQTEkz6bbgH8EQMjCzflOJNcwhHJprBvPX2f6FOb6NXZ3XHPSotshwz4PU9g0/zi1L0VqBdHz2qVnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8cW8Bdf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8cW8Bdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D101F00A3A;
	Tue, 16 Jun 2026 17:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630274;
	bh=k5mXf+v3MzIk0ieaMpn7c2+yPs2VnONd6e3NWIfW96Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f8cW8BdfdDalrF8vNc0NOVL7LLmwnmWcbSDn/2v/xjcn0wsoHpurHML+uQabFJyAJ
	 WK3qpcGW7hpY64aVdoSHRmg2nukCEcRGOS76Qlfm/gLTrp5TLjVfwsrVHhTx8bJvA3
	 b6Weg1MmDtXcsl+ecfrCvLzylMfNmIWj1y5/Wkho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 411/452] iio: chemical: scd30: fix division by zero in write_raw
Date: Tue, 16 Jun 2026 20:30:38 +0530
Message-ID: <20260616145138.378526863@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

[ Upstream commit 5aba4f94b225617a55fed442a70329b2ee19c0a5 ]

Add a zero check for val2 before using it as a divisor when setting the
sampling frequency. A user writing a zero fractional part to the
sampling_frequency sysfs attribute triggers a division by zero in the
kernel.

Fixes: 64b3d8b1b0f5 ("iio: chemical: scd30: add core driver")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/scd30_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/chemical/scd30_core.c
+++ b/drivers/iio/chemical/scd30_core.c
@@ -257,7 +257,7 @@ static int scd30_write_raw(struct iio_de
 	guard(mutex)(&state->lock);
 	switch (mask) {
 	case IIO_CHAN_INFO_SAMP_FREQ:
-		if (val)
+		if (val || !val2)
 			return -EINVAL;
 
 		val = 1000000000 / val2;


