Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7516C44BCBE;
	Tue, 16 Jun 2026 17:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629367; cv=none; b=rQn846YtzUjVzQE9CYQAxbo4X8RWpLWrP1udgTpxkYEU4vR47uMSdfPjd8ks1R3YgnUo/rD1kKkNq9ibpx7L4JuNZvdAMXERVCyzT9ce6LEQmJaaXBbW4bbya0niGkoPOkVo+XFMXLGx3Io6C+U06yA5o9BY87UXTgPVeVWHL34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629367; c=relaxed/simple;
	bh=QBgTYRP2eDKYn5l7rkRFdGSWO0it5Ju/E9fxP8KhMc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjvcuC9Qz+CAaS5QSjtRvbzEAR77vzE7rU6Z+EGeLuBxs8aKouIY3aPEkaLbKpKSMHJll5dgfMiSune8JFOPoiN2vhCNWJbi8CYaAPFJrUi/W0dqe5BlUYcpNQlxz2OsjHNp7xUvoR4GUIzaOq6TslSaUkUa+RxUiNKPSOm1Va0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcX4wneH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcX4wneH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F11A1F000E9;
	Tue, 16 Jun 2026 17:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629366;
	bh=ELzSFPvsGouY3qrOs0MSrYbhAof0rGhjx5nc8hZF3q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PcX4wneHhZyRMZWqVNOIEz3DYy5tc60ra8Oa7JYuCC5TMNYIc5+bL5U5wcHRXcPfw
	 0NMez/D4AGPNyH7dhAlf3wJmjEKvJtlZSCcIa+fSwPbgBS6qjv0EiOInycmugCPUT0
	 EGTnxefPFNdcffvnx5EQN54tLx995npAlQPWZLSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih Kai Hsu <hsu.chih.kai@realtek.com>,
	Hayes Wang <hayeswang@realtek.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 271/452] r8152: handle the return value of usb_reset_device()
Date: Tue, 16 Jun 2026 20:28:18 +0530
Message-ID: <20260616145131.821484418@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
index d39d66e25b01b9..cf8119924bb72e 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9757,7 +9757,12 @@ static int rtl8152_probe_once(struct usb_interface *intf,
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



