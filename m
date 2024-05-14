Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41B96BFAC;
	Tue, 14 May 2024 10:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683781; cv=none; b=Ugxgm+0e2iu6/kiIuxCo1FxyZWWVwFL09HuDH2WH6vlX4Eoerfzct/X4bm21qBgWZFi/rl4yym8rx6o4Jf/DkQGcAnblfha2BkrrTkG1SrR2g0iU8C7DAlDu5fkmEPCTzg7Zyz4wqctZkcoiVMQeRhBeVAiZPbsZiP0pzeB3q5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683781; c=relaxed/simple;
	bh=ybEviFUEj+4sT90hYvmb7ifQ2VcD/wLpn78VE/2qTKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDFV4gJiioI7Uz+3cArKGCSpBO0M8hgYDrQhthbgUFr4aJEDl6+i4QUGt7OuDpNTS0hlgyCaeqeWxNLHuCR1f5oPfg56CDvwcE86FAuf1K+g8XG85+bLYYHX/s8MGjRHNcYS7nDfmzNeDfBNS0s8ymMYk7LqIg5EXWVofp6lL8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmT/Eurg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmT/Eurg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDACC2BD10;
	Tue, 14 May 2024 10:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683780;
	bh=ybEviFUEj+4sT90hYvmb7ifQ2VcD/wLpn78VE/2qTKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmT/EurgvPsIeb/X3OL+0IzudIjsuwwX6OHO+dINBY9nddGnm5aV7NyS2peXyDIrG
	 EbHoQkkZyWYAY1MByZ7jihOMGy1QyPYY5POy5na7yQY3PJ4VAM69EDQBL2MlYVGH3O
	 fPSk+UjByLyRHV3RdN5I5a2YhBVvJXVBccJV1Vmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.8 246/336] usb: typec: ucsi: Fix connector check on init
Date: Tue, 14 May 2024 12:17:30 +0200
Message-ID: <20240514101047.907840995@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

commit ce4c8d21054ae9396cd759fe6e8157b525616dc4 upstream.

Fix issues when initially checking for a connector change:
- Use the correct connector number not the entire CCI.
- Call ->read under the PPM lock.
- Remove a bogus READ_ONCE.

Fixes: 808a8b9e0b87 ("usb: typec: ucsi: Check for notifications after init")
Cc: stable@kernel.org
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240401210515.1902048-1-lk@c--e.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1460,11 +1460,13 @@ static int ucsi_init(struct ucsi *ucsi)
 	ucsi->connector = connector;
 	ucsi->ntfy = ntfy;
 
+	mutex_lock(&ucsi->ppm_lock);
 	ret = ucsi->ops->read(ucsi, UCSI_CCI, &cci, sizeof(cci));
+	mutex_unlock(&ucsi->ppm_lock);
 	if (ret)
 		return ret;
-	if (UCSI_CCI_CONNECTOR(READ_ONCE(cci)))
-		ucsi_connector_change(ucsi, cci);
+	if (UCSI_CCI_CONNECTOR(cci))
+		ucsi_connector_change(ucsi, UCSI_CCI_CONNECTOR(cci));
 
 	return 0;
 


