Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ABA1D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:05:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC74C433C8;
	Tue, 25 Jul 2023 11:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283110;
	bh=XcfV5hcluOaBErMFdED7ecZTMlQxAOkfibQKksdVyMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pt8c6qYFPA/OVce6t0/h1fhmSjIWsOLnTIgYmIPQDzHxfrhwxq33ew8M0SN2WOrq1
	 /kgEDoRqn/Bh+ueTSd6s7TPNHYu43BE8xD/wLYeB78bZVl2wkDBZf174GSR1zVojDR
	 TiiB+gdC8me0r/wDu7yqGHsDZp8ejNgKwdbm/nD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/183] netfilter: nf_tables: fix spurious set element insertion failure
Date: Tue, 25 Jul 2023 12:46:11 +0200
Message-ID: <20230725104513.051189377@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit ddbd8be68941985f166f5107109a90ce13147c44 ]

On some platforms there is a padding hole in the nft_verdict
structure, between the verdict code and the chain pointer.

On element insertion, if the new element clashes with an existing one and
NLM_F_EXCL flag isn't set, we want to ignore the -EEXIST error as long as
the data associated with duplicated element is the same as the existing
one.  The data equality check uses memcmp.

For normal data (NFT_DATA_VALUE) this works fine, but for NFT_DATA_VERDICT
padding area leads to spurious failure even if the verdict data is the
same.

This then makes the insertion fail with 'already exists' error, even
though the new "key : data" matches an existing entry and userspace
told the kernel that it doesn't want to receive an error indication.

Fixes: c016c7e45ddf ("netfilter: nf_tables: honor NLM_F_EXCL flag in set element insertion")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 938cfa9a3adb6..58f14e4ef63d4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10114,6 +10114,9 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 
 	if (!tb[NFTA_VERDICT_CODE])
 		return -EINVAL;
+
+	/* zero padding hole for memcmp */
+	memset(data, 0, sizeof(*data));
 	data->verdict.code = ntohl(nla_get_be32(tb[NFTA_VERDICT_CODE]));
 
 	switch (data->verdict.code) {
-- 
2.39.2



