Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6871C1272D5;
	Tue, 14 May 2024 10:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683721; cv=none; b=QqfJ8UEMxQExKY13PiPJuTrBbgU1VivCddmhA7B0kt6XmGJAor3ZhlYpmPi2Hm0wakUEmtFYgli9fHrr9GlOQns9kNpSSsbhwVmeZjWwvLYsLdcPv/f8ihVXW1fDzxB7uc405pnqYOn92V3HN2RQWsJaUSaDguqvkPUzuPZTHYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683721; c=relaxed/simple;
	bh=M6xhoUZtV6UzLCc1Wphfq1hXJdR4IU8oYdRctyaDRuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABUFMhZwjRQyiKGKMQDNyemHyRr1gd/Ikr86zzGr/+fJD9KDfrRCCjXi9/NhQIKhjtYQFI5vefdydgaiv4NyJ2WeQRxH87xcEFNZwTsFEWxbf1Hq81Lr/AcBm/+sNR84tqne//QDFksJNe/PSrhUx4w1srQ9iSXX/vdARvuL0rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjxhJQon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjxhJQon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C132C2BD10;
	Tue, 14 May 2024 10:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683721;
	bh=M6xhoUZtV6UzLCc1Wphfq1hXJdR4IU8oYdRctyaDRuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjxhJQon58udnLzDHPWug9Q8Vs0lVhGTYSIvnQ5va66/RRX9sp4xMxknj+oHAm7Fu
	 pJL5tesVaxisSwJRPJeVNJlm7jWukCGZKP6lNHvPIBYPimbYMwTsSw8M1oyqqxifOm
	 YZBogrZwUc4edqNFvRyMlgGr7rXWreXvcMUY8gcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.8 245/336] usb: typec: ucsi: Check for notifications after init
Date: Tue, 14 May 2024 12:17:29 +0200
Message-ID: <20240514101047.869209043@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -975,7 +975,7 @@ void ucsi_connector_change(struct ucsi *
 	struct ucsi_connector *con = &ucsi->connector[num - 1];
 
 	if (!(ucsi->ntfy & UCSI_ENABLE_NTFY_CONNECTOR_CHANGE)) {
-		dev_dbg(ucsi->dev, "Bogus connector change event\n");
+		dev_dbg(ucsi->dev, "Early connector change event\n");
 		return;
 	}
 
@@ -1406,6 +1406,7 @@ static int ucsi_init(struct ucsi *ucsi)
 {
 	struct ucsi_connector *con, *connector;
 	u64 command, ntfy;
+	u32 cci;
 	int ret;
 	int i;
 
@@ -1458,6 +1459,13 @@ static int ucsi_init(struct ucsi *ucsi)
 
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


