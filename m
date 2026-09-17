Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9844EDCCF;
	Thu, 17 Sep 2026 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664191; cv=none; b=bocNVqKN6J7QqMkdEE1biRm/WHw1qyV2w2HnZU7Aa80QVjdWhAOaFhUxjPWTvYFM11eEBMz4En9ibSklxAy3vqr7XNMxy7z0ZeJK4Y90t/hcXSsKwT+fN2SH9IomC2tpB1LwhwxAKJEssUOsBhoJyBG9BZd7b/M5PaMltw1L+nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664191; c=relaxed/simple;
	bh=vvk6AeFD6PhBav1J250qf5N2fFmFy+pbOt9OVzczRDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIZt5PGMZGn5VtI4JG9OrRe6Fx0K3bTQaCLTZBJQ4tnoTn/gvfmI4kPAt9Cr0ELs/RWBVqGtk8kAbqc/sk/A9mTBngrCUutdZ33N0bcU5ZtgyKAbqZdqBjXg/+xpEg5mgG/EweR6Zv1JkKFWOXuPAXqII6NsnmD9oFYiDojD0+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaQe6hwr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaQe6hwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0E61F000FF;
	Thu, 17 Sep 2026 16:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664190;
	bh=IWuy+n/Y/vkHIXHgMA7PpCIfrwwtS4hibdnDctCJ8BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HaQe6hwryGRcSuCKJ6fYnjIxFf/3zLZ8pjscXXykL2FqY93sP4+L+Bgi3mSNthm4A
	 PONYkqUEt8YG/QrAWOtpCTqRpmD7ul1934ymqECNBmwVsgqzFgjUyXJEFxUBzpuRQ2
	 Aq8VMjXhVtx7PT6Cwb6ZVhUbIJEkkR40aCdIY3GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0288/1250] net: txgbe: fix phylink leak on AML init failure
Date: Thu, 17 Sep 2026 16:01:23 +0100
Message-ID: <20260917151559.935284147@linuxfoundation.org>
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

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit 9c89f975e66922f346d92d60c9d51d07274a7f3b ]

Destroy the phylink instance when fixed-link setup fails.

Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20260528013258.129146-1-zhaochenguang@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
index 07ae491e3bc9b..a919962b71605 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
@@ -381,6 +381,7 @@ int txgbe_phylink_init_aml(struct txgbe *txgbe)
 	err = phylink_set_fixed_link(phylink, &state);
 	if (err) {
 		wx_err(wx, "Failed to set fixed link\n");
+		phylink_destroy(phylink);
 		return err;
 	}
 
-- 
2.53.0



