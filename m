Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6DF41F5F6;
	Thu, 16 Jul 2026 13:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209143; cv=none; b=kPpjN7QUt2U8mPnuOprSWAmIQEPaR8X+Mi9kdPnGzDV16ixEJxwrhdQr/BjnvhMpWyhVtZ4sT5sXPKROW/a2b95uS+7rm2vn8zozUPGWT+DAHgiLOIAL61Rd968oyHJjKfLFF+18L1tHk3JnZ1s7m2+IEGzj6ZVDnAKleqDvLP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209143; c=relaxed/simple;
	bh=Z0zNIxhTojw/cQnoYyXtMfdc4dCEImGtdydRC7zGZ+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4khUA9M08wioL80fY5EuAAQfZhIB0SAireXAq9jxK/AagdzXTyaEPQ5xci0t90f4sf4sQCnLIWda6p0J9XPGT0JsL3b14rSeNmIPagh54dE3cmNKMsJlkgCx0NfIwDqQtQauerGAryA+MdKe4oJo5F3Eh6w/jzfO+gworotPTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMjdWrUW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMjdWrUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A341F000E9;
	Thu, 16 Jul 2026 13:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209142;
	bh=YglEj7dUm7e0pAlHKqohddE3ZaRTgDreesonTdIB32Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xMjdWrUWgJvwStJYFnCkuSTdKP8Xxrdsuh/5QUO+eAVKAab83WvHFrP2TYXh0RO1y
	 h6z8JmA6tudooee/znSL2OcD/UaXllanRgXYWXn24o8njTO2vyOg/OnVIEUvfYdZOs
	 aLxpBbALC7Pi0xO5oUT+b09JbAnP0ytER4rE4fEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 071/518] iio: pressure: bmp280: zero-init bmp580 trigger handler buffer
Date: Thu, 16 Jul 2026 15:25:39 +0200
Message-ID: <20260716133049.340623533@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 1172160f2a2de7bade3bec64b8c5ecf945cde5ed upstream.

bmp580_trigger_handler() builds an on-stack scan buffer containing
two __le32 fields and an aligned_s64 timestamp, and pushes it to
userspace via iio_push_to_buffers_with_ts(). However, only the low
3 bytes of each __le32 field are populated by the device data:

	memcpy(&buffer.comp_press, &data->buf[3], 3);
	memcpy(&buffer.comp_temp,  &data->buf[0], 3);

The high byte of each field is left uninitialised on the stack.
The bmp580 channels declare storagebits = 32, so the IIO core
transports all four bytes per sample to userspace as part of the
scan element, leaking two bytes of kernel stack per scan.

Zero-initialise the buffer before populating it, mirroring the fix
applied to bme280_trigger_handler() in commit 018f50909e66 ("iio:
bmp280: zero-init buffer").

Fixes: 872c8014e05e ("iio: pressure: bmp280: drop sensor_data array")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/bmp280-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -1910,7 +1910,7 @@ static irqreturn_t bmp380_trigger_handle
 		u32 comp_press;
 		s32 comp_temp;
 		aligned_s64 timestamp;
-	} buffer;
+	} buffer = { };
 	int ret;
 
 	guard(mutex)(&data->lock);


