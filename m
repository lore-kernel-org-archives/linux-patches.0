Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614A334DCED;
	Tue, 26 Aug 2025 14:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218002; cv=none; b=SrD22uNWcNzNVTKPE6mhCFLhekfnHaPKsHEF16oVbmosSP70giYaoThYtjnMcrKI0LHpiPyCwL8cnmdLp1+iVMTtMj57rN7bJO0NEuSMIEqXZDNNjdkz9Bt4mNF9td/VVtWi5VRrpG10azPeS54y/eifH8Ka3A735VqvOSWbLX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218002; c=relaxed/simple;
	bh=rEqgJ3pncP/8R7LeOyhqtwd/hNlXQ5jSl1hF/Y2Vo5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7P5QGJyKlUvBi26sEmAjaELFY3z2alJmW5k3PNXTOvmHGJwR1h+RbOrIUpon5O0rO2FE04HYsyvNoSq0dCtPXJvhwo4/JhyUYmZ9ZKBjo1zW3DBGGFZTzw3RsdzyLuuvyaqZLpCZHrF0M/zPES1iww0X1RcVAtx1arNG4E15uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YeuBosOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YeuBosOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6154C4CEF1;
	Tue, 26 Aug 2025 14:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218002;
	bh=rEqgJ3pncP/8R7LeOyhqtwd/hNlXQ5jSl1hF/Y2Vo5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YeuBosOIpZ5t4H5L+ZUb9+Kcj98oJxFHxDyZx/l6sCc9wYxfQPcXMCAzMGgAP8HQh
	 x58Ig7aLaYjtBAW3ZdONYfcjVq73WUbz7Cl3K1BL9lUCUBxXke2XS6YIZm23Yu2xeh
	 84PGIVnZG6mg+hEJm2uqvhzEZIiqkN50ULWjgyNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 356/523] usb: gadget: udc: renesas_usb3: fix device leak at unbind
Date: Tue, 26 Aug 2025 13:09:26 +0200
Message-ID: <20250826110933.248072756@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


