Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB05C4071DD;
	Sun,  7 Jun 2026 10:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829521; cv=none; b=G15nB2ZLRv7ie3wNWO5SxodpheVxxFh8V57hhZNUUObmqVZ+GXdYQtkhQBjtkB5YE8plexXhAhey/9MGQJf77NV5vQpEtD2G8Rr2d37Y7ZkfIF7ik5wdCyt2QlUnY0O6lo9epcfZt7Q8RJ29xhCB9Ed6t5fpWh15sRk0Wq1rCQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829521; c=relaxed/simple;
	bh=CFtHhAUyAz+zSagu1hb0BctVbZ7IhXWC3Gp5YPaOqQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEjXa/2P8a5lJ80iDHiDr3UOYEI/3xGQlt4UbsIfkZ0V1HVbfVLPH5ZXF6vALmcOqeq1nsiAoLgxqKROZ7p7v+ytcAn0cRVmOLLYdKdyQM+2CnrTvTOqVtpd5+kZ9D3Dk/4t3LaBpwgz2koAMo6eWelFPDi9+HwmjhAdtRDJYTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRtleF5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRtleF5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030801F00893;
	Sun,  7 Jun 2026 10:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829519;
	bh=0HlZZh0tdX96vAW0e5PI/Wlf9Tm70l/TEMztqCqc6qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vRtleF5q5HZ9q6vslrsrhAa3vX9QOlRsFwbukE8lCVlGfpEwA4u3TETcYAldoZp28
	 LemXI5m2Bn0MQbZbKj6RZO4MQn3gu462HzXi78uyMF0sn9aIbCZkFy/UaGO/KEOgzE
	 JBII17DAc8h3TJt3YPcRS/5ML1s27W1xZuNukDxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 7.0 286/332] scsi: target: iscsi: Bound iscsi_encode_text_output() appends to rsp_buf
Date: Sun,  7 Jun 2026 12:00:55 +0200
Message-ID: <20260607095738.549633162@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit bf33e01f88388c43e285492a63e539df6ffed64c upstream.

iscsi_encode_text_output() concatenates "key=value\0" records into
login->rsp_buf, an 8192-byte kzalloc(MAX_KEY_VALUE_PAIRS) buffer
allocated in iscsit_alloc_login_setup_buffer(). The three sprintf() call
sites in this function (lines 1398, 1411, 1424 in v7.1-rc2) never check
the remaining buffer capacity:

	*length += sprintf(output_buf, "%s=%s", er->key, er->value);
	*length += 1;
	output_buf = textbuf + *length;

The 8192-byte ceiling at iscsi_target_check_login_request() bounds the
*input* Login PDU payload, but a single PDU can carry up to 2048 minimal
four-byte "a=b\0" pairs, each unknown key expanding to a 16-byte
"a=NotUnderstood\0" output record via iscsi_add_notunderstood_response().
2048 * 16 = 32 KiB of output into an 8 KiB buffer, producing a ~24 KiB
heap overrun in the kmalloc-8k slab.

The fix introduces a static iscsi_encode_text_record() helper that uses
snprintf() with a per-call bounds check against the remaining buffer,
and threads a u32 textbuf_size parameter through
iscsi_encode_text_output(). Both call sites in
iscsi_target_handle_csg_zero() (PHASE_SECURITY) and
iscsi_target_handle_csg_one() (PHASE_OPERATIONAL) pass
MAX_KEY_VALUE_PAIRS. On overflow the encoder logs the condition, calls
iscsi_release_extra_responses() to drop queued records, and returns -1;
both caller sites now emit ISCSI_STATUS_CLS_INITIATOR_ERR /
ISCSI_LOGIN_STATUS_INIT_ERR via iscsit_tx_login_rsp() before returning,
so the initiator sees an explicit failed-login response rather than a
silent connection drop. (Prior to this patch only the PHASE_OPERATIONAL
caller did that; the PHASE_SECURITY caller is converted to the same
shape.)

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Tested-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/iscsi/iscsi_target_nego.c       |    7 ++
 drivers/target/iscsi/iscsi_target_parameters.c |   62 +++++++++++++++++++------
 drivers/target/iscsi/iscsi_target_parameters.h |    2 
 3 files changed, 55 insertions(+), 16 deletions(-)

--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -899,10 +899,14 @@ static int iscsi_target_handle_csg_zero(
 			SENDER_TARGET,
 			login->rsp_buf,
 			&login->rsp_length,
+			MAX_KEY_VALUE_PAIRS,
 			conn->param_list,
 			conn->tpg->tpg_attrib.login_keys_workaround);
-	if (ret < 0)
+	if (ret < 0) {
+		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_INIT_ERR);
 		return -1;
