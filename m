Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626943148B9;
	Wed,  3 Dec 2025 15:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776834; cv=none; b=Wvnz685zH9PolRd1+imxKIrJWhcPgc/Vr53wF9ND0RkApgeK/QyXQWXuSmvT7LoerRML/EVK+C8V+iZzFj+LOexRCMcR05IxfJUaNUEVzom00fuGZJuEbhpcAlSUZI5lEfA50zBeL5i7Ye/ovkddelZB86deqY2B3FHENIcKKDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776834; c=relaxed/simple;
	bh=Xecv7HMkwsvasjHJUR499MsP2FTeJ7oIdB4lvxoas68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W71cwPtk4AWp26bdIBEyyZf+5H5bbyGatFv4dnXjfIcJ8LPYnkzYYXrFJUFyYpzgxZS0Sem/d3HrPbgJpBH3qv1B1H4coG4+RLTi25MU8O95BUFpV5sVqw3Sly9scZ74FyIIclRmzJT3B6iv9yk6Pe4HmSXDm2cyFwnhQcT36I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frxUg8ZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frxUg8ZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCCCC4CEF5;
	Wed,  3 Dec 2025 15:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776834;
	bh=Xecv7HMkwsvasjHJUR499MsP2FTeJ7oIdB4lvxoas68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frxUg8ZTBFIoHVTqx2txsp7ddz/EAzxrbp4QZO5FlnaGi6oh0i9XXq6J025HYKDU1
	 dieJPaaucfvE8FGELzyJj+Mcj5xRciAXuO3vkqxf90nh+M6zqcryiOf1ohEeocia8M
	 VPykrPBE9nC0oF8k4xojksPptNWdlGOeVIXHdK0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gromm <christian.gromm@microchip.com>,
	Victoria Votokina <Victoria.Votokina@kaspersky.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 277/300] most: usb: fix double free on late probe failure
Date: Wed,  3 Dec 2025 16:28:01 +0100
Message-ID: <20251203152410.891315855@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit baadf2a5c26e802a46573eaad331b427b49aaa36 upstream.

The MOST subsystem has a non-standard registration function which frees
the interface on registration failures and on deregistration.

This unsurprisingly leads to bugs in the MOST drivers, and a couple of
recent changes turned a reference underflow and use-after-free in the
USB driver into several double free and a use-after-free on late probe
failures.

Fixes: 723de0f9171e ("staging: most: remove device from interface structure")
Fixes: 4b1270902609 ("most: usb: Fix use-after-free in hdm_disconnect")
Fixes: a8cc9e5fcb0e ("most: usb: hdm_probe: Fix calling put_device() before device initialization")
Cc: stable@vger.kernel.org
Cc: Christian Gromm <christian.gromm@microchip.com>
Cc: Victoria Votokina <Victoria.Votokina@kaspersky.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251029093029.28922-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/most/most_usb.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/most/most_usb.c b/drivers/most/most_usb.c
index 10064d7b7249..41ee169f80c5 100644
--- a/drivers/most/most_usb.c
+++ b/drivers/most/most_usb.c
@@ -1058,7 +1058,7 @@ hdm_probe(struct usb_interface *interface, const struct usb_device_id *id)
 
 	ret = most_register_interface(&mdev->iface);
 	if (ret)
-		goto err_free_busy_urbs;
+		return ret;
 
 	mutex_lock(&mdev->io_mutex);
 	if (le16_to_cpu(usb_dev->descriptor.idProduct) == USB_DEV_ID_OS81118 ||
@@ -1068,8 +1068,7 @@ hdm_probe(struct usb_interface *interface, const struct usb_device_id *id)
 		if (!mdev->dci) {
 			mutex_unlock(&mdev->io_mutex);
 			most_deregister_interface(&mdev->iface);
-			ret = -ENOMEM;
-			goto err_free_busy_urbs;
+			return -ENOMEM;
 		}
 
 		mdev->dci->dev.init_name = "dci";
@@ -1078,18 +1077,15 @@ hdm_probe(struct usb_interface *interface, const struct usb_device_id *id)
 		mdev->dci->dev.release = release_dci;
 		if (device_register(&mdev->dci->dev)) {
 			mutex_unlock(&mdev->io_mutex);
+			put_device(&mdev->dci->dev);
 			most_deregister_interface(&mdev->iface);
-			ret = -ENOMEM;
-			goto err_free_dci;
+			return -ENOMEM;
 		}
 		mdev->dci->usb_device = mdev->usb_device;
 	}
 	mutex_unlock(&mdev->io_mutex);
 	return 0;
-err_free_dci:
-	put_device(&mdev->dci->dev);
-err_free_busy_urbs:
-	kfree(mdev->busy_urbs);
+
 err_free_ep_address:
 	kfree(mdev->ep_address);
 err_free_cap:
-- 
2.52.0



