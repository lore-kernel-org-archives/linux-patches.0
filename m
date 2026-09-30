Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90AE3B2FDC;
	Wed, 30 Sep 2026 18:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791708; cv=none; b=jL/XMo10hKBr9qrOCBQopUsMYGGe75iuy9qI645WDLqimTUduDqFiHuZ4XSvZ0o6sWkVkMVc0kII2zV36+bMnA7gQltr0QYwvEiO/7TCU2hvZ//g1tq3bKHFV4n9aL8BQ/vcDhux8ll+fEwnZeau5dE5IZnY1rfvSyJRbbtYTxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791708; c=relaxed/simple;
	bh=gStikRCE3BjZ1M9gIzwE9fGrGLgyoxiZSYUi9xtt8kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9gCJvC/2cyErOQ8msf9Gu15TZGzeClCqH15vJgHwtHuUN0rS//7cVwTMq2iu0kyfg4XJr4Rkm8xD3LbnkSpZL0wWm112p5m6ZulagGrckKQbaEOiTCihY/tRFd2PXbu9UYF0ZkABN0E+/XdVxQNfkkVSNoQ3Cb/rVkg9glb2gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zdob6Wh5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zdob6Wh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D26B1F000FF;
	Wed, 30 Sep 2026 18:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791706;
	bh=M1+YvKZw0MBspdoSqxjubUkmkrRaT700qPJQFfwDAN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zdob6Wh5IV3KjDTJvpJ6TkLr+e4x8MSKCaQ3Vbgdn6gwPnalgMbQyp1ifXvUzKEBG
	 tp+8P1QxLcFgWlOO0oy+k/N+cOrqFYREQNILVUrIMhN5qbR8j+m1UikQipKTVbPQWp
	 6K+QyJLUJtXQUy/EkxwvRM5hdLR59TlHW5rMLOlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Nagamani PV <nagamani@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 396/752] s390/qeth: allow bridgeport queries despite OS_MISMATCH
Date: Wed, 30 Sep 2026 17:24:26 +0200
Message-ID: <20260930152406.846261092@linuxfoundation.org>
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

From: Nagamani PV <nagamani@linux.ibm.com>

commit 74f27fc8642b7e8d139796f8c18ee46df393c2b2 upstream.

When HiperSockets interfaces on the same VCHID span different OS
families, reads of the sysfs attributes bridge_role and bridge_state
fail with -EPERM if bridge port ownership belongs to another OS family.

As a result, userspace tools such as 'lszdev -ii' cannot retrieve
bridge_role and bridge_state, even though firmware returns valid bridge
port data for QUERY_BRIDGE_PORTS requests.

The firmware reports IPA_RC_SBP_IQD_OS_MISMATCH (0x0010) to indicate
that bridge port ownership belongs to a different OS family. For
QUERY_BRIDGE_PORTS operations, firmware still returns valid bridge port
data (role=none, state=inactive) together with a primary return code of
0x0000 (success).

Allow QUERY_BRIDGE_PORTS requests to return the bridge port data
provided by the firmware despite OS_MISMATCH. To make the OS family
mismatch visible to userspace, represent the firmware-reported role
"none" as "none (OS family mismatch)" while preserving the reported
bridge_state.

The behavior for non-QUERY bridge port commands is unchanged; SET
operations continue to return -EPERM when another OS family owns the
bridge port.

This restores readability of bridge_role and bridge_state.

Fixes: 1b05cf6285c1 ("qeth: Include error message for "OS Mismatch"")
Cc: stable@vger.kernel.org
Suggested-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Nagamani PV <nagamani@linux.ibm.com>
Link: https://patch.msgid.link/20260901155344.3561483-1-nagamani@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/net/qeth_l2.h      |    3 ++-
 drivers/s390/net/qeth_l2_main.c |   26 ++++++++++++++++++++++----
 drivers/s390/net/qeth_l2_sys.c  |    7 ++++++-
 3 files changed, 30 insertions(+), 6 deletions(-)

--- a/drivers/s390/net/qeth_l2.h
+++ b/drivers/s390/net/qeth_l2.h
@@ -13,7 +13,8 @@ extern const struct attribute_group *qet
 
 int qeth_bridgeport_query_ports(struct qeth_card *card,
 				enum qeth_sbp_roles *role,
-				enum qeth_sbp_states *state);
+				enum qeth_sbp_states *state,
+				bool *os_mismatch);
 int qeth_bridgeport_setrole(struct qeth_card *card, enum qeth_sbp_roles role);
 int qeth_bridgeport_an_set(struct qeth_card *card, int enable);
 
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1143,7 +1143,7 @@ static void qeth_l2_setup_bridgeport_att
 		qeth_bridgeport_setrole(card, card->options.sbp.role);
 		/* Let the callback function refresh the stored role value. */
 		qeth_bridgeport_query_ports(card, &card->options.sbp.role,
-					    NULL);
+					    NULL, NULL);
 	}
 	if (card->options.sbp.hostnotification) {
 		if (qeth_bridgeport_an_set(card, 1))
@@ -1529,6 +1529,7 @@ struct _qeth_sbp_cbctl {
 		struct {
 			enum qeth_sbp_roles *role;
 			enum qeth_sbp_states *state;
+			bool *os_mismatch;
 		} qports;
 	} data;
 };
