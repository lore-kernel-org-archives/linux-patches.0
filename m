Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15B53EA6C;
	Wed, 21 Feb 2024 14:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525816; cv=none; b=sZllS9O8eWIQNtyahkHX+nL9/BmDAvH43fJh0b5aXL7Usv6hGAc8sIWW9AVTC4MvYYJx4vQo0XYk3OeLJeNlLFrPJqH1Lup2wM9OeH0v8WziIsXA40s1nxL2zDi0QlfN59YLgZWDnWvR2rogcyHCVFud0X2nHJ/EZogFpy837A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525816; c=relaxed/simple;
	bh=Dmg/xjzBqC8PufZM/7B8WFmby7dG3PvggdXdMET0pdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CG3sl3eaLaTU/umgNkp/cedpGD8nosrxZ65Q06zxm6eflsSnv10bzeknOZdf0j9oBdSbHqZBLSgAWFAkXcX6DSV8Ya/xo8dmmynkWJQLG0y3jzS4B+DUKkugnKu4ajLr5h7UlxJ0kMlcG5eX24aen+kPxzY3sbFnc2WdUY3UWU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rv9ijGEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rv9ijGEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B92C433C7;
	Wed, 21 Feb 2024 14:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525816;
	bh=Dmg/xjzBqC8PufZM/7B8WFmby7dG3PvggdXdMET0pdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rv9ijGExrKk1kVB5RUl0of5DeIZuioKlMf9ABKQ1BnB6a4M4A/wuHFOyUTIEMRHWz
	 Y+wJOwXBgFfY+vTtsC3jWNu9MchcaVO1XR4LuUAO4hbzWhw+eV+xHKNuqQSOhX+/+p
	 ZOwLB+bJRNqnLk6QF8PXwov6Exm1HwMooVgaOh3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 5.4 263/267] netfilter: nf_tables: fix pointer math issue in nft_byteorder_eval()
Date: Wed, 21 Feb 2024 14:10:04 +0100
Message-ID: <20240221125948.498266442@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit c301f0981fdd3fd1ffac6836b423c4d7a8e0eb63 upstream.

The problem is in nft_byteorder_eval() where we are iterating through a
loop and writing to dst[0], dst[1], dst[2] and so on...  On each
iteration we are writing 8 bytes.  But dst[] is an array of u32 so each
element only has space for 4 bytes.  That means that every iteration
overwrites part of the previous element.

I spotted this bug while reviewing commit caf3ef7468f7 ("netfilter:
nf_tables: prevent OOB access in nft_byteorder_eval") which is a related
issue.  I think that the reason we have not detected this bug in testing
is that most of time we only write one element.

Fixes: ce1e7989d989 ("netfilter: nft_byteorder: provide 64bit le/be conversion")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[Ajay: Modified to apply on v5.4.y]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    4 ++--
 net/netfilter/nft_byteorder.c     |    5 +++--
 net/netfilter/nft_meta.c          |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -130,9 +130,9 @@ static inline u16 nft_reg_load16(u32 *sr
 	return *(u16 *)sreg;
 }
 
-static inline void nft_reg_store64(u32 *dreg, u64 val)
+static inline void nft_reg_store64(u64 *dreg, u64 val)
 {
-	put_unaligned(val, (u64 *)dreg);
+	put_unaligned(val, dreg);
 }
 
 static inline u64 nft_reg_load64(u32 *sreg)
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -38,20 +38,21 @@ void nft_byteorder_eval(const struct nft
 
 	switch (priv->size) {
 	case 8: {
+		u64 *dst64 = (void *)dst;
 		u64 src64;
 
 		switch (priv->op) {
 		case NFT_BYTEORDER_NTOH:
 			for (i = 0; i < priv->len / 8; i++) {
 				src64 = nft_reg_load64(&src[i]);
-				nft_reg_store64(&dst[i], be64_to_cpu(src64));
+				nft_reg_store64(&dst64[i], be64_to_cpu(src64));
 			}
 			break;
 		case NFT_BYTEORDER_HTON:
 			for (i = 0; i < priv->len / 8; i++) {
 				src64 = (__force __u64)
 					cpu_to_be64(nft_reg_load64(&src[i]));
-				nft_reg_store64(&dst[i], src64);
+				nft_reg_store64(&dst64[i], src64);
 			}
 			break;
 		}
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -247,7 +247,7 @@ void nft_meta_get_eval(const struct nft_
 		strncpy((char *)dest, out->rtnl_link_ops->kind, IFNAMSIZ);
 		break;
 	case NFT_META_TIME_NS:
-		nft_reg_store64(dest, ktime_get_real_ns());
+		nft_reg_store64((u64 *)dest, ktime_get_real_ns());
 		break;
 	case NFT_META_TIME_DAY:
 		nft_reg_store8(dest, nft_meta_weekday(ktime_get_real_seconds()));


