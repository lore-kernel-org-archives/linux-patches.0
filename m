Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A318E24B28;
	Sat, 12 Sep 2026 09:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203734; cv=none; b=pnipycCJ/oLRTa1Y2fkhP5GJ0QSew/Ie0r0xaNDFH7WqFe3wmdS/NHbTZt5AtPbd/MPgwQt+tdLmLrIJG/z+EAGgt1WkOFfOrcEd/7qVcakAEAd1BjytaIR8YXIEGBS7x7/WNfcsZcxfz1MNyIr4f6sJKeTWZZ8MQPf+wQiOUwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203734; c=relaxed/simple;
	bh=BNYy/FaVASAT7F8FzSaAp4JQ70XQySPik3j/Y3qRoSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaP3iVxLTLETRkm0BPHG1bDreFNIkVj/WxA//SZVKGSHIQojC90TReCu4QWpxPwWqNccWtNSjYDNi/8z3u2UITvlluwZZCtD8YPs1cAEwbrDcby52waltj0GomfwSakIqVvAnxzEirmYpP9fVodeCfcsGUHRNtTRRe6hYFuWzTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0/oAwAm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0/oAwAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A886E1F000FF;
	Sat, 12 Sep 2026 09:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203733;
	bh=afBR9Rqs9R6GZxlabOyPvA/CslMkzd9k2pGU6KXk1oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0/oAwAmnFYTcFxvbRaop8eAaWfeqKbWb57uhbsZcgOd2uvB7mVAUf0qga2uAnQjL
	 V4+Jr/E1zA1y9kttxd9Fooztj586qsfluwCgnG2sn6QqEgP0PXwyKkz3B0XCI600QN
	 kaaETREvJ7UOEANUBjOfOStVflAVFxNyuFVfowjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Kalle Niemi <kaleposti@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1415/1815] power: supply: bd71815: Fix temperature reading
Date: Sat, 12 Sep 2026 08:52:45 +0200
Message-ID: <20260912065722.240275219@linuxfoundation.org>
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit c15f0eabec5a051cb8190fa2bff3b211730f4acb ]

The temperature read from the hardware is never returned to caller.
Furthermore, the check for temperature validity is wrong. This yields
garbage value to be returned to caller, and also detection of
bad values read from hardware to fail.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Fixes: 5bff79dad20a ("power: supply: Add bd718(15/28/78) charger driver")
Tested-by: Kalle Niemi <kaleposti@gmail.com>
Link: https://patch.msgid.link/4ae3dfa7fc80372977fd29c837321f96d551bf6f.1786356145.git.mazziesaccount@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bd71828-power.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/bd71828-power.c b/drivers/power/supply/bd71828-power.c
index 19f24f859666a..e5e5f25474f54 100644
--- a/drivers/power/supply/bd71828-power.c
+++ b/drivers/power/supply/bd71828-power.c
@@ -224,13 +224,13 @@ static int bd71815_get_temp(struct bd71828_power *pwr, int *temp)
 	if (ret)
 		return ret;
 
-	t = 200 - t;
-
 	if (t > 200) {
 		dev_err(pwr->dev, "Failed to read battery temperature\n");
 		return -ENODATA;
 	}
 
+	*temp = 200 - t;
+
 	return 0;
 }
 
-- 
2.53.0



