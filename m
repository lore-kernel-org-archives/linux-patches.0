Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9329311C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE500C433CC;
	Mon, 28 Aug 2023 10:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218452;
	bh=Y+Q4FsFa2RT1Xvtm4u2l8abQo/43M8kMRtQaTvYGcJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fp61uAWfF0SgLfR7MLrEyV01K+tfPG4J44TnjaPx/VCynCrzoOeWC40WrdoNtVXny
	 QmjRYtLrJ5zC7J9sLLLJNEyEagytFHHWLqN89ja/qBmPHHtbschxtHr2nF/bPyPsih
	 WpU/IRXto062KTJAJskKvqnYPxX9TCUEXGAKlUaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/129] net: af_key: fix sadb_x_filter validation
Date: Mon, 28 Aug 2023 12:12:27 +0200
Message-ID: <20230828101155.226002545@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index b8456e2f11673..47ffa69ca6f67 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1858,9 +1858,9 @@ static int pfkey_dump(struct sock *sk, struct sk_buff *skb, const struct sadb_ms
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



