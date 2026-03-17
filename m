Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B17357A4A;
	Tue, 17 Mar 2026 17:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767032; cv=none; b=UT3DJqBaHbNRx16ylUQYUwPhUF5+mHwPkBGSwK6An7bce44DtyZ/jwkLI+mJ6e3EgYnzJ8MXZNY7AKxcbexcNBN6c40RNI0d3lEFX2gG6IQZlsBSXBcZOEzfGcGM2j9HEgkT6ZdsmPujoCWIb6DGfpSIXRO1KLtaCGnHVCGdqiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767032; c=relaxed/simple;
	bh=O/pLcXIgaeMBwj/oqMJ5ZwWlHUX7NB7lX4bhWeVrYvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbQBo9ZIx/lPX36B1uN61Fq3MMsGprq/mj9oB+jh7eMeGITOrBy3q9m30UTg/qgtJ6ARreh6VqDBH4rPUbyFJn56EtYCLvHMCGcBL4QA2LxYskurLaQwVgaIsFc80TH7CECf7h30jvEJCJPaCrL1B/vCO8udwgYEgoloJRo5P+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1fL+BN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1fL+BN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF94C4CEF7;
	Tue, 17 Mar 2026 17:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767032;
	bh=O/pLcXIgaeMBwj/oqMJ5ZwWlHUX7NB7lX4bhWeVrYvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1fL+BN5H0Q03FAT0b4kqvPCoOiMsKsX7SuuCAaVmZ5+0g6TFAXC6Eb9xt8FoeCMD
	 4vRMq5QgOAXBZAOz/TlDScz0ig6FNo4Wu6IY9FRYN7hrFJQly0nXA0DwxeAuvMZJaX
	 GnSx2sRt/9tsfdwE/2b277CcDyA3gonAzwaWLQYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 346/378] iio: dac: ds4424: reject -128 RAW value
Date: Tue, 17 Mar 2026 17:35:03 +0100
Message-ID: <20260317163019.720695535@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 5187e03b817c26c1c3bcb2645a612ea935c4be89 upstream.

The DS442x DAC uses sign-magnitude encoding, so -128 cannot be represented
in hardware (7-bit magnitude).

Previously, passing -128 resulted in a truncated value that programmed
0mA (magnitude 0) instead of the expected maximum negative current,
effectively failing silently.

Reject -128 to avoid producing the wrong current.

Fixes: d632a2bd8ffc ("iio: dac: ds4422/ds4424 dac driver")
Cc: stable@vger.kernel.org
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ds4424.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ds4424.c
+++ b/drivers/iio/dac/ds4424.c
@@ -141,7 +141,7 @@ static int ds4424_write_raw(struct iio_d
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
-		if (val < S8_MIN || val > S8_MAX)
+		if (val <= S8_MIN || val > S8_MAX)
 			return -EINVAL;
 
 		if (val > 0) {


