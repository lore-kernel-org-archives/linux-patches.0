Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3988125333E;
	Tue, 20 May 2025 14:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750391; cv=none; b=Tis5p0x3rStgeoc1pQ6LeAuiRvST2b8775al296li0RaNGix/RKfyNGPrpukLXLxxVxKPoQ6Uukz+/6qSRkEAnXMPoebizn1wk3jWAoiVW+bC/1B7S5lJBeHdo6NBkBhvCKkvGAtwPHz4cJeNZnZG3OZfZfo6DpyYBLLKd3PlnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750391; c=relaxed/simple;
	bh=Ii81AJZjOWz9wsvfQVS7ZqtGwmnVwjBi05Q0k3Pm1v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQNKIZi+TvUhNcvdi5hnLhL3Ei1dhxlB2opYJUPKyFEabrwDHKEepD5fUROhd/an5iiHJGatflazCTsiDXtSFF7uRblSxOwEKNRV7/1sVDLoLvijcq4e2+A4U4wGl13sJw3mjZWQaeVjdqfU4IxnnMknnzpuPrkTYIdvwXhKn+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IntQWaxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IntQWaxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44240C4CEE9;
	Tue, 20 May 2025 14:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750390;
	bh=Ii81AJZjOWz9wsvfQVS7ZqtGwmnVwjBi05Q0k3Pm1v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IntQWaxnqKj/YkVTDRJFJLvwHoq0mWMuNSyGt5smYx34ZIP6s1HgSxZd9IHMcmZn/
	 pbyYKibwsntPa9O6yJY1bY5ka02zRusdAzt3+X6zZYjy81eMpWgi3edidcsEWYRg8T
	 AVfP4zxm/pnVxjiLNWZAqaLj/uP0lne+6WZi+pQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Thierry Reding <treding@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 107/143] phy: Fix error handling in tegra_xusb_port_init
Date: Tue, 20 May 2025 15:51:02 +0200
Message-ID: <20250520125814.248820190@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit b2ea5f49580c0762d17d80d8083cb89bc3acf74f upstream.

If device_add() fails, do not use device_unregister() for error
handling. device_unregister() consists two functions: device_del() and
put_device(). device_unregister() should only be called after
device_add() succeeded because device_del() undoes what device_add()
does if successful. Change device_unregister() to put_device() call
before returning from the function.

As comment of device_add() says, 'if device_add() succeeds, you should
call device_del() when you want to get rid of it. If device_add() has
not succeeded, use only put_device() to drop the reference count'.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 53d2a715c240 ("phy: Add Tegra XUSB pad controller support")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20250303072739.3874987-1-make24@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/tegra/xusb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/phy/tegra/xusb.c
+++ b/drivers/phy/tegra/xusb.c
@@ -548,16 +548,16 @@ static int tegra_xusb_port_init(struct t
 
 	err = dev_set_name(&port->dev, "%s-%u", name, index);
 	if (err < 0)
-		goto unregister;
+		goto put_device;
 
 	err = device_add(&port->dev);
 	if (err < 0)
-		goto unregister;
+		goto put_device;
 
 	return 0;
 
-unregister:
-	device_unregister(&port->dev);
+put_device:
+	put_device(&port->dev);
 	return err;
 }
 