@@ -1705,10 +1706,19 @@ static int qeth_bridgeport_query_ports_c
 	struct qeth_ipa_cmd *cmd = (struct qeth_ipa_cmd *) data;
 	struct _qeth_sbp_cbctl *cbctl = (struct _qeth_sbp_cbctl *)reply->param;
 	struct qeth_sbp_port_data *qports;
+	u16 sbp_rc;
 	int rc;
 
 	QETH_CARD_TEXT(card, 2, "brqprtcb");
-	rc = qeth_bridgeport_makerc(card, cmd);
+	sbp_rc = cmd->data.sbp.hdr.return_code;
+
+	/* on OS family mismatch, query still returns valid port data;
+	 * treat as success
+	 */
+	if (sbp_rc == IPA_RC_SBP_IQD_OS_MISMATCH && !cmd->hdr.return_code)
+		rc = 0;
+	else
+		rc = qeth_bridgeport_makerc(card, cmd);
 	if (rc)
 		return rc;
 
@@ -1724,6 +1734,9 @@ static int qeth_bridgeport_query_ports_c
 		if (cbctl->data.qports.state)
 			*cbctl->data.qports.state = qports->entry[0].state;
 	}
+	if (cbctl->data.qports.os_mismatch)
+		*cbctl->data.qports.os_mismatch =
+			(sbp_rc == IPA_RC_SBP_IQD_OS_MISMATCH);
 	return 0;
 }
 
@@ -1732,13 +1745,17 @@ static int qeth_bridgeport_query_ports_c
  * @card:			   qeth_card structure pointer.
  * @role:   Role of the port: 0-none, 1-primary, 2-secondary.
  * @state:  State of the port: 0-inactive, 1-standby, 2-active.
+ * @os_mismatch: if non-NULL, set to true when firmware reports
+ *		 OS family mismatch.
  *
  * Returns negative errno-compatible error indication or 0 on success.
  *
- * 'role' and 'state' are not updated in case of hardware operation failure.
+ * 'role', 'state' and 'os_mismatch' are not updated in case of
+ * hardware operation failure.
  */
 int qeth_bridgeport_query_ports(struct qeth_card *card,
-	enum qeth_sbp_roles *role, enum qeth_sbp_states *state)
+	enum qeth_sbp_roles *role, enum qeth_sbp_states *state,
+	bool *os_mismatch)
 {
 	struct qeth_cmd_buffer *iob;
 	struct _qeth_sbp_cbctl cbctl = {
@@ -1746,6 +1763,7 @@ int qeth_bridgeport_query_ports(struct q
 			.qports = {
 				.role = role,
 				.state = state,
+				.os_mismatch = os_mismatch,
 			},
 		},
 	};
--- a/drivers/s390/net/qeth_l2_sys.c
+++ b/drivers/s390/net/qeth_l2_sys.c
@@ -15,6 +15,7 @@ static ssize_t qeth_bridge_port_role_sta
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 	enum qeth_sbp_states state = QETH_SBP_STATE_INACTIVE;
+	bool os_mismatch = false;
 	int rc = 0;
 	char *word;
 
@@ -25,7 +26,7 @@ static ssize_t qeth_bridge_port_role_sta
 	if (qeth_card_hw_is_reachable(card) &&
 					card->options.sbp.supported_funcs)
 		rc = qeth_bridgeport_query_ports(card,
-			&card->options.sbp.role, &state);
+			&card->options.sbp.role, &state, &os_mismatch);
 	if (!rc) {
 		if (show_state)
 			switch (state) {
@@ -52,6 +53,10 @@ static ssize_t qeth_bridge_port_role_sta
 		if (rc)
 			QETH_CARD_TEXT_(card, 2, "SBP%02x:%02x",
 				card->options.sbp.role, state);
+		else if (!show_state &&
+			 card->options.sbp.role == QETH_SBP_ROLE_NONE &&
+			 os_mismatch)
+			rc = sysfs_emit(buf, "%s (OS family mismatch)\n", word);
 		else
 			rc = sprintf(buf, "%s\n", word);
 	}


