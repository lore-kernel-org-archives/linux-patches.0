Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB7E3BE643;
	Sat, 12 Sep 2026 12:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216633; cv=none; b=cxwscaiArbQy8Jw9R3fGUkZsppn/butPITvB9TY+lbxVFixF3QLza/qTRUjsAIJ/EUgmNK8gDCvctbD4dyUL2EAqqCt5zCTD3AO4ilEJ0rSYh1zCt43QvXzYmrmPAD0XWTDIwrPc/QqxTuSpf9qz8adnKSkiAKwnlC79kTdOgnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216633; c=relaxed/simple;
	bh=0J5jCTQpUht1xtqNcOrV93WNtBKK8Cx+JKbwSVek21c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5lZV6uRCep43UiQPwmslxWY8Our3rPp/VX9pnatR7t1+GOeQ4mqm11wFB39RueSfiqDKu33/RG5Uychd2tYwcSeXXOIlcH8JmRlVa0rgk0QcYN9DFSgcqSCBrnZzqIFAU1ZjCrMECQ3fzmKzL/KaF+otybgp+crYU9aj2/O14U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYRSW7MA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYRSW7MA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D511F000FF;
	Sat, 12 Sep 2026 12:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216632;
	bh=sWCNXnVEvXHJJUCFZAiHEc6AwA5SuVGF07P/hJ8BFG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sYRSW7MA52dWpI9PS77PpgLU0XkPZyL7/nucrUamUagMwQvqvrpYKIU1TYqGHAwZW
	 gdqZjgFtDNVVhCcYTwqpnistMBM0pWNszThqH7gcPmHSw5jjHregKk9AsLnOS1HzBc
	 EqRWDILBPLCatY/eBfcQI26fiATLr0cr6ZJUhtww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0775/1376] power: supply: isp1704_charger: cancel work on remove
Date: Sat, 12 Sep 2026 08:53:21 +0200
Message-ID: <20260912065624.811229263@linuxfoundation.org>
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
index 860d8614c98fd..71008c5d9d7f5 100644
--- a/drivers/power/supply/isp1704_charger.c
+++ b/drivers/power/supply/isp1704_charger.c
@@ -482,6 +482,7 @@ static void isp1704_charger_remove(struct platform_device *pdev)
 	struct isp1704_charger *isp = platform_get_drvdata(pdev);
 
 	usb_unregister_notifier(isp->phy, &isp->nb);
+	cancel_work_sync(&isp->work);
 	power_supply_unregister(isp->psy);
 	isp1704_charger_set_power(isp, 0);
 }
-- 
2.53.0



