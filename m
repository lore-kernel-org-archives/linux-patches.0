Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C169E3D5C06;
	Tue, 13 Oct 2026 12:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895333; cv=none; b=qdn8Tlq+2zkx7yyDaUGKkEJjmu8Ryr4QiogDDt0YGbWSzfSMc7/k3mNk62VaYkw+JKQTQNQXs7gM5tjIexkxuFLf7nwi/ZlH4TFmPQZsA3BXPHxtFhsN95TgjnZ76h/Oz9ApwVzrdSmpPZSRVPAYsxf9xEFNRuewMy43kGNJ1qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895333; c=relaxed/simple;
	bh=Oqiql4OWH8QdI7BlvreRn75Cqv4HrJ+Pmft5y33hHbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VL0EYnTrxFs+cPBiauW0sC5kSGl/1tvtHwQFZG9g6bs2zeNKMhrmlj/V7q546pIIkQ4jk7wLFdyKUApnrvyicsKMKdu8L0fiZTELhEVIayIbtUwleslGGszI+b2g8uG1tXV9hx5QvettYxQ42PzV9GqjO1mq+XjyJXj7Piw2Ar4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JIjvEExK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JIjvEExK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283D91F000FF;
	Tue, 13 Oct 2026 12:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895332;
	bh=BXm1zRHhjKH3geD0p0tXFvX0PG0LL0OZHYaJH4p0yTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIjvEExK2dRG44rneDg6g+uDok40V+Q80gZPUOgIuGNagI2q4+pWQnji60V/F/kbP
	 UMdnSECMaRMdjh/HKRjdAZDQ9O7kjLKNify//83+s4V9PYueXZYq0RGQxhH8DeH+B7
	 nJsWN501SE+9SiPt0n6B98GoronXsXP730/n5/C0=
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
Subject: [PATCH 6.12 240/497] iio: buffer: Ensure bounce buffer used for unaligned case is zeroed.
Date: Tue, 13 Oct 2026 13:36:47 +0200
Message-ID: <20261013112913.592747494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2438,7 +2438,8 @@ int iio_push_to_buffers_with_ts_unaligne
 
 		bb = devm_krealloc(&indio_dev->dev,
 				   iio_dev_opaque->bounce_buffer,
-				   indio_dev->scan_bytes, GFP_KERNEL);
+				   indio_dev->scan_bytes,
+				   GFP_KERNEL | __GFP_ZERO);
 		if (!bb)
 			return -ENOMEM;
 		iio_dev_opaque->bounce_buffer = bb;


