Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF584BEE32;
	Sat, 12 Sep 2026 11:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211809; cv=none; b=AW/kg5idsNSQVIjziATpE+c8MV0Fh5zxPdLptT37JnVVRRzC2T1tIcPVtPN/HkWVjIjHO7xFCa+qV54entD60oTXb4L0irtp9D6iZo6XYtPZ1UGjRQf8WXpcjhLUt6PeXP+HT4PDb9lIjOiLDfrXP6R6jbCSQ3FoR1JEKvbwNVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211809; c=relaxed/simple;
	bh=tXMfH2C/oWOel3g91Dz3P2Nbzz9R7df19kH+0CbwFJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBqKz3XKOuvyyJtRTFVQ54zY/ZX2otg6atMaOWuuo0t50wMdSoJ69Bt9NViJZqo710B4X87n7/qlZa2LZTy+gLaGwZPUZi3CI4AjDULuZukp73pVyvvZLKMtBY2JT3gVIKzWcjBWYwoOhU1utjYNSO2s6hfep7VIebm3jkg7HYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rclCGOBv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rclCGOBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58231F000FF;
	Sat, 12 Sep 2026 11:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211808;
	bh=zMKvKHt9jtvVNaFrmXsJSFBNiGY6mCw2ewzLA0gRfFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rclCGOBvbTC/dUInT2L1ro/CWXdnSfdBTejnIzpUAefWQcwnJz8PVa+JM/Zn+Yd5p
	 f8OEOiy7Ogkl4nFWbE6gJmFfr2qj2tPz58PT8WE2MBMfKWmR+vKNXD1mDkRFhp9l2f
	 tPioc708S+coBczI82L957chnDaoxYn5xfaz0KYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1307/1518] rtc: gamecube: check return value of devm_rtc_register_device()
Date: Sat, 12 Sep 2026 08:57:56 +0200
Message-ID: <20260912065653.091509756@linuxfoundation.org>
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

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit ca45cfa74370644d371b552bef57938c19e3c80c ]

gamecube_rtc_probe() ignored the return value of
devm_rtc_register_device() and always returned success. Propagate the
error so probe fails when RTC registration fails.

Fixes: 86559400b3ef ("rtc: gamecube: Add a RTC driver for the GameCube, Wii and Wii U")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Link: https://patch.msgid.link/20260731080458.417532-1-gonglinkai@kylinos.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-gamecube.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-gamecube.c b/drivers/rtc/rtc-gamecube.c
index 045d5d45ab4b0..889028cecf4a5 100644
--- a/drivers/rtc/rtc-gamecube.c
+++ b/drivers/rtc/rtc-gamecube.c
@@ -355,9 +355,7 @@ static int gamecube_rtc_probe(struct platform_device *pdev)
 	rtc->range_max = U32_MAX;
 	rtc->ops = &gamecube_rtc_ops;
 
-	devm_rtc_register_device(rtc);
-
-	return 0;
+	return devm_rtc_register_device(rtc);
 }
 
 static const struct of_device_id gamecube_rtc_of_match[] = {
-- 
2.53.0



