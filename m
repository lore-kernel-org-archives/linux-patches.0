Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4804E2F36;
	Fri,  9 Oct 2026 14:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555449; cv=none; b=UMsvN4TBFtobN0d/y7uHvC475JuTqOGEhAy4BbBhGx+n1VrOO6nc624r1MSNS2md9oSTnJXhXUNQ+uuyFnfeFdqXV5y9XtdZ3jWpBV56qJF5trJJp4wybyFXg+7SXKV6buqT5GtqJB5+REAmRzYKvMK/CYOB0jrHM7Q2drUQ/uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555449; c=relaxed/simple;
	bh=t/rWIRSoONcCC+l1v/veYswzwkBuhpMIf/S3w1HNCTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckKPaZDfVMGb2xAJzDXmTqbwjQUIE30AOVHw/WsvfTn+jIFZxAFcoVXHu3+wGPl0DCnd6sC9mJJOvW7nwpGC+Bds2/mXKg0H8KoMxHuW36JhMpXwlIBK71Ls7p9p4f5HvUhLbXkP1C3rd70dYffzUoIE4p476eRYjrFkreKKAGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5HYxT8x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5HYxT8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA031F000FF;
	Fri,  9 Oct 2026 14:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555444;
	bh=62fwmuoBKrtXQHO3eEkDLIhS606l4ekRgAohkw21mCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5HYxT8xrlsZpavD9AiGNWY1ax28snicxL1I3vNivhJKlW6SrlVQgU6t/q9IJFkaL
	 kmWg3ZClTpiM3AKA6g5+De9mJBwKiGpJA2askdhBDuPvRLUJ6JMCyNSycRGVd7tyXi
	 TZFsj4zaNmyr8F8Iqjx74AVvMZZ3m35DRVsoLHVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 059/403] iio: accel: kionix-kx022a: Fix array boundary check
Date: Fri,  9 Oct 2026 16:07:00 +0200
Message-ID: <20261009140953.479713629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 0e65412aee4f651d2c9785f542a13e4b44002a75 ]

The driver performs a sanity check for an array size, when converting a
register value to an array index. The check incorrectly accepts the
sizeof(array) as a last index, when last valid index should be
sizeof(array) - 1.

Fix the check by bailing out when index >= sizeof(array).

Fixes: 7c1d1677b322 ("iio: accel: Support Kionix/ROHM KX022A accelerometer")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/kionix-kx022a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/kionix-kx022a.c b/drivers/iio/accel/kionix-kx022a.c
index 39485572a76b4..8a13f78aeab07 100644
--- a/drivers/iio/accel/kionix-kx022a.c
+++ b/drivers/iio/accel/kionix-kx022a.c
@@ -649,7 +649,7 @@ static int kx022a_read_raw(struct iio_dev *idev,
 		if (ret)
 			return ret;
 
-		if ((regval & KX022A_MASK_ODR) >
+		if ((regval & KX022A_MASK_ODR) >=
 		    ARRAY_SIZE(kx022a_accel_samp_freq_table)) {
 			dev_err(data->dev, "Invalid ODR\n");
 			return -EINVAL;
-- 
2.53.0



