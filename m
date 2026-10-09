Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AC581ACD;
	Fri,  9 Oct 2026 14:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557644; cv=none; b=okJJQcZZHqBIpSmoqmt8sBrRr6Sga01UNDbZ8vDyI5+r4nT1AL8BwdTMK2wJMpjAfag2zcqc7QmOAcH7YDqIirzWdOJNr21eKAlwgEDucUXSiLXyZkciB6a0GJmcPPkwkF6mjCkWn5smyR6KNJ7dKFKmeI0M0dhImPSQ8eDjO10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557644; c=relaxed/simple;
	bh=s+C0iBeaRqmSuIp/I6DcWZIdw0xbWXOoJnJ2Q4ByL1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mj1jHVgbc4h3c0K+QztL1Fl/YPTRXufQJep0UJlorUGAIx3ICl6iodmIasuJj3QRc3tSvUBnfXwquO/9GJDLSzkwddGLGoZ8824v/i3NAwgjbg1nf5J/RmH/Pl1ghq0XcXe5cgUV025U96CMDHvxNwfhFzpgJwK6KZQYsRZZIkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NvYR4uuz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvYR4uuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A251F000FF;
	Fri,  9 Oct 2026 14:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557643;
	bh=zxjFnfrghL4wqB5iGZIspF6DEYln/MhwzlDadenCinE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvYR4uuzHzA0GaTIV3+pHPBy8Mwt9eFXdgfHy6xOcaewFQfD4xPJ7SBuJnMEdd1p7
	 WMPJe7/KPIQH3Qf1B9BPtg7xCuACmI0vzuYU5Q6YuXGd07rArDF6tcBzflM+Z7aLp5
	 01J2w0o/OxmCTTmzTlGTmkS4YKTdUVORnKFuDKEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	Jinseob Kim <kimjinseob88@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 395/428] iio: buffer: serialize buffer teardown with mode claims
Date: Fri,  9 Oct 2026 16:12:12 +0200
Message-ID: <20261009140954.885883216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinseob Kim <kimjinseob88@gmail.com>

commit 84bb0fc46ccf6a545b8fdf57cda83770186ed8dd upstream.

Buffer-mode claims hold mlock to guarantee that the device remains in
buffer mode until the claim is released. Normal buffer updates take
info_exist_lock followed by mlock in iio_update_buffers().

However, iio_device_unregister() disables and deactivates all buffers
without taking mlock. This can invalidate buffer state, including
active_scan_mask, while a buffer-mode claim is held.

Take mlock in iio_disable_all_buffers() so that unregister honors the
mode-claim lifetime guarantee. The info_exist_lock -> mlock ordering
matches iio_update_buffers().

Fixes: 0a8565425afd ("iio: core: introduce iio_device_{claim|release}_buffer_mode() APIs")
Suggested-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jinseob Kim <kimjinseob88@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1377,6 +1377,10 @@ EXPORT_SYMBOL_GPL(iio_update_buffers);
 
 void iio_disable_all_buffers(struct iio_dev *indio_dev)
 {
+	struct iio_dev_opaque *iio_dev_opaque = to_iio_dev_opaque(indio_dev);
+
+	guard(mutex)(&iio_dev_opaque->mlock);
+
 	iio_disable_buffers(indio_dev);
 	iio_buffer_deactivate_all(indio_dev);
 }


