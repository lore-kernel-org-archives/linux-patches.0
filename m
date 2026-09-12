Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D13214A84;
	Sat, 12 Sep 2026 12:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216427; cv=none; b=DRjbwvkripYCZ3Kw7I5jYMNeUiulunRtL37UOzRm4EYN616JFofa7t17TFfArzcmYiTmYvlVWAChRO5RTBC4TT/vkoQ4PIY+Vlqkqb03Tekg2dyfrMPL97zjhQnf26P72SscTZo19RnMjjFtZkuIYHcuIicpuo7sOiksvMQod8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216427; c=relaxed/simple;
	bh=GD+izeFr7dc/CgASmJpJi5UhtdajKCTyN0AWv1BslU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCa7a/uFhDBDRlQG12HeVtfFmv64AbZHk3g7HMtJScqRYAJ+dJAKDHmXXXTcoMXlwS5WeLVbhYcC3xicwfvQ+gNiZfnh4CseTQuGhsjBsJF/JP100/E4z/LFEVti4AT6PpBk1Hu8RM9ZM83+AiwOZoUAw5uQAwH5vy6kgAAQwpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnnimgqi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnnimgqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2031F000FF;
	Sat, 12 Sep 2026 12:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216426;
	bh=8A1C2g2Nuh+SgrzniGzbzvYtqk+CgORt2rkyMohd4kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rnnimgqi8rYMS0agDMSHCopnq7gA+lNc2cNflEHdRHpohmOoZ2DQFU/NNtXm++9cZ
	 u0tJElP6Ds6vOfvspalIebus61yLqdZEPSv1WzcIaKf5fzyo/iQunLM85gA6/9RFnB
	 3op8V8jzSPxRTf7LC9UkmH5cJeM2ayzYUX2Aps/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0733/1376] platform/chrome: cros_ec_debugfs: Clean up console log on probe failure
Date: Sat, 12 Sep 2026 08:52:39 +0200
Message-ID: <20260912065623.882939713@linuxfoundation.org>
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
index 839154c46e46c..ef93b34c7dd07 100644
--- a/drivers/platform/chrome/cros_ec_debugfs.c
+++ b/drivers/platform/chrome/cros_ec_debugfs.c
@@ -525,7 +525,7 @@ static int cros_ec_debugfs_probe(struct platform_device *pd)
 	ret = blocking_notifier_chain_register(&ec->ec_dev->panic_notifier,
 					       &debug_info->notifier_panic);
 	if (ret)
-		goto remove_debugfs;
+		goto cleanup_console_log;
 
 	ec->debug_info = debug_info;
 
@@ -533,6 +533,8 @@ static int cros_ec_debugfs_probe(struct platform_device *pd)
 
 	return 0;
 
+cleanup_console_log:
+	cros_ec_cleanup_console_log(debug_info);
 remove_debugfs:
 	debugfs_remove_recursive(debug_info->dir);
 	return ret;
-- 
2.53.0



