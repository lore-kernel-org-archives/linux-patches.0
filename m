Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9928827;
	Mon, 23 Dec 2024 16:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970628; cv=none; b=RwAo2NRxeUHXB8zyCy4kJYWk4Xm7JuCGGQ13gRyMuzOJ3/x0+Y20sm86twtv6QAN21fAgXFng35De/rcLv2QptDYz0RRjL1L/gL32Vzg36wqMRfKoOr0RSNSbbWOcHx2+/N+Dl5DMmdgDmHUZc3vUjWE5d6hV9Mk+3umNwfv+Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970628; c=relaxed/simple;
	bh=wrCqJCrDNR7us6BAOEX61IibJMSNWuLa+pyLyWwXtYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DypxqnDr1+dlX4Z2p/zSvXfW/dfSriWevCgMAnZPQWxgypWQDxmbFvVjwenL+gWUHcViSryNzWEAmISCy3tWVdLjjQNR5HyNDjj7ES3w3C40iDgBE0o/E74rT5Xs3mU/WEdkbFu0hDOI5/3kZokddQwmAIjQC8yhxTFWaJCrlao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGG9/JYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGG9/JYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A66C4CED4;
	Mon, 23 Dec 2024 16:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970627;
	bh=wrCqJCrDNR7us6BAOEX61IibJMSNWuLa+pyLyWwXtYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGG9/JYntugl8DKtN4t3FuY4WdD+rbZAJcxuvkwLaY3YMwSQUJF9dtydYZfdbxp5f
	 1NaLTVeqZuND+K7OStpHlDMgS+gQxPiPAm6l+UbE+1yj7EgJ/K5ZocBxEgRFGVij1y
	 fq88/AXH85SIrBnOsKLCskCW848Bg+yTawquMoPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 21/83] net/smc: check iparea_offset and ipv6_prefixes_cnt when receiving proposal msg
Date: Mon, 23 Dec 2024 16:59:00 +0100
Message-ID: <20241223155354.453180025@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aeeb6e62361f..889709c35b1f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1988,6 +1988,8 @@ static int smc_listen_prfx_check(struct smc_sock *new_smc,
 	if (pclc->hdr.typev1 == SMC_TYPE_N)
 		return 0;
 	pclc_prfx = smc_clc_proposal_get_prefix(pclc);
+	if (!pclc_prfx)
+		return -EPROTO;
 	if (smc_clc_prfx_match(newclcsock, pclc_prfx))
 		return SMC_CLC_DECL_DIFFPREFIX;
 
@@ -2153,7 +2155,9 @@ static void smc_find_ism_v1_device_serv(struct smc_sock *new_smc,
 	int rc = 0;
 
 	/* check if ISM V1 is available */
-	if (!(ini->smcd_version & SMC_V1) || !smcd_indicated(ini->smc_type_v1))
+	if (!(ini->smcd_version & SMC_V1) ||
+	    !smcd_indicated(ini->smc_type_v1) ||
+	    !pclc_smcd)
 		goto not_found;
 	ini->is_smcd = true; /* prepare ISM check */
 	ini->ism_peer_gid[0] = ntohll(pclc_smcd->ism.gid);
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 867df4522815..f734fdd90c81 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -354,6 +354,10 @@ static bool smc_clc_msg_prop_valid(struct smc_clc_msg_proposal *pclc)
 
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
index 5fee545c9a10..08279081d438 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -303,8 +303,12 @@ struct smc_clc_msg_decline_v2 {	/* clc decline message */
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



