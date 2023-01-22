Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF6F7E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D29C433D2;
	Sun, 22 Jan 2023 15:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400123;
	bh=DuQiDl/YWt6EFpc1zdn23JcqY9QhDA8HNrfW3/dehoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQthzXuQHy0Ybbp0JgNvf4VwK+58KW2K5F6Z5OrRx1dkfOGh/lIRZFO0ExZBa93J8
	 6qo9ggZD1ynqPBS1aD+r8i98zOI6kZr8QC10sZSwoNeRdfnPwAUFtAQYhm80/d5Yit
	 sHEJVYlnGIPXR902futiNjvHlbJpBSACfXRdyvCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/55] net/ethtool/ioctl: return -EOPNOTSUPP if we have no phy stats
Date: Sun, 22 Jan 2023 16:03:50 +0100
Message-Id: <20230122150222.369810790@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
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
index cbd1885f2459..9ae38c3e2bf0 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1947,7 +1947,8 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
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



