Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A666D11C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF71C433C8;
	Thu, 24 Aug 2023 15:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889275;
	bh=77KpwRPjGxEKOXktWylHOtu0Dh/cvfigpx3S3CFMvkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pfs6X7cIlZ5Cci85FvQz14igJ1mDS81Mwl2ZAvMptCgjreyou2MWSSS/I5cCsW3SN
	 NpoTAbX0CY6F0fApBc9gpBe1WFy16d3iVn5SjHe2z19OZYzj4n0fG568fPNUjXZck9
	 vIhwV0LgsYRL8qXDX0RoCLfuok5KEh0eey3Crbb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/135] net: af_key: fix sadb_x_filter validation
Date: Thu, 24 Aug 2023 16:50:20 +0200
Message-ID: <20230824145030.190019253@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
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

[ Upstream commit 75065a8929069bc93181848818e23f147a73f83a ]

When running xfrm_state_walk_init(), the xfrm_address_filter being used
is okay to have a splen/dplen that equals to sizeof(xfrm_address_t)<<3.
This commit replaces >= to > to make sure the boundary checking is
correct.

Fixes: 37bd22420f85 ("af_key: pfkey_dump needs parameter validation")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/key/af_key.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index fff2bd5f03e37..f42854973ba8d 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1852,9 +1852,9 @@ static int pfkey_dump(struct sock *sk, struct sk_buff *skb, const struct sadb_ms
 	if (ext_hdrs[SADB_X_EXT_FILTER - 1]) {
 		struct sadb_x_filter *xfilter = ext_hdrs[SADB_X_EXT_FILTER - 1];
 
-		if ((xfilter->sadb_x_filter_splen >=
+		if ((xfilter->sadb_x_filter_splen >
 			(sizeof(xfrm_address_t) << 3)) ||
-		    (xfilter->sadb_x_filter_dplen >=
+		    (xfilter->sadb_x_filter_dplen >
 			(sizeof(xfrm_address_t) << 3))) {
 			mutex_unlock(&pfk->dump_lock);
 			return -EINVAL;
-- 
2.40.1



