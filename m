Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5497D1494DB;
	Thu,  5 Sep 2024 10:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530609; cv=none; b=HUuox9zcrAA6uFoLcXNc4ITbGAhny77zE3S6kDD6ZPYSSxxTYGbwPrTAnE0kqrwFBlE5Y6Bc4nMaP//7DtDd3lMrv099Z++wFh8C3SkfRfSKk7NdngWO9oZzuTnLRjR2or95FygM2BXeQdg5Ywi4FBhKAAhlYnv6rmn+5tyeX+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530609; c=relaxed/simple;
	bh=8mmoNu5YhzJIsgSLPiH9lzo29CDQTvyqEsgxKclVu78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fx+te6pLAQee82RVNd0gJ4/bU4fGM3W9kgg86u46PWQZJXwW5n1s5MfbLyyuGSMIeCk4EmPOS/4lydQBXYRMk/qMyrEVwofUnUKabXmGTXVp2t67D6NEqA/r3oWxwdwavs+i2uS0iY/1boWywE8FQuWBOcDLLffntzmnyZwrZO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hSYHjYvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hSYHjYvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33ACC4CEC3;
	Thu,  5 Sep 2024 10:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530609;
	bh=8mmoNu5YhzJIsgSLPiH9lzo29CDQTvyqEsgxKclVu78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSYHjYvyup6UripPpci3ZqVDUqjRU5zMHHKl38nI9O76xvrAbBhXU5tWgIro+wkGk
	 X2lshjel4z96QXtfNNaA0aHRu1QMaAk7jZjdIYR7fv2RAyXSFddCjTMfZD4Y5gVseX
	 gbc24FW9lCCgZHmQe/TKW1PIeBi05pFSipK1xRFw=
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
Subject: [PATCH 6.1 077/101] usb: typec: ucsi: Fix null pointer dereference in trace
Date: Thu,  5 Sep 2024 11:41:49 +0200
Message-ID: <20240905093719.142314743@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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
index dbb10cb310d4..4a1a86e37fd5 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -373,7 +373,7 @@ ucsi_register_displayport(struct ucsi_connector *con,
 			  bool override, int offset,
 			  struct typec_altmode_desc *desc)
 {
-	return NULL;
+	return typec_port_register_altmode(con->port, desc);
 }
 
 static inline void
-- 
2.43.0



