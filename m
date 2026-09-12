Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1C73A6F09;
	Sat, 12 Sep 2026 19:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240451; cv=none; b=f1aWa9UOHkV+j7ufVqRzWu2bspzT4fn65z+CjDJWodPVcEumP96jxDz3B6J6AQI19xFwmI0NLAhLf8YLgNvSYdzqjje90U24DbdpHhYQziX8IPFU/lqAmkznsaXA9mJPtOS250LsmFpaibFPeou5G92erXzPtEz0IFZkkIX+D2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240451; c=relaxed/simple;
	bh=aFyESu23Ju1fGT1gHZMyGuT4f7a0fGHrtB5MPxM0qiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/F7TDpoqLVvaEiYvDzHrI14+3O+H7XanFriztnWb1vhR7O4p8faYBdN9i7/iRFfKhvGQ1EqDHgd+6uF23/QKgkpnBPrNEwiuhUaATXkS5GHdqY/fFiehAogP+KtLTyj7h2YlHebEIo2x9yRo2a9ijxpK85kgMVkc3hioMDzBbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2Cr65Al; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2Cr65Al"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125F41F000FF;
	Sat, 12 Sep 2026 19:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240449;
	bh=yhjE3C7vA7kk2GBpYuKqxMCBhTbl5ggbMoYynStd9PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2Cr65AlF0oKSlP88CdCx+oX4gAOpIMIEcpRYksBLr8Nx0dFVbABE2LZu2+NFdB/P
	 GYfjeeBam0lfPAXPOkCqerze5pEHyd+51LSG4WgrE/cXjTbMi15yhqgwOojtx7Tj3x
	 XjGCooDkGbU52bRAi6yOgFS4NgxNYoL8uY1PeWbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 872/935] net: ipa: balance runtime PM reference on remove error
Date: Sat, 12 Sep 2026 09:05:02 +0200
Message-ID: <20260912065546.816991270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 6b9eaa61ff2df63c6eb35d5cd025e2cef0861d76 ]

ipa_remove() takes a runtime PM reference before accessing IPA hardware
during teardown. If a concurrent modem start or stop keeps
ipa_modem_stop() busy across both attempts, the callback intentionally
returns without releasing the remaining resources because proceeding
with teardown could crash. That return also skips the matching
pm_runtime_put_noidle(), leaving the callback's usage-count reference
held.

Drop only this runtime PM reference before returning.
pm_runtime_put_noidle() does not request an idle transition, so the
hardware and resources retained on this exceptional path remain
untouched while the usage count stays balanced.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 923a6b698447 ("net: ipa: get clock in ipa_probe()")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Alex Elder <elder@riscstar.com>
Link: https://patch.msgid.link/20260815151737.3758320-1-ruoyuw560@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 8a5dd0b595601..540abd0f8c7b2 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -820,12 +820,12 @@ static void ipa_remove(struct platform_device *pdev)
 		}
 		if (ret) {
 			/*
-			 * Not cleaning up here properly might also yield a
-			 * crash later on. As the device is still unregistered
-			 * in this case, this might even yield a crash later on.
+			 * Continuing teardown after failing to stop the modem
+			 * could crash, so leave the remaining resources allocated.
 			 */
 			dev_err(dev, "Failed to stop modem (%pe), leaking resources\n",
 				ERR_PTR(ret));
+			pm_runtime_put_noidle(dev);
 			return;
 		}
 
-- 
2.53.0



