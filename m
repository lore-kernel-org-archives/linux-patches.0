Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8347D44CAF9;
	Tue, 16 Jun 2026 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625273; cv=none; b=tgEhkk5kbDAoRbceSCBhtoQlyJFC3+qs78aljQln2fe7GpVx+hNhgItDud+OecHa/KLmrQLiyFYAllgpeCFEfwVWWXLiJtz4QiyyHn4ALbJuYBjea6vomoVx3BNKm7/DTdm8Z2KZ/GqTc974ZUzNcVqhW89g0zBG1rSaa7kES3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625273; c=relaxed/simple;
	bh=eA3BzSYQIEJkQZKe8mJ7Ce9X6N6kHE6fTL1wztWtBvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pO/gHOZbdSZV9eQIVRN81DAar+hTyiaYK7e14cOlSfaT85y2Ro+1zr1reEKYlDEeh8CHu+yl9QCoo/vZ3KhxnhOWNMjAohurWfOXD7Fk4X0S16HSUQLFM+E/WqrVZTcELj+OOtICK7suT63uThQ1vwqA2rycyUOyrGWQhdcQKCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvnZ3iCp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvnZ3iCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899ED1F000E9;
	Tue, 16 Jun 2026 15:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625272;
	bh=5EyTsRRqAmMHg/WAgkCXxUbffEQmmiZFIn6wMh2jkLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qvnZ3iCpaupyzyFugHs0dwcU3iewSI6OFeosPixAnnAg5BtooWN9W7emZz295r+KJ
	 FYjWbW6ew1zgJuH4/FeRmK4upWuBgsbRmaH1jE5uX8LlvVYu1Qb8tQC5DE76lJoIEr
	 +cQbjZPC35a1upHOOjeIbnBL771niMse/eC1xYJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih Kai Hsu <hsu.chih.kai@realtek.com>,
	Hayes Wang <hayeswang@realtek.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 109/325] r8152: handle the return value of usb_reset_device()
Date: Tue, 16 Jun 2026 20:28:25 +0530
Message-ID: <20260616145103.137081795@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Chih Kai Hsu <hsu.chih.kai@realtek.com>

[ Upstream commit 19440600e729d4f74a42591a872099cf25c7d28a ]

If usb_reset_device() returns a negative error code, stop the
process of probing.

Fixes: 10c3271712f5 ("r8152: disable the ECM mode")
Signed-off-by: Chih Kai Hsu <hsu.chih.kai@realtek.com>
Reviewed-by: Hayes Wang <hayeswang@realtek.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260604092247.27158-450-nic_swsd@realtek.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index d610741782794b..8cf4e81f8f882b 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9781,7 +9781,12 @@ static int rtl8152_probe_once(struct usb_interface *intf,
 	struct net_device *netdev;
 	int ret;
 
-	usb_reset_device(udev);
+	ret = usb_reset_device(udev);
+	if (ret < 0) {
+		dev_err(&intf->dev, "USB reset failed, errno=%d\n", ret);
+		return ret;
+	}
+
 	netdev = alloc_etherdev(sizeof(struct r8152));
 	if (!netdev) {
 		dev_err(&intf->dev, "Out of memory\n");
-- 
2.53.0



