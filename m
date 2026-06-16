Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3B247A0DA;
	Tue, 16 Jun 2026 17:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630158; cv=none; b=hSWKX1FbEViAYXmAEylzhV6sVHcbL1Xtwy5sCiAb6puEIKzzBEjzprkLGqbidddvN+UafvyxxufyW3dze9uF1++7f9mlBm/WJM6ilSwI0tXautQM+9+EQ7lBHhRwEeT5zaO3Q6dIsMPPTgk7wShBnp2oBai06M0QCqoquBpgDqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630158; c=relaxed/simple;
	bh=8YiA6XqhMMHWYgjHtrR2ITWutstnMThAcYAqv0WOeNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6qNvZ5jfqcVmzVEmIrD+5LFpbwW0XokFQ6ybFz1eityCKw5vEg3jYzkhKQYMsOLGHwExx9kzt2kbAGWBy6QG9VvBDeqV6DwbetVtXs2/IHHxX4Ubn+75jC2qJ7quznBlrvWW1NEhaomNBkj/YlYtKAYY3u9TaL1SFdsv6HyOnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h48lZla3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h48lZla3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BE21F000E9;
	Tue, 16 Jun 2026 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630156;
	bh=tp1E4TYAYWhGworzYyAQ7Bwo4yGzp1bPp79cNtKeznI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h48lZla38CCRNFukHUCWrbayukmfCQPe2IsDrFkQZOUsPj0yh9e3UCFlwRA7k9buq
	 Aqsc7apZkuglOMSSRuU30h54T5F1sXoBzEHB5w9QLsNBr20xBt8jSH/AkSHlwEAFzL
	 pV9GPvmtKQsDYZ/eWuGcAGLf70fYt0gMpWI397Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 6.6 422/452] usb: typec: ucsi: Check if power role change actually happened before handling
Date: Tue, 16 Jun 2026 20:30:49 +0530
Message-ID: <20260616145138.906074707@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>

[ Upstream commit b80e7d34c7ea6a564525119d6138fbb577a23dba ]

The CrOS EC may send a connector status change event with the power
direction changed flag set even if the power direction hasn't actually
changed after initiating a SET_PDR command internally [1]. In practice
this happens on every system suspend due to other changes performed by
the EC [2][3][4], causing suspend to fail.

Fix this by checking if the power role change actually happened before
handling it.

[1]: https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main:src/platform/ec/zephyr/subsys/pd_controller/pdc_power_mgmt.c;l=1689;drc=2d5a1cffce4e5ac8a39442cb3b764d2d5e1cf794
[2]: https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main:src/platform/ec/zephyr/subsys/pd_controller/pdc_power_mgmt.c;l=3923;drc=2d5a1cffce4e5ac8a39442cb3b764d2d5e1cf794
[3]: https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main:src/platform/ec/zephyr/subsys/pd_controller/pdc_power_mgmt.c;l=5094;drc=2d5a1cffce4e5ac8a39442cb3b764d2d5e1cf794
[4]: https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main:src/platform/ec/zephyr/subsys/pd_controller/pdc_power_mgmt.c;l=2229;drc=2d5a1cffce4e5ac8a39442cb3b764d2d5e1cf794

Cc: stable <stable@kernel.org>
Fixes: 7616f006db07 ("usb: typec: ucsi: Update power_supply on power role change")
Signed-off-by: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
Reported-and-tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260519-ucsi-fix-2-v1-1-6f1239535187@qtmlabs.xyz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -884,7 +884,7 @@ static void ucsi_handle_connector_change
 	struct ucsi_connector *con = container_of(work, struct ucsi_connector,
 						  work);
 	struct ucsi *ucsi = con->ucsi;
-	enum typec_role role;
+	enum typec_role role, prev_role;
 	u64 command;
 	int ret;
 
@@ -892,6 +892,8 @@ static void ucsi_handle_connector_change
 
 	command = UCSI_GET_CONNECTOR_STATUS | UCSI_CONNECTOR_NUMBER(con->num);
 
+	prev_role = !!(con->status.flags & UCSI_CONSTAT_PWR_DIR);
+
 	ret = ucsi_send_command_common(ucsi, command, &con->status,
 				       sizeof(con->status), true);
 	if (ret < 0) {
@@ -908,7 +910,7 @@ static void ucsi_handle_connector_change
 
 	role = !!(con->status.flags & UCSI_CONSTAT_PWR_DIR);
 
-	if (con->status.change & UCSI_CONSTAT_POWER_DIR_CHANGE) {
+	if ((con->status.change & UCSI_CONSTAT_POWER_DIR_CHANGE) && role != prev_role) {
 		typec_set_pwr_role(con->port, role);
 		ucsi_port_psy_changed(con);
 


