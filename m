Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B5D154BFB;
	Mon, 16 Sep 2024 12:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488501; cv=none; b=hQdB4OA6wTZq2iuR1vYWTWQms7zFELOJZmi44ryS7OdazDlrrDDL0IVB8FkUN8RMD6NSr79INNGEh6NKCFQPRPJ9I+JklsN5pYZIz5ifBBUDX1RR/WISUGuV4IXP8EjiUDsOchl4+my8oqMFOdYwO29ftMLqyBuUwh+7iEU9g4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488501; c=relaxed/simple;
	bh=MLVhKtJCHRhI8d034OKM0b2aN1Bb4jcLGUBbclH/z5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9SYHEt4lWTzAUBW4pZbXrmJos0AvqhXh5aMj5fj/6H+v94muyEXanvImVESfki1jsRFC8N/UeXxIkYhEkXg2KKU7UPJQeGZ3D97U6Se3WxeBEeqz6FVYrXycfdl7KYgVKGS01DqjAV6dHzBiQ0NA5sLTDdl3ryWApNmnwVfVLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaVDMCA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaVDMCA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B824AC4CEC4;
	Mon, 16 Sep 2024 12:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488501;
	bh=MLVhKtJCHRhI8d034OKM0b2aN1Bb4jcLGUBbclH/z5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XaVDMCA+5zl8n5IGVXSojvBlnAAA4mlgosjwLBJRf4nmLtpeCJhMZFTtW73r1koNC
	 gZ8FG8GSJJiMhyTUE+R2X+QemSA10ZxfhjB2HA+gjqjbbhJ33rcVBGmHW0W1LynpJs
	 r4B83+Pvt0fhq6Rhir1o4wrqBx9V61Vp5PtWug0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Foster Snowhill <forst@pen.gy>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 14/91] usbnet: ipheth: do not stop RX on failing RX callback
Date: Mon, 16 Sep 2024 13:43:50 +0200
Message-ID: <20240916114224.999248924@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

From: Foster Snowhill <forst@pen.gy>

[ Upstream commit 74efed51e0a4d62f998f806c307778b47fc73395 ]

RX callbacks can fail for multiple reasons:

* Payload too short
* Payload formatted incorrecly (e.g. bad NCM framing)
* Lack of memory

None of these should cause the driver to seize up.

Make such failures non-critical and continue processing further
incoming URBs.

Signed-off-by: Foster Snowhill <forst@pen.gy>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ipheth.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index f04c7bf79665..cdc72559790a 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -308,7 +308,6 @@ static void ipheth_rcvbulk_callback(struct urb *urb)
 	if (retval != 0) {
 		dev_err(&dev->intf->dev, "%s: callback retval: %d\n",
 			__func__, retval);
-		return;
 	}
 
 rx_submit:
-- 
2.43.0



