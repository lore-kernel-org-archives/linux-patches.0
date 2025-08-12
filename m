Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DCB2E11BF;
	Tue, 12 Aug 2025 19:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026837; cv=none; b=TvOt31+1MxlHgq3vy9aDBKRpzk/2EdRDTVqETWaAlCDtKtZOS5Zc2YVjmKpwtuqW8lHPn2iF0iJ/aVvG137Yu8Qmp0IyG9UZ+nqYa/Zm9GN3GUfHxxOB97guc6mqNwGil4CkMtvyrm6uUA70jGbnewmVZELZ95Nh497Pp6/UuD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026837; c=relaxed/simple;
	bh=nG10S7Uh6TGLHBsVNYRZI1+JSkqG3/13TSGHIAbiMvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqMnrNksMF72xTP6KZxQ7uJDlzsOHAbT365PRjx+Vby0WkCj+OFWFzFqEqLTpPsXy2cUkueVt3PIt13O7EOM4Ki4zdXbcwKFse+KkDOj4L/ZvE588jJicqzfZnAiEgDLwsZbyMB8frBCOPOCxgVPtabfiN49W+bIfC6Q45ccAiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZR8tKEj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZR8tKEj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06531C4CEF0;
	Tue, 12 Aug 2025 19:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026837;
	bh=nG10S7Uh6TGLHBsVNYRZI1+JSkqG3/13TSGHIAbiMvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZR8tKEj5TgQYR463ZaepVVyfYYje1aQb3XuhBahvArCnjKpD7ArJz+/jvw7pSOl29
	 qc1MALJedH1so9zODF1EjLnvrQTgniAOzOfs3cbhLcFsQVBoUwXYgsJmvMjwB9IVwE
	 9dKbzZebtDdKFyNoiZwFApYkdY7Rxgjp2eaf7IFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armando Budianto <sprite@gnuweeb.org>,
	Simon Horman <horms@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH 6.15 455/480] net: usbnet: Fix the wrong netif_carrier_on() call
Date: Tue, 12 Aug 2025 19:51:03 +0200
Message-ID: <20250812174416.158717795@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

commit 8466d393700f9ccef68134d3349f4e0a087679b9 upstream.

The commit referenced in the Fixes tag causes usbnet to malfunction
(identified via git bisect). Post-commit, my external RJ45 LAN cable
fails to connect. Linus also reported the same issue after pulling that
commit.

The code has a logic error: netif_carrier_on() is only called when the
link is already on. Fix this by moving the netif_carrier_on() call
outside the if-statement entirely. This ensures it is always called
when EVENT_LINK_CARRIER_ON is set and properly clears it regardless
of the link state.

Cc: stable@vger.kernel.org
Cc: Armando Budianto <sprite@gnuweeb.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/all/CAHk-=wjqL4uF0MG_c8+xHX1Vv8==sPYQrtzbdA3kzi96284nuQ@mail.gmail.com
Closes: https://lore.kernel.org/netdev/CAHk-=wjKh8X4PT_mU1kD4GQrbjivMfPn-_hXa6han_BTDcXddw@mail.gmail.com
Closes: https://lore.kernel.org/netdev/0752dee6-43d6-4e1f-81d2-4248142cccd2@gnuweeb.org
Fixes: 0d9cfc9b8cb1 ("net: usbnet: Avoid potential RCU stall on LINK_CHANGE event")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1113,6 +1113,9 @@ static void __handle_link_change(struct
 	if (!test_bit(EVENT_DEV_OPEN, &dev->flags))
 		return;
 
+	if (test_and_clear_bit(EVENT_LINK_CARRIER_ON, &dev->flags))
+		netif_carrier_on(dev->net);
+
 	if (!netif_carrier_ok(dev->net)) {
 		/* kill URBs for reading packets to save bus bandwidth */
 		unlink_urbs(dev, &dev->rxq);
@@ -1122,9 +1125,6 @@ static void __handle_link_change(struct
 		 * tx queue is stopped by netcore after link becomes off
 		 */
 	} else {
-		if (test_and_clear_bit(EVENT_LINK_CARRIER_ON, &dev->flags))
-			netif_carrier_on(dev->net);
-
 		/* submitting URBs for reading packets */
 		tasklet_schedule(&dev->bh);
 	}


