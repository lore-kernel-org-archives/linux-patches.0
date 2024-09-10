Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED56718C357;
	Tue, 10 Sep 2024 09:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962384; cv=none; b=Z79hLrQRwHUI0UDqtMQ1g0qbZf4A9D3ra7f9zV/N6FiXYpfqZDWC0zIFJKROzI7lT1TxDfPm66dOrgmsVgTzsIUQYcmM6AnCO2TaNOsSlIVkaZTudafKT4aTVXY7rQV8xer86Ej7oJtUSWEcNSfQGLwJfHCo8dXrG0rDnKEZ2OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962384; c=relaxed/simple;
	bh=bY/SZJF98LEvb8Pk5FzZ7KIdHkT5R9+9qbHqm3y9EUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7OijapZQqXoJUtGbduddi8hxaf0pjbiVbZCDNmgxxnw5s7e6CSlDE0PjJMO0M147FrtZyL7zJcoZ2EVVm9nfsfYadWPmGupXjMo6y1f2w5m1TfOyTzk942S5CMvILArEoFqINbSaStcH/R36Rhn9QsVtSH8NzkDIXU+qmTDe1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uP8ok23k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uP8ok23k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757C6C4CECE;
	Tue, 10 Sep 2024 09:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962383;
	bh=bY/SZJF98LEvb8Pk5FzZ7KIdHkT5R9+9qbHqm3y9EUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uP8ok23kRmRnH5KCucCbkQgjXioyOtIq4YG7XyRTultLL4KKLLnhR06Ntbg9P9VBY
	 wjeVHcJSMdChj6BgnLsBCmrXa0r922MUx4fQB8qkOHacrjnPL930pQgPp5A+7NndBm
	 e5yyKMjWkbc5G3+RD9ql40t3lFqiCiFghGab7E4U=
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
Subject: [PATCH 5.4 016/121] usb: typec: ucsi: Fix null pointer dereference in trace
Date: Tue, 10 Sep 2024 11:31:31 +0200
Message-ID: <20240910092546.509853027@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index de87d0b8319d..179ad343f42f 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -446,7 +446,7 @@ ucsi_register_displayport(struct ucsi_connector *con,
 			  bool override, int offset,
 			  struct typec_altmode_desc *desc)
 {
-	return NULL;
+	return typec_port_register_altmode(con->port, desc);
 }
 
 static inline void
-- 
2.43.0



