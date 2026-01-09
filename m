Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4043335B12B;
	Fri,  9 Jan 2026 12:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962135; cv=none; b=IW0jusgjitvsycHrYqVidk4jbJBkJ8l+fXadEl8lz0uP+oq1v5+3k236cp4OKkcVy7SFV9xmyKkZryc27VagvwWsNorB2qiJjYWjuDzgDanKqy3egnaULJdHbs592dIqc151MGfQcPkrVrFMq/2iJmzJ3z3df5+/1geGeRfMq00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962135; c=relaxed/simple;
	bh=Yts/9m779TfRRQF2NWtm8A8r/BdZx+R4BWLwEWFGzX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSM5Y0MpzD2rzIiNoz2fLkUuwIIwQq1KifuBvvXH6lDZ5FHu3WagdW9aHhussBFqlGbPXpm2Z6ti7GgMJ1CXqTlnU58MAhmsSa3/969HHzTuNPau0EpQly9poTDJjFyC9YMx2i6Zp6ER/TtQFFKuEjorwrz558KXkLiz+umSjuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtzMJtcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtzMJtcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B6DC4CEF1;
	Fri,  9 Jan 2026 12:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962135;
	bh=Yts/9m779TfRRQF2NWtm8A8r/BdZx+R4BWLwEWFGzX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtzMJtcuKBrkFfY9miXW2fxRYMhstxuyt6MkmlTRB0GF2lXmo99pq8brDUN9Y6S9O
	 y79wEBZV+qujo1BTenRH8FK8Awsl2Rvc01sk1LGdbZh5v5sSUpiw862zkVth4vraik
	 QmB5kf9kXDaySK7Oc7cXg1WLajPkk4VrdJSu+ZW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 259/634] nfc: pn533: Fix error code in pn533_acr122_poweron_rdr()
Date: Fri,  9 Jan 2026 12:38:57 +0100
Message-ID: <20260109112127.283699562@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



