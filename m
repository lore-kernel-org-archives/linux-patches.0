Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AF22DFF04;
	Sun,  7 Jun 2026 10:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829302; cv=none; b=f4JhpPmX31CeuPDJ/o03/t4hWe9bANo9J6b/5SZVwpv4NSdGkoIK/h5PUZF/qu5hWHA+L4OIaYIJCI7ypXEayzNPRc1ruSXTAgdnEnn2HuH1wDT/GCP8rKj+NzMgj7xwxYfC2ah55MA807abGB1felejm6STooVVR6SAPmOxWbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829302; c=relaxed/simple;
	bh=YYxkZbzSHjMaJ44rVMXHDLgPirZqIbO9/+0PaL7Yv/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZ/+6kX5H4HtGR/67fzxXElScJzub67YouP2pWqlY+RSRXRQdJO2xqSlz4w6/kd3jmvOSRmURwU/vPLTVWb6M6y9RidfXDu07XVjnrGW6lHeDJClBLYPW6vHBeop3B37vxyY2jkej2s/jyRl6S9FBXv39mkFsF/Zxuzaib/8P1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGOOfAKJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGOOfAKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875A81F00893;
	Sun,  7 Jun 2026 10:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829301;
	bh=fLIkGQhgi7j7qJ/sYaCiz3rq+uESEnOrVUUTPy1ZQuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGOOfAKJCLvEPXYhWZouTQdqPZN9tR4esT0L/m9JB/UddQQEVK2ru4cgaBLDahtlw
	 +BybdVKin1bWL7uPPhy2OKY+q8fDetakL1I9TahqcKaqwxWH10s5NIbC4uzCLwQGTz
	 6K9XJ6BUNkiV8JwTwmK4TtQ6dpFdwzhDt3QEDeGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 7.0 262/332] usb: typec: ucsi: Check if power role change actually happened before handling
Date: Sun,  7 Jun 2026 12:00:31 +0200
Message-ID: <20260607095737.664356052@linuxfoundation.org>
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

From: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>

commit b80e7d34c7ea6a564525119d6138fbb577a23dba upstream.

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
---
 drivers/usb/typec/ucsi/ucsi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1267,7 +1267,7 @@ static void ucsi_handle_connector_change
 						  work);
 	struct ucsi *ucsi = con->ucsi;
 	u8 curr_scale, volt_scale;
-	enum typec_role role;
+	enum typec_role role, prev_role;
 	u16 change;
 	int ret;
 	u32 val;
@@ -1278,6 +1278,8 @@ static void ucsi_handle_connector_change
 		dev_err_once(ucsi->dev, "%s entered without EVENT_PENDING\n",
 			     __func__);
 
+	prev_role = UCSI_CONSTAT(con, PWR_DIR);
+
 	ret = ucsi_get_connector_status(con, true);
 	if (ret) {
 		dev_err(ucsi->dev, "%s: GET_CONNECTOR_STATUS failed (%d)\n",
@@ -1294,7 +1296,7 @@ static void ucsi_handle_connector_change
 	change = UCSI_CONSTAT(con, CHANGE);
 	role = UCSI_CONSTAT(con, PWR_DIR);
 
-	if (change & UCSI_CONSTAT_POWER_DIR_CHANGE) {
+	if ((change & UCSI_CONSTAT_POWER_DIR_CHANGE) && role != prev_role) {
 		typec_set_pwr_role(con->port, role);
 		ucsi_port_psy_changed(con);
 


