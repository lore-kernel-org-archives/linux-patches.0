Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B77425CFF;
	Tue, 16 Jun 2026 15:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622023; cv=none; b=jUN8OaMiqd7amWM13JTUQvXcNVjU/SsP+Rm+2+I9lAZnTlEDCPh6NnJ+kZjL9ezpNGwud8/7Ffgpt8RTx7rrp5qcGpurADFHeWBqIzn5g+PaA1EtidBdK8g1mBjXDH/iWopmt4PBOSaRM2kvmePrvaKfv4+CyWaobskmYeiQizo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622023; c=relaxed/simple;
	bh=Wwq/KYiOKFLNxA4GOrJg381N4ZtOyK0KCci4Pq1qXkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xd6x5oiT1/KXFqZnzVkFzinxoL4fdPMWCGLTDDH4X/RffaXmxhfJigfaUCGz6V2fLu/nJsJXh49tTURqS54o5BXu1Z90J6h9m2Zo4WPKFtr56B9q5e1RnGBfseDxe0F6o1HIa0qi2DitWf3ye0D/AfHLAFYxc2joVw1SMBemIlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNWPL80X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNWPL80X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE2E1F00A3A;
	Tue, 16 Jun 2026 15:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622022;
	bh=c9S9/2W39+1KMTSr0J3sFpjeWCSmPuPXducFJLmWc/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNWPL80XcGMirwkNOOjyu3jeOGp8CuBl3nxaGBalhFIz8WcFZgkQlbi9NbbTRNFlt
	 HF/g5Aqm8IANpL8u5gbIWql0PD2BhSAP29QJ175rwqiptvbc9mbo4vttdetGYZc4Zf
	 eJzj5eV40/C8rb6otO0ZG71sFczWcnDiellOpGk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 7.1 2/8] driver core: faux: fix root device registration
Date: Tue, 16 Jun 2026 20:28:47 +0530
Message-ID: <20260616145523.407123558@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145523.335696673@linuxfoundation.org>
References: <20260616145523.335696673@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 580a795105dae2ef1622df72a27a8fb0605e2f6b upstream.

A recent change made the faux bus root device be allocated dynamically
but failed to provide a release function to free the memory when the
last reference is dropped (on theoretical failure to register the device
or bus).

Fix this by using root_device_register() instead of open coding.

Also add the missing sanity check when registering faux devices to avoid
use-after-free if the bus failed to register (which would previously
have triggered a bunch of use-after-free warnings).

Fixes: 61b76d07d2b4 ("driver core: faux: stop using static struct device")
Cc: stable@vger.kernel.org	# 7.0
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260424153127.2647405-2-johan@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/faux.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/base/faux.c
+++ b/drivers/base/faux.c
@@ -133,6 +133,9 @@ struct faux_device *faux_device_create_w
 	struct device *dev;
 	int ret;
 
+	if (!faux_bus_root)
+		return NULL;
+
 	faux_obj = kzalloc_obj(*faux_obj);
 	if (!faux_obj)
 		return NULL;
@@ -232,19 +235,12 @@ EXPORT_SYMBOL_GPL(faux_device_destroy);
 
 int __init faux_bus_init(void)
 {
+	struct device *root;
 	int ret;
 
-	faux_bus_root = kzalloc_obj(*faux_bus_root);
-	if (!faux_bus_root)
-		return -ENOMEM;
-
-	dev_set_name(faux_bus_root, "faux");
-
-	ret = device_register(faux_bus_root);
-	if (ret) {
-		put_device(faux_bus_root);
-		return ret;
-	}
+	root = root_device_register("faux");
+	if (IS_ERR(root))
+		return PTR_ERR(root);
 
 	ret = bus_register(&faux_bus_type);
 	if (ret)
@@ -254,12 +250,14 @@ int __init faux_bus_init(void)
 	if (ret)
 		goto error_driver;
 
+	faux_bus_root = root;
+
 	return ret;
 
 error_driver:
 	bus_unregister(&faux_bus_type);
 
 error_bus:
-	device_unregister(faux_bus_root);
+	root_device_unregister(root);
 	return ret;
 }


