Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E406322524;
	Tue, 26 Aug 2025 11:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207101; cv=none; b=WoAfZRK+8iMoFM0BtijA4xjd+rpQqZ2pKW9rbQUU+caABxg8WSYPopzBMTDhe2m6Al5oXLV66r39/LvOSDnyeLGGXKyZ+A/VtiAn5LrfnUahudqio4zhrNCRwJui4GShlO/iY7ACf7G1a/BVsmOE2heN+K0HukjKXyHDtQ6364c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207101; c=relaxed/simple;
	bh=yhFRPgUtTOVwfYitBtgSPYU/A3PhBbHsfvqLEqVtWL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3QT1Qmy8wcQGS1vO2XjBkgXi8GDYnykkMARLXbYTlVmzO+gNNPGP3HC3FD9fSDjCSN/nw/fIrx+i99jG9fZDAPXWKUZzfWghSHeVtvqFxb9KJ5BjXDZpwFVQCmZExBWM8b+6CWMMjQopFo8N2zeffVKy11YuNkr0LN048yyyHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ul7lMGQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ul7lMGQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E301FC4CEF1;
	Tue, 26 Aug 2025 11:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207101;
	bh=yhFRPgUtTOVwfYitBtgSPYU/A3PhBbHsfvqLEqVtWL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ul7lMGQVpnpdEjFiKlIBRLvWt3WOW1NttdEtE/b5dhug4sUTfcOaOpXuB/xMEjiZH
	 yZws39oDrH3hBkD8IIdlLwXP3q+dyAzbIQTaNfQXVNfvDETmAk3lwjIgJSdFxHsPck
	 xURTvI1R7mK9vSnqpi63YC9Tb5MA/IqFBujZ1ISk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.16 011/457] usb: gadget: udc: renesas_usb3: fix device leak at unbind
Date: Tue, 26 Aug 2025 13:04:55 +0200
Message-ID: <20250826110937.592838655@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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
@@ -2657,6 +2657,7 @@ static void renesas_usb3_remove(struct p
 	struct renesas_usb3 *usb3 = platform_get_drvdata(pdev);
 
 	debugfs_remove_recursive(usb3->dentry);
+	put_device(usb3->host_dev);
 	device_remove_file(&pdev->dev, &dev_attr_role);
 
 	cancel_work_sync(&usb3->role_work);


