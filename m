Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1554E36D0;
	Wed, 30 Sep 2026 17:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788559; cv=none; b=PxI9593VnRxFiOu3B6kCWM8uNejxTHzQ1sNodRj60Pq44IYGAwrGVFlO+NdohLTAfFUgmPTEH4SPItNEck4pWkjTH6aDwWF3fMxtPjRZliRxTkG6o4ySH7HK1V/c0Xn2kzirDprfZFdVxQp+F+UFgf0UXy/RoFxLMRrZc1NvKNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788559; c=relaxed/simple;
	bh=F+CGvYtOAcuL2R/GcIXy/P96CenqOWDGmgIkFYTx78k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8UC49QBMU7wsaprtrbo0mzPUvbLNtELMVHLMrTWs3mAmSfqLvAZDpIneRviXeGzUC8rBubIdx/f3V9J2VaCTW6ogxPnlo4pyJiYwtllpg8OkRhN844Zs2vkHKlT09Ci/NfjGdi90CKmt78LOwLbN9+YGNqU0N9dm8v+SVXgF5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERjrs03B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERjrs03B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559871F000FF;
	Wed, 30 Sep 2026 17:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788557;
	bh=DDRnkGjob4+0YCP4sgJVszeS3X31WvwlyIy6O8MX3W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERjrs03Bim9PosrQmXal2ORYKBDEH8eJ9jRSQ49PW+hNRbW3XzTxHEuLdxG7yjlRQ
	 3tusg0vzhmhgJl+6SoYyasA+tZbG21MDydXUYzhj++/JT9IEqREgczkqWUQ5kYUiYK
	 nkqo64MekuPb3Nb5P2AsFzHZOk1VxR+OpawllYSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.12 168/877] ata: libahci_platform: Fix device reference leak in ahci_platform_get_resources()
Date: Wed, 30 Sep 2026 17:17:59 +0200
Message-ID: <20260930152418.349706419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 0d1cb83337f13af082afb68b28d3fdfe29cde7fb upstream.

of_find_device_by_node() takes a reference on the port platform device,
which is only used to look up its port regulator and is never released,
neither on success nor on the error paths. Drop the reference with
put_device() once the regulator has been obtained, which covers both the
success and error paths.

Fixes: c7d7ddee7e24 ("ata: libahci: Allow using multiple regulators")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/r/20260915065933.1733061-1-vulab@iscas.ac.cn
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libahci_platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -623,10 +623,10 @@ struct ahci_host_priv *ahci_platform_get
 			of_platform_device_create(child, NULL, NULL);
 
 			port_dev = of_find_device_by_node(child);
-
 			if (port_dev) {
 				rc = ahci_platform_get_regulator(hpriv, port,
 								&port_dev->dev);
+				put_device(&port_dev->dev);
 				if (rc == -EPROBE_DEFER)
 					goto err_out;
 			}


