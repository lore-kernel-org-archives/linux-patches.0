Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFF34071DA;
	Sun,  7 Jun 2026 10:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827435; cv=none; b=hHRPnai2qWZeGSZiYMj/nvJ/dX46D/AUEXVCi5PAqvbdEvZCjZxbCIeLzK9C27/wHECUyRLYp7cqHsGDl/RCzcEC2KtZH2CoN+Vcqg+i/24CtnugLsRX/BMTwXS1pKmeBFhEVFOM5RyCBVUgx7O3CNlz6zVlRACqVmRKTEzUDk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827435; c=relaxed/simple;
	bh=acnkdwPXszY2T/PgaEUqGnok8EJwsODBCfc6o3DUYoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQXqvkckTB5Ve+wpYs7pLD55fbGB5R01V/x2f3TD+S4RiuXr1TU8GLZCfR85TDPt6HxVm1HFNrB0ac2ATKtoyk1G5E1tf9w7uKPMY2gyoX7RYntejiKJfUy1EsXp0pH1ZISOqjHDLCkGKiYdAjZSeUg0D3r+Hjd6WJrtfmsbAXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVKjqrtc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVKjqrtc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E801F00893;
	Sun,  7 Jun 2026 10:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827433;
	bh=YsV0suLlUB520UMVFE8UbGZoqTPiNj9DUvZYWd+NlO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVKjqrtcqLYzvZB4p3fnNrWe+pAupbPPwDcLGFAlxxFXtS4gXjkxM/K7QTouJn/IQ
	 rb3JBeaTtviE5S6Mixth3esOvtHmZdmbGPCCsh3I4PxJJYmo7H1r5BtWRH5L8YeJOl
	 jl/g6vww7Z1XP0YmAf+L37r3Vl0/Gmfn9FSGWHgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danielle Ratson <danieller@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/307] net: ethtool: Add new parameters and a function to support EPL
Date: Sun,  7 Jun 2026 11:57:32 +0200
Message-ID: <20260607095729.749604388@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit edc344568922eb9588e77ba49de1ef0cb9a2ff1c ]

In the CMIS specification for pluggable modules, LPL (Local Payload) and
EPL (Extended Payload) are two types of data payloads used for managing
various functions and features of the module.

EPL payloads are used for more complex and extensive management
functions that require a larger amount of data, so writing firmware
blocks using EPL is much more efficient.

Currently, only LPL payload is supported for writing firmware blocks to
the module.

Add EPL related parameters to the function ethtool_cmis_cdb_compose_args()
and add a specific function for calculating the maximum allowable length
extension for EPL. Both will be used in the next patch to add support for
writing firmware blocks using EPL.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 12c2496a71f8 ("ethtool: cmis: validate start_cmd_payload_size from module")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/cmis.h           | 12 +++++++-----
 net/ethtool/cmis_cdb.c       | 32 +++++++++++++++++++++-----------
 net/ethtool/cmis_fw_update.c | 17 ++++++++++-------
 3 files changed, 38 insertions(+), 23 deletions(-)

diff --git a/net/ethtool/cmis.h b/net/ethtool/cmis.h
index aa32a675b8f8d2..e11e47b3f2fc8f 100644
--- a/net/ethtool/cmis.h
+++ b/net/ethtool/cmis.h
@@ -96,13 +96,15 @@ struct ethtool_cmis_cdb_rpl {
 	u8 payload[ETHTOOL_CMIS_CDB_LPL_MAX_PL_LENGTH];
 };
 
-u32 ethtool_cmis_get_max_payload_size(u8 num_of_byte_octs);
+u32 ethtool_cmis_get_max_lpl_size(u8 num_of_byte_octs);
+u32 ethtool_cmis_get_max_epl_size(u8 num_of_byte_octs);
 
 void ethtool_cmis_cdb_compose_args(struct ethtool_cmis_cdb_cmd_args *args,
-				   enum ethtool_cmis_cdb_cmd_id cmd, u8 *pl,
-				   u8 lpl_len, u16 max_duration,
-				   u8 read_write_len_ext, u16 msleep_pre_rpl,
-				   u8 rpl_exp_len, u8 flags);
+				   enum ethtool_cmis_cdb_cmd_id cmd, u8 *lpl,
+				   u8 lpl_len, u8 *epl, u16 epl_len,
+				   u16 max_duration, u8 read_write_len_ext,
+				   u16 msleep_pre_rpl, u8 rpl_exp_len,
+				   u8 flags);
 
 void ethtool_cmis_cdb_check_completion_flag(u8 cmis_rev, u8 *flags);
 
