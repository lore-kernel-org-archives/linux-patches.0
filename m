Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C750A8634A;
	Mon,  6 Jan 2025 15:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178123; cv=none; b=GBSu6hgtgSOgS+PQlKb0QRvAExmogtGrD8rzZyY/AAcaTDny8xZXQ7CeGAgNgDpJ8RsGxgrUlvgxn86rSIU961UbZzp3ylO7JUaX10umX+4XO8uk1AoDPqrHFM66OcJlDB6cM41RhtjKstyerdOO6ijcokNIJlW2dg6KTLc+wUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178123; c=relaxed/simple;
	bh=XZBoBPFN4B8HBtZmAISGQ6FPUdE62NcO2vF8822rEX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2ruwqw6bmAmeQGVSLdzeOzYKxketz+2AFJIVRBbl+9eNcalQ6V2a+g/EZK0FjZs+8tqb3hGa/ZAYzCYGSskExcAIRLk/MFW19aVHlvdPLMPqds6I04AuAsm78cChOs4ogd2eluzROcdkOY3R36hCUchvHKOEIGCt8fTsqzo0eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fnRgnVZv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fnRgnVZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C973C4CED6;
	Mon,  6 Jan 2025 15:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178123;
	bh=XZBoBPFN4B8HBtZmAISGQ6FPUdE62NcO2vF8822rEX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fnRgnVZvLQLIzPs51Lo+5PSbsndJ6JgU+Q9Ausq813MpAUpYPBFWFvxNQV+js7Ygy
	 7NhrI44B7Mi5zNQMfjDT1jgmOdFPMriBvW1l4mZZDBNQ16PXEXqlUt1VZJ7LMcQvk6
	 SbfkUDzsyxFwXW+iaDzK1qtfRKHV5NCF7sAQ+6Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/138] net/smc: check iparea_offset and ipv6_prefixes_cnt when receiving proposal msg
Date: Mon,  6 Jan 2025 16:15:37 +0100
Message-ID: <20250106151133.720655575@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

[ Upstream commit a29e220d3c8edbf0e1beb0f028878a4a85966556 ]

When receiving proposal msg in server, the field iparea_offset
and the field ipv6_prefixes_cnt in proposal msg are from the
remote client and can not be fully trusted. Especially the
field iparea_offset, once exceed the max value, there has the
chance to access wrong address, and crash may happen.

This patch checks iparea_offset and ipv6_prefixes_cnt before using them.

Fixes: e7b7a64a8493 ("smc: support variable CLC proposal messages")
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c  | 6 +++++-
 net/smc/smc_clc.c | 4 ++++
 net/smc/smc_clc.h | 6 +++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 3a4ae589671a..0e0a12f4bb61 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1422,6 +1422,8 @@ static int smc_listen_prfx_check(struct smc_sock *new_smc,
 	if (pclc->hdr.typev1 == SMC_TYPE_N)
 		return 0;
 	pclc_prfx = smc_clc_proposal_get_prefix(pclc);
+	if (!pclc_prfx)
+		return -EPROTO;
 	if (smc_clc_prfx_match(newclcsock, pclc_prfx))
 		return SMC_CLC_DECL_DIFFPREFIX;
 
@@ -1578,7 +1580,9 @@ static void smc_find_ism_v1_device_serv(struct smc_sock *new_smc,
 	struct smc_clc_msg_smcd *pclc_smcd = smc_get_clc_msg_smcd(pclc);
 
 	/* check if ISM V1 is available */
-	if (!(ini->smcd_version & SMC_V1) || !smcd_indicated(ini->smc_type_v1))
+	if (!(ini->smcd_version & SMC_V1) ||
+	    !smcd_indicated(ini->smc_type_v1) ||
+	    !pclc_smcd)
 		goto not_found;
 	ini->is_smcd = true; /* prepare ISM check */
 	ini->ism_peer_gid[0] = ntohll(pclc_smcd->ism.gid);
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 5ee5b2ce29a6..32cbdc321aec 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -49,6 +49,10 @@ static bool smc_clc_msg_prop_valid(struct smc_clc_msg_proposal *pclc)
 
 	v2_ext = smc_get_clc_v2_ext(pclc);
 	pclc_prfx = smc_clc_proposal_get_prefix(pclc);
+	if (!pclc_prfx ||
+	    pclc_prfx->ipv6_prefixes_cnt > SMC_CLC_MAX_V6_PREFIX)
+		return false;
+
 	if (hdr->version == SMC_V1) {
 		if (hdr->typev1 == SMC_TYPE_N)
 			return false;
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index c579d1d5995a..a57a3489df4a 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -259,8 +259,12 @@ struct smc_clc_msg_decline {	/* clc decline message */
 static inline struct smc_clc_msg_proposal_prefix *
 smc_clc_proposal_get_prefix(struct smc_clc_msg_proposal *pclc)
 {
+	u16 offset = ntohs(pclc->iparea_offset);
+
+	if (offset > sizeof(struct smc_clc_msg_smcd))
+		return NULL;
 	return (struct smc_clc_msg_proposal_prefix *)
-	       ((u8 *)pclc + sizeof(*pclc) + ntohs(pclc->iparea_offset));
+	       ((u8 *)pclc + sizeof(*pclc) + offset);
 }
 
 static inline bool smcr_indicated(int smc_type)
-- 
2.39.5



