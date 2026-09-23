Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EA3418368;
	Wed, 23 Sep 2026 14:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173430; cv=none; b=L8kqgNiUd2fkXba1F7Eds3s1grW1UJ5arJq1kpPMpzqp7EtPD6L0tjUTdUmK4hV0r4QzmyBEn9GUvoMkOUUv0VSiwc7GAWQnUoQmFFu7obwFZphTIq4ubUz0sBnZZMLkcxEb8yY+mP3v1Ij9W8a73xRhnazC5sgxC94ubpQq/wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173430; c=relaxed/simple;
	bh=1BIbtlLQsCt224VCsLtHOVEO8mTeFJcMD+34yn5jht0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIKbehUnJAWCwwtwI4F6xX5oa5FELlFqyJ/GFsLVNXE36uKC/cIm+2yLTs9G7wp58WOQWJ4+uekKiXVexNVyOHWaOsUwkSkrRDlMf86MT4YEXXyoB86O2XMa2wTY2S3hv8fMNHh8JmFb8D4pSvk9fEC2AzXnGltGYIC0EoW7dvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UtqMSuY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UtqMSuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF1F1F000FF;
	Wed, 23 Sep 2026 14:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173428;
	bh=87tk47gfXUkWSgr2yjhyvWk5fnfMOQiL18U2X2/SVh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0UtqMSuY2HvR88jMrRlpbp8ik/JwMywcuiW0NbUiloM3nUTzii1uL7xXrRTn2KjNT
	 q1XDbyyXQdKKGRzojcA3ZZLaG1usa00P6GLkn61YkACnxnIntOTf1jxIy5qBdUyH3j
	 +hUspR0MFHC1ZMovvQnHcTYmYP9pwNz1ckQM2eK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 7.2 243/438] ata: libahci_platform: Fix device reference leak in ahci_platform_get_resources()
Date: Wed, 23 Sep 2026 16:04:24 +0200
Message-ID: <20260923140651.070074536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -620,10 +620,10 @@ struct ahci_host_priv *ahci_platform_get
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


