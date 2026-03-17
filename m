Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D33C1ACEDE;
	Tue, 17 Mar 2026 17:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767674; cv=none; b=NoLgYXqdL4QxP9YzhTjqy+WbtcI+7R1BB8BNV3apIzgG+cOHRd7GoZGZ/dTGYKfkyYq4n5KJUres8sDZXwrblbF6myRQmztGeFIpFWiUhHnQGTvG0OHfuTDXw9k+FWAIWMhZprRkis/CXPHwr/GBE4+CmHEtmbzymWXGq/xVEU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767674; c=relaxed/simple;
	bh=JrAS3a7N/zH57GERoGgWsRSucoQEVyf39WH6eXlaCjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRG7FMst4DbYeccGYyAP0wLGQjpIosCUYCiwesLFTXBvV1F1x8wCR31RoqLgHljb+unMjskyGd/dtTTOgNSbvk9NI/u2lMF1RQ+yYqW3KU36u3zjhzgMOLQwuL51EPH7bYFxpOLzCdKJPaeeLAqbMcgOadd2sE3sQFWx8KIWHww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCGFU+c0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCGFU+c0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1FAC4CEF7;
	Tue, 17 Mar 2026 17:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767674;
	bh=JrAS3a7N/zH57GERoGgWsRSucoQEVyf39WH6eXlaCjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PCGFU+c09ujEIZLLm1QMDvTvmlPmstA9YtWweH0kPDxYGwXF3Vs/Gq0gbskYo+RJn
	 g6BH4IwAO8kYsoR6nzGfnqW2uM7guGl04xT1IQ90iKi406consfG9lcfq1ntGbkbSO
	 5wrJg0IcOWgJebjMm1EdXsttEa4N/sOjasEDKY+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.18 134/333] usb: core: dont power off roothub PHYs if phy_set_mode() fails
Date: Tue, 17 Mar 2026 17:32:43 +0100
Message-ID: <20260317163004.331421321@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -200,16 +200,10 @@ int usb_phy_roothub_set_mode(struct usb_
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
 


