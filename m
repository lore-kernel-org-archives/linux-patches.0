Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7442C2943F;
	Tue, 14 May 2024 11:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685689; cv=none; b=tOqVx1klFnmdXidSdyTv/ranD1/HF8iZ9aZWXImjzOpNUho3Z4zUFnimdc3xnYCCtsHu480aMA/nrNHhQK0sdN+kP/dvWVFUGEHC6D67JoHG1pY3ij81ICBXdhAXH5c7+fwcv6AFV5BApF8GVEtdBVRyGX+K/WGOnV4wEMA/juk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685689; c=relaxed/simple;
	bh=2Qpxmvfd35a+vP7tf/+XKudoct26dRu+dO7mfm+XRrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUZe4QCvdVAjNOUQALQyW9nUFfr4N1TI7bqx6GRKsHN83LIIjTso/Gk0LuD3gdxkRTan4RKfE3fH01RjJA2sf80gNenEo0Tpq6+ydWe78tiKhpIdiP2Eo++VMdbkg5fXZpfPt1Ov9rE1bh5Xg0wnK1ogT7CPeXdYSZdWp/ZLTXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=182cTxt8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="182cTxt8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5110FC2BD10;
	Tue, 14 May 2024 11:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685689;
	bh=2Qpxmvfd35a+vP7tf/+XKudoct26dRu+dO7mfm+XRrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=182cTxt8k4bcRrnMrlY4rV3Hi0YVFGi9q9Itpio7l7ZvEeqweHQATHifGyiHiiH20
	 36jJabzFv+vXxnvj0T543r6hkpDH+n3jVd0DdC1llRr5X0fvDkNd7hm/mMTxDlbw5+
	 7ZTkxLd+0R+W/sFT9Y8PT9wuc3Z0HbaMLtugeJ0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 226/301] usb: typec: ucsi: Fix connector check on init
Date: Tue, 14 May 2024 12:18:17 +0200
Message-ID: <20240514101040.790434781@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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
@@ -1457,11 +1457,13 @@ static int ucsi_init(struct ucsi *ucsi)
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
 


