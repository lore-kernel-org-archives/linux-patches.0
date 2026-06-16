Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17B43A5E91;
	Tue, 16 Jun 2026 17:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631022; cv=none; b=njYM5ryNgPurfa4wSuLb+1KDVBjLcuSl1qvFrcjZucXsUcrP8em/ZQlm175GQxXcTimDU4U7c5nBRqyzDtDXGGgMMkPHK3soFdUZz5+AZxWysk2Q6IZ6bJEDoKIabM4CyDAG6RkWlAkvSYabPTCIcfItai1XfBnG5oB0mluGZKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631022; c=relaxed/simple;
	bh=4uOlNO5+rRZDUsYb5pCzYHE3NvH9/33PXUXWFhJmwbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMtvpapKmYxzuqKv/VJ6IqUcceKaK23rp38KXRPEuPeVscLIu0HV1eBYWdJG/FiHpJEzBoXczNAB1atiNujaiJ9Wj5FtCDByWEm1wyU4BVufozt3mGIraGNquCKvstgD6qsI3FawEDo6jZPiabkOaBs4MGj0KsiZ6Mdfy2X1g9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3yNKbK+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3yNKbK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E291F000E9;
	Tue, 16 Jun 2026 17:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631021;
	bh=jwGy2dbpShF+d+S6cyQpg89vsjTHGaVpLk1/CCFB+m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3yNKbK+JyURmEbxpEXQI4FO4FpFtgS0AUBK2dzwULbElyl9f8poNVh263kZ3zlFU
	 3jns9S78H1AeHehqf9s6DL/AlhEEikYVISkoagLxS4C+CfbYPRhoo37Oh41GyinxwG
	 ezHN3U8iJ50DzC1kZ5tQl2iskbSLdNfIsfGBuDW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.1 108/522] iio: gyro: itg3200: fix i2c read into the wrong stack location
Date: Tue, 16 Jun 2026 20:24:15 +0530
Message-ID: <20260616145130.994076396@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 6bdc3023d62ed5c7d591f0eb27a5adb37fb892ae upstream.

itg3200_read_all_channels() takes `__be16 *buf' as a parameter and
fills the i2c_msg destination as `(char *)&buf'. Since `buf' is the
parameter (a pointer), `&buf' is the address of the local pointer
slot on the stack of itg3200_read_all_channels(), not the address
of the caller's scan buffer. The (char *) cast hides the type
mismatch.

i2c_transfer() therefore writes ITG3200_SCAN_ELEMENTS * sizeof(s16)
= 8 bytes into the parameter's stack slot, which is discarded when
the function returns. The caller's scan buffer in
itg3200_trigger_handler() is never written to, so
iio_push_to_buffers_with_timestamp() pushes uninitialised stack
contents to userspace via /dev/iio:deviceX every scan -- both a
functional bug (no actual gyroscope or temperature data is
delivered through the triggered buffer) and an information leak.

The non-buffered read_raw() path is unaffected: it goes through
itg3200_read_reg_s16() which uses `&out' on a local s16 value,
where that is correct.

Drop the spurious `&' so the i2c read writes into the caller's
buffer.

Fixes: 9dbf091da080 ("iio: gyro: Add itg3200")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/itg3200_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/gyro/itg3200_buffer.c
+++ b/drivers/iio/gyro/itg3200_buffer.c
@@ -34,7 +34,7 @@ static int itg3200_read_all_channels(str
 			.addr = i2c->addr,
 			.flags = i2c->flags | I2C_M_RD,
 			.len = ITG3200_SCAN_ELEMENTS * sizeof(s16),
-			.buf = (char *)&buf,
+			.buf = (char *)buf,
 		},
 	};
 


