Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C273BAD85;
	Mon, 23 Mar 2026 15:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278364; cv=none; b=l1pMci37KiGo6au6xlaw9cX24W9T8brIhE49C9WWVHRUz5jaIvel8Yob0pLFiHxTbW4fbP1Cje43I3bHq5EA8C3ML/rAlZoA/Vsgn5LryEKWNFGh1gIs7HlwGraKSgwP4zECKXjW+wZaa9sWFfsx3k2qqHpxJ10Fap/XgL2cMXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278364; c=relaxed/simple;
	bh=oJMklibNZ+4fyGjdJ9rAnyCPJhb9Fk3G3FnLRGVGv58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBGq1HBp4JQ0xmSe87XUeLMFfBYAmW10AdOWIMTQME/pf3i6WasKgwTStbqDzAE6L1jmt3EVtA+lEuWL48QauIqpH+8yBn/LKFHwC+7q4DvJQiKtqBnJVBVkGiaemL5QIRA0chYNqJ11xVYvqBFVli15od5OLaEtmTFroDejF08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXs+gD/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXs+gD/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D58C4CEF7;
	Mon, 23 Mar 2026 15:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278364;
	bh=oJMklibNZ+4fyGjdJ9rAnyCPJhb9Fk3G3FnLRGVGv58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXs+gD/lNohamE3WOAE2mQoV1nuOeipdrYyflQDNzqrxtGT4RUPdd8vhCqpneb1Ht
	 28xGJBiTnlA9jbhVXp2vAFctr21WiyFngI9o08QTjEPpMHgA4gHbyaoLF5I11cRKYo
	 ec0eYkmex3XdDhxrMeZ6RMSrqasw+fLkEXHF/gbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 277/567] usb: core: dont power off roothub PHYs if phy_set_mode() fails
Date: Mon, 23 Mar 2026 14:43:17 +0100
Message-ID: <20260323134540.680061470@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
 


