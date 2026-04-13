Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68151223DCE;
	Mon, 13 Apr 2026 16:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098892; cv=none; b=tThtlP9+my8iysMJXHsbCC9LX/9uXqUBgmMUSF9HoFjFS5tQmX5IWepnnqrW1sbn7nmVbSQ90Zze+rC4LIJLIu428muKI30Sv+0QiR6flCbERFKGkk4g+CFtDa22cQ8TrGRLNOaMuvvOfYnBFmrel6eyAOVZ9BqL9onWM5wd0CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098892; c=relaxed/simple;
	bh=zGpYlSxYERkNIogH5biXZn4XQPW3JMMpoWpZZ4LjTEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfqZTOo1JbeaAHcoYT3iSfvCpV5oi5pxk8fxjCNYQ/CnCFMVpzu9VggYPxQLlxCFsZZd2cCsDXdnVa69EWmkBlkxJtCOvOuT/GylqdO0O5iqEfDH9GzWrm6d6P9fbkIWdBXJ6VzOnEDrhnjK8VLy08xwR9RTJ/cmzNdXl0p/yL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1y4vIdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1y4vIdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EF3C2BCAF;
	Mon, 13 Apr 2026 16:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098892;
	bh=zGpYlSxYERkNIogH5biXZn4XQPW3JMMpoWpZZ4LjTEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1y4vIdUI0vklDf6VvaElRAv2pur1k9l7Mj/XqBJUC+XILeM4PuGxq9WVHgVYKhXT
	 jmMdQv2WvuKldkL26J6OrxA9Kw3PaaOrm1fNTRXqhEH8MsWYcsegBAMgUwT/FXzyGc
	 k6n6Ss2wBuSy/bB+qorgsc1ROHky9ZqvfsKODVlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 129/491] iio: dac: ds4424: reject -128 RAW value
Date: Mon, 13 Apr 2026 17:56:14 +0200
Message-ID: <20260413155823.871110682@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


