Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3613922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAFEC4339B;
	Wed,  7 Jun 2023 20:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171471;
	bh=tmlNpHpfwrYx017/9t1PLX6HNcke1rUBoT/Dxi6psME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BX6ljJTH64ekXFYeWw+ASJph7SW41I7w0+pRI9ghMNtFK6wENBJWI/8/L69RlFu/0
	 4vU/eXtuDeBsItzmX00UvmMoxM0Obpryes8gRrhd4MHBaywgewfjX6GybtCu6bg3kr
	 W5CbHcAMfX7BybPZhx1GbtQzDxGSGZ/EodYCZ03s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/159] net/netlink: fix NETLINK_LIST_MEMBERSHIPS length report
Date: Wed,  7 Jun 2023 22:15:34 +0200
Message-ID: <20230607200904.688201291@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
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
index 998c736d3ae8b..46c4306ddee7e 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1789,7 +1789,7 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
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



