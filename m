Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290CC3DC4D9;
	Tue, 16 Jun 2026 18:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635030; cv=none; b=hR7+Pyd17OSNRiDYUjWWL1s4oCyvPpoeTpSWahWh3c67xhQUAnbEQcscJJAuAcJpTYCW1bZfZP2axa5ZPtvcFRivnr2pV4L3zWdTimAv0/kUHeSH0b9GyGhXQL/f5BMLoaOaEJ5wln+6/mG5NK0cfquVmZhn3lznk/Yz9YLAGLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635030; c=relaxed/simple;
	bh=M7yH6lwml+A0PybFDAMLEjlnIf8sTXAkJDfm5v64OH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgHNzOv7P0iR+SQlDXR9otJ2GZnGgWC0WhQe3aVYIsOoJtnGpICG+c3BmvEupNOe6oHbggCn9DmlgvCMCuqoMptthIgLNkp9xUoskXghdx+M42txkNRbs4M3wcXirmrUNLjFMy+bZbvky0yK/hZtaPQ52jJFgAf3xx7IU6ybjpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SU4n7Kn6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SU4n7Kn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B551F000E9;
	Tue, 16 Jun 2026 18:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635029;
	bh=ez3927RCbjVAud8RXAEHJ92TwTWniRpZu24mdxgp0RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SU4n7Kn6oH3SL2NxpqZBPU/vE80DenfxaF2V0mAUucIEQOLPFulm5Bheyb9S/HUTA
	 IX5RXV+Co7+5sCCkfsRH8Oqv6NR4DvUueRDvx6tugV8RA60+1OSjNKCGwUp9YoW1M8
	 R+D7fEwYTHakKRc6jQ9A60eKjav3mAb9OWtbXHsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 5.15 378/411] usb: typec: ucsi: Check if power role change actually happened before handling
Date: Tue, 16 Jun 2026 20:30:16 +0530
Message-ID: <20260616145121.383888719@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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
 drivers/usb/typec/ucsi/ucsi.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -669,7 +669,7 @@ static void ucsi_handle_connector_change
 	struct ucsi *ucsi = con->ucsi;
 	struct ucsi_connector_status pre_ack_status;
 	struct ucsi_connector_status post_ack_status;
-	enum typec_role role;
+	enum typec_role role, prev_role;
 	enum usb_role u_role = USB_ROLE_NONE;
 	u16 inferred_changes;
 	u16 changed_flags;
@@ -706,6 +706,8 @@ static void ucsi_handle_connector_change
 	 * short transitional changes.
 	 */
 
+	prev_role = !!(con->status.flags & UCSI_CONSTAT_PWR_DIR);
+
 	/* 1. First UCSI_GET_CONNECTOR_STATUS */
 	command = UCSI_GET_CONNECTOR_STATUS | UCSI_CONNECTOR_NUMBER(con->num);
 	ret = ucsi_send_command(ucsi, command, &pre_ack_status,
@@ -783,7 +785,8 @@ static void ucsi_handle_connector_change
 		ucsi_port_psy_changed(con);
 	}
 
-	if (con->status.change & UCSI_CONSTAT_POWER_DIR_CHANGE) {
+	if ((con->status.change & UCSI_CONSTAT_POWER_DIR_CHANGE) &&
+	    role != prev_role) {
 		typec_set_pwr_role(con->port, role);
 
 		/* Complete pending power role swap */


