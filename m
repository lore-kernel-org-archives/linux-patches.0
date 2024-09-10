Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB211885A6;
	Tue, 10 Sep 2024 09:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961160; cv=none; b=oXo4jGxtDMcZdiYriXdJ/qbaaUhrUAZHCw3JcJ33pQPD1oZxo7Y+flv7GYsB8vCmtroJPITIrs9Dy9PQdzT67s6GvDPBHdOpIgZuqAQV894HAHbCUrI1VDs9+zl0hcYS8j5ieAoDEyviaYY75b7nzeMmKweNeWu1PIVF1bsNJBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961160; c=relaxed/simple;
	bh=FLpEExGs3wM4NQUckVFchWcoS6SFPr4htfAQudOXLc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ckxfo/kMb5CqXoctPK3ht+e3RYKehdU9D/RpYk7SeB1K+fOA60dwYBP0GWBEB2vM94UJsMVk4J6CVPsrqZjPYXRqVvCQTt2AdrTxqzJQLkmCY8oeSvy4cRz9lEQKKIyxUui8ScZG+HKT9xbS9aQ+SjpQ76vtpHpmlkbjV1mWV3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGXJlneF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGXJlneF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125FEC4CECE;
	Tue, 10 Sep 2024 09:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961160;
	bh=FLpEExGs3wM4NQUckVFchWcoS6SFPr4htfAQudOXLc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGXJlneF64DdTZuxe9zjgjX+MJMCVBYBSqzGtKNzZ2CSlJjIoujXCqStrd7xaXS5p
	 22xuaQCGVWZUD4bRqpwiXjcuAnDJwx0RyE0pGsYeX/ULNX/Oo5E0vUB9gUUZaF+riO
	 c4CtpjIFjnQzj0a5VLvf+N/6VN9Hb9PzA5CiPzd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Martelli <matteomartelli3@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 74/96] iio: fix scale application in iio_convert_raw_to_processed_unlocked
Date: Tue, 10 Sep 2024 11:32:16 +0200
Message-ID: <20240910092544.801537327@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matteo Martelli <matteomartelli3@gmail.com>

commit 8a3dcc970dc57b358c8db2702447bf0af4e0d83a upstream.

When the scale_type is IIO_VAL_INT_PLUS_MICRO or IIO_VAL_INT_PLUS_NANO
the scale passed as argument is only applied to the fractional part of
the value. Fix it by also multiplying the integer part by the scale
provided.

Fixes: 48e44ce0f881 ("iio:inkern: Add function to read the processed value")
Signed-off-by: Matteo Martelli <matteomartelli3@gmail.com>
Link: https://patch.msgid.link/20240730-iio-fix-scale-v1-1-6246638c8daa@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/inkern.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -640,17 +640,17 @@ static int iio_convert_raw_to_processed_
 		break;
 	case IIO_VAL_INT_PLUS_MICRO:
 		if (scale_val2 < 0)
-			*processed = -raw64 * scale_val;
+			*processed = -raw64 * scale_val * scale;
 		else
-			*processed = raw64 * scale_val;
+			*processed = raw64 * scale_val * scale;
 		*processed += div_s64(raw64 * (s64)scale_val2 * scale,
 				      1000000LL);
 		break;
 	case IIO_VAL_INT_PLUS_NANO:
 		if (scale_val2 < 0)
-			*processed = -raw64 * scale_val;
+			*processed = -raw64 * scale_val * scale;
 		else
-			*processed = raw64 * scale_val;
+			*processed = raw64 * scale_val * scale;
 		*processed += div_s64(raw64 * (s64)scale_val2 * scale,
 				      1000000000LL);
 		break;


