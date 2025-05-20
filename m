Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF9E243370;
	Tue, 20 May 2025 13:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749207; cv=none; b=IeASbmRFieJ79uMI73MCcWV3MwQ+v4/1i73H424rSPloPejzzkFKFDQxiNRcyxmmjSTbr2MfpTDftCG+tvPCjULIQKwfzvf1qvuAu8Uv94WGFMqnxae9/NOs51Dhgis7egglGyXSja2v62R8vRnbo1FzAQ4wQ4Lb8Zo2jg9wA/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749207; c=relaxed/simple;
	bh=OgTSrg0Z5ifDdwFVvQuUtVGSe18G/vOnvhsw/DYKaYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NAhfXS7lSQNQ3zdtRlNHfh0/tH0OHTYcJcxzb93njD2+nNF10hSkqAkIfuMxgt+saEb55oAZP3tFE8vjQD8murjBsz6w6H3beMrwjpLofKoYHfdGHGpvfol+b447OiLJ4MoLLU3gW2GUuCuGhMd0gJtTNTCW1AYBUgH3rEmsRKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwcokMnQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwcokMnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1552C4CEE9;
	Tue, 20 May 2025 13:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749207;
	bh=OgTSrg0Z5ifDdwFVvQuUtVGSe18G/vOnvhsw/DYKaYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwcokMnQAhaYko2o5Rw8QGr5r34amBmXsRP/cls9/QKs7ntpd5z0S22ftnmGqfXth
	 I8MBA+0wBrC1nGl4ehUgylDR9j6q2pHG6cHHOa4gRP09Gee90v4bJfs8T04gc4/q4Z
	 xSWoA754SfxaCjYMUcGODJa+6ESqHqPQ0AIa4sZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/59] iio: adc: ad7768-1: Fix insufficient alignment of timestamp.
Date: Tue, 20 May 2025 15:49:54 +0200
Message-ID: <20250520125753.975032971@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c922faab4a52b..e240fac8b6b37 100644
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



