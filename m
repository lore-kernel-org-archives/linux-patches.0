Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9FB1DFF4;
	Mon,  1 Apr 2024 16:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990593; cv=none; b=poUIVwB0mvmSnTyRmcHzRpjco9+aBZEWknzwCySSL2jHWwcqTAH6XGLJBgItygLU6HeGnyeFdNK+ID9hJ9zeeGL58i2nqe8g1i2HPSdGclrendo/stb+j4+o/BDmXLbocQ/pY6YY6vsGZwY3hgwmO8ZyW7lvWLwVmKzkdphX1SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990593; c=relaxed/simple;
	bh=FfJBaHTIDSbK+9RGCQ7DzBqZuHCnBmFFlyNTaoDRlcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hnw6Ye/VQKMFDmPZVZdyj25K+G/3z0unGMMINtxqsDKrIjpLXMgENe3iYYkd9SLkGH0YORyPAoSxF8nJODWw/ORPlvoz/UxuPoUDmeV9U1Mn5yP6fPPOvVEVISC0XgYXYyx4ONradP46f9bRUFs8JkfloYf3DhoUx6p0knXyG0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffFsFb5t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffFsFb5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4E6C433F1;
	Mon,  1 Apr 2024 16:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990592;
	bh=FfJBaHTIDSbK+9RGCQ7DzBqZuHCnBmFFlyNTaoDRlcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffFsFb5t+RVp1DRBhYq+B/yBlwuoUYfokOpo+GmUvk+RfTyuMOR32ZUdTqpHgQ0N4
	 f7qIUx32gD7HUCLWqE81qLHscVVPXsAh2Tz5SE6WyGSkB1Y9O+xkF1DFr7tBM8Wcln
	 ap0CSSuFJhj5ka5HkrYV4YCBFmQrpp4foAgJP/to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.6 373/396] usb: typec: ucsi: Clear EVENT_PENDING under PPM lock
Date: Mon,  1 Apr 2024 17:47:02 +0200
Message-ID: <20240401152559.033504858@linuxfoundation.org>
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
 


