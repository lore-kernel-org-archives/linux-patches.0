Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1442754BD4;
	Tue, 27 Feb 2024 13:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042212; cv=none; b=GNQzel9jzUTL3wm9qf81mZo5jrcj12/WSw8v3LQxd0x3aClpEtllS7qtRWtz+ldtES6vCT8EYA+quH9aPG8gphElnlzJx1Q5Xj/ft73fDJFNt5aZO0hoIZbQTTeyRRe4kgh0wOmxiPKb6T2bJ2VVT9/yXbQc4TW7SkI70RBbSV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042212; c=relaxed/simple;
	bh=dqChMNewwzeB+LpqaOsu2chusLcjqo21aeSGDTyBtzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6zJ1R/3V6d73NVhZ/skr7OLCnYIEa1ksHg/lucyYwRMGA+VIa5hCzRk058pnrekI0+mhqOI3ksP1GLpCsK9YsiZPanXJMZbwdqM9S1/2h0fbpPlSHZ49XuPHiFqQ64xBUpNMMIzlbzTki9wDZyIArR+CMnt1yDukt/7dEbHT2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zE378QMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zE378QMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BE2C433C7;
	Tue, 27 Feb 2024 13:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042211;
	bh=dqChMNewwzeB+LpqaOsu2chusLcjqo21aeSGDTyBtzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zE378QMP0YN/kxT/TqA8EA374CcCtgAoyCcMCAd4+I/3wvzj6XRoHio0IZWsQXJOt
	 vna+DLWDfu2Qv0AkavCSdwqXNZQIs+y+HjnAZBOMJJWCVyZKAwsq0gW3n7s5NEX71R
	 vCl1LbYTyUcVWuorsOAl8A9bE61ozjbs5DNL20nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.6 189/299] usb: gadget: omap_udc: fix USB gadget regression on Palm TE
Date: Tue, 27 Feb 2024 14:25:00 +0100
Message-ID: <20240227131631.911217577@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Aaro Koskinen <aaro.koskinen@iki.fi>

commit 858a74cb512833e276d96a72acb560ce8c138bec upstream.

When upgrading from 6.1 LTS to 6.6 LTS, I noticed the ethernet gadget
stopped working on Palm TE.

Commit 8825acd7cc8a ("ARM: omap1: remove dead code") deleted Palm TE from
machine_without_vbus_sense(), although the board is still used. Fix that.

Fixes: 8825acd7cc8a ("ARM: omap1: remove dead code")
Cc: stable <stable@kernel.org>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20240217192042.GA372205@darkstar.musicnaut.iki.fi
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/omap_udc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/omap_udc.c
+++ b/drivers/usb/gadget/udc/omap_udc.c
@@ -2036,7 +2036,8 @@ static irqreturn_t omap_udc_iso_irq(int
 
 static inline int machine_without_vbus_sense(void)
 {
-	return  machine_is_omap_osk() || machine_is_sx1();
+	return  machine_is_omap_osk() || machine_is_omap_palmte() ||
+		machine_is_sx1();
 }
 
 static int omap_udc_start(struct usb_gadget *g,


