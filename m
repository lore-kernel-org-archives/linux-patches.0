Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F8418C928;
	Tue, 10 Sep 2024 09:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962102; cv=none; b=Hv+nTPPzVQmLhYfyJ3zXFVUgc8/BT2/0Nq8CEMExJPe1VywOxR140mqzWOK5HxH4WV6/eilMYoLPH2mWvTYU2lNLHNdr6rfsWXZlIIxqbgjepdZJN7IKfAopRRpPO/Jqcf1ycn8Njbb4zEZGzA4P1jDoqsTWD2isHm+puuI7W9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962102; c=relaxed/simple;
	bh=0JnFlbD8aJ5qxbmUzmcs7V5Kqj4pKUIa66PUU8YARKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvt5cOk/vMwEbWmNFUVvdWu1/NWwufch8h+2rUFgyy9AsshP0qHUNkdK5yJEHa+Fjf1EF/oCz75Q9C3TcQjoPaOFa62LBM1WLvpt54LlOEds/gveADb2zLaAJRDludoiCuQ0msGZF8WY3mVX6+bShiEHy+7Ib33X4juQqUpdPCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yVa9zBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yVa9zBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6D9C4CEC3;
	Tue, 10 Sep 2024 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962101;
	bh=0JnFlbD8aJ5qxbmUzmcs7V5Kqj4pKUIa66PUU8YARKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yVa9zBqu7QYECcNDHxhfKeT1qPrUr1Ay/2gKwjooe6qAs6WLxxxo4uP1yAKo0AGm
	 Dt9YkjKJXslii8XB/HhZ8VqZgUM40pnWaShtpTMh3/16OBa/HvKF3QRwJzjrg9Jbb+
	 tDmX4uTdYVnW1MMBmv8cb2NhUinhCX5N/dj9wpCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.10 296/375] usb: typec: ucsi: Fix the partner PD revision
Date: Tue, 10 Sep 2024 11:31:33 +0200
Message-ID: <20240910092632.500802531@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit de3d7969f6a80aa5abbbc0f39897495ae35548d0 upstream.

The Partner PD Revision field in GET_CONNECTOR_CAPABILITY
data structure was introduced in UCSI v2.1. In
ucsi_check_connector_capability() the version was assumed to
be 2.0, and in ucsi_register_partner() the field is accessed
completely unconditionally.

Fixing the version in ucsi_check_connector_capability(), and
replacing the unconditional pd_revision assignment with a
direct call to ucsi_check_connector_capability() in
ucsi_register_port(). After this the revision is also
checked only if there is a PD contract.

Fixes: b9fccfdb4ebb ("usb: typec: ucsi: Get PD revision for partner")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240830111645.2134301-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   50 +++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -961,6 +961,27 @@ static void ucsi_unregister_cable(struct
 	con->cable = NULL;
 }
 
+static int ucsi_check_connector_capability(struct ucsi_connector *con)
+{
+	u64 command;
+	int ret;
+
+	if (!con->partner || con->ucsi->version < UCSI_VERSION_2_1)
+		return 0;
+
+	command = UCSI_GET_CONNECTOR_CAPABILITY | UCSI_CONNECTOR_NUMBER(con->num);
+	ret = ucsi_send_command(con->ucsi, command, &con->cap, sizeof(con->cap));
+	if (ret < 0) {
+		dev_err(con->ucsi->dev, "GET_CONNECTOR_CAPABILITY failed (%d)\n", ret);
+		return ret;
+	}
+
+	typec_partner_set_pd_revision(con->partner,
+		UCSI_CONCAP_FLAG_PARTNER_PD_MAJOR_REV_AS_BCD(con->cap.flags));
+
+	return ret;
+}
+
 static void ucsi_pwr_opmode_change(struct ucsi_connector *con)
 {
 	switch (UCSI_CONSTAT_PWR_OPMODE(con->status.flags)) {
@@ -970,6 +991,7 @@ static void ucsi_pwr_opmode_change(struc
 		ucsi_partner_task(con, ucsi_get_src_pdos, 30, 0);
 		ucsi_partner_task(con, ucsi_check_altmodes, 30, 0);
 		ucsi_partner_task(con, ucsi_register_partner_pdos, 1, HZ);
+		ucsi_partner_task(con, ucsi_check_connector_capability, 1, HZ);
 		break;
 	case UCSI_CONSTAT_PWR_OPMODE_TYPEC1_5:
 		con->rdo = 0;
@@ -1013,7 +1035,6 @@ static int ucsi_register_partner(struct
 
 	desc.identity = &con->partner_identity;
 	desc.usb_pd = pwr_opmode == UCSI_CONSTAT_PWR_OPMODE_PD;
-	desc.pd_revision = UCSI_CONCAP_FLAG_PARTNER_PD_MAJOR_REV_AS_BCD(con->cap.flags);
 
 	partner = typec_register_partner(con->port, &desc);
 	if (IS_ERR(partner)) {
@@ -1090,27 +1111,6 @@ static void ucsi_partner_change(struct u
 			con->num, u_role);
 }
 
-static int ucsi_check_connector_capability(struct ucsi_connector *con)
-{
-	u64 command;
-	int ret;
-
-	if (!con->partner || con->ucsi->version < UCSI_VERSION_2_0)
-		return 0;
-
-	command = UCSI_GET_CONNECTOR_CAPABILITY | UCSI_CONNECTOR_NUMBER(con->num);
-	ret = ucsi_send_command(con->ucsi, command, &con->cap, sizeof(con->cap));
-	if (ret < 0) {
-		dev_err(con->ucsi->dev, "GET_CONNECTOR_CAPABILITY failed (%d)\n", ret);
-		return ret;
-	}
-
-	typec_partner_set_pd_revision(con->partner,
-		UCSI_CONCAP_FLAG_PARTNER_PD_MAJOR_REV_AS_BCD(con->cap.flags));
-
-	return ret;
-}
-
 static int ucsi_check_connection(struct ucsi_connector *con)
 {
 	u8 prev_flags = con->status.flags;
@@ -1225,15 +1225,16 @@ static void ucsi_handle_connector_change
 		if (con->status.flags & UCSI_CONSTAT_CONNECTED) {
 			ucsi_register_partner(con);
 			ucsi_partner_task(con, ucsi_check_connection, 1, HZ);
-			ucsi_partner_task(con, ucsi_check_connector_capability, 1, HZ);
 			if (con->ucsi->cap.features & UCSI_CAP_GET_PD_MESSAGE)
 				ucsi_partner_task(con, ucsi_get_partner_identity, 1, HZ);
 			if (con->ucsi->cap.features & UCSI_CAP_CABLE_DETAILS)
 				ucsi_partner_task(con, ucsi_check_cable, 1, HZ);
 
 			if (UCSI_CONSTAT_PWR_OPMODE(con->status.flags) ==
-			    UCSI_CONSTAT_PWR_OPMODE_PD)
+			    UCSI_CONSTAT_PWR_OPMODE_PD) {
 				ucsi_partner_task(con, ucsi_register_partner_pdos, 1, HZ);
+				ucsi_partner_task(con, ucsi_check_connector_capability, 1, HZ);
+			}
 		} else {
 			ucsi_unregister_partner(con);
 		}
@@ -1650,6 +1651,7 @@ static int ucsi_register_port(struct ucs
 		ucsi_register_device_pdos(con);
 		ucsi_get_src_pdos(con);
 		ucsi_check_altmodes(con);
+		ucsi_check_connector_capability(con);
 	}
 
 	trace_ucsi_register_port(con->num, &con->status);


