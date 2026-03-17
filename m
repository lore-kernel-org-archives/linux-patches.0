Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DA83F23B9;
	Tue, 17 Mar 2026 16:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766014; cv=none; b=tekQOeY/1IqnPcdHQn3RXfy+PWuvKz08xTDa/02Uw4xLwelcik1DDan5gb0k/ebeobOeA+1PKTwY5GWs7pRCV2Z3x6aOaZAweN1NMPUVpS74qPnYBQF7nx2B5eHk0GM6jGN1mKf7Zi+l2JrsfOlWrh7qicMw4y3D/mVC2AUv8ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766014; c=relaxed/simple;
	bh=QYmb/1DYB2jiRMW2vEbQ0EKanCLUXO6TgQc0vK9I6YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inYgyXOkz1t+MMqYxjOV8zoWhi+2pgksBGnGWHpphNX68+IVsk1DkYta0sFu/mMce+Dx+twskfh7/TOjNx5OL1CfNuNYK3YrdHyqJ5UEqP3eVCwmzuEcz4ll01m2LUGuSeSYbmqrlRDv4RThTLSZuCbo0paQzJsFLDogNifkIM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGkCdZ6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGkCdZ6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C325C4CEF7;
	Tue, 17 Mar 2026 16:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766014;
	bh=QYmb/1DYB2jiRMW2vEbQ0EKanCLUXO6TgQc0vK9I6YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGkCdZ6+7iDEB+4S1WgBp/eFYqHJxQOmj4rxvKiShActnq1lulxK/qB9ohinQwcQu
	 3LMSt0LCFg0ExMt9d4EH2qeQw8skAVqFs2JdWnujTyiL/XtZHvVJJ13HKSfIhub5cq
	 2wBALlf1hLAHpzc+awAX6S544P/uKkvVUsq198F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.19 151/378] usb: core: dont power off roothub PHYs if phy_set_mode() fails
Date: Tue, 17 Mar 2026 17:31:48 +0100
Message-ID: <20260317163012.568265822@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
 


