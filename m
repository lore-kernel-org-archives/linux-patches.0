Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CD11FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586E1C433C7;
	Tue,  1 Aug 2023 09:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883021;
	bh=nqXUpcsp+/BUIRwwPKLlWWYzLBlqVzpOUkNRtjvXT6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PblTfjfHlQpVTBr1962c4UoC6cMPBw+EGudr+oAo7dtN+/FwLMq/e0ms6VtXER1Jo
	 WC/t3K0PXTxAovIVajypUZRRWr+EuZa2Quw6vdAJeNFYtwoxGgCGrSaEOhgPF5nlj5
	 sLjk6N/2hE3FmcWrD49Fu0jKiDt9VG0TibhbW/G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 086/239] macvlan: add forgotten nla_policy for IFLA_MACVLAN_BC_CUTOFF
Date: Tue,  1 Aug 2023 11:19:10 +0200
Message-ID: <20230801091928.844736046@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 55cef78c244d0d076f5a75a35530ca63c92f4426 ]

The previous commit 954d1fa1ac93 ("macvlan: Add netlink attribute for
broadcast cutoff") added one additional attribute named
IFLA_MACVLAN_BC_CUTOFF to allow broadcast cutfoff.

However, it forgot to describe the nla_policy at macvlan_policy
(drivers/net/macvlan.c). Hence, this suppose NLA_S32 (4 bytes) integer
can be faked as empty (0 bytes) by a malicious user, which could leads
to OOB in heap just like CVE-2023-3773.

To fix it, this commit just completes the nla_policy description for
IFLA_MACVLAN_BC_CUTOFF. This enforces the length check and avoids the
potential OOB read.

Fixes: 954d1fa1ac93 ("macvlan: Add netlink attribute for broadcast cutoff")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230723080205.3715164-1-linma@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 4a53debf9d7c4..ed908165a8b4e 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1746,6 +1746,7 @@ static const struct nla_policy macvlan_policy[IFLA_MACVLAN_MAX + 1] = {
 	[IFLA_MACVLAN_MACADDR_COUNT] = { .type = NLA_U32 },
 	[IFLA_MACVLAN_BC_QUEUE_LEN] = { .type = NLA_U32 },
 	[IFLA_MACVLAN_BC_QUEUE_LEN_USED] = { .type = NLA_REJECT },
+	[IFLA_MACVLAN_BC_CUTOFF] = { .type = NLA_S32 },
 };
 
 int macvlan_link_register(struct rtnl_link_ops *ops)
-- 
2.39.2



