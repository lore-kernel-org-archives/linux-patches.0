Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38461946C8;
	Fri,  9 Jan 2026 12:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960269; cv=none; b=mIwtbeJ7RoXELEsFqtg9Sd+9u07/2z+0TtrdN5VU+s+I4Mfhn4gB3118lgdex29+x+EDD0mDi9jZ8Rk0VBTfxIkW89X8bqPVvyvJ9csYRz4EAcsrLG0FtFL1iWmfqWe/lBjut3YM2D43M2GnnbD5b6+7wkLGHLkJxpp1zI4x2mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960269; c=relaxed/simple;
	bh=1Mfceq6vZluxTarlS1RuzwSS8sdrbPRpw9CnHQzCFjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hArl63uMNvq34wcsggOECyAdzfA1xMsmH+UgqerxWld/CU+i+Z8VJWdFdzvA1yTsJLRKKgoZEnQ+QVJxRXgvSL4JtBBsZPIEjfojIVYXRV5KkMivZnZF79ICeYyMs9brfmPQIUG/PrimZfpp1XJlmtSLIWmiGQ42lLuvErGxMVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxkR+gL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxkR+gL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CD4C4CEF1;
	Fri,  9 Jan 2026 12:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960268;
	bh=1Mfceq6vZluxTarlS1RuzwSS8sdrbPRpw9CnHQzCFjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxkR+gL9fsIYI4V+T6M6AU2Qr2A0NV01s5VfXsGR02iL260Nd682WTCo6GtVeb6c5
	 yia1YlI4pjxCrrwU7be3+gQTW0cJAAB71CHnAimjw+LCf8yC4pMoDI5yVhAwkvGk4N
	 S9pqHfOX81PSmU/jYe3MvVIa5CcQsMtyXGr0Hm1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 344/737] nfc: pn533: Fix error code in pn533_acr122_poweron_rdr()
Date: Fri,  9 Jan 2026 12:38:03 +0100
Message-ID: <20260109112146.929250014@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 885bebac9909994050bbbeed0829c727e42bd1b7 ]

Set the error code if "transferred != sizeof(cmd)" instead of
returning success.

Fixes: dbafc28955fa ("NFC: pn533: don't send USB data off of the stack")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aTfIJ9tZPmeUF4W1@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index a187f0e0b0f7d..9e079be43583e 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -407,7 +407,7 @@ static int pn533_acr122_poweron_rdr(struct pn533_usb_phy *phy)
 	if (rc || (transferred != sizeof(cmd))) {
 		nfc_err(&phy->udev->dev,
 			"Reader power on cmd error %d\n", rc);
-		return rc;
+		return rc ?: -EINVAL;
 	}
 
 	rc =  usb_submit_urb(phy->in_urb, GFP_KERNEL);
-- 
2.51.0