+	}
 
 	if (!iscsi_check_negotiated_keys(conn->param_list)) {
 		bool auth_required = iscsi_conn_auth_required(conn);
@@ -986,6 +990,7 @@ static int iscsi_target_handle_csg_one(s
 			SENDER_TARGET,
 			login->rsp_buf,
 			&login->rsp_length,
+			MAX_KEY_VALUE_PAIRS,
 			conn->param_list,
 			conn->tpg->tpg_attrib.login_keys_workaround);
 	if (ret < 0) {
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -1371,19 +1371,42 @@ free_buffer:
 	return -1;
 }
 
+/*
+ * Append "key=value" plus a trailing NUL into @textbuf at *@length.
+ * Returns 0 on success and advances *@length, or -EMSGSIZE if the
+ * record (including the NUL) would not fit in the remaining buffer.
+ */
+static int iscsi_encode_text_record(char *textbuf, u32 *length,
+				    u32 textbuf_size,
+				    const char *key, const char *value)
+{
+	int n;
+	u32 avail;
+
+	if (*length >= textbuf_size)
+		return -EMSGSIZE;
+
+	avail = textbuf_size - *length;
+	n = snprintf(textbuf + *length, avail, "%s=%s", key, value);
+	if (n < 0 || (u32)n + 1 > avail)
+		return -EMSGSIZE;
+
+	*length += n + 1;
+	return 0;
+}
+
 int iscsi_encode_text_output(
 	u8 phase,
 	u8 sender,
 	char *textbuf,
 	u32 *length,
+	u32 textbuf_size,
 	struct iscsi_param_list *param_list,
 	bool keys_workaround)
 {
-	char *output_buf = NULL;
 	struct iscsi_extra_response *er;
 	struct iscsi_param *param;
-
-	output_buf = textbuf + *length;
+	int ret;
 
 	if (iscsi_enforce_integrity_rules(phase, param_list) < 0)
 		return -1;
@@ -1395,10 +1418,12 @@ int iscsi_encode_text_output(
 		    !IS_PSTATE_RESPONSE_SENT(param) &&
 		    !IS_PSTATE_REPLY_OPTIONAL(param) &&
 		    (param->phase & phase)) {
-			*length += sprintf(output_buf, "%s=%s",
-				param->name, param->value);
-			*length += 1;
-			output_buf = textbuf + *length;
+			ret = iscsi_encode_text_record(textbuf, length,
+						       textbuf_size,
+						       param->name,
+						       param->value);
+			if (ret < 0)
+				goto err_overflow;
 			SET_PSTATE_RESPONSE_SENT(param);
 			pr_debug("Sending key: %s=%s\n",
 				param->name, param->value);
@@ -1408,10 +1433,12 @@ int iscsi_encode_text_output(
 		    !IS_PSTATE_ACCEPTOR(param) &&
 		    !IS_PSTATE_PROPOSER(param) &&
 		    (param->phase & phase)) {
-			*length += sprintf(output_buf, "%s=%s",
-				param->name, param->value);
-			*length += 1;
-			output_buf = textbuf + *length;
+			ret = iscsi_encode_text_record(textbuf, length,
+						       textbuf_size,
+						       param->name,
+						       param->value);
+			if (ret < 0)
+				goto err_overflow;
 			SET_PSTATE_PROPOSER(param);
 			iscsi_check_proposer_for_optional_reply(param,
 							        keys_workaround);
@@ -1421,14 +1448,21 @@ int iscsi_encode_text_output(
 	}
 
 	list_for_each_entry(er, &param_list->extra_response_list, er_list) {
-		*length += sprintf(output_buf, "%s=%s", er->key, er->value);
-		*length += 1;
-		output_buf = textbuf + *length;
+		ret = iscsi_encode_text_record(textbuf, length, textbuf_size,
+					       er->key, er->value);
+		if (ret < 0)
+			goto err_overflow;
 		pr_debug("Sending key: %s=%s\n", er->key, er->value);
 	}
 	iscsi_release_extra_responses(param_list);
 
 	return 0;
+
+err_overflow:
+	pr_err("iSCSI login response buffer (%u bytes) exhausted, dropping login.\n",
+	       textbuf_size);
+	iscsi_release_extra_responses(param_list);
+	return -1;
 }
 
 int iscsi_check_negotiated_keys(struct iscsi_param_list *param_list)
--- a/drivers/target/iscsi/iscsi_target_parameters.h
+++ b/drivers/target/iscsi/iscsi_target_parameters.h
@@ -43,7 +43,7 @@ extern struct iscsi_param *iscsi_find_pa
 extern int iscsi_extract_key_value(char *, char **, char **);
 extern int iscsi_update_param_value(struct iscsi_param *, char *);
 extern int iscsi_decode_text_input(u8, u8, char *, u32, struct iscsit_conn *);
-extern int iscsi_encode_text_output(u8, u8, char *, u32 *,
+extern int iscsi_encode_text_output(u8, u8, char *, u32 *, u32,
 			struct iscsi_param_list *, bool);
 extern int iscsi_check_negotiated_keys(struct iscsi_param_list *);
 extern void iscsi_set_connection_parameters(struct iscsi_conn_ops *,


