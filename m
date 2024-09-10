Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D693188CDC;
	Tue, 10 Sep 2024 10:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963406; cv=none; b=OwC5HcvHWZewcH+sbLK/wL1eV3wxDl79MJLnExiwvTkfZP+l8X9KP6iiVLeZnrbZxgoMK0ThUwzvY7tbU3H8FbO/E41QksJaWqUqcSgMwty4Snaac81cktxaK9C0EomstJ5GMWXFcSO+aGqImaVJx1Lysx02dDbpg2pN9dAoSoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963406; c=relaxed/simple;
	bh=XKTV9BjffJ16/OjXoGhyDkbzDBv3dZitPIxRVHybSwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJqF7ARw4T0e0q3Xr2Py4p97zOgiJlXhNeWxtKCIfG0nut5Y3ITbyhJcKtWD0/I9rkbcmGOqd09gR1kj5Htdo1X5q6TQTX1wu3JDm94kungZUvufJVRuKCjijjpIfDPvctguwTp4XsIP2O+UAzw0Qtb1pgswtmRO9TP9AkH5wlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XrPhGYpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XrPhGYpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05239C4CEC3;
	Tue, 10 Sep 2024 10:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963406;
	bh=XKTV9BjffJ16/OjXoGhyDkbzDBv3dZitPIxRVHybSwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrPhGYpBCYFc4QPWQ+HH28g19EllCzBUJrcjCL7OyiMWKk9B6bRCqCfO7shtwtf+U
	 51ILsuWDgEAEFu8gC8Qu4qtImqpDkC+OQVjJNmCmLo1IlxBVqkQxY0aeNCUGOniMru
	 Uu9V2X4i/vahy5DJ4M124UtTV6pVnWGmR3B3PXJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	Jameson Thies <jthies@google.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/214] usb: typec: ucsi: Fix null pointer dereference in trace
Date: Tue, 10 Sep 2024 11:31:08 +0200
Message-ID: <20240910092600.654982631@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

[ Upstream commit 99516f76db48e1a9d54cdfed63c1babcee4e71a5 ]

ucsi_register_altmode checks IS_ERR for the alt pointer and treats
NULL as valid. When CONFIG_TYPEC_DP_ALTMODE is not enabled,
ucsi_register_displayport returns NULL which causes a NULL pointer
dereference in trace. Rather than return NULL, call
typec_port_register_altmode to register DisplayPort alternate mode
as a non-controllable mode when CONFIG_TYPEC_DP_ALTMODE is not enabled.

Reviewed-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Jameson Thies <jthies@google.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240510201244.2968152-2-jthies@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.h b/drivers/usb/typec/ucsi/ucsi.h
index 3dc3da8dbbdf..656a53ccd891 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -368,7 +368,7 @@ ucsi_register_displayport(struct ucsi_connector *con,
 			  bool override, int offset,
 			  struct typec_altmode_desc *desc)
 {
-	return NULL;
+	return typec_port_register_altmode(con->port, desc);
 }
 
 static inline void
-- 
2.43.0



