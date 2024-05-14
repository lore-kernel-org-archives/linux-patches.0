Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F6150278;
	Tue, 14 May 2024 11:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687491; cv=none; b=NQrUdYxvMQfVar283kJPSya09OIP5j49zhapZWbYiPusNdUk35cyXR3zXV+uO2LIcGNWFP7wOVelbt416bfpEI5pxQWfKZ/JEpoVQ9U44+eqR7nNvYxC5eel8J3DDpPlbx/6wQcuEl+hLlEGFvW3PS+pcj7Ys1H1kcdtUoVkJk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687491; c=relaxed/simple;
	bh=fKMLcaIwT6tuN4w7kBKhjRaBECGxRyRXh9VnJjLMocw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sC6WBXC56+zwy19hdRlh+eDMSnirYAOyDV0rBIgklRG0Dxtp4gujfypTTBfLGM2r0nutW+GD5waLiUHoCTvu/kbAeM0e2dNHHLO4N6vqLil42HaWkXSpyLIQ/EC6rEkuIBB3QM0+rOq6JmBG5yJX6JCnl9IBHbgOhJuAhZB0JDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHO9uF0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHO9uF0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D947C2BD10;
	Tue, 14 May 2024 11:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687491;
	bh=fKMLcaIwT6tuN4w7kBKhjRaBECGxRyRXh9VnJjLMocw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHO9uF0iwhX/hWExPAWSobTIuQxLUJkEywHMHVBNVsX+XuUj17I7fc2/Xe6QofNrV
	 ln4HUI++xAInZh1GoNEosstqHY1sCJG2gunor+mS3ZRTTVtDQ+u10MNxbTCFBHbW1y
	 b5iiDttFM/ood3JjFAV3L+SD0VaQUcW2zyZp7IlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.10 093/111] usb: typec: ucsi: Fix connector check on init
Date: Tue, 14 May 2024 12:20:31 +0200
Message-ID: <20240514101000.665583025@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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
@@ -1244,11 +1244,13 @@ static int ucsi_init(struct ucsi *ucsi)
 
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
 


