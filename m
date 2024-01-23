Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419BA110A;
	Tue, 23 Jan 2024 02:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975777; cv=none; b=l19QQc/3Lq2G+GmzDsB4dFmse3F7obEaj/1yNmBKYLLbAdM9NjqSDe868znr52b4P8gCYhbdSr4I3nPEFJE8SgJJPaoGhBbW2mhO2s0Q0YJzO6x4ePlICsrJ3o1MKq5q8IqqUzhl/8s7/aLtsFP3mHFPm2cpjjB/k1oUH9yaP8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975777; c=relaxed/simple;
	bh=m1zh44KmNhmMoyeyGv1wycxqnwTLtlwvcjEr8aTV6g0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/AXwXGAeubga8+A0npvxu7Q4OcrOYMNylog9rBWraTt/z6obD8gPh/v+io4WQuZEJfI3XfB/Smmqa5I8/yEBFkMzSo30Sgz6xTKp+7maTailDlmzevYEZ+ywEqTSFawp/LDoOgdKFspdgXOFota4oxM6vjijgQ0Qhfk4SThF90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=So7/bqDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="So7/bqDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A5CC43330;
	Tue, 23 Jan 2024 02:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975777;
	bh=m1zh44KmNhmMoyeyGv1wycxqnwTLtlwvcjEr8aTV6g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=So7/bqDhIfVrEgonSE22GVv3R3X9kAhUVDhTnv4Hr7G0VD0NRTTglI6joKYk6lMTZ
	 w0VXs86CP/1uEbSUSt1d9OP5AQeXt3E1cImarhK7NQraOmrtI7DJZfiLZiJaG+rExk
	 MNVuTmHNx/mTrYJdS036JKqCpb5LddVZlTPBwFK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 560/583] netfilter: nf_tables: reject invalid set policy
Date: Mon, 22 Jan 2024 16:00:11 -0800
Message-ID: <20240122235829.302460544@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5200bd804954..55cd82190888 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4990,8 +4990,16 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
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



