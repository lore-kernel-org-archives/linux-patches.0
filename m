Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D0D39FD9;
	Tue, 26 Aug 2025 13:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214746; cv=none; b=VbyzIjBZRphqQKoTtboSeDTpf3c2mXWFdsL+KApeTAdkOmoqZni/za/NtExUwG45xDa8Jz2maCehbrN7luctiWJi5UkK9ctQR2fE66lksVm06PleJZLvaZruzSrEqHVRxmEMut6tugTEhhJh4olCINagT8N9289L3RiSq5KncLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214746; c=relaxed/simple;
	bh=1WHc+J+jNrrbuD/9RBZSaV2tvjI8KaDa9Z30RenDJ54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpt6FbsqHaSZ8hH/J2I7+9ijqvQExncCKoDbw0hZfGAyUdhKe/RxaSNhNBoj4k8AhuFWCEcsov0OTjypmRiEPpA+/CEQSqV1JZbtSSq4lSM5b4S/Wc6xsp0EWrdMoe/zNXdBvKeAO4wBbNn8CSDQNecwUjV/3uxgN7imcdCQxwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPCFa2d4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPCFa2d4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF9FC116B1;
	Tue, 26 Aug 2025 13:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214745;
	bh=1WHc+J+jNrrbuD/9RBZSaV2tvjI8KaDa9Z30RenDJ54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPCFa2d4084vyIAsBIXao3j/yryB6lDeEdaoT2EhkEJxT+5l2knjG4C1OqX6YEjYT
	 EsQfk4Ud3TNyUqcf86wBNVhXXZhEIlp3OlgRSUrbqz9EdtdBfOLdXaqPs5w8VJD9+L
	 ft3SQNJOBrRqBML3Ggf8I/Mo/zmdVC9Gc/DebWw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 222/482] scsi: target: core: Generate correct identifiers for PR OUT transport IDs
Date: Tue, 26 Aug 2025 13:07:55 +0200
Message-ID: <20250826110936.259260432@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 6e0f6aa44b68335df404a2df955055f416b5f2aa ]

Fix target_parse_pr_out_transport_id() to return a string representing
the transport ID in a human-readable format (e.g., naa.xxxxxxxx...)  for
various SCSI protocol types (SAS, FCP, SRP, SBP).

Previously, the function returned a pointer to the raw binary buffer,
which was incorrectly compared against human-readable strings, causing
comparisons to fail.  Now, the function writes a properly formatted
string into a buffer provided by the caller.  The output format depends
on the transport protocol:

* SAS: 64-bit identifier, "naa." prefix.
* FCP: 64-bit identifier, colon separated values.
* SBP: 64-bit identifier, no prefix.
* SRP: 128-bit identifier, "0x" prefix.
* iSCSI: IQN string.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Link: https://lore.kernel.org/r/20250714133738.11054-1-mlombard@redhat.com
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_fabric_lib.c | 63 +++++++++++++++++++------
 drivers/target/target_core_internal.h   |  4 +-
 drivers/target/target_core_pr.c         | 18 +++----
 3 files changed, 60 insertions(+), 25 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 6600ae44f29d..d3ab251ba049 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -257,11 +257,41 @@ static int iscsi_get_pr_transport_id_len(
 	return len;
 }
 
-static char *iscsi_parse_pr_out_transport_id(
+static void sas_parse_pr_out_transport_id(char *buf, char *i_str)
+{
+	char hex[17] = {};
+
+	bin2hex(hex, buf + 4, 8);
+	snprintf(i_str, TRANSPORT_IQN_LEN, "naa.%s", hex);
+}
+
+static void srp_parse_pr_out_transport_id(char *buf, char *i_str)
+{
+	char hex[33] = {};
+
+	bin2hex(hex, buf + 8, 16);
+	snprintf(i_str, TRANSPORT_IQN_LEN, "0x%s", hex);
+}
+
+static void fcp_parse_pr_out_transport_id(char *buf, char *i_str)
+{
+	snprintf(i_str, TRANSPORT_IQN_LEN, "%8phC", buf + 8);
+}
+
+static void sbp_parse_pr_out_transport_id(char *buf, char *i_str)
+{
+	char hex[17] = {};
+
+	bin2hex(hex, buf + 8, 8);
+	snprintf(i_str, TRANSPORT_IQN_LEN, "%s", hex);
+}
+
+static bool iscsi_parse_pr_out_transport_id(
 	struct se_portal_group *se_tpg,
 	char *buf,
 	u32 *out_tid_len,
-	char **port_nexus_ptr)
+	char **port_nexus_ptr,
+	char *i_str)
 {
 	char *p;
 	int i;
@@ -282,7 +312,7 @@ static char *iscsi_parse_pr_out_transport_id(
 	if ((format_code != 0x00) && (format_code != 0x40)) {
 		pr_err("Illegal format code: 0x%02x for iSCSI"
 			" Initiator Transport ID\n", format_code);
-		return NULL;
+		return false;
 	}
 	/*
 	 * If the caller wants the TransportID Length, we set that value for the
@@ -306,7 +336,7 @@ static char *iscsi_parse_pr_out_transport_id(
 			pr_err("Unable to locate \",i,0x\" separator"
 				" for Initiator port identifier: %s\n",
 				&buf[4]);
-			return NULL;
+			return false;
 		}
 		*p = '\0'; /* Terminate iSCSI Name */
 		p += 5; /* Skip over ",i,0x" separator */
@@ -339,7 +369,8 @@ static char *iscsi_parse_pr_out_transport_id(
 	} else
 		*port_nexus_ptr = NULL;
 
-	return &buf[4];
+	strscpy(i_str, &buf[4], TRANSPORT_IQN_LEN);
+	return true;
 }
 
 int target_get_pr_transport_id_len(struct se_node_acl *nacl,
@@ -387,33 +418,35 @@ int target_get_pr_transport_id(struct se_node_acl *nacl,
 	}
 }
 
-const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
-		char *buf, u32 *out_tid_len, char **port_nexus_ptr)
+bool target_parse_pr_out_transport_id(struct se_portal_group *tpg,
+		char *buf, u32 *out_tid_len, char **port_nexus_ptr, char *i_str)
 {
-	u32 offset;
-
 	switch (tpg->proto_id) {
 	case SCSI_PROTOCOL_SAS:
 		/*
 		 * Assume the FORMAT CODE 00b from spc4r17, 7.5.4.7 TransportID
 		 * for initiator ports using SCSI over SAS Serial SCSI Protocol.
 		 */
-		offset = 4;
+		sas_parse_pr_out_transport_id(buf, i_str);
 		break;
-	case SCSI_PROTOCOL_SBP:
 	case SCSI_PROTOCOL_SRP:
+		srp_parse_pr_out_transport_id(buf, i_str);
+		break;
 	case SCSI_PROTOCOL_FCP:
-		offset = 8;
+		fcp_parse_pr_out_transport_id(buf, i_str);
+		break;
+	case SCSI_PROTOCOL_SBP:
+		sbp_parse_pr_out_transport_id(buf, i_str);
 		break;
 	case SCSI_PROTOCOL_ISCSI:
 		return iscsi_parse_pr_out_transport_id(tpg, buf, out_tid_len,
-					port_nexus_ptr);
+					port_nexus_ptr, i_str);
 	default:
 		pr_err("Unknown proto_id: 0x%02x\n", tpg->proto_id);
-		return NULL;
+		return false;
 	}
 
 	*port_nexus_ptr = NULL;
 	*out_tid_len = 24;
