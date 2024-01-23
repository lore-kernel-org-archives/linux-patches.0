Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156621FBF;
	Tue, 23 Jan 2024 02:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975784; cv=none; b=lf0bRcbAOrEX9qgKhvOA+X1wbNpuvwqBQShmxf35dt3t3oOrp8uLNafNT7PbLGCqi3iV4MW4t8x42bdLg09xIqQfjZoGBinXjH/u3Eq6/CLVeS7Va56hkL3vgGoz4NhV1EY36pzgDr/oB97GYe0QNiAF3aJrTyoO1vTX6uM0n0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975784; c=relaxed/simple;
	bh=+Cn9/wlLg5ZMgdMy48+IvjnKns317xfezGWEAidXsGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uS1263M3hHPtgDgmEUOgj4tu5ocpPuJcD3SN3T1tUtH7eYcVzAgXaAYG0BAQdM5ahQxZTAPAvRiXBZ8OsbIO4bBq4+uSvo2XVnaNSSn264A+q00Ad5osQd7/KH0HjcrKbnuG+Hj55Rp8sUwPauB3Jn754sY6iF+k08P6imbUcVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHEWBm+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHEWBm+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACB1C433F1;
	Tue, 23 Jan 2024 02:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975783;
	bh=+Cn9/wlLg5ZMgdMy48+IvjnKns317xfezGWEAidXsGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yHEWBm+tU/7opqlZRjyXSG/25nSwOuU/hvoP1u1qRnn/4oLzuKnVN3zZq1j0NwErt
	 F6Cl2HCShhKsyIs7KnU7tLiAFaRXW/PkIpsx0j2MUMcXM9ZAjnH1KEldoSX9jNPQnt
	 SFV7AJcXgTpJoX6ISyfmu7oZIbNygnOF4EGxnfGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 566/583] netfilter: nf_tables: do not allow mismatch field size and set key length
Date: Mon, 22 Jan 2024 16:00:17 -0800
Message-ID: <20240122235829.484941821@linuxfoundation.org>
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
index 55cd82190888..5730f9a1f47d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4753,8 +4753,8 @@ static int nft_set_desc_concat_parse(const struct nlattr *attr,
 static int nft_set_desc_concat(struct nft_set_desc *desc,
 			       const struct nlattr *nla)
 {
+	u32 num_regs = 0, key_num_regs = 0;
 	struct nlattr *attr;
-	u32 num_regs = 0;
 	int rem, err, i;
 
 	nla_for_each_nested(attr, nla, rem) {
@@ -4769,6 +4769,10 @@ static int nft_set_desc_concat(struct nft_set_desc *desc,
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



