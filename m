Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC4C38F630;
	Mon, 23 Mar 2026 14:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275739; cv=none; b=iphkBMxSzEbP5P+eSEHrXmlh1sYyYdoEOyEyQlhteQof2WVfAyXocXBNNHmyw3PYlogi0BpY2ru/9ZzTsPNk6BSBmNvg9ODQtdB9Mn10wGuvYZLq4qLrNjMhPG9ki4tanDQrBrimfKWc6/k34Gh0WPN7KjDKQwVkjiowJ9HZ3Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275739; c=relaxed/simple;
	bh=S7WLFnjDboLkjm5NaN9yvdD6aMM68SwpqSvGZFbKUo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVO4v7I072YfC6XO42PQPiL9+DNGCsWcT2X3dZuGvr1+qOgL/rHdsiYtZcx9jfBH31FCFp4mh1pHK51opWxO3aq9SpcwznFLQnIR00aqbtH7TEcxxD2tzXawMbNBBXoGSgR0ZkwVHVjvvRijUAMta1RqNmsUsVafSZGYPp/57Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmAYgDbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmAYgDbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015C4C2BC9E;
	Mon, 23 Mar 2026 14:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275739;
	bh=S7WLFnjDboLkjm5NaN9yvdD6aMM68SwpqSvGZFbKUo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AmAYgDbx78+kJ9r77QgQ3j6BNJxTzKP3uK+wg65fpWUNzKuaf7Y/tw5qecbZG2U03
	 5WgWL7/5uqtA5yDZyWIO/5E26+z7D7F/fwM7H3A5/gBblzrFdvI4o7NM2zCW0Fkz9e
	 NIzaHGUyUGSbVFq0rKA0DAtC6zu3xRG3QSTKTjmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 203/460] iio: dac: ds4424: reject -128 RAW value
Date: Mon, 23 Mar 2026 14:43:19 +0100
Message-ID: <20260323134531.522860548@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


