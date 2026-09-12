Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE1647ACF4;
	Sat, 12 Sep 2026 12:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217066; cv=none; b=OskuKHXD9vjD0S2s0Vfi8bg2Uv3kMj6pUOZYiF3B3atvKHohyIhIP48GC22c4Wd1kMx919TXk0RWw5PYY8ODazbWIPrrzdf9R/wHvlvHUR+vbS2c59jsQ0VKU8Y0t8XVs/FPCv2H+ALL05u2NNUK925UB8dFLac1HjTyI/Mlzu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217066; c=relaxed/simple;
	bh=OPSSciXzIxnXPg7zZL8IXSlb+xH3h3wwwLeK7rq5b+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iE7VSxYRDfv1NgzKvpnZsmvPAq/6GKaUoo2RpvtJVeKMDb0/jpLqdg9vIZ0GtfKMbr0D5BHtHj/IDUMz2PBUX+zZ+FZh879KIbtiX2DiQ0I8MCApzYenBtUk6pSDJAU3wFG5ia/gVKQP5ZvZG37hmM0Z7c3rldZH+hJUn97dGV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xh5AN93d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xh5AN93d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BD21F000FF;
	Sat, 12 Sep 2026 12:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217065;
	bh=4mmLLGlddGQYh3z6pQ7vXbS3gD8oLzOgcVkJNfGN7qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xh5AN93dm33veBxI3LADhS6fHrq+Mo7ly0/flu/p2tUzInrI0Cmf1mnZa6gf3RP9p
	 MwLBxh+rhn/SdXvDqNLiSCuG/9f+bjC7KqVBXB3x0bao2hch4Cx0MeOpTm+/Pv1dv2
	 pGV9LVPWsb13QTz1e1ofJAHqW29Bcz6Rr7jRvBDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Huang <huangchao@kylinos.cn>,
	Douglas Anderson <dianders@chromium.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0864/1376] HID: i2c-hid: goodix: Disable VDD on VDDIO enable failure
Date: Sat, 12 Sep 2026 08:54:50 +0200
Message-ID: <20260912065626.816001504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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



