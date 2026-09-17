Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A933F5187C1;
	Thu, 17 Sep 2026 16:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664399; cv=none; b=TmkbDk2J0sdOkmEP3nOlpq/vQbjOqk/5mHyIs4oiOfaxalOKZ4l68UlKEqYZLkp+eNBaGaCQMD59auXJ8seWXKZ/lkIGS1gPdXx9K7HfhkblQuSJK+0dgYCMhS30TZrw18MoGqMi7tETM5iXpZxsJZ4QAChZbB9+PRhWuktvnsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664399; c=relaxed/simple;
	bh=DjteYOCDFI3iXOr47xjBZ0+jvuTfjBe04N4IvzUZK9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7Dlf8xkHailERvVCegSa4/AIMrAVmX4A0aiXmbS0ic3uVMFv9a4kF9Vy7Faeuueu5HyqqdduWWHef6B7TEyGCsXA2RP3EjQMcXBF0gBEO4Z4eP4bJqtbYFKeQAoW0FGRLM3bQxfEXeU7mfyhztf5Utykg2S5T+/R79bg8P+Z+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQad4umN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQad4umN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC66E1F0089D;
	Thu, 17 Sep 2026 16:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664398;
	bh=X7WUZhLOA6B6xABZhJSPV2cSPjTjWKSU3jd+kHo4nHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQad4umNrVKnWcAN/p1JbnzsTsDy3EVoKRDHGAdrrNEitnTMFj6hlZnKQkYJWPA5J
	 g9yVoyu6kE/qr023h0I6/Ue8XdaTpFy/XGn6tx7Lo0G+Tmjr/OEyXY1xtXYXHJUOdV
	 dKibhCqGzLby2YPT/9aa9ketN4mL89cFyUBAGtpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0343/1250] net: cpsw_new: unregister devlink on port registration failure
Date: Thu, 17 Sep 2026 16:02:18 +0100
Message-ID: <20260917151601.374607445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit b64f763b607426ac97e44b114f0b8844ac3b86dd ]

cpsw_probe() registers devlink before registering the CPSW ports.

If cpsw_register_ports() fails, the error path only unregisters the
notifiers and then releases the lower level resources. It does not undo
the successful cpsw_register_devlink() call, leaving the devlink instance
and its parameters registered after probe has failed.

Add a devlink cleanup label for the path where devlink registration has
already succeeded, and use it when port registration fails.

Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260604043115.1409134-1-lgs201920130244@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw_new.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index c6cf7a0375e08..34c0e651e2da3 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -2048,7 +2048,7 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	ret = cpsw_register_ports(cpsw);
 	if (ret)
-		goto clean_unregister_notifiers;
+		goto clean_unregister_devlink;
 
 	dev_notice(dev, "initialized (regs %pa, pool size %d) hw_ver:%08X %d.%d (%d)\n",
 		   &ss_res->start, descs_pool_size,
@@ -2060,6 +2060,8 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	return 0;
 
+clean_unregister_devlink:
+	cpsw_unregister_devlink(cpsw);
 clean_unregister_notifiers:
 	cpsw_unregister_notifiers(cpsw);
 clean_cpts:
-- 
2.53.0



