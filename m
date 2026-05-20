Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6893F39EE;
	Wed, 20 May 2026 17:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299506; cv=none; b=QYSbCQYCbvz+1G0opBSGEHI/6VW6xSAjPnXLsOwlYZZ3Z7kxnIxbjupVLGeem4oHyQiEA7NI6azqK9xSSQxKishM896tqXVSBPJabwSO7Z0rYiAeFSCgu/W4hNhX/kztsY4PZRgCObsdO8+aaXkG1O6AtMqEtFmXSkB2UnQ9n24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299506; c=relaxed/simple;
	bh=1eSyL9j6uImXXqNDXL8+Xac/jv6LQX5x87HvvGvWIOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSjSjGMgI3AoHUIohG8uB+NpRnYCgE35h/+g2NfW3+EF9bVmktClrjGm2edfLcH6ZXx8MSt9yO4nNoMaOPoq1j6e3riKIw38ji+WZTg8206lfgexE+z+sOH11ESQdqeYuAc8m6bsceLvtkdJUczJkoI6a7nQhrnPrNbbnbBGHz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lg22pY+a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lg22pY+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523F41F000E9;
	Wed, 20 May 2026 17:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299505;
	bh=UXY4jiEHeM+LUNj5argwqzQjuTkh72Q35PAiY3OJHAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lg22pY+aIfJSAdtJ+1cntqZ7pNMsFMLPnqQUNgnAjTMqBvHpRk8FkhooeidE64FUJ
	 L2MzCcBGdOzaiXYPjR5XkgGbWTXtiD+tquV+HmY6vb03B/8v5kTnYGmM+YYxIXncdY
	 B1X8q01nmtal+sDHOTy9Lc/QNqWEIp11nFpcW1qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 756/957] ASoC: tas2764: Mark die temp register as volatile
Date: Wed, 20 May 2026 18:20:39 +0200
Message-ID: <20260520162150.960276873@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: James Calligeros <jcalligeros99@gmail.com>

[ Upstream commit 4cfb5971c2fbfac061c23fb4224a3a008199de81 ]

Reading the temperature register always returns the first value
read from the chip due to regcache.

Mark TAS2764_TEMP as volatile to prevent returning stale, cached
values when reading the die temp.

Fixes: 186dfc85f9a8 ("ASoC: tas2764: expose die temp to hwmon")
Signed-off-by: James Calligeros <jcalligeros99@gmail.com>
Link: https://patch.msgid.link/20260425-tas27xx-hwmon-fixes-v1-1-83c13b8e8f54@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index 36e25e48b3546..9f351565dc82d 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -809,6 +809,7 @@ static bool tas2764_volatile_register(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
 	case TAS2764_SW_RST:
+	case TAS2764_TEMP:
 	case TAS2764_INT_LTCH0 ... TAS2764_INT_LTCH4:
 	case TAS2764_INT_CLK_CFG:
 		return true;
-- 
2.53.0



