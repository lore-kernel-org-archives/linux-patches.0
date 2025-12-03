Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AA234CFC2;
	Wed,  3 Dec 2025 16:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780779; cv=none; b=V4Cq96QpW2/fcR6nwoOkBfwRVxrXDkPoyxSwkQtedTlSVz/5Z1Q++Jt/ZYvDWz98rfzXAgXeZh/bSdMLT/CpTiuOVH+ptncK1tYTG4tTup8Ua6pBbqed0vxgvWpgaou2nyElADmxO2DHQwirKg5T7g+5Oo4hsJ3OLeJKnT5Mxsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780779; c=relaxed/simple;
	bh=F/NplFP2+BUPKhiyrN7BOrayz41zJFL3kt9nyU4Zm3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDpXuFIlcRSGGN6WEmgBqkELuRV0XELLnjjbAm5xta0ofhBlrEbJLt+mZo3Qnt9E8ID8c7g+6c8Z+BWma79nP9Y3dSxelOZFRZdECtJCzK/Jtzpdf8Z/KaWF0qJvPahURNZLq/Dweg/79ol9qPv3gGhhsL/VLnX5A34VO9fZYEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjLYb4Xc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjLYb4Xc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5D7C4CEF5;
	Wed,  3 Dec 2025 16:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780779;
	bh=F/NplFP2+BUPKhiyrN7BOrayz41zJFL3kt9nyU4Zm3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WjLYb4XcnZAn/wCNbpigGVA7Z22m9q5wxNRMv2dc6dC4G88myxUK0T0W3WMMMTaGE
	 rF9Wl+dBkkK2FOna1GXCivEngSg/1Y22bPhPL7TUHt6p60WcmZktiHgiUQP39aPY6w
	 s8LRhXqNSIeM2mymZ7ydf8BeiOVw/7F182wiKYt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gromm <christian.gromm@microchip.com>,
	Victoria Votokina <Victoria.Votokina@kaspersky.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 087/132] most: usb: fix double free on late probe failure
Date: Wed,  3 Dec 2025 16:29:26 +0100
Message-ID: <20251203152346.515168742@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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
 drivers/most/most_usb.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/drivers/most/most_usb.c
+++ b/drivers/most/most_usb.c
@@ -1058,7 +1058,7 @@ hdm_probe(struct usb_interface *interfac
 
 	ret = most_register_interface(&mdev->iface);
 	if (ret)
-		goto err_free_busy_urbs;
+		return ret;
 
 	mutex_lock(&mdev->io_mutex);
 	if (le16_to_cpu(usb_dev->descriptor.idProduct) == USB_DEV_ID_OS81118 ||
@@ -1068,8 +1068,7 @@ hdm_probe(struct usb_interface *interfac
 		if (!mdev->dci) {
 			mutex_unlock(&mdev->io_mutex);
 			most_deregister_interface(&mdev->iface);
-			ret = -ENOMEM;
-			goto err_free_busy_urbs;
+			return -ENOMEM;
 		}
 
 		mdev->dci->dev.init_name = "dci";
@@ -1078,18 +1077,15 @@ hdm_probe(struct usb_interface *interfac
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


