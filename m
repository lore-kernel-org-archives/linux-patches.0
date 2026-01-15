Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9F221CC5A;
	Thu, 15 Jan 2026 17:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497878; cv=none; b=FtUOACA5j0TQrivaUlXMOBGaOuhhxrC28O1PPPJqob4Ig2d2iy9lnr0m7q4gtZZPP/QFVY16o8Cl9w7GWggbEg4jjedwOLd0AoIKrKUXKHGhQT2suZrWyqT6IlagSm+L8QzWlgDfWVOegR1LTmGK8ftBxvXmwM7Gk1dpnIJcZSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497878; c=relaxed/simple;
	bh=4Djij3PQ+srSlaVBzY6Smv+QSX22XeRqL2j1TqAMxGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LM6LhZu3dEFy84KEgkxuen4+2L9990Yfugz5c4+73xu73PCrhLZn920H9ifX83/4o7LX8eslmkY3gaOjQPupupawju2clHPcQTQ0e2/hsBZbTIAvH2L+PsPRquIMfgszk7xvYQRpBVTupxlEoNiGDFSPxFjk0YAzzvncz2Yer/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iM1sTx7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iM1sTx7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D905C116D0;
	Thu, 15 Jan 2026 17:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497878;
	bh=4Djij3PQ+srSlaVBzY6Smv+QSX22XeRqL2j1TqAMxGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iM1sTx7PODmIXs6dExPbgUevzPlwfDgVpXz3mg+uHLdeeFgwOzoHYqHEQ1/00ZZ+E
	 lcxwPK7Wb2ZFNiGdcC+rAXwBzmEVdsurk2xq2wSEBajx7oAXA9peFfzqxDNcw5hDu4
	 b4RWu4BQcRgXY1ojpvA2VotjWchjC36ei+pFOqn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 234/554] nfc: pn533: Fix error code in pn533_acr122_poweron_rdr()
Date: Thu, 15 Jan 2026 17:45:00 +0100
Message-ID: <20260115164254.717025009@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 47d423cc26081..11d3c4045c1e1 100644
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



