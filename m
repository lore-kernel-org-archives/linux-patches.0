Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AD53A8746;
	Tue, 16 Jun 2026 15:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623308; cv=none; b=L0cZQ1ambBEmhQFrwKLEyu88ZhKgWpF2M5nQa6hw41PoiIGXj64RvSqLvYWuDIbjxXP4jk365oLYZSV91uWXuwDNLd7yDOW0JVp5Ee0c3MbsvTINk8Y67khPs0KtbPYrujGgJ8SR1FoJqOO9KAsWQVGcgnxP8roRUTY1V8so9yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623308; c=relaxed/simple;
	bh=LB4K+/qdllVuuCKvts5TxNR42X9WFDvLU5LVHpqNawA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFZQLMFSdi5vf3BPij2EqJZq+YDLVAYFW6xVhQoJGVztIJrL4KNAOvbu9VhF7mvIlnoO0l1UwJYPXMg1BHuTaAsXzv1V3ZAZ/ZuO2CJgX2sXCDBCrs7L4VKe8cQq8m8lBh9SIGGLEsaEmPxL7KXytNEz6ogE7yXCqN1mXm/3/rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMiQuS1v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMiQuS1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47301F000E9;
	Tue, 16 Jun 2026 15:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623306;
	bh=HSXBjsKssPV7utGPXmcJ5L9B7mFgUk9XEILcDVoKehs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZMiQuS1v382BeMTGuR7B+sU2reriGdWaYgbe6am3+VFkWeXv7XVWdfPMNsm7ut2tq
	 WMB+NLu3uHRvRSXlu7J6g+lB7nHLT7Y6I8RoxiTr16FzugPRERDgtiQxImx4CthBVi
	 0XuafTSEHxMwiRo46MAQAr84pzjZ7OHwOF/pczXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih Kai Hsu <hsu.chih.kai@realtek.com>,
	Hayes Wang <hayeswang@realtek.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 124/378] r8152: handle the return value of usb_reset_device()
Date: Tue, 16 Jun 2026 20:25:55 +0530
Message-ID: <20260616145116.873236807@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index f69e7e1ab7788d..240265746990ec 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9775,7 +9775,12 @@ static int rtl8152_probe_once(struct usb_interface *intf,
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



