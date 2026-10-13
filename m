Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F074156C6;
	Tue, 13 Oct 2026 12:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895330; cv=none; b=QabAf6Z5Xx1p0Rvzbd0yp8M16L7cclUFYSYOtV7NrcMm10RhtLNoIB3yMF41A0gkSXMaiIliUFRZt32Fk1rBdd475DNEE9aY/jD+r7H2TLo5MsbE0eeaZfRslII1bOMBFMTPNrefYXry8/RAdWYQJ9lEwW01qPfRN5U3vcWiXoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895330; c=relaxed/simple;
	bh=ywcKP0XCnsHTjD6qQX5n19jDBFrOQUNKGIFOV4jz0H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bH52SQLUzphFLj94it8z5UJjHGQvh/1c9VRf3AGQbkx0Az/1ElYsmPxh8kO/p/Fq1kSxwb5hi6M1XeZN7V95Mj/Syviq50YvgApn7jV0ivGChjbsocrae/8dxCDOKSdqrRTMsvqDzTiHit61oLLPYfyq7B3YSgXYcNJJMPmNPH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbUagOpV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbUagOpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366571F000FF;
	Tue, 13 Oct 2026 12:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895329;
	bh=op9a1Na0Auger0rR07H1uZYCdryh2zelq3rEw99gX9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QbUagOpVKlXIktVCpwSfumcWovtdqKxpzeuBec1rhT+Wvb5dVr8nFGFJTma1CmXtJ
	 m69dH4VuAAPh7daHbGlMmnKwX1pEedJ9tArdJTrgpgJtPgWJzu7q0hAhi1vKueNcks
	 T8CN6EcIWEpF3xXUIOxxbjr+d2tlSNd5XWtVlyJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	Jinseob Kim <kimjinseob88@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 239/497] iio: buffer: serialize buffer teardown with mode claims
Date: Tue, 13 Oct 2026 13:36:46 +0200
Message-ID: <20261013112913.569340884@linuxfoundation.org>
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
@@ -1355,6 +1355,10 @@ EXPORT_SYMBOL_GPL(iio_update_buffers);
 
 void iio_disable_all_buffers(struct iio_dev *indio_dev)
 {
+	struct iio_dev_opaque *iio_dev_opaque = to_iio_dev_opaque(indio_dev);
+
+	guard(mutex)(&iio_dev_opaque->mlock);
+
 	iio_disable_buffers(indio_dev);
 	iio_buffer_deactivate_all(indio_dev);
 }


