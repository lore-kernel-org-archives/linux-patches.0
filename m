Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E891650E5BC;
	Wed, 30 Sep 2026 16:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784460; cv=none; b=Id+l9+ZO031d4v95c8v40bLkfmaWtfzIbZp+YHr8vegQ28wi3X76WhyRFH0Ug3/orKXuVm8iVylujHU+Uf7z1zGxuuJt2gFZ1Uwj5vYDCGL1ECNBBXfMvCgqdfucZazDuhFJS5KbMao6N7WHLJ00q4+Bbr1B0KhnIIVkCNgEPCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784460; c=relaxed/simple;
	bh=m5iVP/DYwoGHC7FIsrM4K+MXsdycS/1hDFkRYY3RZQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBkMwGKwJJAvibiAA0n9Fx7TTC8VcOIsdEfhBSxjXkcAW2wbmm6MlKBFVMkh3yb5C2FV3tHFmNGzM4zirLGCfCnDLn2OOpDsPoozxsXfoGF+nNIIuuuGAc3A2vhYc7NeAhYyjzlezxz6GtrWTEj2HmD7+ZsDuKvCXv1XzHT+khI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRNLD7b7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRNLD7b7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7871F00899;
	Wed, 30 Sep 2026 16:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784451;
	bh=xbn1f9F2kLXybogqDESJisFjKNn9LNblpjqKu3NjKNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oRNLD7b72ObI9ZSDG/hiuShloYDezzeVzoDRSSZo1lx/rLWqv9nt1CnXcr6HBWE0g
	 2kPzI/Ku3MA1SNfoY/PRC7XmlsjmB8TfTXXEWcNMjIIJU3aM6JQisJXigq26mWmWze
	 b2tTNggoiBKSMsEmWqHcdere1Kmnfm3CkF53/Ld8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/982] net: cpsw_new: unregister devlink on port registration failure
Date: Wed, 30 Sep 2026 17:14:54 +0200
Message-ID: <20260930152420.203371017@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index 17c267f6d79aa..931fc8fdead05 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -2010,7 +2010,7 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	ret = cpsw_register_ports(cpsw);
 	if (ret)
-		goto clean_unregister_notifiers;
+		goto clean_unregister_devlink;
 
 	dev_notice(dev, "initialized (regs %pa, pool size %d) hw_ver:%08X %d.%d (%d)\n",
 		   &ss_res->start, descs_pool_size,
@@ -2022,6 +2022,8 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	return 0;
 
+clean_unregister_devlink:
+	cpsw_unregister_devlink(cpsw);
 clean_unregister_notifiers:
 	cpsw_unregister_notifiers(cpsw);
 clean_cpts:
-- 
2.53.0



