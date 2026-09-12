Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AA9369990;
	Sat, 12 Sep 2026 08:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200585; cv=none; b=PUZYUY8/LeLXgdfgtun/I67sbPb80a8c8/v/PltQXSXZwtcYuh9ba3FyOCRs/Ea2BMDhsu5wGZxyHfZJAtvzVJ/BByh2QeMrl9IRBbRdn9wWLdcitQDqRWVU31oio0msf4PZMWvlkkmQylOljFqy9bOXGjf+9mmUsvHGNBeBRrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200585; c=relaxed/simple;
	bh=tKTRc2jGBidNDsVun+ltiNmBjlASf8hkY2llQ/4D8Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xr21QTyQDumV5PDdeUnzbeSidcVA4rLicvdQUTdvUxMPI+5YIgQgZ+r1w53KNlYRMEg67oPliK2nTx+NMjFsdNd1J86xdrGxnj+gaCekZupNzDnXajk5f3e/L+22g28f8Omb1UQ0nSPGg3WMhK0JSZe7L7U3zFRWGRkBGIXEjk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkrCn260; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkrCn260"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978721F000FF;
	Sat, 12 Sep 2026 08:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200584;
	bh=1xYb2xRomCWQyKI/wuYX+JTWyCaZWm+06qriZeMjit8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkrCn260+z11sd5XN/v/ZpsYTe213c+q81R+Lwp6yQNbjz7Bg33qaB/9vFM65kRNH
	 k4UlXSwGQ8RsXSk08/uLXDH5MpN/E56v2oPEYIMfVU6D9vn77udQWCuODSmTd0kAuE
	 NDX3+ujE5UwAjdwPJtV9mJ9fleYxRyy+ihREE/AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0818/1815] power: supply: isp1704_charger: cancel work on remove
Date: Sat, 12 Sep 2026 08:42:48 +0200
Message-ID: <20260912065708.116326909@linuxfoundation.org>
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
index 237912a922724..e329321d06dbd 100644
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



