Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E3D1D696;
	Mon, 11 Dec 2023 18:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxna11Nx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FC5C433C8;
	Mon, 11 Dec 2023 18:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319428;
	bh=kPUEaDe5V8WgZEcLdPVm6E4ua3cZKtQ4DpXJ6Rp99NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxna11NxiafTGfxoChe25/fm53ADljJKtKC8hz6aQMIvwXYrKDL9qn7DEKsh91yve
	 /eHzHC2f17EhtsT/vOJvJDgbT5lGLP+178aQdoon+2QWphcrFxRh947bE/RYEIAL8q
	 ButTdoSsuHMG1HKPsgABWbKjqjNHBvUhDLFOSz3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gu <guwen@linux.alibaba.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/244] net/smc: fix missing byte order conversion in CLC handshake
Date: Mon, 11 Dec 2023 19:19:27 +0100
Message-ID: <20231211182049.109254919@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit c5a10397d4571bcfd4bd7ca211ee47bcb6792ec3 ]

The byte order conversions of ISM GID and DMB token are missing in
process of CLC accept and confirm. So fix it.

Fixes: 3d9725a6a133 ("net/smc: common routine for CLC accept and confirm")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Link: https://lore.kernel.org/r/1701882157-87956-1-git-send-email-guwen@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c  | 4 ++--
 net/smc/smc_clc.c | 9 ++++-----
 net/smc/smc_clc.h | 4 ++--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 741339ac94833..ef5b5d498ef3e 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -723,7 +723,7 @@ static void smcd_conn_save_peer_info(struct smc_sock *smc,
 	int bufsize = smc_uncompress_bufsize(clc->d0.dmbe_size);
 
 	smc->conn.peer_rmbe_idx = clc->d0.dmbe_idx;
-	smc->conn.peer_token = clc->d0.token;
+	smc->conn.peer_token = ntohll(clc->d0.token);
 	/* msg header takes up space in the buffer */
 	smc->conn.peer_rmbe_size = bufsize - sizeof(struct smcd_cdc_msg);
 	atomic_set(&smc->conn.peer_rmbe_space, smc->conn.peer_rmbe_size);
@@ -1415,7 +1415,7 @@ static int smc_connect_ism(struct smc_sock *smc,
 		if (rc)
 			return rc;
 	}
-	ini->ism_peer_gid[ini->ism_selected] = aclc->d0.gid;
+	ini->ism_peer_gid[ini->ism_selected] = ntohll(aclc->d0.gid);
 
 	/* there is only one lgr role for SMC-D; use server lock */
 	mutex_lock(&smc_server_lgr_pending);
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 8deb46c28f1d5..72f4d81a3f41f 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -1004,6 +1004,7 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 {
 	struct smc_connection *conn = &smc->conn;
 	struct smc_clc_first_contact_ext_v2x fce;
+	struct smcd_dev *smcd = conn->lgr->smcd;
 	struct smc_clc_msg_accept_confirm *clc;
 	struct smc_clc_fce_gid_ext gle;
 	struct smc_clc_msg_trail trl;
@@ -1021,17 +1022,15 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 		memcpy(clc->hdr.eyecatcher, SMCD_EYECATCHER,
 		       sizeof(SMCD_EYECATCHER));
 		clc->hdr.typev1 = SMC_TYPE_D;
-		clc->d0.gid =
-			conn->lgr->smcd->ops->get_local_gid(conn->lgr->smcd);
-		clc->d0.token = conn->rmb_desc->token;
+		clc->d0.gid = htonll(smcd->ops->get_local_gid(smcd));
+		clc->d0.token = htonll(conn->rmb_desc->token);
 		clc->d0.dmbe_size = conn->rmbe_size_comp;
 		clc->d0.dmbe_idx = 0;
 		memcpy(&clc->d0.linkid, conn->lgr->id, SMC_LGR_ID_SIZE);
 		if (version == SMC_V1) {
 			clc->hdr.length = htons(SMCD_CLC_ACCEPT_CONFIRM_LEN);
 		} else {
-			clc_v2->d1.chid =
-				htons(smc_ism_get_chid(conn->lgr->smcd));
+			clc_v2->d1.chid = htons(smc_ism_get_chid(smcd));
 			if (eid && eid[0])
 				memcpy(clc_v2->d1.eid, eid, SMC_MAX_EID_LEN);
 			len = SMCD_CLC_ACCEPT_CONFIRM_LEN_V2;
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index c5c8e7db775a7..08155a96a02a1 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -204,8 +204,8 @@ struct smcr_clc_msg_accept_confirm {	/* SMCR accept/confirm */
 } __packed;
 
 struct smcd_clc_msg_accept_confirm_common {	/* SMCD accept/confirm */
-	u64 gid;		/* Sender GID */
-	u64 token;		/* DMB token */
+	__be64 gid;		/* Sender GID */
+	__be64 token;		/* DMB token */
 	u8 dmbe_idx;		/* DMBE index */
 #if defined(__BIG_ENDIAN_BITFIELD)
 	u8 dmbe_size : 4,	/* buf size (compressed) */
-- 
2.42.0



