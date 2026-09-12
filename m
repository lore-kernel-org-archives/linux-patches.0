Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9BD47A0AB;
	Sat, 12 Sep 2026 13:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219132; cv=none; b=FvpxPaQpr59ZpXUmRLZpXPx3ehXhJcOUMEKYcmcD/yvzaqrXdt8pXDzh/QEd01Oygfz+BwmMezk6EhSD4k8ISOfi9lBwSWahzzmxxz7gTP/ZtqgJvQ+WesA77BIhse8VS7Qn761jlNMZFl886j1vZxuU7egIVrkJdsh2LBvyyjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219132; c=relaxed/simple;
	bh=nBQiTSM637MmlKsAdch3cKo9yc5P33xImsOeI2FXIMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qksoge+ZvmrRfCVRphV5UwywRkko4mkfpUrq1dCYXyqjKkphctts7fppZGNVeXoRdiM/7b7T6j1f+PziocYOz5asUuJhWGJu5xKocUKnQLX/Awq5d8yUUcZxXjOts3WR+BPsBlocwinxCkirQmnEZfIGRGqP3QK4K3vYAWST69c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjNWTL4G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjNWTL4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A3E1F000FF;
	Sat, 12 Sep 2026 13:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219131;
	bh=LKJxRTTC/Xm8WHaSTkrocwt4rwDar8texrNda99rXmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjNWTL4GEdzREw5DEEsOngIXvUp7thnYBA0aFkiDxHNW2fB/KfwCrkb70J1hUHNU4
	 51mSkW3XOOAPgA1lEUYU+zJWNq32q7o35POfxoaXfoxgTretI5d7tY2nwPmL8IfYes
	 EiHsi4XgHOcz2pQNolxmyI+ept3fR3WReqqAMYIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1251/1376] net: ipa: balance runtime PM reference on remove error
Date: Sat, 12 Sep 2026 09:01:17 +0200
Message-ID: <20260912065635.424202547@linuxfoundation.org>
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
index f374a590d1c5e..aa48ee2c91576 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -974,12 +974,12 @@ static void ipa_remove(struct platform_device *pdev)
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



