Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D543AC17;
	Sat, 12 Sep 2026 15:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226022; cv=none; b=k/9lXJ1jnKHj/MhfN7CyNmeMsPPVitXHwsBjqupHQcTVWQKcH9MYA9emUry7uYnJ/ApuymmK7Ye/P/pDQHL+oXMb8NEeCrgXz/qK3oYyEUeX3fd7g/4FUj2Ra2zr3tz5GAOeHVWe+yT8WTslIqYkNr8j/gXnW1Yn7n4vhko06do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226022; c=relaxed/simple;
	bh=oidabuqHJRUQ5IwaJvSaHiRN9tRV/2W85uIznqDUU78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1mWPSRFrXMDiJrc6L96/GB8qapW8hpBg+ErqUjaDn+qJWkUJbQGHIhaoWA9m9D3eDayIZCirmy6fx8yLStwzt7AlvYBER+EZNPmfysYC3SqTKD/ubccaE2QgScjQkmJEnNQ0Zc8M+dVhyO6kKnfF8UUP1AGXd6D/wzfjHay5/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QM/+KQsm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QM/+KQsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1271B1F000FF;
	Sat, 12 Sep 2026 15:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226021;
	bh=E3eBy4p+Mm9YStd1JVdO02ImWe0n5Dc8woShitwwMVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QM/+KQsmN93AR6iOtWJogtRqKljkhB184WyZ1XuYyoxaIvnvj7MsWCD5f4gMba4/r
	 b2D4rEJG2U++dWPta+lq2AFTXn64eWfqXCKh/Pnc7B6PYtCnp/9OsmTruuqRHPhEmt
	 pnaCyyIclHYAwcxdSdqpRQF2MmurGkWrP0iXLhzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1315/1424] rtc: gamecube: check return value of devm_rtc_register_device()
Date: Sat, 12 Sep 2026 09:02:27 +0200
Message-ID: <20260912065636.710077700@linuxfoundation.org>
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



