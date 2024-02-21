Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194AF762C1;
	Wed, 21 Feb 2024 13:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523831; cv=none; b=XC9UkB5xGUr0XjRBXTa2L4lCd25AjQrMT4y/wOwxHyNHzZ+J2lnFVpxpljtCjbJtPZwLHxJQER/xbZSPFCVStDssfKCa90OZ/f4MZzMmqUDkTvX/33uTiYy9kDLNZPKuJcZIBDUmywVi1YOLIulqB8Xtq0od0OrOLCrcJfebsEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523831; c=relaxed/simple;
	bh=uov3ReQzE10/Z3Q++bTIericHx0Svi3UlF/I7zKff74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sedkGthe/4Lxb5W9nYTgkK9Qx3pq3E1neT1gWdoLFfsGpLIlxreF+j68MZMlOYdEL/Vlh2w5IcP2DZYY5cr2I8J0NH+Ubb1v7R9b4aDqfkDQnaz55eIWsqD1OioarXE9SzC9x2PIVuXDYnINGMghM/2GFBP23q0ZLbLW9Awuh30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5uYZwA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5uYZwA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D53C433F1;
	Wed, 21 Feb 2024 13:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523830;
	bh=uov3ReQzE10/Z3Q++bTIericHx0Svi3UlF/I7zKff74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5uYZwA5hnfg6umzGbEhrVOqof4FJQEpZQQ9IgorRjRiw2bqDYWbtDsY+Zcz1C+Tr
	 ZGAEvCSuZ4HjerSSWwk30sEjElV5Yt1FU3cFO5l30iUovG7QgEKPdXgYYiwyFuDR5x
	 jVV6CrMbk6clCYaby9D43W0wOFhb+7LN1aPLXxhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Notselwyn <notselwyn@pwning.tech>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 071/379] netfilter: nf_tables: reject QUEUE/DROP verdict parameters
Date: Wed, 21 Feb 2024 14:04:10 +0100
Message-ID: <20240221125957.015911032@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit f342de4e2f33e0e39165d8639387aa6c19dff660 upstream.

This reverts commit e0abdadcc6e1.

core.c:nf_hook_slow assumes that the upper 16 bits of NF_DROP
verdicts contain a valid errno, i.e. -EPERM, -EHOSTUNREACH or similar,
or 0.

Due to the reverted commit, its possible to provide a positive
value, e.g. NF_ACCEPT (1), which results in use-after-free.

Its not clear to me why this commit was made.

NF_QUEUE is not used by nftables; "queue" rules in nftables
will result in use of "nft_queue" expression.

If we later need to allow specifiying errno values from userspace
(do not know why), this has to call NF_DROP_GETERR and check that
"err <= 0" holds true.

Fixes: e0abdadcc6e1 ("netfilter: nf_tables: accept QUEUE/DROP verdict parameters")
Cc: stable@vger.kernel.org
Reported-by: Notselwyn <notselwyn@pwning.tech>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9340,16 +9340,10 @@ static int nft_verdict_init(const struct
 	data->verdict.code = ntohl(nla_get_be32(tb[NFTA_VERDICT_CODE]));
 
 	switch (data->verdict.code) {
-	default:
-		switch (data->verdict.code & NF_VERDICT_MASK) {
-		case NF_ACCEPT:
-		case NF_DROP:
-		case NF_QUEUE:
-			break;
-		default:
-			return -EINVAL;
-		}
-		fallthrough;
+	case NF_ACCEPT:
+	case NF_DROP:
+	case NF_QUEUE:
+		break;
 	case NFT_CONTINUE:
 	case NFT_BREAK:
 	case NFT_RETURN:
@@ -9384,6 +9378,8 @@ static int nft_verdict_init(const struct
 
 		data->verdict.chain = chain;
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	desc->len = sizeof(data->verdict);


