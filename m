Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB1815705E;
	Mon, 29 Jan 2024 17:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548194; cv=none; b=PcIyTzFfkdWZ5mlHiO1yH9wFeEKWr9nYhNjFbPiU/XpAyGqX1OmUAYfF3mBn6uhKd7IrLG10Xwygtvvf39yNNm3gWR3pz2gDwVNDW2/Fnk9QJTQvMed7mzwe6+I/rjz8hPBlKZuf7IHKxR7eoSd0drwN7GXPkW7wn4LQsxOEeh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548194; c=relaxed/simple;
	bh=EYWiqkxiGznfeNFW1YA2LFYoeS9bcjpLIo5upidrAJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfhar3X12ydEnisPyNFKl40kZ0awqfqrygkeF/A9Kt7MWTU2zmFFMH29Ao163lIMf50GB78oyOdJ7MtgSXwBv5PMxNFNp9fdlQvFcT+rOW3T9HB1SdcuVa+SqzDVC+j9ln06M7etPI1YD1T6SVRSu3ZqHWYcYpI76wRGznoHJZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qy0mULTz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qy0mULTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29001C433F1;
	Mon, 29 Jan 2024 17:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548194;
	bh=EYWiqkxiGznfeNFW1YA2LFYoeS9bcjpLIo5upidrAJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qy0mULTznsaM6CBP1n0Wp+SqyHGyJ2WVwFbKeYhIe4kBxs1SRfLKHPgPzkAQ/fP4R
	 DCKu8nR4ITSpsSdABcgSMEBS6+CcfzULUNVd1kjAmT3f6f9zS5zzjHl36ZU5WTIDFa
	 id+rRCm3luSC/+Pa8ZXTd94+XdIhXNqY/bbr3zqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Notselwyn <notselwyn@pwning.tech>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.7 236/346] netfilter: nf_tables: reject QUEUE/DROP verdict parameters
Date: Mon, 29 Jan 2024 09:04:27 -0800
Message-ID: <20240129170023.342488576@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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
@@ -10909,16 +10909,10 @@ static int nft_verdict_init(const struct
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
@@ -10953,6 +10947,8 @@ static int nft_verdict_init(const struct
 
 		data->verdict.chain = chain;
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	desc->len = sizeof(data->verdict);


