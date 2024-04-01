Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AEC47A64;
	Mon,  1 Apr 2024 17:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991389; cv=none; b=QHZ51Ag80vEq7eYQs0YPEfBLPWscTeQsotrXn0QyiwwXhvWfTZ/d6+8J+vHaw+2A2ptMraREd2O5pyq27+fBrzV0wJJY6LFKgxbUpTZRlvDx7JIydbdEUpwqWW6+wmgzuXlirE4cE7Mes0Up02jiNgNaStGoSqrb8b9iKAiT2n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991389; c=relaxed/simple;
	bh=1gBeHkQi8aDLTIqWe1/h9O8NbhKTRqthnIIWjN4lMl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eb2bpMiszTw2fL8GwCXEz7mBa+6hekEwg7Ia5t4PB/0CeERdNb5SfNwN2aSJRUIm8wAE3Gk8PduVGy10pp8mcYnzAoyfezcUGaDg063C8lrW3KnJT/5A8xxpyPHzbxynDUNxe7u/AJmlt7yKRbKW+yRQVMQ/zbnqG/wqNJnoBk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyNZ6701; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyNZ6701"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F357C433C7;
	Mon,  1 Apr 2024 17:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991389;
	bh=1gBeHkQi8aDLTIqWe1/h9O8NbhKTRqthnIIWjN4lMl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OyNZ6701lm5CdYHrhao2b8ROxHSJegtcmDcDl7eQllk8wYnAuaF5QE/bIzucJ1p9d
	 l5XL/RuGLPltIycnIItyJabrbEahwpcQV/pFMPmBBNEB5DZoL0hr8QucG9dH7CIlJL
	 6cQgbk+5YORFMG83lJugkShmG3e2qJZWIhXxTzAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.1 250/272] usb: typec: ucsi: Clear EVENT_PENDING under PPM lock
Date: Mon,  1 Apr 2024 17:47:20 +0200
Message-ID: <20240401152538.826205758@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
@@ -829,11 +829,11 @@ static void ucsi_handle_connector_change
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
 


