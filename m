Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC736158524;
	Mon, 16 Sep 2024 12:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488216; cv=none; b=U7eDmQkI9USnHoeSGLJm8RlwAQJWyJjioyVR0mJ+Ws0wth6dj2wRUuYyXoMLNYZnQjaKSSYbIVTvc2oy7Tv1jupNTFc+RI2yhMaHRDLB1a4XXaOgfmHBdq/CsZgWceOCh9ApBm7kRJglj9AtzP9MWR6bDnhcZMC/DnEpdiJzMOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488216; c=relaxed/simple;
	bh=iiIE4KNH0zNnk1CGJOdDm6lEUdF92tAqGcikvQbvdWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHgmtqCBF5dNrW8Mw242NKdgXXDTwVzbm2Q35FObIES3//M6fq9T2uIZwMUmSy6hax6aO08fNdXbY82Q5akUh61+qu5GNMKSORDCWTscEE3YPqPKHfpi7+VX/BMD851/C/0Z9sXWvgfcTGL+IE3LrFHhXRAo4VyJj/QcT6Q5BXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3u+TQJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3u+TQJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E250C4CEC4;
	Mon, 16 Sep 2024 12:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488216;
	bh=iiIE4KNH0zNnk1CGJOdDm6lEUdF92tAqGcikvQbvdWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3u+TQJtLq0AxP30/HQxrMOhwm2OUozYIUEYyuHqSymkBTgdyDBzaW9WVbncpyfL8
	 nrlvsTZB5NcfI27kd99IAOOO/L+DV1B6YTpM0nJxMh1TTW9IX6OtXLztTYsU+B8hpc
	 +B3laTCOuP6Z7G7jdPGLvpDYF9oKrmR47gkiN6Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Foster Snowhill <forst@pen.gy>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 008/121] usbnet: ipheth: do not stop RX on failing RX callback
Date: Mon, 16 Sep 2024 13:43:02 +0200
Message-ID: <20240916114229.199548921@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



