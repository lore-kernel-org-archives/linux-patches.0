Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55833246BCD;
	Sat, 12 Sep 2026 10:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208660; cv=none; b=nyO9OolPXJU0H2d70ntroht/FerLKiLMUsc3PS1pJSJruaRQrCVeWc2QKobpSkD9aJvs67TXndKf5H2rOMnRjmOUXqBApus1x2loa2ldIUPvG7qmqhhP0vpwvgzKddLVWlrt66u/13bqDnGAkVQmdOsZrFwLuDtdy0NGtv8d1Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208660; c=relaxed/simple;
	bh=n5YkTPOD5OmYkVlzK4VTRr67MDaesHYT/ddBpcTR/dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S49GXTy571LTcjdpRiZX+Dd0a7eMUcCMk5bx5bBgO55i53+9REfs7OmYVRfSaiO5o9G7ATmv6ytEO6s9YE7v3JPawVmVK9pZ0HDzT655i1y0nAb3M/q1NTXiSDQgpKeZ8zYd8QXGm5QHRlyDBmk5TLw/e9SagXM9tABem0bz9YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BRgWIKnF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BRgWIKnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590F91F000FF;
	Sat, 12 Sep 2026 10:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208659;
	bh=/jHnwFCwR9UjoEK4vGzTsOKDoK4Ct+VrOwK6PzEeefo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BRgWIKnFacOZtbk/4g3Y+wpaDdMtTxTQcp2/PfSrvzUFy9iepf2XuCPVFYMR+0dFB
	 wbLjvOfzUCEkxvSjzEXSHYKOaJM/FBuFtNDAZt5O6Lrc158C4GSGyHBo9O4gnXaY5H
	 z5SkN4bZggUJIwfOZMGkLCNQJ1UWh0eE6l19D9fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0645/1518] platform/chrome: cros_ec_debugfs: Clean up console log on probe failure
Date: Sat, 12 Sep 2026 08:46:54 +0200
Message-ID: <20260912065638.021948401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index d10f9561990c8..01993ad696b04 100644
--- a/drivers/platform/chrome/cros_ec_debugfs.c
+++ b/drivers/platform/chrome/cros_ec_debugfs.c
@@ -513,7 +513,7 @@ static int cros_ec_debugfs_probe(struct platform_device *pd)
 	ret = blocking_notifier_chain_register(&ec->ec_dev->panic_notifier,
 					       &debug_info->notifier_panic);
 	if (ret)
-		goto remove_debugfs;
+		goto cleanup_console_log;
 
 	ec->debug_info = debug_info;
 
@@ -521,6 +521,8 @@ static int cros_ec_debugfs_probe(struct platform_device *pd)
 
 	return 0;
 
+cleanup_console_log:
+	cros_ec_cleanup_console_log(debug_info);
 remove_debugfs:
 	debugfs_remove_recursive(debug_info->dir);
 	return ret;
-- 
2.53.0



