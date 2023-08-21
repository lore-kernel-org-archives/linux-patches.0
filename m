Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6391171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAC8C433C9;
	Mon, 21 Aug 2023 20:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648318;
	bh=qV5jtqWSj+qs3dYA0eoDOjouxhKsJpZeXAvdeQbRk6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEAImDudhh4onbIvm/1WpiDke+vqwMtoHknAE7rqu8YisoWewRNgrQyVHW5qsZi/b
	 MpZXsikdd7gl4YrfhXHVx4fsZWcmMD39iazQdkhTi/Wbjmyvj8UwdFqv2awP6+TT5X
	 HUSwsPD162rJBAOsuqR7AgKOhS+tjRawyrGLOH2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 133/234] net: af_key: fix sadb_x_filter validation
Date: Mon, 21 Aug 2023 21:41:36 +0200
Message-ID: <20230821194134.713519286@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
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
index 31ab12fd720ae..203131ad0dfe1 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1848,9 +1848,9 @@ static int pfkey_dump(struct sock *sk, struct sk_buff *skb, const struct sadb_ms
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



