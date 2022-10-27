Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806648486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 16:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F64C433D6;
	Thu, 27 Oct 2022 16:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666889883;
	bh=aQEOGOeSG9pDrO/z98RtjS8y+rmEz2ejtkDJMRZlChY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mduaHNpEG+42FtmVhkkUEJKWR9RQBuwV8u0epij7G/LgkgrilFgAC/mFQh9A3+FFw
	 5iP1V02JX/W7ckJqfg6Ik4tdFQw8dFq/qSQUojFshLgd03gO9OxXK1z7VLtD2Fm2VF
	 FstS2QV1YPvyWZIfeM4cGEXSeQTNkKa/vduTG2FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 35/94] tipc: Fix recognition of trial period
Date: Thu, 27 Oct 2022 18:54:37 +0200
Message-Id: <20221027165058.517908257@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

[ Upstream commit 28be7ca4fcfd69a2d52aaa331adbf9dbe91f9e6e ]

The trial period exists until jiffies is after addr_trial_end. But as
jiffies will eventually overflow, just using time_after will eventually
give incorrect results. As the node address is set once the trial period
ends, this can be used to know that we are not in the trial period.

Fixes: e415577f57f4 ("tipc: correct discovery message handling during address trial period")
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/discover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index da69e1abf68f..e8630707901e 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -148,8 +148,8 @@ static bool tipc_disc_addr_trial_msg(struct tipc_discoverer *d,
 {
 	struct net *net = d->net;
 	struct tipc_net *tn = tipc_net(net);
-	bool trial = time_before(jiffies, tn->addr_trial_end);
 	u32 self = tipc_own_addr(net);
+	bool trial = time_before(jiffies, tn->addr_trial_end) && !self;
 
 	if (mtyp == DSC_TRIAL_FAIL_MSG) {
 		if (!trial)
-- 
2.35.1



