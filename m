Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B34487BE;
	Mon,  1 Apr 2024 16:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990596; cv=none; b=XYHXk3s4uM+eXwsvv9ZMnszfrhbonw5QxAXTxQtWKbnFuCEK0tu8ozEjsy3Jp9yckJaG8E8kWqJ9kQ2Hh3h+2OgmjbUTGasCI06liE3yLfXR2SHFZpaj7Lsw/S/cCKPrEdxMxx6QSc8uEYN8+sOgKxOMePFSnY6oD7zlECGr1FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990596; c=relaxed/simple;
	bh=Egx6pwBlMy3glGVdnASkyDZynXloJq7nHzGhwx2wjss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qhl2qCwRVciaOYIKxQjjukMyJyXNuLVgyHAuCzSGiNttmvievCp3j46ptkQRx9RZ7ozrAeEW3VQ3+oAoIq8wdkjhuxMzZdxYV+QivMWjF7GBGNyJRsu0rwPhQIEZdRyLAlu9POay9arSl6hZiYeoaMBlUby9/C1rRJ3wNFXv+KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOzrKqr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOzrKqr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60960C433C7;
	Mon,  1 Apr 2024 16:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990595;
	bh=Egx6pwBlMy3glGVdnASkyDZynXloJq7nHzGhwx2wjss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NOzrKqr4Qe/+QT/ql3f5KDamIIMTTHMjjioMZw2iwqB8nT9Q9jXiheT4EHul3uENP
	 Z+mw+MBxtm3ufCngyEb19luh0mYDKBDo9zBoOZt/7s0r8pnEr6qLn6QusxYu0Ni5TX
	 BccWQJWfweV0IlkmYc0EPKvfkQY1e0boHhGn0DCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.6 374/396] usb: typec: ucsi: Check for notifications after init
Date: Mon,  1 Apr 2024 17:47:03 +0200
Message-ID: <20240401152559.063765655@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <lk@c--e.de>

commit 808a8b9e0b87bbc72bcc1f7ddfe5d04746e7ce56 upstream.

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
---
 drivers/usb/typec/ucsi/ucsi.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -955,7 +955,7 @@ void ucsi_connector_change(struct ucsi *
 	struct ucsi_connector *con = &ucsi->connector[num - 1];
 
 	if (!(ucsi->ntfy & UCSI_ENABLE_NTFY_CONNECTOR_CHANGE)) {
-		dev_dbg(ucsi->dev, "Bogus connector change event\n");
+		dev_dbg(ucsi->dev, "Early connector change event\n");
 		return;
 	}
 
@@ -1352,6 +1352,7 @@ static int ucsi_init(struct ucsi *ucsi)
 {
 	struct ucsi_connector *con, *connector;
 	u64 command, ntfy;
+	u32 cci;
 	int ret;
 	int i;
 
@@ -1404,6 +1405,13 @@ static int ucsi_init(struct ucsi *ucsi)
 
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


