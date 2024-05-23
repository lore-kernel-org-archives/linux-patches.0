Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACBC1E504;
	Thu, 23 May 2024 13:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470180; cv=none; b=Nlv7IM+Z4GzuCnHjI0KgU0ZG5UCKNVEV27pMYDBivPPwPiYd5sOrgsXrCuAqamjpYlCwF6VhTX1VtX3yZw11XKG+NSmB+AK+fSHpsgOVEfHGJFwjfhlilPRcDdVd+Ru0E4Q1s68AqWMY1SdNYNwQeyYrNKrm5hVMED3+bx+r/gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470180; c=relaxed/simple;
	bh=Y0XPkQK3dhz+RIIYXEkMrtWFlJfgQzQsBQN6eQvKpRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTvfFVYJy3O4YDCGRwXDPPHFlonpA9R0WMm7HXneM7dJ9pZ7DmlfjH76i5s/7XjllpfMmsdY8MXX3G33REDAdqLrnAsckYkRh15htuA5xrHa/oCULBjbcz9LvtpCwUPwm5z7C/QximmvpxLlw1t9NuMkKotiGS/fdYQ+qeQctKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCwbkrjj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCwbkrjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8618EC3277B;
	Thu, 23 May 2024 13:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470179;
	bh=Y0XPkQK3dhz+RIIYXEkMrtWFlJfgQzQsBQN6eQvKpRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCwbkrjji5OXy14FSYw7zUvvSqHDfvEiws+iK5dH2RQmDAT5jpgkZ06tP6rAIQ48J
	 oIvZTRHj9gyiYsEcW+pptbNPjeWFg4T+g7hQVShpYD1mXDjx2VdiDyxwOgkcZolwxg
	 mZ1sLUU++3JwjZ7zUtQb7T4JiYDZsQQoO3Bfn8fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.10 13/15] usb: typec: ucsi: displayport: Fix potential deadlock
Date: Thu, 23 May 2024 15:12:55 +0200
Message-ID: <20240523130326.958599196@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130326.451548488@linuxfoundation.org>
References: <20240523130326.451548488@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit b791a67f68121d69108640d4a3e591d210ffe850 upstream.

The function ucsi_displayport_work() does not access the
connector, so it also must not acquire the connector lock.

This fixes a potential deadlock scenario:

ucsi_displayport_work() -> lock(&con->lock)
typec_altmode_vdm()
dp_altmode_vdm()
dp_altmode_work()
typec_altmode_enter()
ucsi_displayport_enter() -> lock(&con->lock)

Reported-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240507134316.161999-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/displayport.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -249,8 +249,6 @@ static void ucsi_displayport_work(struct
 	struct ucsi_dp *dp = container_of(work, struct ucsi_dp, work);
 	int ret;
 
-	mutex_lock(&dp->con->lock);
-
 	ret = typec_altmode_vdm(dp->alt, dp->header,
 				dp->vdo_data, dp->vdo_size);
 	if (ret)
@@ -259,8 +257,6 @@ static void ucsi_displayport_work(struct
 	dp->vdo_data = NULL;
 	dp->vdo_size = 0;
 	dp->header = 0;
-
-	mutex_unlock(&dp->con->lock);
 }
 
 void ucsi_displayport_remove_partner(struct typec_altmode *alt)


