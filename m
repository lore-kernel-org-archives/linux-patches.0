Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90002FA0FD;
	Tue, 12 Aug 2025 17:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020277; cv=none; b=K5Oumv+V8fM+A782Zvl5CJWG/MT1bxeL90d1v8i/uqDxoLNFHzYFE9ytqNsIvtCK6s8h9C8SCKqnxCTxDo0pDpifN2s8V/xOu5TLHGY0kZV5Xe6FFKKX969upz5iHr8g9lAv87LF03brQdqUXEfcpKS2v5LuRbnjoZyyWli8lL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020277; c=relaxed/simple;
	bh=arEqBiHFuH6ODIb9AEMEFDlwR84cvZGpCh4u0nFHKIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5v1gESvjfms7Cwp6JjJlpWusd5RIVtJfSK1BC02OLaJf9LT5sfY+gLDAN9sQEvl70iKqXdyvv7PCtDtqljAEG6CH8m2xIhgv9qH999isXdsmcASj5vfnSWot1M/pnFj9xBtR9vfXFOMn0vD0mvCIu50Y/owScK15AmcEn1mh/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDlrx5+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDlrx5+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAD5C4CEF0;
	Tue, 12 Aug 2025 17:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020277;
	bh=arEqBiHFuH6ODIb9AEMEFDlwR84cvZGpCh4u0nFHKIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDlrx5+xMLDJTD1NwhJ/mboPjWI/taX6/MULhxic9f4OkeUgtfy6mLNitgAxo0ClP
	 VTvSkj6J9xwcww+VIzw0XMT2f+kaz213Z2KOROglaOV4WwVwR1PTKIKw22MYme3d4V
	 yCeZrooK4qkIlYA/7pm1SjU73aMkULopFhB89Scs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 033/253] dpaa2-switch: Fix device reference count leak in MAC endpoint handling
Date: Tue, 12 Aug 2025 19:27:01 +0200
Message-ID: <20250812172950.140833444@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 96e056ffba912ef18a72177f71956a5b347b5177 upstream.

The fsl_mc_get_endpoint() function uses device_find_child() for
localization, which implicitly calls get_device() to increment the
device's reference count before returning the pointer. However, the
caller dpaa2_switch_port_connect_mac() fails to properly release this
reference in multiple scenarios. We should call put_device() to
decrement reference count properly.

As comment of device_find_child() says, 'NOTE: you will need to drop
the reference with put_device() after use'.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 84cba72956fd ("dpaa2-switch: integrate the MAC endpoint support")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250717022309.3339976-3-make24@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1439,12 +1439,19 @@ static int dpaa2_switch_port_connect_mac
 	if (PTR_ERR(dpmac_dev) == -EPROBE_DEFER)
 		return PTR_ERR(dpmac_dev);
 
-	if (IS_ERR(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
+	if (IS_ERR(dpmac_dev))
 		return 0;
 
+	if (dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type) {
+		err = 0;
+		goto out_put_device;
+	}
+
 	mac = kzalloc(sizeof(*mac), GFP_KERNEL);
-	if (!mac)
-		return -ENOMEM;
+	if (!mac) {
+		err = -ENOMEM;
+		goto out_put_device;
+	}
 
 	mac->mc_dev = dpmac_dev;
 	mac->mc_io = port_priv->ethsw_data->mc_io;
@@ -1472,6 +1479,8 @@ err_close_mac:
 	port_priv->mac = NULL;
 err_free_mac:
 	kfree(mac);
+out_put_device:
+	put_device(&dpmac_dev->dev);
 	return err;
 }
 


