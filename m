Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D86483BF0;
	Thu, 20 Aug 2026 17:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248320; cv=none; b=X+bAiBw/4TgcVQUFlpS/nFaIOB6vBZKkJ9QBAxwEDvbILwOnKQQa/aWSizWBOl8cHg76Z7zqD6up4CedAzAC5/KlP12DE4yl9Ak+XNjGy/MIDU+sbjvhysybpOhgcL7L8SawZGadkNFFnS7iRxgLDISjl9kYuzgFYxvXBUGLBKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248320; c=relaxed/simple;
	bh=os+YThasDPov4qQUzJGIM57nO6Dpsdrm+JLIwueENz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kF3Dy6jg+IvvurSNHB4aU80AqPVN5oDRVoLbkmOp/TimFk4Hc36NNe5AasxBgEnNwVekTmZnMFxGP9je0kXA9pZOYY+zMYv2k8jaVcZ8qqm6K/88Sm6xRwDx69q7sajsxKZ9IM84bbH/spebvjhqpTX96CODfXD6L9Y2XORaLnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2UKLOB3x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2UKLOB3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706791F000E9;
	Thu, 20 Aug 2026 17:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248318;
	bh=DjIsPVUgfTQjmOCTxbChD4pllUQyPJAXA9X5Hwek8Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2UKLOB3xRB0p5h8h8frEEmQfw2shnHpiTOWJqEDX6J97Qd/+ZaRP3X/ts8N6C5dDO
	 Gqtvdgu0HtmOjk5dO49LoLbS5i+R4l0JOwoxqUAaop8zpWjK8RBUiY67b517CGBRZO
	 dqs3dczpVu3thA+a9jKgWvtu1/kIKumtygovOB6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 184/303] usb: typec: ucsi: Only enable supported notifications
Date: Thu, 20 Aug 2026 16:55:20 +0200
Message-ID: <20260820145258.846446160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>

[ Upstream commit 27ffe4ff0b33b3dcc97fd448fd1e38d31ade575b ]

The UCSI specification defines some notifications to be optional for the
PPM to support. From these only enable the ones the PPM informs us are
actually supported.

Signed-off-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/yhz7nq622mbg3rqsyvqz632pc756niagpfbnzayfswhzo7esho@vrdtx5c3hjgx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 7aa7d4bf9d3f ("usb: typec: ucsi: Fix race condition and ordering in port unregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1254,6 +1254,27 @@ out_unlock:
 	return ret;
 }
 
+static u64 ucsi_get_supported_notifications(struct ucsi *ucsi)
+{
+	u8 features = ucsi->cap.features;
+	u64 ntfy = UCSI_ENABLE_NTFY_ALL;
+
+	if (!(features & UCSI_CAP_ALT_MODE_DETAILS))
+		ntfy &= ~UCSI_ENABLE_NTFY_CAM_CHANGE;
+
+	if (!(features & UCSI_CAP_PDO_DETAILS))
+		ntfy &= ~(UCSI_ENABLE_NTFY_PWR_LEVEL_CHANGE |
+			  UCSI_ENABLE_NTFY_CAP_CHANGE);
+
+	if (!(features & UCSI_CAP_EXT_SUPPLY_NOTIFICATIONS))
+		ntfy &= ~UCSI_ENABLE_NTFY_EXT_PWR_SRC_CHANGE;
+
+	if (!(features & UCSI_CAP_PD_RESET))
+		ntfy &= ~UCSI_ENABLE_NTFY_PD_RESET_COMPLETE;
+
+	return ntfy;
+}
+
 /**
  * ucsi_init - Initialize UCSI interface
  * @ucsi: UCSI to be initialized
@@ -1314,8 +1335,8 @@ static int ucsi_init(struct ucsi *ucsi)
 			goto err_unregister;
 	}
 
-	/* Enable all notifications */
-	ntfy = UCSI_ENABLE_NTFY_ALL;
+	/* Enable all supported notifications */
+	ntfy = ucsi_get_supported_notifications(ucsi);
 	command = UCSI_SET_NOTIFICATION_ENABLE | ntfy;
 	ret = ucsi_send_command(ucsi, command, NULL, 0);
 	if (ret < 0)


