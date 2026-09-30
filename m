Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0762E7386;
	Wed, 30 Sep 2026 18:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794360; cv=none; b=htTXlznv/g2jzmn4I32RqBYXSIngVOmi1aGMUmzsRBpljlPTnfTfyqgADj1gfMKAsPhYRUjvaazxXxclU+YNA+1ii79srfDiC+JGnfTdnD9QBXbnAvenCDY5LzD2SAp6jOdwtJKaThkCNcG+MDf7mcbV9MXNKmP7zlFN/pHwaXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794360; c=relaxed/simple;
	bh=4Nen+4aqIP2YKs1ExhMV2ybj53v9KRB5F4BQTC7xNK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+QlfIcunJOZxx2ILPtzc1eCXv8rMWcn+c+sQJaaF0ofp9IwaegwrGHRui65/BSpn8jlueoppsLrzkteR+dWvdTRk/PMS4JlGNDLGnYqL14uvCDt0tPg7T9F5u265MwLWgpTi8uwMk4qP9Z6axxBWTeyCJ5C0Rj4DAIr/WYyICI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vo/Dl5OL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vo/Dl5OL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80C01F000FF;
	Wed, 30 Sep 2026 18:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794359;
	bh=UhI6LKPZzsgfm/PH9fRdIUbH5xQthhlySjlPNpqS2xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vo/Dl5OL63DVzFcmf3L7ICsvNDSsFE5jC6PWLq83tsvO00gDM3/7CKRa93vziAtQZ
	 A6AV22UuSUkctoSVIGlMtA/vvTFFxj5B8EE6x/ONFZWcKuF5JMCciY8kpthvef8aCK
	 /WqBW38X9RHxAItdLueLbd2z9zd6Wd9W7ys69ym4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0182/1193] net: cpsw_new: unregister devlink on port registration failure
Date: Wed, 30 Sep 2026 17:14:26 +0200
Message-ID: <20260930152438.238435552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 64f527ba9a474..adbb44cd829fd 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -2015,7 +2015,7 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	ret = cpsw_register_ports(cpsw);
 	if (ret)
-		goto clean_unregister_notifiers;
+		goto clean_unregister_devlink;
 
 	dev_notice(dev, "initialized (regs %pa, pool size %d) hw_ver:%08X %d.%d (%d)\n",
 		   &ss_res->start, descs_pool_size,
@@ -2027,6 +2027,8 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	return 0;
 
+clean_unregister_devlink:
+	cpsw_unregister_devlink(cpsw);
 clean_unregister_notifiers:
 	cpsw_unregister_notifiers(cpsw);
 clean_cpts:
-- 
2.53.0



