Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A912874FE;
	Wed, 28 Jan 2026 15:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615961; cv=none; b=YtF9wS5fMXHaSrtB7kGaEgW7lkPo0rAG+D4WNbtM+SRiZObJoEUR7fThEADfDbo22sQEP1pjOnBS+igdAXDpdo+yNIy/aNEY9s1XYgtq6SG/ot69xvFVvqo6slz6lqQieQ5ZgmpP8t3jX4cByNbfMKdj+8FrhMiEnRHolGwtM6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615961; c=relaxed/simple;
	bh=iLcGVKO7uu/D/ezrEk89swetY3RRo1RJwFwY1UZAZdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LSgKnruYTSMo4+KWM5wW0pqSR+aMcaSIlKkduwU07RzrRatxO2uA2VaIY+ZVja18Zypb/Ci1Qq2Mfn4yFiY3zZR7RPliZKoDYbNsM2Q+aDTI22yN19zqRHYE3xo5gwsG6IYK7Kejk/zTMblH/RvOmS7fxYeqITjr3qwjB/fh4jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMZ9B0So; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMZ9B0So"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABACEC4CEF1;
	Wed, 28 Jan 2026 15:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615961;
	bh=iLcGVKO7uu/D/ezrEk89swetY3RRo1RJwFwY1UZAZdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMZ9B0SoGjdM98aRGNUJFP3OsflOjqjwhxPCLti/PE3BHy0345CvDMmOYyxha8ACV
	 x1zxGGcBFUTrejy7ctTeCgCBXFIKM3ZhSGFelVWRiBG46cz84YZoqZ1+wU+Qg3B5YI
	 AyXyFh1iptmPvaW22o/bFXtL70yd7noD3LoDuvlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 164/227] iio: dac: ad3552r-hs: fix out-of-bound write in ad3552r_hs_write_data_source
Date: Wed, 28 Jan 2026 16:23:29 +0100
Message-ID: <20260128145350.353655590@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit 978d28136c53df38f8f0b747191930e2f95e9084 upstream.

When simple_write_to_buffer() succeeds, it returns the number of bytes
actually copied to the buffer. The code incorrectly uses 'count'
as the index for null termination instead of the actual bytes copied.
If count exceeds the buffer size, this leads to out-of-bounds write.
Add a check for the count and use the return value as the index.

The bug was validated using a demo module that mirrors the original
code and was tested under QEMU.

Pattern of the bug:
- A fixed 64-byte stack buffer is filled using count.
- If count > 64, the code still does buf[count] = '\0', causing an
- out-of-bounds write on the stack.

Steps for reproduce:
- Opens the device node.
- Writes 128 bytes of A to it.
- This overflows the 64-byte stack buffer and KASAN reports the OOB.

Found via static analysis. This is similar to the
commit da9374819eb3 ("iio: backend: fix out-of-bound write")

Fixes: b1c5d68ea66e ("iio: dac: ad3552r-hs: add support for internal ramp")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad3552r-hs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iio/dac/ad3552r-hs.c
+++ b/drivers/iio/dac/ad3552r-hs.c
@@ -549,12 +549,15 @@ static ssize_t ad3552r_hs_write_data_sou
 
 	guard(mutex)(&st->lock);
 
+	if (count >= sizeof(buf))
+		return -ENOSPC;
+
 	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, userbuf,
 				     count);
 	if (ret < 0)
 		return ret;
 
-	buf[count] = '\0';
+	buf[ret] = '\0';
 
 	ret = match_string(dbgfs_attr_source, ARRAY_SIZE(dbgfs_attr_source),
 			   buf);


