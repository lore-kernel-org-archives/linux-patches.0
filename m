Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128D47F49C;
	Mon,  8 Apr 2024 14:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585087; cv=none; b=lUnYJFBQdpEuLuSjDebR0w2hwj/5jAAIWmDiDnywkKhqbcfQiYVVez6VaXt7hxc9usSM4k9zMOBxyeN4/VcK25ODJ1UgThwfqjPe2aX/2YNH+jej8Rg7WXUVlCIAj2Pb+ltCFX6KdXipzTC/GbSSOnAKsotqhKtNkhR/bokBGXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585087; c=relaxed/simple;
	bh=vDIzNt0BslmmFiQPTzlOHufrQJJk/MiqAZY35oQMS6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWvN2gfAkTyYerymmLq6ul1dIEj0bSySdGd01m6+CqntOboMlLAUqVhFiRlS20nSXlG67K+dEz1J6thYKeJ/3UnwKl80UwWwp4lEWAwmxGgiMEyz89qi+e17araLWf/r1WvE5/6z9JKEZwI6JriXjenspGIna+SH5nwCYBUM7oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTfPZCKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTfPZCKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3F2C433F1;
	Mon,  8 Apr 2024 14:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585086;
	bh=vDIzNt0BslmmFiQPTzlOHufrQJJk/MiqAZY35oQMS6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PTfPZCKiYkCPqDlVrYp8Y3dJWLFkkzoTADV7BLUyrLWpPZiQd81LgvyrjDpN81QJQ
	 mLKCzsXlhfFzlltqFMjNkclz8vpP3Gbg/cUDZSLD8sq5JKr23Xnq72kFwa0ruEUk4p
	 q8FoiiMe+24WoqqnqTc1cqitKRjpBWUGa7SxX3nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.15 659/690] usb: typec: ucsi: Check for notifications after init
Date: Mon,  8 Apr 2024 14:58:45 +0200
Message-ID: <20240408125423.548139042@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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
index 985e512c0e659..df7c42df9ea0d 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -854,7 +854,7 @@ void ucsi_connector_change(struct ucsi *ucsi, u8 num)
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
-- 
2.43.0



