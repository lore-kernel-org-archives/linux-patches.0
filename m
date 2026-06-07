Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C921A6822;
	Sun,  7 Jun 2026 10:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829284; cv=none; b=LY5SPwEy2YKN0weOULgBGXt+zQTldRHsUGrI7QWKnAYKEZaj5VlbxWSjzi/+kFt2LxGYBfVjcEeCraqzdvGGUUUS9GpZb7fjJYvmiay1bjBa9mSFZeWQ5AqYwrWd/vAFJlSqhJnh+gma9HnYSsN28ny2OYNuKpWaW7BM1EYIbFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829284; c=relaxed/simple;
	bh=0NN4w0+RKdZoee3K52S36CAlf2xKiUMh5+n9qFOFMaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVUY+nhdwUcyj4PWMQjhhcjOHYBu5IfifB43Y6g4n9lGHGXRgHEONh3ITDOhLhfifkSA3J43wBPu/obxlfmmsHYE2Th4nKuwS7royH4gWMaA9By+B9SJ2qe/C3Crn5W4xW8aQBlNFkbhkunX1LnaHOhpWVKJH1s4n4J2rb0TleM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2xv+Rzh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2xv+Rzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2551F00893;
	Sun,  7 Jun 2026 10:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829283;
	bh=bsya4kkGNjvYdoOqCUbI+EQqjqBOOfglyPYWnZ6iClE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T2xv+Rzh1Ny6ZubVLtNoeaL35b11GEBdcJTHCoStyxPi0w5diny3RaBqo/UAeEYtS
	 aaj4v6Q6qX5tt29Hb5csnylv1riQvRo2TRPg09ONsXIYw5qEgL4u7kckfLu4GPggOK
	 67DYMoMRDZnZ0iLCec4olByPtC3xvhoO27zRd8/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 6.18 232/315] usb: typec: ucsi: Check if power role change actually happened before handling
Date: Sun,  7 Jun 2026 12:00:19 +0200
Message-ID: <20260607095736.094727720@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1224,7 +1224,7 @@ static void ucsi_handle_connector_change
 						  work);
 	struct ucsi *ucsi = con->ucsi;
 	u8 curr_scale, volt_scale;
-	enum typec_role role;
+	enum typec_role role, prev_role;
 	u16 change;
 	int ret;
 	u32 val;
@@ -1235,6 +1235,8 @@ static void ucsi_handle_connector_change
 		dev_err_once(ucsi->dev, "%s entered without EVENT_PENDING\n",
 			     __func__);
 
+	prev_role = UCSI_CONSTAT(con, PWR_DIR);
+
 	ret = ucsi_get_connector_status(con, true);
 	if (ret) {
 		dev_err(ucsi->dev, "%s: GET_CONNECTOR_STATUS failed (%d)\n",
@@ -1251,7 +1253,7 @@ static void ucsi_handle_connector_change
 	change = UCSI_CONSTAT(con, CHANGE);
 	role = UCSI_CONSTAT(con, PWR_DIR);
 
-	if (change & UCSI_CONSTAT_POWER_DIR_CHANGE) {
+	if ((change & UCSI_CONSTAT_POWER_DIR_CHANGE) && role != prev_role) {
 		typec_set_pwr_role(con->port, role);
 		ucsi_port_psy_changed(con);
 


