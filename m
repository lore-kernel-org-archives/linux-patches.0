Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0469921D5B0;
	Tue, 17 Mar 2026 17:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768360; cv=none; b=dgnRzSTXNIekp2TvUSfz6gvTJmJba3hWj3i6mhEQaUdUQTUjGLKJGnY129OafEnOGF95d+DNsLFBx2fEm6aVuWjwXN76W9wh6B2HDr6bK9pvsMFAjVtY4RMeI7zL5vf2fWMXLsjiFK/ksD1wg9VX7GzqwAn/aVemIiNL7d3sqSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768360; c=relaxed/simple;
	bh=pSGFpIDUGMHtuW57cBh6sW49ibSI4YtIHlsV2uRixzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kM7OwBaJv4huL48FD4DfTfRhHZuHGvtu3nrgFc7v+xhmxtO9Jv4bY9w5g+q8yERLEg6eie5RBh585qrtq26zSNZFVNZp5wGS8+ZyYPp+VE6BoUBITSEPXR6UNrCaPeLRDSOgr8ty2SUqzN4fgIREWtCF+N8QYEm2TE2mEMaxsrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UD1ZAsyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UD1ZAsyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A59C19424;
	Tue, 17 Mar 2026 17:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768359;
	bh=pSGFpIDUGMHtuW57cBh6sW49ibSI4YtIHlsV2uRixzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UD1ZAsyCzwIgdhJD0Unq93NywTOu1KMtUqtzX4P1MRWELu3R5PMvisaIIZwu+WMNQ
	 nU/5ay3UbotJPvSbJQdiQZgUsHzJtEhfRcPzWqZ6XsPO9CpM19yhGsNIG/9v6LKPO6
	 9XGao0YtxHHz+f5Jw+vIajKiXVxLUUhpxk6aZjUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 292/333] iio: dac: ds4424: reject -128 RAW value
Date: Tue, 17 Mar 2026 17:35:21 +0100
Message-ID: <20260317163010.222848434@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


