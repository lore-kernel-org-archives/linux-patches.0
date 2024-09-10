Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F4419993F;
	Tue, 10 Sep 2024 10:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964561; cv=none; b=iZ1XDLKrVVjiL4ShUdPR9/bz+HhaExJd7mDZbX46qJ8yVGxGQ8+RsRfHz5yR35TSq1eh3+CbofSxndmKKmucOisRZY4b+AX7ZpOslupPZHUw/iohu5Unm73rdNh9QIOaGhKtqwtxHZ+9hPVfmcfORVVM51mWNlFPAZAY2OZoYX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964561; c=relaxed/simple;
	bh=q4mXKdFRSGXwTnA1aCHMjeaNzAF3Lt293G3b4M9VfGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDfZydjpHAvs42aiZPKr9Xs+q9rS93Vfd/e02xwe51aCaS0ksN+dPFbYhpZ9k4yPET879rVwm4ZJ4s2lELVDGpK4RJOhSV8lOFF0pXqbQ1fo5w+W5NSbra4TodFh06AapGblbd3WWPYYFRSy8A1grIC84Ks4WMnLscbH+87M56Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=anAV+GbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="anAV+GbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB48C4CEC3;
	Tue, 10 Sep 2024 10:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964561;
	bh=q4mXKdFRSGXwTnA1aCHMjeaNzAF3Lt293G3b4M9VfGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=anAV+GbUTla1rcKdjBO/ZaBLYtQHOEES+wh+dC41BCHInd2sWGbTTELBBgsl5DYFB
	 WfzYBwYsZfFN/PhKdCjjKjcydwj9y7g2ig1DMd7R5g6UPzeZ9+4kZfYE8QFEI1rWo7
	 +V396uJY4FBtO4p7nOK+ICXBkL1zG3sJWI857CAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Martelli <matteomartelli3@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 207/269] iio: fix scale application in iio_convert_raw_to_processed_unlocked
Date: Tue, 10 Sep 2024 11:33:14 +0200
Message-ID: <20240910092615.426080781@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -680,17 +680,17 @@ static int iio_convert_raw_to_processed_
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


