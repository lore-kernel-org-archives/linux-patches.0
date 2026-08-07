Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E1C4746CF;
	Fri,  7 Aug 2026 15:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116401; cv=none; b=pAVrt+QACOKKyT7XFA674eacZxF8xAF/NH9khNdZF5PM8uBi/xNv+NAZ107UUvx8/FDWPop8fmaIa6C6Zg8lIBKiuItSkyKFFPtIoQ2URJTJcY6isG+nZeB7GqV5jYb2EFcLyUSECKk2WUgU7StybzBgTS8KMWr1uFH1i9eNBg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116401; c=relaxed/simple;
	bh=+x4UVZASnvBZ1ypCVhSO6zta+uTogECy324FCRw3jW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7KNYHjjcsg2kR25eHDWrIKH+3c4UN5RsBO54CTE+xwtKwNMZJG/daMijzLpcFiFVUo1OAVeUxfpLN7c3+D5SwP4S2D+gah8wkRoDhGtUifr6P/4qJop18qzFsWlSe3dNLeZKmavjdX/mXSFeiFRqCN7WGa+iLDkwnfhX09OXEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwx9bwwF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwx9bwwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E491F000E9;
	Fri,  7 Aug 2026 15:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116399;
	bh=TDiFFtapCbwg5sDV8QOir8cNAgoa7k2EemUCFAyBJbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jwx9bwwFvbFPd1wqEBec3qZPfJONinZPtiYfWAwTZsZITXvCvlnwAvkF7aAeDaRpO
	 nt2Au68fd1U9kVCZnYSb9YafXbP/yhfU7hcj/bcGTo/2SFLPX8lcMmS4/aPynNsWOm
	 gDIcZ7jiXWJ0PA3MgJIMKEcu1yTOr4e6ALjC7HTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 219/261] usb: typec: ucsi: Only enable supported notifications
Date: Fri,  7 Aug 2026 16:39:36 +0200
Message-ID: <20260807143420.094334336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
@@ -1406,6 +1406,27 @@ out_unlock:
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
@@ -1466,8 +1487,8 @@ static int ucsi_init(struct ucsi *ucsi)
 			goto err_unregister;
 	}
 
-	/* Enable all notifications */
-	ntfy = UCSI_ENABLE_NTFY_ALL;
+	/* Enable all supported notifications */
+	ntfy = ucsi_get_supported_notifications(ucsi);
 	command = UCSI_SET_NOTIFICATION_ENABLE | ntfy;
 	ret = ucsi_send_command(ucsi, command, NULL, 0);
 	if (ret < 0)


