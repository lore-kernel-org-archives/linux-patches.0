Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F4A1419AD;
	Tue, 23 Jan 2024 01:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972057; cv=none; b=EDcuR5BzXRxZTax9hzO5RmZXPZJwPJ/6SsOzgWQot1gghfJswWkB5nmt7Fjit2iWLdrI+NbSzuDBKOJxWBoZmiOlVXPUiR00Kxy1HPJ8HQHOfkt8RRe64JKSPowIPhb6uHyfbMbRgfdEA4CI01VCJ5UoONnv2R4MeTIyC45xuVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972057; c=relaxed/simple;
	bh=291ABtcp4pUbcUIhZvNt374dO9JUr1bjCdoPDoUGsoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYy5HkwSjOneSv3NGqNam7KRJ7+Dw/Vft+lXOdZmJNmDOolPRJbp+CizkbShfxqqf+ShzRYQtFh4GCL4LnoMgHsnh7pBJVw5b5ZlaIOcdhkVbHTXEE3XZRMN8/ynuVbwyQsPuip3WQRpxiTQLZmtbhbOMv++Ttkt3iJfypxLhXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRktA0Nm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRktA0Nm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9FDC433F1;
	Tue, 23 Jan 2024 01:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972056;
	bh=291ABtcp4pUbcUIhZvNt374dO9JUr1bjCdoPDoUGsoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRktA0NmpuLVXC9TuOQIlv7E45iBH5o1E/DyVmOMh7lScpo3d0QeVYyPxcoW84BRX
	 GYxc9ZNlFGG8/eeWLuvEgc0BsERink/a8kQu2QY1jZpN4GhJCt8Nn6n+wuOt7LZ6Am
	 Bn/Zudi9hiXKw8BBWb9E06MeerHziPYE5uCmGQu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 398/417] netfilter: nf_tables: reject invalid set policy
Date: Mon, 22 Jan 2024 15:59:26 -0800
Message-ID: <20240122235805.524084436@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

[ Upstream commit 0617c3de9b4026b87be12b0cb5c35f42c7c66fcb ]

Report -EINVAL in case userspace provides a unsupported set backend
policy.

Fixes: c50b960ccc59 ("netfilter: nf_tables: implement proper set selection")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9526d00d75d6..98f1d42dd436 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4753,8 +4753,16 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	desc.policy = NFT_SET_POL_PERFORMANCE;
-	if (nla[NFTA_SET_POLICY] != NULL)
+	if (nla[NFTA_SET_POLICY] != NULL) {
 		desc.policy = ntohl(nla_get_be32(nla[NFTA_SET_POLICY]));
+		switch (desc.policy) {
+		case NFT_SET_POL_PERFORMANCE:
+		case NFT_SET_POL_MEMORY:
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+	}
 
 	if (nla[NFTA_SET_DESC] != NULL) {
 		err = nf_tables_set_desc_parse(&desc, nla[NFTA_SET_DESC]);
-- 
2.43.0



