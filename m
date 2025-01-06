Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AF513DB9F;
	Mon,  6 Jan 2025 15:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178540; cv=none; b=VuQkYK4jVR6MFDFdHUD3niQZ3YxS4LxQ+IMA1urfYZHBJGSXjHW7T1cJ1tbYNC/3s31ZLw7+eYMbJCnJZvRAxC8aC+cuFDzSskS3TBQEzeFHaOoicTdyWDw2d9oqn/IsI5QJV2tA63R9WQR4u7k//QbZ1wA61h3TrWU/8FlImIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178540; c=relaxed/simple;
	bh=9HrpxWr8nJA90b/67oNEZoP8TNtzm9fBt8ZFvkM1aeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dr0GLI8fGcR0dSb+JQqSY7Ff3E73nR/D5BGMNstCCGA+jqO4T+iGdLdUOnQILVXNWfxk10dg3MhBzSyWdJ65GohqVQlmQPGg06AbmRTOL+5kQmMSytqq3pa0rFWywLrGaiXNiiKj62Q0C8Mz5tePFbGrIP4vDJu+9tXiDjy51oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSZP02oA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSZP02oA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBD5C4CED2;
	Mon,  6 Jan 2025 15:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178540;
	bh=9HrpxWr8nJA90b/67oNEZoP8TNtzm9fBt8ZFvkM1aeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSZP02oALEN5L8viC8PIbwDg6oxET1lKokf/FeI0qkDUNvAjDzmcCECmsBYI8bpLL
	 Yja9D/fo6fmXVWxXxTe8K6hUZoTuYX+Hn0qr/JVCqOSOBH16SHXq07Fwe6AW5eUyFt
	 JAlvZEZut3VQuJcwmqYvJCs4uKVQgQzSYr165nGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/168] net/smc: check iparea_offset and ipv6_prefixes_cnt when receiving proposal msg
Date: Mon,  6 Jan 2025 16:15:22 +0100
Message-ID: <20250106151139.001261026@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fb299dbc0c26..ef0f264932e1 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1632,6 +1632,8 @@ static int smc_listen_prfx_check(struct smc_sock *new_smc,
 	if (pclc->hdr.typev1 == SMC_TYPE_N)
 		return 0;
 	pclc_prfx = smc_clc_proposal_get_prefix(pclc);
+	if (!pclc_prfx)
+		return -EPROTO;
 	if (smc_clc_prfx_match(newclcsock, pclc_prfx))
 		return SMC_CLC_DECL_DIFFPREFIX;
 
@@ -1797,7 +1799,9 @@ static void smc_find_ism_v1_device_serv(struct smc_sock *new_smc,
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
index 6ec1ebe878ae..035e8135ea49 100644
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
index 32d37f7b70f2..986dcd5db3ed 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -264,8 +264,12 @@ struct smc_clc_msg_decline {	/* clc decline message */
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



