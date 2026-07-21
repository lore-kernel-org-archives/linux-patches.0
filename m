Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C6146D57B;
	Tue, 21 Jul 2026 22:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672472; cv=none; b=Pj66yL+B6nKrvZ40sXDQhgN6/23WUbNVit5cLyaCLHmVezeFw/b8HDNwakIucWlgeM3b84pCM8rY5Nt7REwyaiBBXzwZ3F2dHp3kx+OSJkXR+TPEX8FI08IH96Y1mO9WkAtJkKxKhHscXI4EwBCNJgYS8+7BhS4pVqPKRwTAuwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672472; c=relaxed/simple;
	bh=XwpGarME/tLgB4sZwna35oH5Rjw0azJeSjJ4ro9cD4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njXQce/RUgC9ajiyT6roJemedOuPFkFEEZyv/R7nd+WEzovZz7uv8bnR0WAAvRxH+IOioUiEr2pLfari5b5YJZoeQ6Ph8IQ+n7MPYsMmdb91YxG+7lJ+5WkTjNZPgQdDofVWCmWA+sRgWcmSqqOsh+n6IJWMqkPtyF9UngGHWiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4tAEIKh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4tAEIKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476FC1F000E9;
	Tue, 21 Jul 2026 22:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672470;
	bh=5G/mDRJakTFNKFlQfc8dN86JBTU8SxemIDFpUmvfG/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4tAEIKhzp9KRHaykgoK/TDSInHAn0162O6YvAw12Zj0kIdsTBntDPL8rzVN3RG/4
	 nuPAJpk3LQ9kGcUtAArU4ApkAHY96Q36Lbr7NdJMMs3G7O4gxIWK7Hfkc6d7/3HJzs
	 wnRvoSCHfhMzaqoFsQ9t6w0Dx2crdcpNPGyw8lak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.15 584/843] mfd: sm501: Fix reference leak on failed device registration
Date: Tue, 21 Jul 2026 17:23:39 +0200
Message-ID: <20260721152419.185007783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 8c2f0b42fc252e1bf1c7746447091a468e784ca1 upstream.

When platform_device_register() fails in sm501_register_device(), the
embedded struct device in pdev has already been initialized by
device_initialize(), but the failure path only reports the error and
returns without dropping the device reference for the current platform
device:

  sm501_register_device()
    -> platform_device_register(pdev)
       -> device_initialize(&pdev->dev)
       -> setup_pdev_dma_masks(pdev)
       -> platform_device_add(pdev)

This leads to a reference leak when platform_device_register() fails.
Fix this by calling platform_device_put() before returning the error.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: b6d6454fdb66f ("[PATCH] mfd: SM501 core driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260415162627.3558789-1-lgs201920130244@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/sm501.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -747,9 +747,11 @@ static int sm501_register_device(struct
 	if (ret >= 0) {
 		dev_dbg(sm->dev, "registered %s\n", pdev->name);
 		list_add_tail(&smdev->list, &sm->devices);
-	} else
+	} else {
 		dev_err(sm->dev, "error registering %s (%d)\n",
 			pdev->name, ret);
+		platform_device_put(pdev);
+	}
 
 	return ret;
 }


