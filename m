Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65789295DAB;
	Mon, 12 May 2025 17:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071946; cv=none; b=cUyNP01/l9MAH++dX1qPiLoMUZ+4+228H7GhiV40PAYQxEu2ZeDTC7VULpgY/TcpKKLbdvKE4e1dMq5v9WxwKgpzkkpedukP0PJHSEYpfpJIB4nWf06LJbTfr8WpX6XtctlXjBz3RahUqSMIpLgpnYKhI1dVmT5ujL76UnKj9Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071946; c=relaxed/simple;
	bh=4zXjOwbwKvNMNTCeztUyBZRzfnmlGCX+IKVc4wRE6dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jwo8JOgnNws/fh2+FBqe8hADiDQ7+qh6aRld554Wwh0Yt5UhSRqM6cWN0NTC7S9Mqo5LZ6/8U0r381zuB1dwR1u3J1HbRHA+28HGtaf+g8Y6zbMmMLQE6UzhMfHZPgMsc/E4Jeg66YfJLyJq9qCPavaS0/EdQ7/jjILJAK/FMFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RT+gpPus; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RT+gpPus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96C7C4CEE9;
	Mon, 12 May 2025 17:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071946;
	bh=4zXjOwbwKvNMNTCeztUyBZRzfnmlGCX+IKVc4wRE6dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RT+gpPusEqC1cUc6qK2Med/no5/Yt95UfO1GOP2Pig+G31VK5tW5+LOPo1dbZ4oik
	 SeE0ERvfm81vzR5P2R3QXKppQuRGqEHnF6fXZIlmvyQORENVG7gIoRTxXX5NBaJsf8
	 HpnGk90JMEAROAG2Dw/wOlByTjDC7AkWnGhf0Nc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.14 086/197] iio: adc: ad7768-1: Fix insufficient alignment of timestamp.
Date: Mon, 12 May 2025 19:38:56 +0200
Message-ID: <20250512172047.877089036@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit ffbc26bc91c1f1eb3dcf5d8776e74cbae21ee13a upstream.

On architectures where an s64 is not 64-bit aligned, this may result
insufficient alignment of the timestamp and the structure being too small.
Use aligned_s64 to force the alignment.

Fixes: a1caeebab07e ("iio: adc: ad7768-1: Fix too small buffer passed to iio_push_to_buffers_with_timestamp()") # aligned_s64 newer
Reported-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250413103443.2420727-3-jic23@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7768-1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -169,7 +169,7 @@ struct ad7768_state {
 	union {
 		struct {
 			__be32 chan;
-			s64 timestamp;
+			aligned_s64 timestamp;
 		} scan;
 		__be32 d32;
 		u8 d8[2];


