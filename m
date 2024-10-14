Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F1C1AC8A2;
	Mon, 14 Oct 2024 14:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917412; cv=none; b=kvsczR/slpPcIKHC51Zxv1ragGDGhAfpn4bQj0tpbQdbGxi0EuS6tPTczby/rm/wkPk+T1425Tx5Q/5vEBPoJeq20FytWJvFK+I739DZ6TARh1PNsu/cOkg6x7Kbaz8U3s2ldulKPs0+Pyky+iiDehmuCJx+ifubvhT1WLzBcNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917412; c=relaxed/simple;
	bh=H8tUOozogb3UbssZiJwGbCMqhNgT/THRJmIKSmVz9vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+7oclK2qlJEm6LKbnzU+oWU4sJD0XTj3vcD6a5BjOewh8nDsBOFgz0SpuVmtFE10XBTdSye8WVD2MDyjLuAJo1F3EI4fJNHm4y2ZmO4Ti8m4ACu64xUDejK6G34AITQZjWbNUzE/X9fxPIyBHNdsJODK+vozPajU156ncBJOC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ls18m3wW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ls18m3wW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B58EC4CEC3;
	Mon, 14 Oct 2024 14:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917412;
	bh=H8tUOozogb3UbssZiJwGbCMqhNgT/THRJmIKSmVz9vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ls18m3wWgQxa5aGHP63mUm+2bGT/1C6i9Li0dDQ8IUe2cl0SCNCyCEkLT8kzqPXLQ
	 7C51kf43yyIP9WQmfka+gIOa+yKYnmu7J8Ypf/Z/J+PGuam7uFR2Vc0Z0KaANyrigU
	 ERSyS0f95OqTks7azpJsW8ZLt+aZmSeSrgBDtFX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/798] netfilter: nf_tables: reject element expiration with no timeout
Date: Mon, 14 Oct 2024 16:09:42 +0200
Message-ID: <20241014141219.053445066@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d2dc429ecb4e79ad164028d965c00f689e6f6d06 ]

If element timeout is unset and set provides no default timeout, the
element expiration is silently ignored, reject this instead to let user
know this is unsupported.

Also prepare for supporting timeout that never expire, where zero
timeout and expiration must be also rejected.

Fixes: 8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23 days")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4ebd3382f15b0..77306f48b3994 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6411,6 +6411,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (nla[NFTA_SET_ELEM_EXPIRATION] != NULL) {
 		if (!(set->flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
+		if (timeout == 0)
+			return -EOPNOTSUPP;
+
 		err = nf_msecs_to_jiffies64(nla[NFTA_SET_ELEM_EXPIRATION],
 					    &expiration);
 		if (err)
-- 
2.43.0



