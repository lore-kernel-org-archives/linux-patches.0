Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C282FFDEA;
	Sat, 12 Sep 2026 14:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224587; cv=none; b=XSDUuJWy4au1ea5CFi+Mu0pR4IdEIgb4SzdEV/2Axq80BiPP3tE7j2KkR7vmRFuh/wgIMkwVd8vzOGcGW9V9SDmyEwczDsaoQUE0GvU0Q7mWx00H4Dgy87YlRQfSHm9n7DP/lBUDCWFGumgK9xJY5GhE0FDIj04O9LiyHrawq6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224587; c=relaxed/simple;
	bh=OmYh5VTEWiNZd58S9cGfx2tg43qlcbaxTEpS/5bn2yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6zNz1OnIlFZVvIVFhjgkFny7l7Jxe2wOEel1HOBn9a8wo9mNgf6bX4fOGP+/8Mtg3oN/3Z27f41qfEPTckIg2ntBeru0G4xx9l8FIMXXtRxMhsg6uydl6Cvx819A2zcvfgHeCCP8KLKntaHOY3skLtoozDLFmPVbsSRAjNfQqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=utsSQTAN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="utsSQTAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E511F000FF;
	Sat, 12 Sep 2026 14:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224586;
	bh=zfoWbB9L2HYmgkhgJ2P/mWKW34vAMstHT8ZF479SXiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=utsSQTAN47aXEqeKaVQw8/ghBkX14+3+J+VmfGJgB27V5+IEU+7vdlKq09kf6YRXs
	 SkQISQxldIpLKG3Ktjt6+tydjwbO5KjtUzqJ8MufN+1LC7Tfr8Qg30S0y5fuenZsS3
	 ulpV86phSBn3cOkVFwt+L1x/9BDSZdrIyG4YbhAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Huang <huangchao@kylinos.cn>,
	Douglas Anderson <dianders@chromium.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1023/1424] HID: i2c-hid: goodix: Disable VDD on VDDIO enable failure
Date: Sat, 12 Sep 2026 08:57:35 +0200
Message-ID: <20260912065630.220106697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



