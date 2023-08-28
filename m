Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7CF11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2ECC43395;
	Mon, 28 Aug 2023 10:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219711;
	bh=3ZBwEX1Nh8rDajtzKMWQF2o5spWVPV81YsNZYjDAy0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFKuXk3U5k7VHlkvTW4hlhkd/nS5ufMXF4k01/15V/C6ZlYE5rGhpMesWJ1ZWueBo
	 iCLCTdX1+DlXhGwkD9t3m8tO4QC3Wzi/LT5T7vjZfgP/ZM7KrmPPrUYycEaWo+QGjB
	 XMurCbu779ZhnPciEJ+pyI6K3UmpPB78brnSiQw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/84] netfilter: nf_tables: fix out of memory error handling
Date: Mon, 28 Aug 2023 12:13:54 +0200
Message-ID: <20230828101150.525221574@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
References: <20230828101149.146126827@linuxfoundation.org>
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

[ Upstream commit 5e1be4cdc98c989d5387ce94ff15b5ad06a5b681 ]

Several instances of pipapo_resize() don't propagate allocation failures,
this causes a crash when fault injection is enabled for gfp_kernel slabs.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 3be93175b3ffd..50f840e312b03 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -901,12 +901,14 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
 static int pipapo_insert(struct nft_pipapo_field *f, const uint8_t *k,
 			 int mask_bits)
 {
-	int rule = f->rules++, group, ret, bit_offset = 0;
+	int rule = f->rules, group, ret, bit_offset = 0;
 
-	ret = pipapo_resize(f, f->rules - 1, f->rules);
+	ret = pipapo_resize(f, f->rules, f->rules + 1);
 	if (ret)
 		return ret;
 
+	f->rules++;
+
 	for (group = 0; group < f->groups; group++) {
 		int i, v;
 		u8 mask;
@@ -1051,7 +1053,9 @@ static int pipapo_expand(struct nft_pipapo_field *f,
 			step++;
 			if (step >= len) {
 				if (!masks) {
-					pipapo_insert(f, base, 0);
+					err = pipapo_insert(f, base, 0);
+					if (err < 0)
+						return err;
 					masks = 1;
 				}
 				goto out;
@@ -1234,6 +1238,9 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 		else
 			ret = pipapo_expand(f, start, end, f->groups * f->bb);
 
+		if (ret < 0)
+			return ret;
+
 		if (f->bsize > bsize_max)
 			bsize_max = f->bsize;
 
-- 
2.40.1



