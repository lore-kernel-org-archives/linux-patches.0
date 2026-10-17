Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3276F3B14A9;
	Sat, 17 Oct 2026 17:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256827; cv=none; b=Ses3apWtrkc9he5o+sQnLdxAEoqfOWYVH8DuZZGhhrLRU9iHrFBFQpwBM4RgHhx/FWD6wuBHZsU7EkutbU5ENuOje50iCrZ/ztq+UEOcG8rkLl2zj510q4elnfsI1+4/n1O61bx6iNtpzDGgP9WEFO0UzuAN2evhrI0S/X/Mrp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256827; c=relaxed/simple;
	bh=zXsiQXPUVyG418oRmf8uuKWRz3FLZfNdAkvceaaQXBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6RScPxyfJKb/Qwa89yJ0KKs/gMZVcipGNyBsfmVS/V4rx3AS9RXEqSljMNivSxzRd+IavslFwlvEepUpSQkhD311HGQBtlIsuylVshl7Ir3hAoYr5hNiW1RQC7vsdkJPu/criyBChAO7F8ze2apyn9gJ7Qqn2xvnQz8TtXgk3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hioujyhq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hioujyhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1EA1F000C4;
	Sat, 17 Oct 2026 17:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256826;
	bh=nPDflpdiMFnHefK4qIG6jRCljD8eqvQ7ZtKsGQZupjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HioujyhqSIO8HDWD/+eRuHeGGRrHe7Fa/SaHhrc5SYmPBzRey+kLC1gBh2LtBwUKK
	 HJyphyxQWQtcDSAvcAovHEINvrl8hDJOGTyc7Vsmsusg8mXKYg6AA5/R7/VzK7kkcK
	 Zs0r9KCgNIqLpw17MN+QtNyGjzjcvR6UWwhaWZ7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0364/1674] wifi: wlcore: Fix runtime PM leak in wlcore_remove()
Date: Sat, 17 Oct 2026 17:43:56 +0200
Message-ID: <20261017160440.463409969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit a8b8881d0c1aff544fae190469d86db7b07f43a9 ]

pm_runtime_get_sync() keeps the runtime PM usage counter elevated even
when it returns an error, so the reference taken at the beginning of
wlcore_remove() has to be dropped on every exit path. When the device
was not initialized the function returned early without doing so,
leaking the reference.

Release it with pm_runtime_put_noidle() as done on the other early error
paths of this driver.

Fixes: fa2648a34e73f ("wlcore: Add support for runtime PM")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917122325.2150910-1-vulab@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 535b47e54d6ab..45563dd3d212d 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6749,8 +6749,10 @@ void wlcore_remove(struct platform_device *pdev)
 
 	if (pdev_data->family && pdev_data->family->nvs_name)
 		wait_for_completion(&wl->nvs_loading_complete);
-	if (!wl->initialized)
+	if (!wl->initialized) {
+		pm_runtime_put_noidle(wl->dev);
 		return;
+	}
 
 	if (wl->wakeirq >= 0) {
 		dev_pm_clear_wake_irq(wl->dev);
-- 
2.53.0



