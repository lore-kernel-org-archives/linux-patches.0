Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C6514263
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3ORxyaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA16C433C8;
	Mon, 23 Oct 2023 11:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059384;
	bh=8EdUQUO7erUTLh9eh+lXsTV/7MqMJ9+8SY1GyKS9/tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3ORxyajq5H6sDoSh8hXDgvgcm6el7CRXmW1R8y6H3cdpHWVtj9mkPVoczJ3GF9f/
	 uOnySStJvTKKtnZ+95eoNH5GLqHgfZdRF6qpBMsbwXU0gAJcZyVeR4Eg1j6S86l40I
	 sOLXoKL1SdY12IMcNZr1dOjZbO5nS2WbUUFHoiuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Jan Karcher <jaka@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 160/241] net/smc: support smc v2.x features validate
Date: Mon, 23 Oct 2023 12:55:46 +0200
Message-ID: <20231023104837.775218104@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

[ Upstream commit 6ac1e6563f5915cd38b6bc6a8b26964b2252f751 ]

Support SMC v2.x features validate for SMC v2.1. This is the frame
code for SMC v2.x features validate, and will take effects only when
the negotiated release version is v2.1 or later.

For Server, v2.x features' validation should be done in smc_clc_srv_
v2x_features_validate when receiving v2.1 or later CLC Proposal Message,
such as max conns, max links negotiation, the decision of the final
value of max conns and max links should be made in this function.
And final check for server when receiving v2.1 or later CLC Confirm
Message should be done in smc_clc_v2x_features_confirm_check.

For client, v2.x features' validation should be done in smc_clc_clnt_
v2x_features_validate when receiving v2.1 or later CLC Accept Message,
for example, the decision to accpt the accepted value or to decline
should be made in this function.

Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Jan Karcher <jaka@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: c68681ae46ea ("net/smc: fix smc clc failed issue when netdevice not in init_net")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c  | 18 ++++++++++++++++++
 net/smc/smc_clc.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_clc.h |  7 +++++++
 3 files changed, 71 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 077e5864fc441..fa7b8015cd7bb 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1199,6 +1199,7 @@ static int smc_connect_rdma_v2_prepare(struct smc_sock *smc,
 		(struct smc_clc_msg_accept_confirm_v2 *)aclc;
 	struct smc_clc_first_contact_ext *fce =
 		smc_get_clc_first_contact_ext(clc_v2, false);
+	int rc;
 
 	if (!ini->first_contact_peer || aclc->hdr.version == SMC_V1)
 		return 0;
@@ -1219,6 +1220,9 @@ static int smc_connect_rdma_v2_prepare(struct smc_sock *smc,
 	}
 
 	ini->release_nr = fce->release;
+	rc = smc_clc_clnt_v2x_features_validate(fce, ini);
+	if (rc)
+		return rc;
 
 	return 0;
 }
@@ -1393,6 +1397,9 @@ static int smc_connect_ism(struct smc_sock *smc,
 				smc_get_clc_first_contact_ext(aclc_v2, true);
 
 			ini->release_nr = fce->release;
+			rc = smc_clc_clnt_v2x_features_validate(fce, ini);
+			if (rc)
+				return rc;
 		}
 
 		rc = smc_v2_determine_accepted_chid(aclc_v2, ini);
@@ -2443,6 +2450,10 @@ static void smc_listen_work(struct work_struct *work)
 	if (rc)
 		goto out_decl;
 
+	rc = smc_clc_srv_v2x_features_validate(pclc, ini);
+	if (rc)
+		goto out_decl;
+
 	mutex_lock(&smc_server_lgr_pending);
 	smc_close_init(new_smc);
 	smc_rx_init(new_smc);
@@ -2475,6 +2486,13 @@ static void smc_listen_work(struct work_struct *work)
 		goto out_decl;
 	}
 
