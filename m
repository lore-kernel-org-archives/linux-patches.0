Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D51446AC;
	Mon,  1 Apr 2024 16:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987719; cv=none; b=nMNKWPDoOLxM0hOpKpMr/alou2e1ZzYVdjn1f5jjmYf85DELtTZY55JnajLRqhg3X5YfvSqDvvUb6BIP2zvBtvw6+3XMs+0bjhWfkv1Uki1xKXmexNpP8S+QjiNvu/7cv8Bi8rlerplSVYkFSsl0cC7g0E4trUWlVNOGbAl7oDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987719; c=relaxed/simple;
	bh=V7Imk9XRDSZR+JLOQzTX54HDxgV0IIAQC6byTw6RGqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1PVPQEpIK1B0iIPSJAyTubNopmMY1p9zzoDNHl8igGUEXduNiFWC1yEIfOM7Y911/iYNEiKndaQ4hNUbPgcn3xmhyKVMssnUE3icTIVZwAWaGjdaQAdyHf5kPTtF568PnnpiyDS73c8rAzsBD/sRb71gOXDi/WQHFbony5aBkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oksttrHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oksttrHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08771C433C7;
	Mon,  1 Apr 2024 16:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987719;
	bh=V7Imk9XRDSZR+JLOQzTX54HDxgV0IIAQC6byTw6RGqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oksttrHwkZ6y0t0yLOqbcAXi1Dm5Q9aU1z56G/wR5KZjNqdlPdPwjQDSL/6FRG93Q
	 zaIm6lOurL2FMvQ+gXXKaEuYoRfDdN8/WhIiJkcjQQZ17jsSVDWrthRNlzHVGl+Uwm
	 Btg/H/6duZMfc4FXik+YCJwbjF3aszHP5MCezjCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.8 372/399] usb: typec: ucsi: Clear EVENT_PENDING under PPM lock
Date: Mon,  1 Apr 2024 17:45:38 +0200
Message-ID: <20240401152600.279912475@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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
@@ -936,11 +936,11 @@ static void ucsi_handle_connector_change
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
 


