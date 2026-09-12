Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E68D3750C9;
	Sat, 12 Sep 2026 16:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230421; cv=none; b=Ap+lIDhHHuu4xZGwzeu1uEVa28aBTkP7cb9EptaLLVG/7+RGmda4lg/zkbVaLdFcWUOZgNXMPfNP/hrUlhneYjDSqXkZsn9pDnifxDYcapwU8PMQaQzYAwPJNULjM+HiM1urYvLIso4jhIV/8uB3pK/3yh/EULizNMK1HdVXuYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230421; c=relaxed/simple;
	bh=UjNS2ZmwZt8q0O4WCMry1uc91wxVgbPrVJ8htBmwo+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYLaywDLsCoTHzYxYenl4O4duWWxvucNrnyVGuLc/cHTfLaE6zpiYT9cjMIOap1aZcv/hP2V1yV5x+H3dWb4GzzOVC+K8F7Pe/c7IGMDI9Vbg0tildgZ0WviT8de15ithYOp3dWQ55eXfvvyNGdIYKQPm60+aBEufziv0UNDfWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUp+7TNZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUp+7TNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40291F000FF;
	Sat, 12 Sep 2026 16:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230419;
	bh=lZBkRElaDfZsNxyejmh4vSHdXytyfrBw41pEPRflQhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RUp+7TNZCB6f8yeE9lwP8FSQO7zzfEg7kkX1ZlV+7WTTWSME1dfvJfPXW/vauvfBY
	 sa5nja2LzYoI2850IULaHQGdreVMUd2UhDIqU5IhdD/R6R57vv45AQ18nqs/btttd2
	 fCpL8fU66bQqR5ZR3pirMrJT2ayQThFG5u7dwVO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0783/1191] power: supply: isp1704_charger: cancel work on remove
Date: Sat, 12 Sep 2026 08:58:31 +0200
Message-ID: <20260912065605.864521846@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit 60c5b8a9ef4dbc5d69bbc1a960fe55826cb3b643 ]

The USB notifier and initial VBUS detection can schedule isp->work. The
remove path unregisters the notifier and power supply, but does not wait
for queued or running work before tearing down the power supply state.

Cancel the work after unregistering the notifier. Do this before
unregistering the power supply.

This issue was found by a static analysis tool.

Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260728123423.781-5-getshell@seu.edu.cn
Fixes: ec46475f3e31 ("power_supply: Add isp1704 charger detection driver")
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/isp1704_charger.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/isp1704_charger.c b/drivers/power/supply/isp1704_charger.c
index b6efc454e4f02..2233dc9cefe08 100644
--- a/drivers/power/supply/isp1704_charger.c
+++ b/drivers/power/supply/isp1704_charger.c
@@ -482,6 +482,7 @@ static int isp1704_charger_remove(struct platform_device *pdev)
 	struct isp1704_charger *isp = platform_get_drvdata(pdev);
 
 	usb_unregister_notifier(isp->phy, &isp->nb);
+	cancel_work_sync(&isp->work);
 	power_supply_unregister(isp->psy);
 	isp1704_charger_set_power(isp, 0);
 
-- 
2.53.0



