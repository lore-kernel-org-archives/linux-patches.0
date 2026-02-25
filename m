Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AA025D53B;
	Wed, 25 Feb 2026 01:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983003; cv=none; b=hxSrtAmzNepVefdCCs1kDNJsXqywOImu2dTwop1DnzsK/CqlVRGprHnswPxJcE+eBzaMq+869798A2OcoaHBjcucyey84erlEf6Sa05YzqGLk61hHNbLEeBhxY4TQe2ErWxaCKEuO/veRc33rFGHAbeSfaJEZmAvD6H0dDNTmc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983003; c=relaxed/simple;
	bh=8DeM5lppd24EPFkp/VgDOnAmKj5MxuFhPOFJ+7Nayqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gsDSXz6cxHive26oQT0G4izVKEBj1Db8cXWSHyNOMXjY37XabKR76Hyt+UtFnQeA0JujZC9jKk00G/9QMuu5MA2Q2V2CWel1oj+63sO+aaEjYgwRsOiR1DyQqtY0ZCGCaccpoZso7d0IZyxPqM5nZLn8m/VOUbL9OM/9drpKtcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItPjXe3a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItPjXe3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954D9C116D0;
	Wed, 25 Feb 2026 01:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983003;
	bh=8DeM5lppd24EPFkp/VgDOnAmKj5MxuFhPOFJ+7Nayqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ItPjXe3aHuL7hYHxz0wRImqrzxoUC42RXmLVlZiPLwC5ZuHNJ24I0F7+epZsEJPYY
	 qAvTMk+T0ze2I5uRLwhT0rgm5iD0VIXLiSfScr1k+1ib8wfOrkixONP3rzvWiGygCi
	 Y0bu+luGJ5PhcLjks/pkgBW/czwViUqHiMPvfNy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 174/781] hwspinlock: omap: Handle devm_pm_runtime_enable() errors
Date: Tue, 24 Feb 2026 17:14:43 -0800
Message-ID: <20260225012403.916837776@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 3bd4edd67b034f8e1f61c86e0eb098de6179e3f2 ]

Although unlikely, devm_pm_runtime_enable() can fail due to memory
allocations. Without proper error handling, the subsequent
pm_runtime_resume_and_get() call may operate on incorrectly
initialized runtime PM state.

Add error handling to check the return value of
devm_pm_runtime_enable() and return on failure.

Fixes: 25f7d74d4514 ("hwspinlock: omap: Use devm_pm_runtime_enable() helper")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251124104805.135-1-vulab@iscas.ac.cn
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwspinlock/omap_hwspinlock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwspinlock/omap_hwspinlock.c b/drivers/hwspinlock/omap_hwspinlock.c
index 27b47b8623c09..2d8de835bc242 100644
--- a/drivers/hwspinlock/omap_hwspinlock.c
+++ b/drivers/hwspinlock/omap_hwspinlock.c
@@ -88,7 +88,9 @@ static int omap_hwspinlock_probe(struct platform_device *pdev)
 	 * make sure the module is enabled and clocked before reading
 	 * the module SYSSTATUS register
 	 */
-	devm_pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
 	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		return ret;
-- 
2.51.0



