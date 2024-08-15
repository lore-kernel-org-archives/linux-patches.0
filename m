Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AD317C9A9;
	Thu, 15 Aug 2024 13:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730285; cv=none; b=CquVSKpVczNp9Qnp8hK9aaimxgsxcINiHgilmfK+dwrANkevbS+1+mtZjmNz4Uhy8FIVysF2AHuqqHJZKA0cvanS0n9DLyj78Z3LGDbZF3Ba9J2cbf9h/W29jhRXssRRgvjyWnOoHpC6DqIeCysl1G5nvRtgEprJ7MyJ3aJId5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730285; c=relaxed/simple;
	bh=MiVHKYv1dUHZz+R8eFmMXKpBqJgObdMOY/BD8dnB1VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PP4UxaY6dV/Ta1H+DyGTg+fr72jKGNz2IuGm5U/GCwG+HWzgahWzYesns8ezoUDZ1H4d606wZbX7jk+r+0oTZfWRd1l5Iy0Lm1eXFJ5HZM4uUBj45cIeMsLRFrYCtts8v8tv17HpSgToNmY1lYkmoxvIVXT9+nfIELCa2Y7a+ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebungFfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebungFfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C805C32786;
	Thu, 15 Aug 2024 13:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730284;
	bh=MiVHKYv1dUHZz+R8eFmMXKpBqJgObdMOY/BD8dnB1VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebungFfw+lfdxpNKO/oWizqBdI/DeCEtMMXbDQ6wh+1TD+hIh3sl6Rdc3F3OgStEl
	 qzIcGZtVibt3xYRrM0TXEdzZ4t3biOCEKIubimDHk5qQvWmCOytL7WTLo43e9vxSX6
	 6+pAaXjFRsRBtG15TeZzPans4RUZMb3kikyFHtCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Palmas <dnlplm@gmail.com>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 360/484] net: usb: qmi_wwan: fix memory leak for not ip packets
Date: Thu, 15 Aug 2024 15:23:38 +0200
Message-ID: <20240815131955.336736626@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Palmas <dnlplm@gmail.com>

[ Upstream commit 7ab107544b777c3bd7feb9fe447367d8edd5b202 ]

Free the unused skb when not ip packets arrive.

Fixes: c6adf77953bc ("net: usb: qmi_wwan: add qmap mux protocol support")
Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index fb09e95cbc258..773a54c083f61 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -201,6 +201,7 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			break;
 		default:
 			/* not ip - do not know what to do */
+			kfree_skb(skbn);
 			goto skip;
 		}
 
-- 
2.43.0



