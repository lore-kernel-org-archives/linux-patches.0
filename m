Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610214E1D0;
	Tue, 23 Jan 2024 00:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970284; cv=none; b=QV+Uzk3OT5yNnHJSPRggZAoy+GnpHcbJCGO1/+K7Si0wQssA53f/7/nZJmsl1yqgtchIBQZGmM2j6CA1geerTS8PvwWakllC7faS7Kw/TmDLnyLAZ1Hsv4CRhqwmpCR8ldkiAmBMBl0QdEyVK1geXYknBlpmW6r10ZK6Ko5IkCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970284; c=relaxed/simple;
	bh=zm8SsCVnvVGFOIXSNCpP+L9KV3CMiJ/IOgNFYNihoU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRg34enxYtSv/e3ngPCuab25ENyOLSlf6mFHOCbDfMqv19raG6S7Eh//ovju/FsuRjmTVNx1d6NL4qVdtsh2BBp9faqqfkQ2Ts/XwUHjqGt8xqK5VGly6p7yb5z8QpSw7M0jTmMM1bIOTJMnksCPIKbx4gNBsbwJ6eIiPIpOZy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bD3hYjPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bD3hYjPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEE4C433C7;
	Tue, 23 Jan 2024 00:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970284;
	bh=zm8SsCVnvVGFOIXSNCpP+L9KV3CMiJ/IOgNFYNihoU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bD3hYjPJFSiXHErmxMR3+So1yWmOeLTkXD4Qu7pdKKIoVMIh+Tj5hZnnyTGPw2+gO
	 4hKbryojiH7DcNXOvRKEJ4/91D5vAnLvAOewPtlfM6OElTUrXnD0Ib3px75OgQmajl
	 M9qrhhDiHT0ZahBPn+ZzoSKPLMHIu5Sb/SP1V27k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 625/641] netfilter: nf_tables: do not allow mismatch field size and set key length
Date: Mon, 22 Jan 2024 15:58:49 -0800
Message-ID: <20240122235837.815517188@linuxfoundation.org>
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

[ Upstream commit 3ce67e3793f48c1b9635beb9bb71116ca1e51b58 ]

The set description provides the size of each field in the set whose sum
should not mismatch the set key length, bail out otherwise.

I did not manage to crash nft_set_pipapo with mismatch fields and set key
length so far, but this is UB which must be disallowed.

Fixes: f3a2181e16f1 ("netfilter: nf_tables: Support for sets with multiple ranged fields")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3912a133324c..7775bf5224ac 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4811,8 +4811,8 @@ static int nft_set_desc_concat_parse(const struct nlattr *attr,
 static int nft_set_desc_concat(struct nft_set_desc *desc,
 			       const struct nlattr *nla)
 {
+	u32 num_regs = 0, key_num_regs = 0;
 	struct nlattr *attr;
-	u32 num_regs = 0;
 	int rem, err, i;
 
 	nla_for_each_nested(attr, nla, rem) {
@@ -4827,6 +4827,10 @@ static int nft_set_desc_concat(struct nft_set_desc *desc,
 	for (i = 0; i < desc->field_count; i++)
 		num_regs += DIV_ROUND_UP(desc->field_len[i], sizeof(u32));
 
+	key_num_regs = DIV_ROUND_UP(desc->klen, sizeof(u32));
+	if (key_num_regs != num_regs)
+		return -EINVAL;
+
 	if (num_regs > NFT_REG32_COUNT)
 		return -E2BIG;
 
-- 
2.43.0



