Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE5B15A497;
	Mon, 29 Jan 2024 17:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548588; cv=none; b=QGdTX04QxUV+XkRKsmq4IQaUGsNhFQCBg1thRtU4w+jucIM/tD6v8N4VmKCxH8VXAWB9Hs7Bn+yWjwl1I3yks70HWsdq3b1d4dht73xyU/XuHJP3UMA/sNWx8LfNbLEx4xuYWw4UNMc2toOYl6PV/Ebrtp06b+f56aPWXlvPx88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548588; c=relaxed/simple;
	bh=61AHG5QX3M6m0gTkz8ObLF8U1VhmBHWZvvwh0DaurCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SeetlenH9nYwhxT6C0lW+GPZFydDvGHV9FEqbgWKunt06u8D97A657E1f6nzNzrQ9KOnIlVTKw0LkLACzX2KUX/TGCzvVOi71CQqzTryBOXj7+6CyL7e4ApGxil93VOlCwaEgcgq2e/J41qmAgnJNyrqjQwGAoYTZofiak7glWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpXz226J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpXz226J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B370FC433F1;
	Mon, 29 Jan 2024 17:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548587;
	bh=61AHG5QX3M6m0gTkz8ObLF8U1VhmBHWZvvwh0DaurCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpXz226JHV1zcsYX390kfQlsvy4yEl2lF+yHRU14d3qw9ff1BOmWNqZNs68IGxBGX
	 DMqx9UGOgxDEnYtt82RHFHpXCZVfPmAj/MO2KtbvzZFknOWoy+kXNlquGSFbEKdRzN
	 j15omKyc8DNxgV8uPptl4+sJSUzXmh/x8/FQr5NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Notselwyn <notselwyn@pwning.tech>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 244/331] netfilter: nf_tables: reject QUEUE/DROP verdict parameters
Date: Mon, 29 Jan 2024 09:05:08 -0800
Message-ID: <20240129170022.021468137@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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
@@ -10871,16 +10871,10 @@ static int nft_verdict_init(const struct
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
@@ -10915,6 +10909,8 @@ static int nft_verdict_init(const struct
 
 		data->verdict.chain = chain;
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	desc->len = sizeof(data->verdict);


