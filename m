Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AAAA59;
	Wed, 30 Sep 2026 18:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791801; cv=none; b=UfBSg+h2YVLjUF1bWH/zX9bE3Y3HxrmbMo4HW1fqP9sbpDcmTqgfgCWPn13iGgwySPB+7VFootnOG6GSXlTeAqRaQrfAT3KRIUVBaAS1OldQiwzZy/z62ntduIBm36i7jMF0AS+h/7VV0ocfYUFtCZmQ1guzKQgSew65d47xKI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791801; c=relaxed/simple;
	bh=Inlt+BVkB9Ao98RsQnJIFf9w0sOXWA/eis7PeMhxq4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pzp57kgxwoL8nhpHW/0AWIzcaAMcYIo1/dTQE3XlGwtUNQZQvaEDP/hsAV+po79eySXFbIPMgZKr0DnLEDveFwSRaDnsaFMdE4HTWXzI//fjgMygwVd+QpG+d4gKSUv5xDcrYyTH79VDryj/K17mp8R0Ew2aGpNUjvqahqmQNd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/PvQ6sQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/PvQ6sQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93561F000FF;
	Wed, 30 Sep 2026 18:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791800;
	bh=V41YjvPrAsHsgnD6aRortJAvgBRY0ERV5nstszv/4ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/PvQ6sQ9zVTdDd8lyWwBrawjOMN1jsCNvkg3mx3wHFmn3iEziC1evypRyb2PvHRB
	 YlseCSHFcxHq4XliM3z5/5+B1wEj7WjX687fBs/zFkCxOT1d6aAofr2vOaqsX7Vk5g
	 c5AUke3vabskwMdnc8CjH4UIbqlYBpTMQV04Ur+0=
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
Subject: [PATCH 5.15 431/752] net/smc: check v2_ext_offset/eid_cnt/ism_gid_cnt when receiving proposal msg
Date: Wed, 30 Sep 2026 17:25:01 +0200
Message-ID: <20260930152407.612655802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ jcao: drop the af_smc.c hunk, smc_find_rdma_v2_device_serv() came
  with SMC-Rv2 in e49300a6bf62 (v5.16); take SMC_CLC_MAX_UEID from
  fa0866625543 (v5.16); SMC_MAX_ISM_DEVS is the pre-b40584d14570 name
  of SMCD_CLC_MAX_V2_GID_ENTRIES ]
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_clc.c | 8 +++++++-
 net/smc/smc_clc.h | 9 ++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index fb214faf5f984..0c2c0b2edfdff 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -47,7 +47,6 @@ static bool smc_clc_msg_prop_valid(struct smc_clc_msg_proposal *pclc)
 	struct smc_clc_msg_hdr *hdr = &pclc->hdr;
 	struct smc_clc_v2_extension *v2_ext;
 
-	v2_ext = smc_get_clc_v2_ext(pclc);
 	pclc_prfx = smc_clc_proposal_get_prefix(pclc);
 	if (!pclc_prfx ||
 	    pclc_prfx->ipv6_prefixes_cnt > SMC_CLC_MAX_V6_PREFIX)
@@ -64,6 +63,13 @@ static bool smc_clc_msg_prop_valid(struct smc_clc_msg_proposal *pclc)
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
index 78a94b9122b64..bda7c0384b845 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -158,6 +158,7 @@ struct smc_clc_msg_proposal {	/* clc proposal message sent by Linux */
 } __aligned(4);
 
 #define SMC_CLC_MAX_V6_PREFIX		8
+#define SMC_CLC_MAX_UEID		8
 
 struct smc_clc_msg_proposal_area {
 	struct smc_clc_msg_proposal		pclc_base;
@@ -297,8 +298,14 @@ static inline struct smc_clc_v2_extension *
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



