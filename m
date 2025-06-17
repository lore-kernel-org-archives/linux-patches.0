Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B8D2F94A0;
	Tue, 17 Jun 2025 16:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177598; cv=none; b=eH350q/pIU+jwW0qCZaOqej5/E0S9a5spStC/Zdp88GBcdM12YCk+nKaXuCBQ+HR6SHX8J/xlLhS23DTRPC+LGomen23tsy9nLm1FZHP6kzSS4KY6wSHEqhcfgsJcWVJG5Z24hX1qvLjJVzwR/WWbVCbiywQl3z+U+LjwLD6Ng4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177598; c=relaxed/simple;
	bh=lGlauVhIySHikfsmbrNZG5UEhDbPOD238gMMh0RhhKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cm5xuKWrILssGWT1LmgcvtF41Nceose6vqOPVDieLRV5NIDW5ATm4OBhljAzkW5L/KYk59+QTtXexI/lysmSGVr36qX0vdr4MNrThrT4FuY1Ozt+jZRCsqekWGfeHEaJKwz7dLfGbIevUAlQ5C6O4+f6tcG8DZuNN8ICATiSYhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1vXTQ1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1vXTQ1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1195C4CEE3;
	Tue, 17 Jun 2025 16:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177598;
	bh=lGlauVhIySHikfsmbrNZG5UEhDbPOD238gMMh0RhhKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1vXTQ1aJRiHDrtOMBKZSP8y9C/DU2yVefRl2kVMIebCSI6diyI6lWjS5R86ahIz/
	 P7fStBMqExlUOJS7285vba3GU15NaOP4pyFSPs4cfil2e2+AVwYl5gfPBl7v8Fb18x
	 1/nHBqR7J98BpvvKZY2bXqk3pdqQjIrYBTepGtrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 341/512] USB: gadget: udc: fix const issue in gadget_match_driver()
Date: Tue, 17 Jun 2025 17:25:07 +0200
Message-ID: <20250617152433.419896956@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 5f5cc794fac605afd3bef8065e33096aeacf6257 ]

gadget_match_driver() takes a const pointer, and then decides to cast it
away into a non-const one, which is not a good thing to do overall.  Fix
this up by properly setting the pointers to be const to preserve that
attribute.

Fixes: d69d80484598 ("driver core: have match() callback in struct bus_type take a const *")
Link: https://lore.kernel.org/r/2025052139-rash-unsaddle-7c5e@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 4b3d5075621aa..d709e24c1fd42 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1570,7 +1570,7 @@ static int gadget_match_driver(struct device *dev, const struct device_driver *d
 {
 	struct usb_gadget *gadget = dev_to_usb_gadget(dev);
 	struct usb_udc *udc = gadget->udc;
-	struct usb_gadget_driver *driver = container_of(drv,
+	const struct usb_gadget_driver *driver = container_of(drv,
 			struct usb_gadget_driver, driver);
 
 	/* If the driver specifies a udc_name, it must match the UDC's name */
-- 
2.39.5



