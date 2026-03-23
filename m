Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E144C3BE63F;
	Mon, 23 Mar 2026 16:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282735; cv=none; b=XBs5q6gSFd+9fNfGUyzHhbkodluIni7CuCRb+twbKb3D1bKPN5ayGlG4Gxxgr13bT3i1Fv8NJGVm5cQLpmI0WTOz49o7hBMBtJDBf0oxMc+nFAMVWWuBQd8Gnl2WIQ5or1kZ7LcbVBoPc259qkHlNy1x0tLG+4+NeEINTOr65aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282735; c=relaxed/simple;
	bh=G+/NpwCzktAm77zb4tkBaG0Q5sfhWsb46XBIK8RXy0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhmxRcpnnSdS59fcTf14Zfeg94JSuOZmRgC57cJHD36g/2muAi0HNhiVXLo1+ENV1Ak1FtyKNbLqFRiI+6Aq0AxFm8i4/CspPTEs3QCzTkT6sD0CKPa3rtgchXY63dL0RyLF2beV4kxJ0OCJprTwanO6Z3+na+I+x4PnGp8E2R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfblRFDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfblRFDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBC7C2BC9E;
	Mon, 23 Mar 2026 16:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282734;
	bh=G+/NpwCzktAm77zb4tkBaG0Q5sfhWsb46XBIK8RXy0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfblRFDJNmsNj7TH7k0UZyIExAIBGoKgFRFENbKVTfuSyGXEb/6/6ML93RQ7Ts8e0
	 pj3l3zF7ziPCtcIbBjWFAF3Q/nybOWf3FpUh58KIfjH9NvlJoVz64BgRZVdOlDMvnW
	 xveoJ/O0fBXkZs5KjptHrKslTxzYnC12RQH0vqpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 265/481] iio: dac: ds4424: reject -128 RAW value
Date: Mon, 23 Mar 2026 14:44:07 +0100
Message-ID: <20260323134531.601218908@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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


