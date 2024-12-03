Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB001E766E;
	Tue,  3 Dec 2024 16:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242082; cv=none; b=AN07aLotJKEyQUid1Q+wdSSoEYd3+ow7rkpXCqCvh/OaqhyiwsJsi/LJT/AZ3KQMQOmqQbjGxUYZMq6fizTZPTZQwNLdrPeEYPiSXYCpAxoifg/9Jg3pYlcvOENF/DtKgRuRFGWOtskvkBXRRT3LHXSMdq1oH7zPOtuQeWRsNSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242082; c=relaxed/simple;
	bh=TMSr6F+0nTu7DIcaXtzQ+t1PMfZ5k7tXNoSC+K07tU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plr5T54mzeseOEjsa7cKkJiiMyOeD68gA07NYl/j+r5JLjfEqkfe0D+eVdhWckJ5W+PgZyXRlFANPcdoDLFcSp1B0cSZ+eHfxNSNT5egIJIfec5ccx17U8Oy+DbHi4V9tsOVTTaiwo9EqJNT0P8bGI/IuYUpltOPbK27BJ64AlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEzHuhY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEzHuhY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CED9C4CED6;
	Tue,  3 Dec 2024 16:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242082;
	bh=TMSr6F+0nTu7DIcaXtzQ+t1PMfZ5k7tXNoSC+K07tU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEzHuhY2vdKQr3OK9MvcwNlaghq7hnMxgkM2id9bmGHfOoO9j1RxNWV0K1oHbrSE9
	 v+E7tYENh+XhpgDbYymnMh2T6bB9KnbTM145aP4cF69GcJS3W0RrKXLNfr+Gl0tpaR
	 8JfkKP96MJFauvmC3ZVONzsRz7Liipj48kS/BfDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Matteo Martelli <matteomartelli3@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 602/826] iio: adc: pac1921: Check for error code from devm_mutex_init() call
Date: Tue,  3 Dec 2024 15:45:29 +0100
Message-ID: <20241203144807.240086706@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 869aa5e847696bcda8966be9d03de2560226bcc3 ]

Even if it's not critical, the avoidance of checking the error code
from devm_mutex_init() call today diminishes the point of using devm
variant of it. Tomorrow it may even leak something. Add the missed
check.

Fixes: 371f778b83cd ("iio: adc: add support for pac1921")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Matteo Martelli <matteomartelli3@gmail.com>
Link: https://patch.msgid.link/20241030162013.2100253-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/pac1921.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/pac1921.c b/drivers/iio/adc/pac1921.c
index 36e813d9c73f1..fe1d9e07fce24 100644
--- a/drivers/iio/adc/pac1921.c
+++ b/drivers/iio/adc/pac1921.c
@@ -1171,7 +1171,9 @@ static int pac1921_probe(struct i2c_client *client)
 		return dev_err_probe(dev, (int)PTR_ERR(priv->regmap),
 				     "Cannot initialize register map\n");
 
-	devm_mutex_init(dev, &priv->lock);
+	ret = devm_mutex_init(dev, &priv->lock);
+	if (ret)
+		return ret;
 
 	priv->dv_gain = PAC1921_DEFAULT_DV_GAIN;
 	priv->di_gain = PAC1921_DEFAULT_DI_GAIN;
-- 
2.43.0



