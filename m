Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294187E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D63C433EF;
	Sun, 22 Jan 2023 15:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400022;
	bh=YVwAPhdrlGEOU9135pTa9OH5Prks9ZnxA+drB9c9JKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4W1y0XhvwZ7l79G2I2dxSds+ub2/fXui7xtspvQ5WBymvUbaL85AwXe7HHHw7DRM
	 oahLDFdsEELO0NipTbfUSexMYTBAnUs7h7R0bYtm4sS9YwNI53iP7puyr59NOwFVVv
	 2NYZIET9W9+AyuErn7ZdQsYN+H/5ghCoNx2teWew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/37] net/ethtool/ioctl: return -EOPNOTSUPP if we have no phy stats
Date: Sun, 22 Jan 2023 16:03:59 +0100
Message-Id: <20230122150219.668239364@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>
References: <20230122150219.557984692@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit 9deb1e9fb88b1120a908676fa33bdf9e2eeaefce ]

It's not very useful to copy back an empty ethtool_stats struct and
return 0 if we didn't actually have any stats. This also allows for
further simplification of this function in the future commits.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/ethtool.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 4db9512feba8..d007f1cca64c 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -2023,7 +2023,8 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 		return n_stats;
 	if (n_stats > S32_MAX / sizeof(u64))
 		return -ENOMEM;
-	WARN_ON_ONCE(!n_stats);
+	if (WARN_ON_ONCE(!n_stats))
+		return -EOPNOTSUPP;
 
 	if (copy_from_user(&stats, useraddr, sizeof(stats)))
 		return -EFAULT;
-- 
2.35.1



