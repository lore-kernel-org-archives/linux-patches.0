Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030A617BB21;
	Wed, 17 Sep 2025 12:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112928; cv=none; b=N0iuEcfILp8Taw0OH0tv9cgE9h3JRnJ1UmyJpM54OsINWBDhu2HUYJ/IwcbK4u+t0QgeJsQI+WZoKp1Eeaj+8dTKppTRxH13+A1O73KbzK5s7FelvCJLWp+QAYoUe2jvmM4WZDdH+B7sBnL8VLTEifrUVHIEJKbK7UddfhTT5j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112928; c=relaxed/simple;
	bh=SgLS6hR0DuNjyayqVfB+ntzd8GO0q6Nfup30WLrE5dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZhFPNfM7NJTuP3l3yI+F732bQUupmHP9xuDz3rXyLBaBdcx8+FKm9jvp8M/QFVdEwN+fHGSglApp5mORqDzDHfOPZT6DRRZCnS/1qgfBN8Ea5XDIIuIOf3HVxTrcuZF302l9Elm9SIZzQS0UjghaaQdldayP20Ms7Mt82Ff/yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrSDLYHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrSDLYHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7692AC4CEF0;
	Wed, 17 Sep 2025 12:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112927;
	bh=SgLS6hR0DuNjyayqVfB+ntzd8GO0q6Nfup30WLrE5dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrSDLYHOE8OpbVbmyPlqlz3NgWKY6qhl8FHx7utZ72mKUqKxoNWCqzGl6jn4v1945
	 /uTCsceaRVEH+0itToDnoMDehSJhkAEe8fELjdulhRlC2rBUS4QY6RNfIPvCkW3fap
	 Y6KXW9g4j7iWqTdKSaw7P0CR2Nku2m92cbdG0du8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.16 119/189] Revert "net: usb: asix: ax88772: drop phylink use in PM to avoid MDIO runtime PM wakeups"
Date: Wed, 17 Sep 2025 14:33:49 +0200
Message-ID: <20250917123354.771525533@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 63a796558bc22ec699e4193d5c75534757ddf2e6 upstream.

This reverts commit 5537a4679403 ("net: usb: asix: ax88772: drop
phylink use in PM to avoid MDIO runtime PM wakeups"), it breaks
operation of asix ethernet usb dongle after system suspend-resume
cycle.

Link: https://lore.kernel.org/all/b5ea8296-f981-445d-a09a-2f389d7f6fdd@samsung.com/
Fixes: 5537a4679403 ("net: usb: asix: ax88772: drop phylink use in PM to avoid MDIO runtime PM wakeups")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/2945b9dbadb8ee1fee058b19554a5cb14f1763c1.1757601118.git.pabeni@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/asix_devices.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -607,8 +607,15 @@ static const struct net_device_ops ax887
 
 static void ax88772_suspend(struct usbnet *dev)
 {
+	struct asix_common_private *priv = dev->driver_priv;
 	u16 medium;
 
+	if (netif_running(dev->net)) {
+		rtnl_lock();
+		phylink_suspend(priv->phylink, false);
+		rtnl_unlock();
+	}
+
 	/* Stop MAC operation */
 	medium = asix_read_medium_status(dev, 1);
 	medium &= ~AX_MEDIUM_RE;
@@ -637,6 +644,12 @@ static void ax88772_resume(struct usbnet
 	for (i = 0; i < 3; i++)
 		if (!priv->reset(dev, 1))
 			break;
+
+	if (netif_running(dev->net)) {
+		rtnl_lock();
+		phylink_resume(priv->phylink);
+		rtnl_unlock();
+	}
 }
 
 static int asix_resume(struct usb_interface *intf)


