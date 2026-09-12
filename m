Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAC342901F;
	Sat, 12 Sep 2026 10:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209576; cv=none; b=B55lFecaO/XSyIO9LUYNqFmnDB7CJ70o+Ti85Q7yGolbgQV0eP31+ESJKg3ouSn3x7XizhK9JT2FfNTOEMKT64H1v3TOZ8TVynFociM7PHaxQsiFZljxTdfMadcSGBky9jnb4wp+VTpo+/Pgr3H3RPHlncclAN9IlMz+jokBCIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209576; c=relaxed/simple;
	bh=Vyjx9iehX+Z3fJVmSvpmx94z2JUjU4lR/74CylfopUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doPJK1yGGwXmXT7M1sjScu3zmGIWyRn+Ud0qDIUtrrhE0Oj60ejoCnt0w2o5FfgSgo8MDIYi7WnUMIEGb38VW9apr7yYp6ydzg/CD3xVKY6S65/WDQYMfLRCSju4l3XTv4JJfQhH/BA/70TA6OJxsAJ/sstW6mg9tv3tlJ3sBWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNGsVJTJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNGsVJTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5151F000FF;
	Sat, 12 Sep 2026 10:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209571;
	bh=PtFFnLOxe6uyJ0sRKK25VZeuGfYeHpveUWL+dlhCWx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNGsVJTJNJpf8xY9d7tS9vHldDGpwnif2rJz61jCjwmQa5b/NLBCL5wxm8ZtVRp+L
	 y8NgII/vA1KvGXCK61hz9JYXbuRRGAsZolVh9mtIXTAWp238rokzHxzsaXELLFSKmx
	 xb5sonX3CN6yzEaJhkOaSaq7Aum5xFNCOi0bUsU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Huang <huangchao@kylinos.cn>,
	Douglas Anderson <dianders@chromium.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0848/1518] HID: i2c-hid: goodix: Disable VDD on VDDIO enable failure
Date: Sat, 12 Sep 2026 08:50:17 +0200
Message-ID: <20260912065642.629672148@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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



