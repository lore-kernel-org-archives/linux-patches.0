Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE82412AAC3;
	Mon,  8 Apr 2024 13:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581984; cv=none; b=ByZzX8HJ32GEeK7jTerPDQtA3zymyEtwwZTZMmcm03hAnhQDqlo0z4MAJWb9AGZT1quxN21/Li+DEoV6dattmHExeIx9eBmwSlxvwkhiU4i6gRYYjPzqjCrQOkQErdZlZAj6CRw2zZMq8GxijbnCGHDIqm5w32mm2RJir8DoRtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581984; c=relaxed/simple;
	bh=53GoV/pwJ4bSn+i7cYS7+6z+04RAKy1KMK84637uTGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cnb4d04rJ0lAjyPKjb2721LPSR2PGoRC7PRULlUfnM1PHYJNwZ43AU0j6BCQ/MpKQ249SmCELGLEmkliI9EywVIIw0xYaj0Lz9Aa0aZehgRi2zVkYpnuj8EtzvfsCKu8v46bNKrFmy/l3Fot59F9dN74YiGLZSKrmUA7sO7BMao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nXXXxxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nXXXxxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F16C43390;
	Mon,  8 Apr 2024 13:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581984;
	bh=53GoV/pwJ4bSn+i7cYS7+6z+04RAKy1KMK84637uTGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nXXXxxi6itwKIeJh79gFo0keWx1GX4gzM3CmlWu3zggx1DGfCpYQdvzKOm89/yaY
	 CJsPWaEkVJzScPNeyQL+a/ees4BskZEcyJHCtt2J2zRs+jjF82b8mI1nUlD+nmyMKG
	 ek29E9Qk6qoV3Kvfq6Z6BBebFmoMz7FabsPiBVTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.1 069/138] usb: typec: ucsi: Check for notifications after init
Date: Mon,  8 Apr 2024 14:58:03 +0200
Message-ID: <20240408125258.365239039@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <lk@c--e.de>

[ Upstream commit 808a8b9e0b87bbc72bcc1f7ddfe5d04746e7ce56 ]

The completion notification for the final SET_NOTIFICATION_ENABLE
command during initialization can include a connector change
notification.  However, at the time this completion notification is
processed, the ucsi struct is not ready to handle this notification.
As a result the notification is ignored and the controller
never sends an interrupt again.

Re-check CCI for a pending connector state change after
initialization is complete. Adjust the corresponding debug
message accordingly.

Fixes: 71a1fa0df2a3 ("usb: typec: ucsi: Store the notification mask")
Cc: stable@vger.kernel.org
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Link: https://lore.kernel.org/r/20240320073927.1641788-3-lk@c--e.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 98f335cbbcdea..1fd4aaf348047 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -855,7 +855,7 @@ void ucsi_connector_change(struct ucsi *ucsi, u8 num)
 	struct ucsi_connector *con = &ucsi->connector[num - 1];
 
 	if (!(ucsi->ntfy & UCSI_ENABLE_NTFY_CONNECTOR_CHANGE)) {
-		dev_dbg(ucsi->dev, "Bogus connector change event\n");
+		dev_dbg(ucsi->dev, "Early connector change event\n");
 		return;
 	}
 
@@ -1248,6 +1248,7 @@ static int ucsi_init(struct ucsi *ucsi)
 {
 	struct ucsi_connector *con, *connector;
 	u64 command, ntfy;
+	u32 cci;
 	int ret;
 	int i;
 
@@ -1300,6 +1301,13 @@ static int ucsi_init(struct ucsi *ucsi)
 
 	ucsi->connector = connector;
 	ucsi->ntfy = ntfy;
+
+	ret = ucsi->ops->read(ucsi, UCSI_CCI, &cci, sizeof(cci));
+	if (ret)
+		return ret;
+	if (UCSI_CCI_CONNECTOR(READ_ONCE(cci)))
+		ucsi_connector_change(ucsi, cci);
+
 	return 0;
 
 err_unregister:
-- 
2.43.0



