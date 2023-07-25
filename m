Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315DC1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B27C433C9;
	Tue, 25 Jul 2023 11:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284808;
	bh=a5f0Vi97/jJDkYzHRFqUqJYXqQi2mLiNM+ab67O5H+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dntcK6jveLu46nGBjLwgVUIJOv/Ah7lj3Id2SFX+Lw0vzNcnWW8m4kQDEoXtp6R8y
	 VXz+43sRw0AvUTOKIdli9yS3tK7zkgsmyHNLqSm5sPaT8NxavWrVzvDdwP3QYbyiNe
	 4V1mWf7ZXlYYk5TlLCZQN9iUbgHfcrQEsHNV3iF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 488/509] netfilter: nf_tables: fix spurious set element insertion failure
Date: Tue, 25 Jul 2023 12:47:07 +0200
Message-ID: <20230725104616.080641491@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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
index d56f5d7fa5455..9c3a9e3f1ede9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8914,6 +8914,9 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 
 	if (!tb[NFTA_VERDICT_CODE])
 		return -EINVAL;
+
+	/* zero padding hole for memcmp */
+	memset(data, 0, sizeof(*data));
 	data->verdict.code = ntohl(nla_get_be32(tb[NFTA_VERDICT_CODE]));
 
 	switch (data->verdict.code) {
-- 
2.39.2



