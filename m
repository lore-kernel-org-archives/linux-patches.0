Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A93321325D;
	Mon,  2 Jun 2025 14:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874575; cv=none; b=kF/cHpHKTt+jHbnXQoMwa7AToass4dsuPKxbUZhs0npwa6SjXQom7mt00N+dx/Py696CJzac2PWkOl0MdWQHKMwUbYr3hJVqV7zlw517R79eL4Dsjrio5KhzwjRAmRXyPYHPGmguucTSIQuEy9QRLjPaFrSIbQRPw92uBAkxrm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874575; c=relaxed/simple;
	bh=m0CL15nfQkYiCNsI9No2RgZKaxmQbLmpm4hbCVMwlTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c3TzTWFc4ALt4iaBgBldP+xXinMu7N1D4rWhBQ/WDVGNgW4i9TyG77O7iPa0GVtAQrWDLIlLqKWic80+QJPDLzmGRNDdUT35YSNhzoEQU7mTrOFGqIt3RWJKO7adYi74celCLooTJ3g2hFKiRx3z3jzebM677WDUGsmu0Tb3ZVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfh4mk72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfh4mk72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26ACC4CEEB;
	Mon,  2 Jun 2025 14:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874575;
	bh=m0CL15nfQkYiCNsI9No2RgZKaxmQbLmpm4hbCVMwlTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfh4mk72FpX0aRFfFR+xU3gHz9UIYOIxz/0BS3OHavcUhqzKiw3InThDZ4qYEzUq5
	 p0mLK5PsRgtNcC/23Kckt00VvJad+Sm25sSHJicuabIcDiYq1gShYXBOXaiOxd9psf
	 LNb45CteBHP8Pey3ajJQwPTG3B5w+Ynl1r7NRNJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/204] iio: adc: ad7768-1: Fix insufficient alignment of timestamp.
Date: Mon,  2 Jun 2025 15:46:40 +0200
Message-ID: <20250602134258.314459156@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c1adb95f2a464..fd9aea1453201 100644
--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -168,7 +168,7 @@ struct ad7768_state {
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



