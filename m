Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC99472798;
	Tue, 16 Jun 2026 18:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636103; cv=none; b=E+y8G0+CRmkqkrZe/fw+j20DZ2QjUqGyhRHstz8+uYvldhBWBvv5ZRYVSNvTyTAC8l0u5S5sfBeGpG71uziIbRhXXXd5e1g7zczBBw80QjvStmseyEuhr1lY+75GWc4XXn1BQsH6cp7FDZ5xyIEAR/zyiqR2+i7uiD9wMTxL+QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636103; c=relaxed/simple;
	bh=CLypC7jYRZ+/hJodasP9gI5jtqngk2LfYd4CA0P+ORg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIBEiULPDf4U4MBV4OKvVsR+IYwK9Cn11Rn8KYaGEKmpvcfWq7clWv5pbHIqy8G30TINrrXOnfRoaRs64vUb6VhQTSS+1QfV+PI/i93mEeARbeTK4KvYvRT+cipxLvzIMH2tj6dKdpl/JWvzAvXTSdhgoQcJHZOHE1Y2U01afDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJtCJFHV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJtCJFHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593111F000E9;
	Tue, 16 Jun 2026 18:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636102;
	bh=6zyvnmZIPmAHpAUAx6LYU0/jhO8HkASXH+xbbJ7MNn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJtCJFHVrA6MwGGkLoxoawXV16kW9kNXjH+SdN9Kf7/yVi9IYEBXWxKmSldYKwWci
	 N48tpp+mJH8kOEYdsU8MvBtcK97ja8+rQ49deoD+/YGSE+LQNZYqqxwq7q7iq4JPig
	 8EjfMLUNOQz3hQLecyG+YhlKSJlGaJDessDiuLY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 176/342] netfilter: nft_exthdr: fix register tracking for F_PRESENT flag
Date: Tue, 16 Jun 2026 20:27:52 +0530
Message-ID: <20260616145056.402295531@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 772cecf198da732faebb5dcfc46d66a505be8495 ]

nft_exthdr_init() passes user-controlled priv->len to
nft_parse_register_store(), which marks that many bytes in the
register bitmap as initialized.  However, when NFT_EXTHDR_F_PRESENT
is set, the eval paths write only 1 byte (nft_reg_store8) or
4 bytes (*dest = 0 on TCP/DCCP error path).  When len > 4,
registers beyond the first are never written, retaining
uninitialized stack data from nft_regs.

Bail out if userspace requests too much data when F_PRESENT is set.

Reported-by: Ji'an Zhou <eilaimemedsnaimel@gmail.com>
Fixes: c078ca3b0c5b ("netfilter: nft_exthdr: Add support for existence check")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_exthdr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 5bde436b875485..be8ff8b5355721 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -454,6 +454,9 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 			return err;
 	}
 
+	if ((flags & NFT_EXTHDR_F_PRESENT) && len != 1)
+		return -EINVAL;
+
 	priv->type   = nla_get_u8(tb[NFTA_EXTHDR_TYPE]);
 	priv->offset = offset;
 	priv->len    = len;
-- 
2.53.0



