Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB141258A;
	Tue, 26 Aug 2025 13:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216570; cv=none; b=NE6ynIHJTo905UeMycUKrXxspXYUCsPmdSsGrVk9stL6AfGcfyQlcGayAq2d9SNV62OkrORrw7r0dEGPGqGvlveyaBhsPixbhRWDoxyruAfq6ZoEWog5kELJQMECzbHihgjYeXqqVVV5tC8wHIGodPRh+ahMl/JVOqomj8dZpqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216570; c=relaxed/simple;
	bh=n42AOn3jWDEr8HaH5Zu+K6odQqreaCXTcCbCo5J863A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Os2NaOR2Bbu5b3jkgGJqFqcz1ROSpwbuvZtOP1Gk8z1DLPK+3US7OzSnKPDNBwqxkdpRDnaC3hc8pJ6CI+Aj2/B0Vv9pPuOWYk3wfGQSZziY41Mgxwve6tIbDCYpgmfj6pYXSHShU0WTQ1IKNXs1ys9XtCtBEBwHnilDjXSSGos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+0IrxkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+0IrxkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77807C113CF;
	Tue, 26 Aug 2025 13:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216569;
	bh=n42AOn3jWDEr8HaH5Zu+K6odQqreaCXTcCbCo5J863A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+0IrxkNuwSYnTzisQ7krs+S1RV0X2npqMqwDvExMeAlI9vc1oaeR8y+RSH893RvW
	 +TUpQKBHtfdVb5aI43U/DSB4DnImiemCkedEnd3A5khqV5lJQ1cwramO9cXlNHBRt8
	 2N+OwcClkTy1eA29G8G6/vRhSN8oogkwVMxTqN7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 460/644] usb: gadget: udc: renesas_usb3: fix device leak at unbind
Date: Tue, 26 Aug 2025 13:09:11 +0200
Message-ID: <20250826110957.876018152@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 868837b0a94c6b1b1fdbc04d3ba218ca83432393 upstream.

Make sure to drop the reference to the companion device taken during
probe when the driver is unbound.

Fixes: 39facfa01c9f ("usb: gadget: udc: renesas_usb3: Add register of usb role switch")
Cc: stable@vger.kernel.org	# 4.19
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20250724091910.21092-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/renesas_usb3.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/udc/renesas_usb3.c
+++ b/drivers/usb/gadget/udc/renesas_usb3.c
@@ -2566,6 +2566,7 @@ static int renesas_usb3_remove(struct pl
 	struct renesas_usb3 *usb3 = platform_get_drvdata(pdev);
 
 	debugfs_remove_recursive(usb3->dentry);
+	put_device(usb3->host_dev);
 	device_remove_file(&pdev->dev, &dev_attr_role);
 
 	cancel_work_sync(&usb3->role_work);


