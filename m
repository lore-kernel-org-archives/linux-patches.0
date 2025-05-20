Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C08C24290D;
	Tue, 20 May 2025 14:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750043; cv=none; b=t2pFyZ91c5qJAV22u8jWX5eLK7tJhpDwHDBQPapw8v6Hon7DAPVy3pheTtuqqATb5PQeJBbMOAAqP26nT1Sil844eCS6ZXm+E7/xF2ZNw3OO9VlFxk+EokZN4/iLExtDc7vzq17QXiu6SXWFzr1URwryCSvHxplCm6VkTYdqROQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750043; c=relaxed/simple;
	bh=dQ8SjjJUS4pulirghH5tANv8QAUrWdjOy/Wc1c/sftc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dBXsIsYeK45GiziTmRwQaCn9V+4+i5dG9wQO7+WPerI4mJCjpV3OaUIF/Wzio8Dou8vLEEEXn9Cm94BI1M2XqOgcmLxc3oFfhKQiW1DNY8WbHUA84BP+aoo5Mp7QlHzQ6A4ACgNXvcV9vDG10KGhx946uyWg29XlhKiHd43zk4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4WhlAuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4WhlAuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA313C4CEE9;
	Tue, 20 May 2025 14:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750043;
	bh=dQ8SjjJUS4pulirghH5tANv8QAUrWdjOy/Wc1c/sftc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4WhlAuBHcji1SOd9xsfGsubO+S20OqQvKBhek4RxwR9pabfMikw3zof+QlWkgUZp
	 dlVa5VXwAnawH+SrPebywGTA4dBuyoX+hat5AKWU0ohxQB9ouZxyJA9RikHpxDtuj2
	 g5vh97rbD0Ng8CFSntW1TszIeXa8/goLVmOmYybQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/143] iio: adc: ad7768-1: Fix insufficient alignment of timestamp.
Date: Tue, 20 May 2025 15:49:38 +0200
Message-ID: <20250520125810.968755602@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit ffbc26bc91c1f1eb3dcf5d8776e74cbae21ee13a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7768-1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7768-1.c b/drivers/iio/adc/ad7768-1.c
index 157a0df97f971..a9248a85466ea 100644
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
-- 
2.39.5