+	rc = smc_clc_v2x_features_confirm_check(cclc, ini);
+	if (rc) {
+		if (!ini->is_smcd)
+			goto out_unlock;
+		goto out_decl;
+	}
+
 	/* finish worker */
 	if (!ini->is_smcd) {
 		rc = smc_listen_rdma_finish(new_smc, cclc,
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index fb0be0817e8a5..f50d1b019a80f 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -1156,6 +1156,52 @@ int smc_clc_send_accept(struct smc_sock *new_smc, bool srv_first_contact,
 	return len > 0 ? 0 : len;
 }
 
+int smc_clc_srv_v2x_features_validate(struct smc_clc_msg_proposal *pclc,
+				      struct smc_init_info *ini)
+{
+	struct smc_clc_v2_extension *pclc_v2_ext;
+
+	if ((!(ini->smcd_version & SMC_V2) && !(ini->smcr_version & SMC_V2)) ||
+	    ini->release_nr < SMC_RELEASE_1)
+		return 0;
+
+	pclc_v2_ext = smc_get_clc_v2_ext(pclc);
+	if (!pclc_v2_ext)
+		return SMC_CLC_DECL_NOV2EXT;
+
+	return 0;
+}
+
+int smc_clc_clnt_v2x_features_validate(struct smc_clc_first_contact_ext *fce,
+				       struct smc_init_info *ini)
+{
+	if (ini->release_nr < SMC_RELEASE_1)
+		return 0;
+
+	return 0;
+}
+
+int smc_clc_v2x_features_confirm_check(struct smc_clc_msg_accept_confirm *cclc,
+				       struct smc_init_info *ini)
+{
+	struct smc_clc_msg_accept_confirm_v2 *clc_v2 =
+		(struct smc_clc_msg_accept_confirm_v2 *)cclc;
+	struct smc_clc_first_contact_ext *fce =
+		smc_get_clc_first_contact_ext(clc_v2, ini->is_smcd);
+
+	if (cclc->hdr.version == SMC_V1 ||
+	    !(cclc->hdr.typev2 & SMC_FIRST_CONTACT_MASK))
+		return 0;
+
+	if (ini->release_nr != fce->release)
+		return SMC_CLC_DECL_RELEASEERR;
+
+	if (fce->release < SMC_RELEASE_1)
+		return 0;
+
+	return 0;
+}
+
 void smc_clc_get_hostname(u8 **host)
 {
 	*host = &smc_hostname[0];
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index b923e89acafb0..32fa56bfa06d5 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -45,6 +45,7 @@
 #define SMC_CLC_DECL_NOSEID	0x03030006  /* peer sent no SEID	      */
 #define SMC_CLC_DECL_NOSMCD2DEV	0x03030007  /* no SMC-Dv2 device found	      */
 #define SMC_CLC_DECL_NOUEID	0x03030008  /* peer sent no UEID	      */
+#define SMC_CLC_DECL_RELEASEERR	0x03030009  /* release version negotiate failed */
 #define SMC_CLC_DECL_MODEUNSUPP	0x03040000  /* smc modes do not match (R or D)*/
 #define SMC_CLC_DECL_RMBE_EC	0x03050000  /* peer has eyecatcher in RMBE    */
 #define SMC_CLC_DECL_OPTUNSUPP	0x03060000  /* fastopen sockopt not supported */
@@ -404,6 +405,12 @@ int smc_clc_send_confirm(struct smc_sock *smc, bool clnt_first_contact,
 			 u8 version, u8 *eid, struct smc_init_info *ini);
 int smc_clc_send_accept(struct smc_sock *smc, bool srv_first_contact,
 			u8 version, u8 *negotiated_eid, struct smc_init_info *ini);
+int smc_clc_srv_v2x_features_validate(struct smc_clc_msg_proposal *pclc,
+				      struct smc_init_info *ini);
+int smc_clc_clnt_v2x_features_validate(struct smc_clc_first_contact_ext *fce,
+				       struct smc_init_info *ini);
+int smc_clc_v2x_features_confirm_check(struct smc_clc_msg_accept_confirm *cclc,
+				       struct smc_init_info *ini);
 void smc_clc_init(void) __init;
 void smc_clc_exit(void);
 void smc_clc_get_hostname(u8 **host);
-- 
2.40.1



