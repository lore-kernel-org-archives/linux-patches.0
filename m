Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A00E524BD;
	Tue, 23 Jan 2024 00:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970239; cv=none; b=n2ldtWUXVc3KJfjLNlZlISxFd5dhXMjvBAOcbgoVtOr5QlVCVBoOUehX4SEbCNMWnU1FLy0ols/evUHiC1nyp9upgpHSQNX5pOqo+Bd7sPpPWZ5JJaO1EX9mR37XPEiGCCG7xuB52oOiErVYLiDzgHJTetybOlwl/7a0QE/Ks8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970239; c=relaxed/simple;
	bh=qIDYOukiUFg/kBiuf0EJypfNWiLZRMkbKlObc4TPjWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYgjqSdnaSnt91SHlH+ywY506DmGdczyNu6Wzk119PRBywFMDkhEXmSGSo/JtSoXjVtW8ruFazu5bWN4ZXtoTYiGqMpJt6goefDo7XU2ANswUb9cXnenaPpA6YQpXzNGppqmcu6+xEoJqnaI4aRdSuRyoxQXDIPYIWkmDVc/hRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17Q04y4C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17Q04y4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BDDC433C7;
	Tue, 23 Jan 2024 00:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970239;
	bh=qIDYOukiUFg/kBiuf0EJypfNWiLZRMkbKlObc4TPjWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17Q04y4ChRXYBtf0Bit11aOVac+O9EWUsKQz4zubX0Yfbe1I1ugJK2uA59qzcfrb8
	 7BPzIKWVVWY+nMfSO4IE6ya2EXkLLT7zpiXd6Bw/qmpxvO8tFL4F5UeBcQvP9xrbQH
	 UlTieqWHdWRbIFIJPH7O0bp9XmBc702ikp3nc4eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 619/641] netfilter: nf_tables: reject invalid set policy
Date: Mon, 22 Jan 2024 15:58:43 -0800
Message-ID: <20240122235837.613723970@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 5e7994898c76..3912a133324c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5048,8 +5048,16 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
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