-	return buf + offset;
+	return true;
 }
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 85e35cf582e5..84a399a997d8 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -104,8 +104,8 @@ int	target_get_pr_transport_id_len(struct se_node_acl *nacl,
 int	target_get_pr_transport_id(struct se_node_acl *nacl,
 		struct t10_pr_registration *pr_reg, int *format_code,
 		unsigned char *buf);
-const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
-		char *buf, u32 *out_tid_len, char **port_nexus_ptr);
+bool target_parse_pr_out_transport_id(struct se_portal_group *tpg,
+		char *buf, u32 *out_tid_len, char **port_nexus_ptr, char *i_str);
 
 /* target_core_hba.c */
 struct se_hba *core_alloc_hba(const char *, u32, u32);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index a355661e8202..e0a6133bba98 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1477,11 +1477,12 @@ core_scsi3_decode_spec_i_port(
 	LIST_HEAD(tid_dest_list);
 	struct pr_transport_id_holder *tidh_new, *tidh, *tidh_tmp;
 	unsigned char *buf, *ptr, proto_ident;
-	const unsigned char *i_str = NULL;
+	unsigned char i_str[TRANSPORT_IQN_LEN];
 	char *iport_ptr = NULL, i_buf[PR_REG_ISID_ID_LEN];
 	sense_reason_t ret;
 	u32 tpdl, tid_len = 0;
 	u32 dest_rtpi = 0;
+	bool tid_found;
 
 	/*
 	 * Allocate a struct pr_transport_id_holder and setup the
@@ -1570,9 +1571,9 @@ core_scsi3_decode_spec_i_port(
 			dest_rtpi = tmp_lun->lun_rtpi;
 
 			iport_ptr = NULL;
-			i_str = target_parse_pr_out_transport_id(tmp_tpg,
-					ptr, &tid_len, &iport_ptr);
-			if (!i_str)
+			tid_found = target_parse_pr_out_transport_id(tmp_tpg,
+					ptr, &tid_len, &iport_ptr, i_str);
+			if (!tid_found)
 				continue;
 			/*
 			 * Determine if this SCSI device server requires that
@@ -3152,13 +3153,14 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	struct t10_pr_registration *pr_reg, *pr_res_holder, *dest_pr_reg;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	unsigned char *buf;
-	const unsigned char *initiator_str;
+	unsigned char initiator_str[TRANSPORT_IQN_LEN];
 	char *iport_ptr = NULL, i_buf[PR_REG_ISID_ID_LEN] = { };
 	u32 tid_len, tmp_tid_len;
 	int new_reg = 0, type, scope, matching_iname;
 	sense_reason_t ret;
 	unsigned short rtpi;
 	unsigned char proto_ident;
+	bool tid_found;
 
 	if (!se_sess || !se_lun) {
 		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
@@ -3277,9 +3279,9 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
-	initiator_str = target_parse_pr_out_transport_id(dest_se_tpg,
-			&buf[24], &tmp_tid_len, &iport_ptr);
-	if (!initiator_str) {
+	tid_found = target_parse_pr_out_transport_id(dest_se_tpg,
+			&buf[24], &tmp_tid_len, &iport_ptr, initiator_str);
+	if (!tid_found) {
 		pr_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
 			" initiator_str from Transport ID\n");
 		ret = TCM_INVALID_PARAMETER_LIST;
-- 
2.39.5



