Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE32F391832;
	Wed, 23 Sep 2026 14:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174740; cv=none; b=mZnasECI1kyfss/5S4DVotyd9H+esK2ej08zAeWdmGHhZRhnfG2R7p81qBGm3z9i6Tu80XlAPuHeN9++jzp77Vv8y34YLcCgvzQKHEI/8JPubb6tQ2p26oG1aGT6R+IwdRRLpqZCpnKJD53hhLUTg1BkjG7qIACzY25yXoKB3j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174740; c=relaxed/simple;
	bh=pA86XsBFU5wxKpf58K54aeEdXiiCPKln8HUhUF5cOaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+m/wz64KaMm1b9UX52/+SDVARidZ1WI2POilBkJDkOh2W9eyUDXg+gHSYRxaexpnaivV2qr7Au8YmK9NKylEKuwYAQGQVhdS4DdU8eSytGu3OPy2LRzv7nRmnW20Zj/XWmHg//hoKmVZ7OdrWt6qhPRWKqutlon5oXWD8ubB3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqbiMfly; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqbiMfly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB651F000FF;
	Wed, 23 Sep 2026 14:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174738;
	bh=v1+Q8cfLAvuvr8TaZ9dNn+foFPlOPlzT8SDoY3g0StQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RqbiMflyqIsa1UtvrtIPXVJlwxns6oECJfoc3bUdq53/bnFOsVG5p/a7cP2ciHeom
	 7YZLdz6QYSNFqCMEqUUTR9ZIauQnm8fT+TkIkbDiMA3oMvzQ4U7gBOUEGDr+e4ss3r
	 laPkNH7EW4zowLHvSukoW4of0S9X2Q8I+oLnj43Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.18 203/398] ata: libahci_platform: Fix device reference leak in ahci_platform_get_resources()
Date: Wed, 23 Sep 2026 16:04:37 +0200
Message-ID: <20260923140648.684384598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


