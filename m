Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1499E38AC87;
	Sat, 12 Sep 2026 08:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201534; cv=none; b=azgauLbesch7ZUyoumrPZkauD5Fhq3uJQLJYLw2mJnP9QjukhLbTEvLaD7bqpKLCTR6gGPH1tcEqyB70dUU1xwgha4zoPhg2BIrLveI6IaeEHzX/t0Wsp3/mTJ54YqJCoAU5Yo7sBrDXqwKrLEfjNnQnAKmLVw0ynQShEQBEt8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201534; c=relaxed/simple;
	bh=dJCm588oeZ6AQmz3HKi5gZUiOLfIb0+viQ8aNdkIVs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMrbbKVvsdY/KXJZNA4d/RVibPwaz2amqA7v8lmCo7UsYqanW6cesY2GCNhUnO7Y8QU1M/9I2kwo4fZzYmSgrkE241MLWZpFVh696gBubb52DJgr+eRVyLJxBmp2H5rsm7x+tpk2EgmOxwnl79Udaqvona1x0WL8ArfvAz8wcwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVA8Akmw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVA8Akmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5871F000FF;
	Sat, 12 Sep 2026 08:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201533;
	bh=zLXdTxpDW48NLBJTnSlvCiuqEiWhY8Ml/uScAN0/5UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tVA8AkmwrwZciAT3UdGERBhMUBUm7o8Z2r0i0prizBK19edCvSQLUbhARODyCWqel
	 hl5rUyHyKfJjyennkd3AMmS5x2pt07komfwAj0aV6ny6IPvVEy47gC8RttWpe4Xu2g
	 X9iKysQOKa0Kbt5GJ/E/O0yAJHzGmvcYV/zADgtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Huang <huangchao@kylinos.cn>,
	Douglas Anderson <dianders@chromium.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1016/1815] HID: i2c-hid: goodix: Disable VDD on VDDIO enable failure
Date: Sat, 12 Sep 2026 08:46:06 +0200
Message-ID: <20260912065712.862907567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Chao Huang <huangchao@kylinos.cn>

[ Upstream commit 8e2c560faea0220664169f7be4b498915ea1469f ]

If enabling VDDIO fails after VDD has been enabled, the power-up
path returns without disabling VDD. This leaves the regulator enabled
and its enable count unbalanced.

Disable VDD before returning the VDDIO error.

Fixes: eb16f59e8e58 ("HID: i2c-hid: goodix: Add mainboard-vddio-supply")
Signed-off-by: Chao Huang <huangchao@kylinos.cn>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-of-goodix.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-of-goodix.c b/drivers/hid/i2c-hid/i2c-hid-of-goodix.c
index f1597ad67e7c8..f4dbcd1d1d472 100644
--- a/drivers/hid/i2c-hid/i2c-hid-of-goodix.c
+++ b/drivers/hid/i2c-hid/i2c-hid-of-goodix.c
@@ -51,8 +51,10 @@ static int goodix_i2c_hid_power_up(struct i2chid_ops *ops)
 		return ret;
 
 	ret = regulator_enable(ihid_goodix->vddio);
-	if (ret)
+	if (ret) {
+		regulator_disable(ihid_goodix->vdd);
 		return ret;
+	}
 
 	if (ihid_goodix->timings->post_power_delay_ms)
 		msleep(ihid_goodix->timings->post_power_delay_ms);
-- 
2.53.0



