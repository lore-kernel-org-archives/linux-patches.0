Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F3115D1;
	Sat,  7 Jun 2025 10:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290982; cv=none; b=WGoRojTivXZscxR19QMQKORM8u7A+53ozSzPThhGSva6w7BlGDfiqyfFWhUJneYlXvg7yjrF1/leREEomJxOa1/X8Q8oEjHVdjx12/ghS2Kzm542gEXwAvdLBTsVsKIhwqBMDcS0V7MC57yvLVhqjDwB7vwLDYTIcaXyLx+01u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290982; c=relaxed/simple;
	bh=9Io1sqL1lG/PXyUipiyuCFkWKMVqSsHI1d5zOpf5ZCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E9vfMVe8gfHrZu5NgZq/izFDhJFrSgmd0IZhg0pLxMemEkpIsZlcD6XPYTfK7hG9OFEryaZDaGx2CZjOOV8sVhSiCjpdgpADg7E+9EqNQw+cYw72gwcudYXeWKM8Vhrp1R/8zP8VQwCRG595vUtyeMtk2nKID4HCpLkpT4koJ5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHzYpNmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHzYpNmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A70C4CEED;
	Sat,  7 Jun 2025 10:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290981;
	bh=9Io1sqL1lG/PXyUipiyuCFkWKMVqSsHI1d5zOpf5ZCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xHzYpNmn8Kw9b3N+H87y/vzvMvh4cL0DEMT7zPGn28z1qLiAmQEYB9WGrXiB8bCk7
	 O2rGZMc0NmExwIWCClcjKJ/BK75D6UnlwYmVMp3sYFoZuPzYZWLjeLw9m9Z0AXybrl
	 KPtwk9G8AN7jgo0DekGxRVBC0IGUM6N+kFKoqFmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Mergnat <amergnat@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.14 08/24] rtc: Fix offset calculation for .start_secs < 0
Date: Sat,  7 Jun 2025 12:07:48 +0200
Message-ID: <20250607100718.033008451@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.706871523@linuxfoundation.org>
References: <20250607100717.706871523@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Mergnat <amergnat@baylibre.com>

commit fe9f5f96cfe8b82d0f24cbfa93718925560f4f8d upstream.

The comparison

        rtc->start_secs > rtc->range_max

has a signed left-hand side and an unsigned right-hand side.
So the comparison might become true for negative start_secs which is
interpreted as a (possibly very large) positive value.

As a negative value can never be bigger than an unsigned value
the correct representation of the (mathematical) comparison

        rtc->start_secs > rtc->range_max

in C is:

        rtc->start_secs >= 0 && rtc->start_secs > rtc->range_max

Use that to fix the offset calculation currently used in the
rtc-mt6397 driver.

Fixes: 989515647e783 ("rtc: Add one offset seconds to expand RTC range")
Signed-off-by: Alexandre Mergnat <amergnat@baylibre.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/20250428-enable-rtc-v4-2-2b2f7e3f9349@baylibre.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/class.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -327,7 +327,7 @@ static void rtc_device_get_offset(struct
 	 *
 	 * Otherwise the offset seconds should be 0.
 	 */
-	if (rtc->start_secs > rtc->range_max ||
+	if ((rtc->start_secs >= 0 && rtc->start_secs > rtc->range_max) ||
 	    rtc->start_secs + range_secs - 1 < rtc->range_min)
 		rtc->offset_secs = rtc->start_secs - rtc->range_min;
 	else if (rtc->start_secs > rtc->range_min)


