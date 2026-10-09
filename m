Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFF43D8912;
	Fri,  9 Oct 2026 14:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557476; cv=none; b=VH8HZQj7DybyMxCkVgPP8jITlzkyBmpgyTQ9Ys9zqdkLTJcpoX1OorwcE1ZeJNMahe9QyaIjHGz+jzBrphlZ11btZIERnzSDHUu3yX0EaJR9x5ajjCtNEpR/yPlucs30UuJqy9MnyIoKwiK9hc6X70TRjbwawwj2ux/wjpzsYio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557476; c=relaxed/simple;
	bh=dibsYqHeUId1R6Bcx3dDYOspwgmRT0w2KmHP3rTFZ2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6VAyJ4Jra+IZ8uIcRFvB/PyjF3MLr8Inn6kCtt+3p3/RqRLbPGrmEsxBRSJfu2OzVRHOkeVHwzIOuNXE4vb60GkOYDKyiF2FKRm8dZDT98GlhVnN4nyAzRHY0VicXxmUsVlBBCDLxNGIYtzlyY5NicVLgXGX0KdbBc3aQWCxsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epC2n60V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epC2n60V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FA11F000FF;
	Fri,  9 Oct 2026 14:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557475;
	bh=l8KFYOSjBDU2dhkMufBtHorGz2h6ZTqlXVm6ZaACsHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=epC2n60VxZsYgLtLccog54Wk83lh/pJpRKoZB2mMGXebDMpM7N10RnaLy8IOAOxbT
	 L0PaNk9DcUHSzJnZQ/IHWZAbjicCecFDbo9l1BSyS2N0R2YmIRn+q5ydxFv4KxOCwq
	 oz89dU9pyRV9lwONbqUsizLGgJ5Z9p2ZElWZNxJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 372/428] iio: accel: sca3000: fix frequency divider condition check
Date: Fri,  9 Oct 2026 16:11:49 +0200
Message-ID: <20261009140954.355755393@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

commit d380bf5f94a892e546d9a94e8557ad866b043a2a upstream.

When setting the sampling frequency, the check for `base_freq / 2` is
followed by an independent `if` statement for `base_freq / 4`. If `val`
equals `base_freq / 2`, the second check fails and falls through to the
`else if (val != base_freq)` branch, returning `-EINVAL` erroneously.

Fix this by chaining the checks with `else if`.

Fixes: e0f3fc9b47e6 ("iio: accel: sca3000_core: implemented IIO_CHAN_INFO_SAMP_FREQ")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/sca3000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/sca3000.c
+++ b/drivers/iio/accel/sca3000.c
@@ -638,7 +638,7 @@ static int sca3000_write_raw_samp_freq(s
 
 	if (val == base_freq / 2)
 		ctrlval |= SCA3000_REG_OUT_CTRL_BUF_DIV_2;
-	if (val == base_freq / 4)
+	else if (val == base_freq / 4)
 		ctrlval |= SCA3000_REG_OUT_CTRL_BUF_DIV_4;
 	else if (val != base_freq)
 		return -EINVAL;


