Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5F6274B46;
	Sat, 12 Sep 2026 18:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237625; cv=none; b=Mc7QQozwGx9H+ig15VIFzB1E5uPOK1GyGejlDu+O39n0SijRfZepDdoP88MvPf3CJJCvuCjPmZd/P5m1yVX2AkLrKCya3GcE+dGHLHONL+Mh/4Uy1WDzsaU17sz9cQTwVlqdN8ScPXgZWcD0pFClcazi9o9U+qG66IhtY26yuzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237625; c=relaxed/simple;
	bh=XbygxffQNMtX23Xdwz6RTiICmx/tqTfEzdvV6RIyqf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8xBD1IgxZ5nqrtyx/8K28e7QTW5mNqxErrOZoAZ2lEZ96jvdQFz0C0JW6Q123usK04RpvipK/7w37GFGeVdrDJ3ajEFKM8gkk7f/eMvOYP/FrRQxuf19zTiQnR1AVsL4OR92IUURlLkpIc6NSMna0UlJVlaPmbLLY4H3dUMSxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ioGVq1b0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ioGVq1b0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D755B1F000FF;
	Sat, 12 Sep 2026 18:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237623;
	bh=Kuui6kZgYnsw3+87ZFGLO++Z/2H4iuoP2kRY17eatfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ioGVq1b0/Cl15+pcFKIehIaC1Dz1nOeHf8qRQRqPRU/95/s8U1ykUbkUwJlxeFo9g
	 3qMTSz2rGHwKJHSPWxsYD+mzahAvGsSMQPrr+cJwB/+xK6PsiZEmrKAxI7ph16TVai
	 s7nIPQKOuTCwEcSdcJTF/Zw3APz8F91vnDTvy1Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giorgi Tchankvetadze <giorgi@tchankvetadze.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 295/935] iio: light: cm32181: return zero after writing calibscale
Date: Sat, 12 Sep 2026 08:55:25 +0200
Message-ID: <20260912065533.577595241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giorgi Tchankvetadze <giorgi@tchankvetadze.com>

commit 8756acd30919a3e9f547ea4a1d4b7f7895f4d340 upstream.

The write_raw callback is documented to return 0 on success or a
negative error code.  However, the IIO_CHAN_INFO_CALIBSCALE case
returns 'val' (the user-supplied value) instead of 0.

Fix it by returning 0 on success, matching the behavior of other
calibscale implementations in the subsystem.

Fixes: 971672c0b3cc ("iio: add Capella CM32181 ambient light sensor driver.")
Signed-off-by: Giorgi Tchankvetadze <giorgi@tchankvetadze.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/cm32181.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/cm32181.c
+++ b/drivers/iio/light/cm32181.c
@@ -370,7 +370,7 @@ static int cm32181_write_raw(struct iio_
 	switch (mask) {
 	case IIO_CHAN_INFO_CALIBSCALE:
 		cm32181->calibscale = val;
-		return val;
+		return 0;
 	case IIO_CHAN_INFO_INT_TIME:
 		ret = cm32181_write_als_it(cm32181, val2);
 		return ret;


