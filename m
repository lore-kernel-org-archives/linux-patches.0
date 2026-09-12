Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B617F35F184;
	Sat, 12 Sep 2026 08:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200282; cv=none; b=NZelKIFK6DCWmZIga21jFFFOWdG6WnFfM9bdhE7kXBI9nQ+pfgNZ1GyEDFtG94jHp+wyj2nF+26J+MGV8m7olgRmWG+Sj0W+J+8AzrpVfx2PE9DiMbJuCtlogzaPr53NjxfzY3CL42ZyU1F2duM+XTIK3xEBVDSKoOW5NDZlH+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200282; c=relaxed/simple;
	bh=82o8tt+Zs/hQn2WEAyU2sas6/1hckLZblYHGyFa7oiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EymGws+7UmMEwxab5+K6USdRACXdjV66ZIQqohcSPxaAmN8FL2dSBLBAJBSmFpoer92Cn8t+JkfdNhVYduE2mxA/34XsNABCzda9vF8Q11uLbqrfWnua0am6ILhrcHbVXL7EJMd6xnYqBKJ/QW6IHNXmkwZypXg0S3gh6xPaSeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hu0gd/Gh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hu0gd/Gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF111F000FF;
	Sat, 12 Sep 2026 08:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200280;
	bh=mfxDmQDtg2Y6Iz48DSG4T6+JQjZAjc73MgEvUi+amrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hu0gd/Gh11koenc+lkN5F4NjNvI+tNn6w3ntEVNXDdpO39hFRzYBD7n4V7hCv9AUX
	 SAG8wzAmU4ypWt1GLfnYo+FSmFQcMg9HSNtEjLht+zIuwASLAcyx4qajkc91vXAKpR
	 jaI+83IO8yc5T8fbZU4kJmm/E6NSGRf7cBs6MP7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0757/1815] platform/chrome: cros_ec_debugfs: Clean up console log on probe failure
Date: Sat, 12 Sep 2026 08:41:47 +0200
Message-ID: <20260912065706.680118204@linuxfoundation.org>
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

[ Upstream commit 5d187600c4603b8f7812b12ce359a11ad7a7fd3a ]

Add a dedicated error label for failures after successful console log
setup.

Fixes: d90fa2c64d59 ("platform/chrome: cros_ec: Poll EC log on EC panic")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://lore.kernel.org/r/c00974953a1b952f51f0f021d7f9fad134159909.1785320940.git.getshell@seu.edu.cn
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_debugfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_debugfs.c b/drivers/platform/chrome/cros_ec_debugfs.c
index 139cab6fcba17..6d7ff624540ac 100644
--- a/drivers/platform/chrome/cros_ec_debugfs.c
+++ b/drivers/platform/chrome/cros_ec_debugfs.c
@@ -512,7 +512,7 @@ static int cros_ec_debugfs_probe(struct platform_device *pd)
 	ret = blocking_notifier_chain_register(&ec->ec_dev->panic_notifier,
 					       &debug_info->notifier_panic);
 	if (ret)
-		goto remove_debugfs;
+		goto cleanup_console_log;
 
 	ec->debug_info = debug_info;
 
@@ -520,6 +520,8 @@ static int cros_ec_debugfs_probe(struct platform_device *pd)
 
 	return 0;
 
+cleanup_console_log:
+	cros_ec_cleanup_console_log(debug_info);
 remove_debugfs:
 	debugfs_remove_recursive(debug_info->dir);
 	return ret;
-- 
2.53.0