diff --git a/net/ethtool/cmis_cdb.c b/net/ethtool/cmis_cdb.c
index 690002366d965a..31142e239cf6b2 100644
--- a/net/ethtool/cmis_cdb.c
+++ b/net/ethtool/cmis_cdb.c
@@ -11,25 +11,34 @@
  * min(i, 15) byte octets where i specifies the allowable additional number of
  * byte octets in a READ or a WRITE.
  */
-u32 ethtool_cmis_get_max_payload_size(u8 num_of_byte_octs)
+u32 ethtool_cmis_get_max_lpl_size(u8 num_of_byte_octs)
 {
 	return 8 * (1 + min_t(u8, num_of_byte_octs, 15));
 }
 
+/* For accessing the EPL field on page 9Fh, the allowable length extension is
+ * min(i, 255) byte octets where i specifies the allowable additional number of
+ * byte octets in a READ or a WRITE.
+ */
+u32 ethtool_cmis_get_max_epl_size(u8 num_of_byte_octs)
+{
+	return 8 * (1 + min_t(u8, num_of_byte_octs, 255));
+}
+
 void ethtool_cmis_cdb_compose_args(struct ethtool_cmis_cdb_cmd_args *args,
-				   enum ethtool_cmis_cdb_cmd_id cmd, u8 *pl,
-				   u8 lpl_len, u16 max_duration,
-				   u8 read_write_len_ext, u16 msleep_pre_rpl,
-				   u8 rpl_exp_len, u8 flags)
+				   enum ethtool_cmis_cdb_cmd_id cmd, u8 *lpl,
+				   u8 lpl_len, u8 *epl, u16 epl_len,
+				   u16 max_duration, u8 read_write_len_ext,
+				   u16 msleep_pre_rpl, u8 rpl_exp_len, u8 flags)
 {
 	args->req.id = cpu_to_be16(cmd);
 	args->req.lpl_len = lpl_len;
-	if (pl)
-		memcpy(args->req.payload, pl, args->req.lpl_len);
+	if (lpl)
+		memcpy(args->req.payload, lpl, args->req.lpl_len);
 
 	args->max_duration = max_duration;
 	args->read_write_len_ext =
-		ethtool_cmis_get_max_payload_size(read_write_len_ext);
+		ethtool_cmis_get_max_lpl_size(read_write_len_ext);
 	args->msleep_pre_rpl = msleep_pre_rpl;
 	args->rpl_exp_len = rpl_exp_len;
 	args->flags = flags;
@@ -183,7 +192,7 @@ cmis_cdb_validate_password(struct ethtool_cmis_cdb *cdb,
 	}
 
 	ethtool_cmis_cdb_compose_args(&args, ETHTOOL_CMIS_CDB_CMD_QUERY_STATUS,
-				      (u8 *)&qs_pl, sizeof(qs_pl), 0,
+				      (u8 *)&qs_pl, sizeof(qs_pl), NULL, 0, 0,
 				      cdb->read_write_len_ext, 1000,
 				      sizeof(*rpl),
 				      CDB_F_COMPLETION_VALID | CDB_F_STATUS_VALID);
@@ -245,8 +254,9 @@ static int cmis_cdb_module_features_get(struct ethtool_cmis_cdb *cdb,
 	ethtool_cmis_cdb_check_completion_flag(cdb->cmis_rev, &flags);
 	ethtool_cmis_cdb_compose_args(&args,
 				      ETHTOOL_CMIS_CDB_CMD_MODULE_FEATURES,
-				      NULL, 0, 0, cdb->read_write_len_ext,
-				      1000, sizeof(*rpl), flags);
+				      NULL, 0, NULL, 0, 0,
+				      cdb->read_write_len_ext, 1000,
+				      sizeof(*rpl), flags);
 
 	err = ethtool_cmis_cdb_execute_cmd(dev, &args);
 	if (err < 0) {
diff --git a/net/ethtool/cmis_fw_update.c b/net/ethtool/cmis_fw_update.c
index 655ff5224ffa30..a514127985d44e 100644
--- a/net/ethtool/cmis_fw_update.c
+++ b/net/ethtool/cmis_fw_update.c
@@ -54,7 +54,8 @@ cmis_fw_update_fw_mng_features_get(struct ethtool_cmis_cdb *cdb,
 	ethtool_cmis_cdb_check_completion_flag(cdb->cmis_rev, &flags);
 	ethtool_cmis_cdb_compose_args(&args,
 				      ETHTOOL_CMIS_CDB_CMD_FW_MANAGMENT_FEATURES,
-				      NULL, 0, cdb->max_completion_time,
+				      NULL, 0, NULL, 0,
+				      cdb->max_completion_time,
 				      cdb->read_write_len_ext, 1000,
 				      sizeof(*rpl), flags);
 
@@ -122,7 +123,7 @@ cmis_fw_update_start_download(struct ethtool_cmis_cdb *cdb,
 
 	ethtool_cmis_cdb_compose_args(&args,
 				      ETHTOOL_CMIS_CDB_CMD_START_FW_DOWNLOAD,
-				      (u8 *)&pl, lpl_len,
+				      (u8 *)&pl, lpl_len, NULL, 0,
 				      fw_mng->max_duration_start,
 				      cdb->read_write_len_ext, 1000, 0,
 				      CDB_F_COMPLETION_VALID | CDB_F_STATUS_VALID);
@@ -158,7 +159,7 @@ cmis_fw_update_write_image(struct ethtool_cmis_cdb *cdb,
 	int err;
 
 	max_lpl_len = min_t(u32,
-			    ethtool_cmis_get_max_payload_size(cdb->read_write_len_ext),
+			    ethtool_cmis_get_max_lpl_size(cdb->read_write_len_ext),
 			    ETHTOOL_CMIS_CDB_LPL_MAX_PL_LENGTH);
 	max_block_size =
 		max_lpl_len - sizeof_field(struct cmis_cdb_write_fw_block_lpl_pl,
@@ -183,7 +184,7 @@ cmis_fw_update_write_image(struct ethtool_cmis_cdb *cdb,
 
 		ethtool_cmis_cdb_compose_args(&args,
 					      ETHTOOL_CMIS_CDB_CMD_WRITE_FW_BLOCK_LPL,
-					      (u8 *)&pl, lpl_len,
+					      (u8 *)&pl, lpl_len, NULL, 0,
 					      fw_mng->max_duration_write,
 					      cdb->read_write_len_ext, 1, 0,
 					      CDB_F_COMPLETION_VALID | CDB_F_STATUS_VALID);
@@ -212,7 +213,8 @@ cmis_fw_update_complete_download(struct ethtool_cmis_cdb *cdb,
 
 	ethtool_cmis_cdb_compose_args(&args,
 				      ETHTOOL_CMIS_CDB_CMD_COMPLETE_FW_DOWNLOAD,
-				      NULL, 0, fw_mng->max_duration_complete,
+				      NULL, 0, NULL, 0,
+				      fw_mng->max_duration_complete,
 				      cdb->read_write_len_ext, 1000, 0,
 				      CDB_F_COMPLETION_VALID | CDB_F_STATUS_VALID);
 
@@ -294,7 +296,7 @@ cmis_fw_update_run_image(struct ethtool_cmis_cdb *cdb, struct net_device *dev,
 	int err;
 
 	ethtool_cmis_cdb_compose_args(&args, ETHTOOL_CMIS_CDB_CMD_RUN_FW_IMAGE,
-				      (u8 *)&pl, sizeof(pl),
+				      (u8 *)&pl, sizeof(pl), NULL, 0,
 				      cdb->max_completion_time,
 				      cdb->read_write_len_ext, 1000, 0,
 				      CDB_F_MODULE_STATE_VALID);
@@ -326,7 +328,8 @@ cmis_fw_update_commit_image(struct ethtool_cmis_cdb *cdb,
 
 	ethtool_cmis_cdb_compose_args(&args,
 				      ETHTOOL_CMIS_CDB_CMD_COMMIT_FW_IMAGE,
-				      NULL, 0, cdb->max_completion_time,
+				      NULL, 0, NULL, 0,
+				      cdb->max_completion_time,
 				      cdb->read_write_len_ext, 1000, 0,
 				      CDB_F_COMPLETION_VALID | CDB_F_STATUS_VALID);
 
-- 
2.53.0



