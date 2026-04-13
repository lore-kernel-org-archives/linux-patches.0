Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A221314A6B;
	Mon, 13 Apr 2026 16:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098807; cv=none; b=bE6/3WO7/5zkflv60oCd4J+3jRZeFaAue0Y57036zkI92FxWF5hPvsKICRp7XU4JcRHYwRpo6kqIlHfuBynyAqFp0gDvhDPJQJI49QxTXevg7vWC0kgGos5jtS8exVNGK2X2O8bYqJwctECVVlN9zqPoSsrXXnZCkXRCkDyA2VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098807; c=relaxed/simple;
	bh=UgGFxlizCP/rrXBvG1/TQd80E36sqYbuAed2sleg0cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozQWYnco+P3OvxX1LC2gdv7wJjFYMFVGpal9GwKwfq5uG2ypJ/+EUK31CZ8Whm869B4ViW7Ie4/Pp7O3Ys/5KjX9yxdo6+sX0T5OlpBaYSNLarhvyIYJk/JzBFNoX2Iyyu7nPokmzbzAKLsqICRgnbgZfrNvH9DQ9ZnE100nhvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXLzhW40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXLzhW40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20798C2BCAF;
	Mon, 13 Apr 2026 16:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098807;
	bh=UgGFxlizCP/rrXBvG1/TQd80E36sqYbuAed2sleg0cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXLzhW407Su4gm/cx8P3WPxChQbjBgluyI1fUeaFCLQLZLOLIdwGzlADRBg6D/j1M
	 f7ScvEo5RiWgj3P6852mDMTb6qulKeS2WMLCc3+E5E0iUiyPlxuKCTHuCUMNrOW2Rp
	 dUqQyj7uez5NWHQKEVbnnKBMzARXCw2Uq87gL1t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 096/491] usb: core: dont power off roothub PHYs if phy_set_mode() fails
Date: Mon, 13 Apr 2026 17:55:41 +0200
Message-ID: <20260413155822.638703850@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

commit e293015ba76eb96ce4ebed7e3b2cb1a7d319f3e9 upstream.

Remove the error path from the usb_phy_roothub_set_mode() function.
The code is clearly wrong, because phy_set_mode() calls can't be
balanced with phy_power_off() calls.

Additionally, the usb_phy_roothub_set_mode() function is called only
from usb_add_hcd() before it powers on the PHYs, so powering off those
makes no sense anyway.

Presumably, the code is copy-pasted from the phy_power_on() function
without adjusting the error handling.

Cc: stable@vger.kernel.org # v5.1+
Fixes: b97a31348379 ("usb: core: comply to PHY framework")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260218-usb-phy-poweroff-fix-v1-1-66e6831e860e@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/phy.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/usb/core/phy.c
+++ b/drivers/usb/core/phy.c
@@ -138,16 +138,10 @@ int usb_phy_roothub_set_mode(struct usb_
 	list_for_each_entry(roothub_entry, head, list) {
 		err = phy_set_mode(roothub_entry->phy, mode);
 		if (err)
-			goto err_out;
+			return err;
 	}
 
 	return 0;
-
-err_out:
-	list_for_each_entry_continue_reverse(roothub_entry, head, list)
-		phy_power_off(roothub_entry->phy);
-
-	return err;
 }
 EXPORT_SYMBOL_GPL(usb_phy_roothub_set_mode);
 


