Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D6034D8D
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B74C433EF;
	Wed,  7 Jun 2023 20:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169376;
	bh=ElF/sF9SWQbw58MmChNAfbK6iPYTNBXbaBCeogY13Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8Stb5y3lYgN/WV9D1R+bjD7cpv6ZvJ4IN5cWgpbQ8jtqOs5mv9ACZFnXxgMKniz0
	 TahbojdOQ9k/GVu734YCIstrwR5XhLLSOxZB808q5rNpiBOZdbId7R0F+7sRyGaJCU
	 CL5dO58Uvji/yoqlQOJ2Lg3GhYOwzqhpQUmcknSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 057/286] net/netlink: fix NETLINK_LIST_MEMBERSHIPS length report
Date: Wed,  7 Jun 2023 22:12:36 +0200
Message-ID: <20230607200924.935851871@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit f4e4534850a9d18c250a93f8d7fbb51310828110 ]

The current code for the length calculation wrongly truncates the reported
length of the groups array, causing an under report of the subscribed
groups. To fix this, use 'BITS_TO_BYTES()' which rounds up the
division by 8.

Fixes: b42be38b2778 ("netlink: add API to retrieve all group memberships")
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230529153335.389815-1-pctammela@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 45d47b39de225..717e27a4b66a0 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1779,7 +1779,7 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
 				break;
 			}
 		}
-		if (put_user(ALIGN(nlk->ngroups / 8, sizeof(u32)), optlen))
+		if (put_user(ALIGN(BITS_TO_BYTES(nlk->ngroups), sizeof(u32)), optlen))
 			err = -EFAULT;
 		netlink_unlock_table();
 		return err;
-- 
2.39.2



