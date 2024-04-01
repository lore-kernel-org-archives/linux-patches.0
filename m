Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553B61C0DE7;
	Mon,  1 Apr 2024 16:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989187; cv=none; b=crohKElNmAjfwvFC+SUPfXofNKKRbOhXcMjvcx6VCYOuJJzxuQZhXeLUSRD+tckYfSCTj/yngWSjTz8RDUuUa740ENbWTkbP228mVvqoudAK2yxdXi58h9dMHw9qzny1wgRCmH2zGMsfhUhyIHsBY1xYamqRW+Xl251VRxI+HYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989187; c=relaxed/simple;
	bh=OshI82HHhj3GaZYSUK1v6nfix6Qryt3GeWZnj5NwXI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWueUX6nFgHWECfxohy2yTuFEcgrunw9J/BS8NsbrTNvEs1eSBkcRbVIgPPM5FLSvd1x6WH1JvsABQD5XsO0LRTEZteQcAeqGE6qAj7unkY5xhrSKoboDEBEDoOvGHcc4ja7YCGiE5zRHe9rMTwdJsuwE8krwpwTDjBXChyMWZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvHGmc8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvHGmc8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1713C433F1;
	Mon,  1 Apr 2024 16:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989187;
	bh=OshI82HHhj3GaZYSUK1v6nfix6Qryt3GeWZnj5NwXI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvHGmc8B175L0QEmPDq572U0BwrN3QpK9g8Ww76V/XZVEWQtV5huuV2V5Mw2bFet3
	 YQc90YEUvE2g4V++kRbByCJ5U+bHDuZ3awb3SRnuwoRINAu1pXWySTJeIHHDdtdzyE
	 2+DcMFX4aklwE2XVbNa5VaHpSQ5x1i5hrq+CzQRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.7 407/432] usb: typec: ucsi: Clear EVENT_PENDING under PPM lock
Date: Mon,  1 Apr 2024 17:46:34 +0200
Message-ID: <20240401152605.525375578@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <lk@c--e.de>

commit 15b2e71b4653b3e13df34695a29ebeee237c5af2 upstream.

Suppose we sleep on the PPM lock after clearing the EVENT_PENDING
bit because the thread for another connector is executing a command.
In this case the command completion of the other command will still
report the connector change for our connector.

Clear the EVENT_PENDING bit under the PPM lock to avoid another
useless call to ucsi_handle_connector_change() in this case.

Fixes: c9aed03a0a68 ("usb: ucsi: Add missing ppm_lock")
Cc: stable <stable@kernel.org>
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Link: https://lore.kernel.org/r/20240320073927.1641788-2-lk@c--e.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -933,11 +933,11 @@ static void ucsi_handle_connector_change
 	if (con->status.change & UCSI_CONSTAT_CAM_CHANGE)
 		ucsi_partner_task(con, ucsi_check_altmodes, 1, 0);
 
-	clear_bit(EVENT_PENDING, &con->ucsi->flags);
-
 	mutex_lock(&ucsi->ppm_lock);
+	clear_bit(EVENT_PENDING, &con->ucsi->flags);
 	ret = ucsi_acknowledge_connector_change(ucsi);
 	mutex_unlock(&ucsi->ppm_lock);
+
 	if (ret)
 		dev_err(ucsi->dev, "%s: ACK failed (%d)", __func__, ret);
 


