Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097AB2D3A69;
	Sun,  7 Jun 2026 10:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828495; cv=none; b=nrI6BTLY48oNDs84J8KDNG4yXMgfIIzbdL0DGJ7uU3z0AgAGtWS2FYQjAQi85NaD01F1vJGW9Sn/7V9PH4XWMRwIeHf5ONXhgTtR1Ayir4c0FxMDw/sR7A398ichxE5rtIVk/VYUYlv85j03b9YZlgclvW02iQ3rcHdfsBRiT9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828495; c=relaxed/simple;
	bh=B/UQ0d0hRhcMWJKn7ycCxwvoMkkuJYFnDxekHRYgeP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhwNKiI0mb+BrOOCjbEx3Jcwydd1B/DQh+WfvuloF35j3TVWzgnxhDS8KBHDDHJg5878fhom4WZgT5kMrM4N2AgA30Rhz11/YcJVCYTtVmbZKUkmMZ06hB9pcm9Rct9ZgKKhlLeqhoUxsyYiWtqO8WSiOckd2QsXEfHS5H5j8mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MF4do9HQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MF4do9HQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC261F00893;
	Sun,  7 Jun 2026 10:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828493;
	bh=xQyShybSuHSL9Q0otalrKJn3Jrj82YrpX77oDAD5TIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MF4do9HQ/jaeSY21m83BWnD+eJBLClToqBAHwTI2y4mO7GAtIJtUkoDuBv7KlapKo
	 5vF1QxpO3Ha1SDIxquV2Ujubh5JjHPyPgqcMXW5va7PMsCU61GZmKBmKwcmNNSKmyJ
	 cFZ9lU69oIkoCsqCEVtQEvQctY2A0YvClwTktK6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.0 188/332] iio: gyro: itg3200: fix i2c read into the wrong stack location
Date: Sun,  7 Jun 2026 11:59:17 +0200
Message-ID: <20260607095734.971529590@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 


