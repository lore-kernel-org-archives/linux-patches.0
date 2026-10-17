Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8033AE198;
	Sat, 17 Oct 2026 17:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256811; cv=none; b=V8zMnuUrmgJHhTI80xne4QIV0krIZaR/lfJrvPx5HCsuQhe/UKs7uQhOTzPJAZjVQmDbUwj9KxZxP/4kOfoWk7VRNpBRPAx+zHJIjPpFRrbYR+onF8FIqBPvsjVwr481oskn8D5V0mlAwHSOnxuNWXd6LBLvdFAzsMHiNleEyZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256811; c=relaxed/simple;
	bh=SyuIb/MQU1wPEOpeDb9DQa+ohRwMdKFDGTswE4YSi3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uf6mlVtDyBdS1mRbmJQbtImeJRnra7LwooF+qQlSGY/lSClb1IPW6c5HPNg4aLQ0xu50Jwcv1CIl+2SXKGPWd0pOySVByH5C3AsXS5XIgb2FHjhxRLZ0C/lmCwzOmN8Rs6LTCEm+/hwJoUQ1Jg1qPz1bgzNiFluswRmgBBzBXak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/D4chlJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/D4chlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9A21F000C4;
	Sat, 17 Oct 2026 17:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256810;
	bh=XzC16E6L8tcbKMaJE48Xl72v2BkuiGOKMCU3xDJ2KRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/D4chlJT7ANoGH+jy/usnCR0ozD/z1u2U8eclX8q0h2pdhQrzmv4Ftn4Onnrk5Yy
	 MvYhVcMjgLtaygMwDw8xYe0taEOJEMqg4a2s9IwqiLLVII1bkU3QcBrfJ8hS8yl+5o
	 oC3KdR9qDf+XU5v8Y97RE7qxFVKs1b7QaM3BHYhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0342/1674] iio: buffer: Ensure bounce buffer used for unaligned case is zeroed.
Date: Sat, 17 Oct 2026 17:43:34 +0200
Message-ID: <20261017160439.904898716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

commit 5330036bc68d23672bfcc16c60c54701ae123083 upstream.

iio_push_to_buffers_with_ts_unaligned() leaks uninitialized heap memory
to userspace if the data passed in is not a multiple of 8 bytes and the
timestamp is enabled. Specify __GFP_ZERO for the devm_krealloc()
to ensure any extra space is cleared.

Fixes: 95ec3fdf2b79 ("iio: core: Introduce iio_push_to_buffers_with_ts_unaligned()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260529121005.1470-1-kimjinseob88%40gmail.com
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1917,7 +1917,8 @@ int iio_push_to_buffers_with_ts_unaligne
 
 		bb = devm_krealloc(&indio_dev->dev,
 				   iio_dev_opaque->bounce_buffer,
-				   indio_dev->scan_bytes, GFP_KERNEL);
+				   indio_dev->scan_bytes,
+				   GFP_KERNEL | __GFP_ZERO);
 		if (!bb)
 			return -ENOMEM;
 		iio_dev_opaque->bounce_buffer = bb;


