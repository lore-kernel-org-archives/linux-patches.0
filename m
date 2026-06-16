Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AB344DB64;
	Tue, 16 Jun 2026 16:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626898; cv=none; b=f1OtANY8sIxEXczoZWrVzlgdmS5wHeKe5q0iZQWBridqukoxlxOp9ZERqabspC2IhIg7e7+x2TDzDoVVQo1l1jQevRVGtNB2wJXzz0GEmZ1ZMqu8sg/3chDW3luT/Ht2wWrtkJxfxq31Jxas7EIoYeOS+0hhGaR/bqt4uzbwVzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626898; c=relaxed/simple;
	bh=/my2D0aDpWGcH7DyzlalaQm1wDqz7lqXLaVOTHM0P6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwxDipVhAH2eiui96l2VUxWerDm6HG/VDSW/1quP5HtxDTGxNWGM8lqaH5ujGn4mHiKIRcBKbO1IFGH8H/uSs7tchZS0APa2wUa5loALEyWst2Qxi/rhLFBpPbflPLyiD4VBFMu3Ia08QIB87ULxEExH/6BkcjAUXeicD2kOw/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTByNXCA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTByNXCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAE71F000E9;
	Tue, 16 Jun 2026 16:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626897;
	bh=YxW3DJKvyhz1pIsarWz7VYoQfYY87RmQrqsQJt4UdQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTByNXCA9ekmm2nCh+F+Jg/yGhgS4QLHQ6xWxJ4P7KSl9a0f9beobEguN9V3/uI84
	 3GKnI6rp38LUmIc7Hs1kSxD2TutesXMuuCfJ5hvzrdk6xCA3qQjvqD+F9azagcA14A
	 M302j8g6Wo9YqVMjSOnHTQnWUt5ID1bKwuNNmacE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih Kai Hsu <hsu.chih.kai@realtek.com>,
	Hayes Wang <hayeswang@realtek.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/261] r8152: handle the return value of usb_reset_device()
Date: Tue, 16 Jun 2026 20:28:48 +0530
Message-ID: <20260616145049.202641455@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1c36816405f13b..f3a4a40d534631 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9811,7 +9811,12 @@ static int rtl8152_probe_once(struct usb_interface *intf,
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



