Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE83509EFA;
	Wed, 30 Sep 2026 16:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785652; cv=none; b=nwXm0QZ6NlVyXbuQN9R1S8c5x1QzulvYi1S91JK8xaZGbmC2jvzXxWoFheZ1v2BdXEJI92ocqia+N+ovnYepPu6vNjPeTjY6SmTbO+3yO2j3SWFAOIKj8mIa26n3/g27pBriaJgWOCjZZke/dl/AK85MkTI2vtcwPXDzdX3Cmzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785652; c=relaxed/simple;
	bh=elXzayB1x45KFqRyaMYEP+HX3EU7ICdp+8sfdTFhN4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCH9JWUyFvTk/pTSlOoDZCWfejqJ+WQR4oWWuNi5rwuDNEKkclNHBJf3DoIHeyvqpy+xckUAlamYn432I2vJPgCs0NZlmr6keMHG4SRs3wd21/aa853oKAcgbkGre93IA9/jhW5Jf2KH+kFxOT2h9jDJFTUPM9Cjn6dPGemJP30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwsBVJ2j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwsBVJ2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F701F000FF;
	Wed, 30 Sep 2026 16:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785648;
	bh=PkR2WqyxdtuKlltoncwxnqwdVpO0BV9YxGnnA3EgmUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwsBVJ2jz+WcmodD0FgoGvIh0sgw6HjXLPn/DFZ6RVDLUEPJuJx6Hq8ubzOSc5jxN
	 pdqrhI+NQEV16GjtsFpxxzpX15kclUBD1Os8IW2BfmB2ogYON91oRPqJeXRnpHPJhY
	 2+SI0ICrTvY7WmpBbjJnBv5ru5Bjzx2DQ/0bqWzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Junjie Cao <junjie.cao@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 581/982] net/smc: check v2_ext_offset/eid_cnt/ism_gid_cnt when receiving proposal msg
Date: Wed, 30 Sep 2026 17:21:57 +0200
Message-ID: <20260930152429.258240956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

commit 7863c9f3d24ba49dbead7e03dfbe40deb5888fdf upstream.

When receiving proposal msg in server, the fields v2_ext_offset/
eid_cnt/ism_gid_cnt in proposal msg are from the remote client
and can not be fully trusted. Especially the field v2_ext_offset,
once exceed the max value, there has the chance to access wrong
address, and crash may happen.

This patch checks the fields v2_ext_offset/eid_cnt/ism_gid_cnt
before using them.

Fixes: 8c3dca341aea ("net/smc: build and send V2 CLC proposal")
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ jcao: SMCD_CLC_MAX_V2_GID_ENTRIES does not exist in 6.1;
  SMC_MAX_ISM_DEVS is the same limit (8) under its pre-b40584d14570 name ]
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c  | 3 ++-
 net/smc/smc_clc.c | 8 +++++++-
 net/smc/smc_clc.h | 8 +++++++-
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 6713296fffd99..89fa7295275ca 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2225,7 +2225,8 @@ static void smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
 		goto not_found;
 
 	smc_v2_ext = smc_get_clc_v2_ext(pclc);
-	if (!smc_clc_match_eid(ini->negotiated_eid, smc_v2_ext, NULL, NULL))
+	if (!smc_v2_ext ||
+	    !smc_clc_match_eid(ini->negotiated_eid, smc_v2_ext, NULL, NULL))
 		goto not_found;
 
 	/* prepare RDMA check */
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index ad1120a43dbd9..762e50354e11f 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -352,7 +352,6 @@ static bool smc_clc_msg_prop_valid(struct smc_clc_msg_proposal *pclc)
 	struct smc_clc_msg_hdr *hdr = &pclc->hdr;
 	struct smc_clc_v2_extension *v2_ext;
 
-	v2_ext = smc_get_clc_v2_ext(pclc);
 	pclc_prfx = smc_clc_proposal_get_prefix(pclc);
 	if (!pclc_prfx ||
 	    pclc_prfx->ipv6_prefixes_cnt > SMC_CLC_MAX_V6_PREFIX)
@@ -369,6 +368,13 @@ static bool smc_clc_msg_prop_valid(struct smc_clc_msg_proposal *pclc)
 			sizeof(struct smc_clc_msg_trail))
 			return false;
 	} else {
+		v2_ext = smc_get_clc_v2_ext(pclc);
+		if ((hdr->typev2 != SMC_TYPE_N &&
+		     (!v2_ext || v2_ext->hdr.eid_cnt > SMC_CLC_MAX_UEID)) ||
+		    (smcd_indicated(hdr->typev2) &&
+		     v2_ext->hdr.ism_gid_cnt > SMC_MAX_ISM_DEVS))
+			return false;
+
 		if (ntohs(hdr->length) !=
 			sizeof(*pclc) +
 			sizeof(struct smc_clc_msg_smcd) +
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 0f6102cd5de17..cdba392b6ec9c 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -347,8 +347,14 @@ static inline struct smc_clc_v2_extension *
 smc_get_clc_v2_ext(struct smc_clc_msg_proposal *prop)
 {
 	struct smc_clc_msg_smcd *prop_smcd = smc_get_clc_msg_smcd(prop);
+	u16 max_offset;
 
-	if (!prop_smcd || !ntohs(prop_smcd->v2_ext_offset))
+	max_offset = offsetof(struct smc_clc_msg_proposal_area, pclc_v2_ext) -
+		     offsetof(struct smc_clc_msg_proposal_area, pclc_smcd) -
+		     offsetofend(struct smc_clc_msg_smcd, v2_ext_offset);
+
+	if (!prop_smcd || !ntohs(prop_smcd->v2_ext_offset) ||
+	    ntohs(prop_smcd->v2_ext_offset) > max_offset)
 		return NULL;
 
 	return (struct smc_clc_v2_extension *)
-- 
2.53.0



