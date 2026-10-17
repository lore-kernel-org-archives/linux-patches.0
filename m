Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F614384CED;
	Sat, 17 Oct 2026 16:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254136; cv=none; b=O3Vktab26Me+0imgibqM2781B7lniFGgxIALs1NlCTru7OULRJODpEJRF8HXHuWhze986MXvhspmMTFVZCIOTdZzBF0P/j3ZE2qWKMUGlSIVmV6A4jRXkGJXsOuF4KEyp/f55ZY7z/JBIka3B6GR2nCBDrVWaB954ZvTZgq8SdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254136; c=relaxed/simple;
	bh=8qQ3uYj/gZ2g9XWyI+5mFAWetH3x1Sn6UelEtYMhA3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KugWsf/VlUOCQ3qScsJ6PInLgrZcz+pd8z8omYAtnWtEl1JnNk6FPszuF4k+KkNJaBFnK4tbMWUATuB3lKFFpGtHmhUXIPgogUmXlz1c/1C7ojsl91WuI7OL4kvodJc+Pta4P09zOWPvqjQptucpa+f3TnEWiwrFZGUEQ9DZD5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6yZsNzU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6yZsNzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743B01F000C4;
	Sat, 17 Oct 2026 16:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254135;
	bh=gsZgP9pAuMqYzYrUVuBR+DfddTupbJtgGSdBRe/Mm3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6yZsNzUAQqhooHXx5mfTBqK0XQCdJXeEJaweuqEVl1vm+YqX1xsblz44TyZgZf82
	 R7eYFBkOM33u26xWE77qq9yA/wI1wVKaEdd/PaxN1TcBSch7uHeXStBUD9GWxxlT+K
	 Sno/u3+XW6yu+OhmGK7n8OV9ishq/gxPlQx8X9tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 348/869] ethtool: module: call ethnl_ops_complete() on module flash errors
Date: Sat, 17 Oct 2026 17:53:09 +0200
Message-ID: <20261017160046.022651409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 84371fb58423f997939aacdcbc02d128d76a54e5 ]

When validate() fails we are skipping over ethnl_ops_complete()
even tho we already called ethnl_ops_begin().

Fixes: 32b4c8b53ee7 ("ethtool: Add ability to flash transceiver modules' firmware")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Link: https://patch.msgid.link/20260522231312.1710836-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/module.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/module.c b/net/ethtool/module.c
index 5a08c320b4660..e01275103bcd0 100644
--- a/net/ethtool/module.c
+++ b/net/ethtool/module.c
@@ -425,10 +425,11 @@ int ethnl_act_module_fw_flash(struct sk_buff *skb, struct genl_info *info)
 
 	ret = ethnl_module_fw_flash_validate(dev, info->extack);
 	if (ret < 0)
-		goto out_rtnl;
+		goto out_complete;
 
 	ret = module_flash_fw(dev, tb, skb, info);
 
+out_complete:
 	ethnl_ops_complete(dev);
 
 out_rtnl:
-- 
2.53.0



