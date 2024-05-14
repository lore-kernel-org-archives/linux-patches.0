Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBE31CAA4;
	Tue, 14 May 2024 11:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687896; cv=none; b=RPLgxEeO4EMW45E444S+ywgg9oyiTexd0Hz0Nw6+rU2n/be5dW6Td2Xzu324tAYSlvDQVAfKqCv8aAulUbXwM2candsqdza2hZDmUx78DQpDs/nh3k7xTjAcLDG2FB3n44YizniLKKWDxgC/0HB1bFeMZKNa2hgKSm+YOkma1ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687896; c=relaxed/simple;
	bh=adlvr5bhZWFycIcIRIAGOqi3rMRa4+GCKfGwBlYTnAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qn44XtCKBxaTF4poo5hgqgfpaoVp4oRFJ6fybQOZzSTzwYsCbSbUdyHANYN1ILkJq2Kviw/L1b60vWkDR+QmgcjkkEz7BCiIwLNxoqzhyhMFAUfVqUCTm28bUgZg8wusn9BSIP1UW6qXO8tcLK6xQMQzztmlzWdxps+h4aTcrvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXSTKWKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXSTKWKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFF4C2BD10;
	Tue, 14 May 2024 11:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687896;
	bh=adlvr5bhZWFycIcIRIAGOqi3rMRa4+GCKfGwBlYTnAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXSTKWKFsEmpXDU1M/zaqSigd2saAxepy1xeN2bMBCdQy8TUh7bYyHFVFOYxKuKyQ
	 9+EFxAr/y2HKAPw4FLzVojA3BWizsvSrfTs5x17X6BHyBABMBwGmYn3RK4E6JJpqWY
	 3ta2sMtlUEjRL1jonvC7aW3xyrt5bx0OJAt+QP8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.15 141/168] usb: typec: ucsi: Check for notifications after init
Date: Tue, 14 May 2024 12:20:39 +0200
Message-ID: <20240514101012.010057306@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -854,7 +854,7 @@ void ucsi_connector_change(struct ucsi *
 	struct ucsi_connector *con = &ucsi->connector[num - 1];
 
 	if (!(ucsi->ntfy & UCSI_ENABLE_NTFY_CONNECTOR_CHANGE)) {
-		dev_dbg(ucsi->dev, "Bogus connector change event\n");
+		dev_dbg(ucsi->dev, "Early connector change event\n");
 		return;
 	}
 
@@ -1241,6 +1241,7 @@ static int ucsi_init(struct ucsi *ucsi)
 {
 	struct ucsi_connector *con;
 	u64 command, ntfy;
+	u32 cci;
 	int ret;
 	int i;
 
@@ -1292,6 +1293,13 @@ static int ucsi_init(struct ucsi *ucsi)
 		goto err_unregister;
 
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


