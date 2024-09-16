Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238D414D2B3;
	Mon, 16 Sep 2024 12:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488142; cv=none; b=Cv26yRYSwlKQm2xe+hLeMbclQh3+4ri/UzHAoSwoZa6BwtOA8Z1SBDXCieb6m6C6V3eq0rGOYh/cNh/FTAyNWR6Dprmrhyr+puBQBFQykfSpR4wm7hW+CITlSfAq85gwaGEl1U0KgBELdRFuw5rHRMOF6ewJzEDDed563kQB5KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488142; c=relaxed/simple;
	bh=ayjqT1sLOncLw9PSBRIyEPI4eiHNL1541qn5n3d/o0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7Uv6TChzMsyoZOt/zhxVp8G9vB54HxpT4CNdJl7OgnCY/lmxKEMQs4fiJie1YuIHTI6/UbGkGBZqYIRQge9iUym0FiCakogF1x1y2i+9OOqY3HfCp8H8f87DWgMi9N4ztHyhuEHHCqxr/sq/K2TXFJw7uHdN3uKTcVaZ+XYKxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnuN5DAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnuN5DAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D6EC4CEC4;
	Mon, 16 Sep 2024 12:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488142;
	bh=ayjqT1sLOncLw9PSBRIyEPI4eiHNL1541qn5n3d/o0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnuN5DARAprdZrYaVREJUVssljLK/FTam7oiaCfqmBJw66vgmKXZKjRtXJcVrhLgC
	 DhMBsR7lp7fQDJ2iNk0fFhL6xEg5yTV034sKpRfXGh83ahecXl5Dzy+LI5YZcwfkP+
	 l08TYrgnC68O4ZXbGHbPpwlKQXxai+r435fffZOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 002/121] usb: typec: ucsi: Fix cable registration
Date: Mon, 16 Sep 2024 13:42:56 +0200
Message-ID: <20240916114229.012895816@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

[ Upstream commit 87eb3cb4ec619299cd5572e1d5eb68aef4074ac2 ]

The Cable PD Revision field in GET_CABLE_PROPERTY was
introduced in UCSI v2.1, so adding check for that.

The cable properties are also not used anywhere after the
cable is registered, so removing the cable_prop member
from struct ucsi_connector while at it.

Fixes: 38ca416597b0 ("usb: typec: ucsi: Register cables based on GET_CABLE_PROPERTY")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240903130945.3395291-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 30 +++++++++++++++---------------
 drivers/usb/typec/ucsi/ucsi.h |  1 -
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 7a127ea57b5a..bf349ad95dcd 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -915,10 +915,20 @@ static void ucsi_unregister_plug(struct ucsi_connector *con)
 
 static int ucsi_register_cable(struct ucsi_connector *con)
 {
+	struct ucsi_cable_property cable_prop;
 	struct typec_cable *cable;
 	struct typec_cable_desc desc = {};
+	u64 command;
+	int ret;
+
+	command = UCSI_GET_CABLE_PROPERTY | UCSI_CONNECTOR_NUMBER(con->num);
+	ret = ucsi_send_command(con->ucsi, command, &cable_prop, sizeof(cable_prop));
+	if (ret < 0) {
+		dev_err(con->ucsi->dev, "GET_CABLE_PROPERTY failed (%d)\n", ret);
+		return ret;
+	}
 
-	switch (UCSI_CABLE_PROP_FLAG_PLUG_TYPE(con->cable_prop.flags)) {
+	switch (UCSI_CABLE_PROP_FLAG_PLUG_TYPE(cable_prop.flags)) {
 	case UCSI_CABLE_PROPERTY_PLUG_TYPE_A:
 		desc.type = USB_PLUG_TYPE_A;
 		break;
@@ -934,10 +944,10 @@ static int ucsi_register_cable(struct ucsi_connector *con)
 	}
 
 	desc.identity = &con->cable_identity;
-	desc.active = !!(UCSI_CABLE_PROP_FLAG_ACTIVE_CABLE &
-			 con->cable_prop.flags);
-	desc.pd_revision = UCSI_CABLE_PROP_FLAG_PD_MAJOR_REV_AS_BCD(
-	    con->cable_prop.flags);
+	desc.active = !!(UCSI_CABLE_PROP_FLAG_ACTIVE_CABLE & cable_prop.flags);
+
+	if (con->ucsi->version >= UCSI_VERSION_2_1)
+		desc.pd_revision = UCSI_CABLE_PROP_FLAG_PD_MAJOR_REV_AS_BCD(cable_prop.flags);
 
 	cable = typec_register_cable(con->port, &desc);
 	if (IS_ERR(cable)) {
@@ -1143,21 +1153,11 @@ static int ucsi_check_connection(struct ucsi_connector *con)
 
 static int ucsi_check_cable(struct ucsi_connector *con)
 {
-	u64 command;
 	int ret, num_plug_am;
 
 	if (con->cable)
 		return 0;
 
-	command = UCSI_GET_CABLE_PROPERTY | UCSI_CONNECTOR_NUMBER(con->num);
-	ret = ucsi_send_command(con->ucsi, command, &con->cable_prop,
-				sizeof(con->cable_prop));
-	if (ret < 0) {
-		dev_err(con->ucsi->dev, "GET_CABLE_PROPERTY failed (%d)\n",
-			ret);
-		return ret;
-	}
-
 	ret = ucsi_register_cable(con);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/usb/typec/ucsi/ucsi.h b/drivers/usb/typec/ucsi/ucsi.h
index f66224a270bc..46c37643b59c 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -444,7 +444,6 @@ struct ucsi_connector {
 
 	struct ucsi_connector_status status;
 	struct ucsi_connector_capability cap;
-	struct ucsi_cable_property cable_prop;
 	struct power_supply *psy;
 	struct power_supply_desc psy_desc;
 	u32 rdo;
-- 
2.43.0



