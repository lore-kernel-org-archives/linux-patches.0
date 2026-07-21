Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6300305E3B;
	Tue, 21 Jul 2026 22:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671585; cv=none; b=sGiTa7BEaIV4XWUGknejHhCduExLWfCjr+MwwBbp6dy1xXmFGHCZDPOYVYUCHCVUysp5Pic6maX/X7XoSWfYtCv/tUqEigDTJISIvjj3Z9IC9wF5Jml/+3U80jvXVBHgzxpx0fb8+MldigNkRrt7flGD402jAJvYxrltaPU1Mmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671585; c=relaxed/simple;
	bh=V8c/EW4fLnv0WdEBmwneyilezkN+NBbtOtpf/XW08+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2Marp8xppNKZQR/Sh/RWy1M1doXCGklk+PLCgwV2Jv4P+lQ1z5OrXS5VfYZrjDYOu4C7NDF7n/WRiQLahEpuTYDjsXGwEIvhCDPl6sI7pAwMeAR+IOCcMnOu+As6BsX+7wZYjUH3hyxhjuPf3OPKBIQ/fgnnFOKL7rRX5EZn7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PNmzW1Gp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PNmzW1Gp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405041F000E9;
	Tue, 21 Jul 2026 22:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671584;
	bh=qtdgPfme9PLNtiL2uOLnMtb4QRG4E1BBgP5ikO7HyWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PNmzW1GpOzXlVGc/mOca0vONFBznGS/mM41oOncnrJP1UJYsOoOBXLywydDIHvPvk
	 6qzJEaI3Nhnr1jkvZCtGj0eMRDH3ikVwyHDJ2XFgGMcImX4UNHdRdmXvFv/7EjIWcv
	 cgk2gpHuLpiTntubhksg9HMoGNV6LeljJlJzoc+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 301/843] netfilter: nfnetlink_osf: fix mss parsing on big-endian architectures
Date: Tue, 21 Jul 2026 17:18:56 +0200
Message-ID: <20260721152412.798682157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit a625c94144c9b66d32e1f374f909f38db46161c1 ]

The MSS calculation in nf_osf_match_one() manually shifts bytes to
construct a 16-bit value before passing it to ntohs().

This works on little-endian hosts but it does not work on big-endian as
the bytes are being always shifted and set in the same way for all
architectures.

Use get_unaligned_be16() to fix this on big-endian systems. It also
simplifies the code.

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_osf.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 6d3dfbeb398cb4..b61656cb0f3eb5 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -95,11 +95,7 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 
 			switch (*optp) {
 			case OSFOPT_MSS:
-				mss = optp[3];
-				mss <<= 8;
-				mss |= optp[2];
-
-				mss = ntohs((__force __be16)mss);
+				mss = get_unaligned_be16(&optp[2]);
 				break;
 			case OSFOPT_TS:
 				break;
-- 
2.53.0



