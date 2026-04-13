Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D69A49620;
	Mon, 13 Apr 2026 16:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097440; cv=none; b=C1QcvQ8HiLKUxQNXPsweDJUYoERQkEyus5gP3B4+eDKcXUc9jZEN/9jg9XoAFbDw5hSjWt5vlkXw+Tm8s2rc6fNIz9NLfEQmOYRnFeJGgaGkNBhUMPi2qHssSOFKMfAB/qEaH9f3SzIKTWoGVl9qcCjsQ/aw3IgHWgF4/sLJByk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097440; c=relaxed/simple;
	bh=+U8deCTaYl8ZaQQtPcukZKYunQqKQ4N1IHE3etfS8ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSZTV6WlUablaRACpio9gMPfCPccHr7kQqlmwgUwRuRMSAFaA+p9PqBgaWI7gLNo5XxIfyx2woAe91YXclG+Xvn+QWRL8h+yC8lqwVhPsJHxpz2WsnXYDC29SBg1H+gpP1yXiJZVF6lNFPhb8uwaizVWPZVdBen002PhXyJcjvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UA05+uVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UA05+uVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7D0C2BCAF;
	Mon, 13 Apr 2026 16:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097440;
	bh=+U8deCTaYl8ZaQQtPcukZKYunQqKQ4N1IHE3etfS8ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UA05+uVyQkDRt2ka+YGYhscTbi2hZVPvyOfGrogthIifv1i4zOFV0fBU2jT4skLgK
	 DVopw5eo++lxX091VnyzBLZtMdxDpgZ3mIQvcqwGqTpY5BEF8Fc5ornkPB/8Oh5Ist
	 x3CrlcbGO5CDb0B1QyW1QnmkHvJ9XYv+IMynMjO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 138/570] usb: core: dont power off roothub PHYs if phy_set_mode() fails
Date: Mon, 13 Apr 2026 17:54:29 +0200
Message-ID: <20260413155835.611645355@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
 


