Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048291;
	b=meFplwl21JRMgjFZxWJkfv4ipTqMKmuWPP24jIVh90vVpa5TzLsFN8zUAhrRODQ2NiFc
	 QwyilEmAXRwZ4CnVWs0Thm9E0zkdSp4TCk6PkxRLTaGNmzY1d4OvmOsMWut8NwihLdjR2
	 DV7kQE9Axr+r6AGe55VJJxFBp6DyRYTZD++wkFlMGmB85BMkM65PNrzd4xwenHH6ojAM1
	 6EDnU725YC0ibSB5cC4ZDpRTPiKkmJpCbOFkNoBA1JDirT+K7kK8lBVjl0+UETLvyKIie
	 sDG5QnPrHcDQNmvb2YDAZJ8hpnV5k98+QHEtick3FHSY0lv14rQyGA7E62UIzzNM58g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tJ3/nEhNX9fjTXEl6yLBs6KFKYpTRtHaljIXZHXxIUo=;
	b=qp/84UoIbWffhQRCG/YHDUN07s4iOHiYpYWGFg4ZWsEaY0LF4T1X11w9ncI8+DQXOtm+
	 UVa5SipYKddjCJ1BpdiPOaVeNc3I5J+NoswC1bNvXManfhZO2BeEN6bJChbkkprzn+zcM
	 /+2uVJqugkmy8xgawjOLdOehv1OTibrRCtbh4q1jANh8/amuMbh/YJNrvmCDXEFSX5GCw
	 krxofgUM7qWBFLknUWq178Zb2NMkO0gWNuQPqVoUhs7aZgLiCNTttVC8uzLgbTzh2zhCg
	 o41xeJF5tm8DkMk3fGwcCQG2xZ/7m7j0FUaGR27lbnXdP0w13qWNIlMeoAS5QIdPokw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qn9lVEbx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AC2606A31C;
	Thu, 19 Nov 2026 00:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qn9lVEbx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE751F000C4;
	Thu, 19 Nov 2026 00:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048291;
	bh=tJ3/nEhNX9fjTXEl6yLBs6KFKYpTRtHaljIXZHXxIUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qn9lVEbx32q/MTY3QuM/RycLit3Am5Wk0Kk1xfpl5LWaAoHhyF2XpubhXUlsfe2MF
	 aAlUsbgb6bEXRU5VY+7lyEFc8wiFo1SicTsZXCJi2xaKuVvIwSCFoFtOd0lxNZQZjk
	 D5xJe7HzOX2LIgGiQ6b1N99upGZq0KSfq26ikjGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miles Krause <mileskrause5200@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1940/2857] memory: emif: fix device_node reference leak on np_ddr
Date: Wed, 18 Nov 2026 15:49:34 +0100
Message-ID: <20261118150311.063788210@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miles Krause <mileskrause5200@gmail.com>

[ Upstream commit 314ef67d673284d4c070455bd62d332f6d0f8634 ]

of_get_memory_device_details() takes a reference on the DDR device
node via of_parse_phandle() and stores it in emif->np_ddr for later
use, but drops that reference without calling of_node_put() on two
error paths: the devm_kzalloc() allocation-failure check and the
is_dev_data_valid() check. Both return NULL immediately, leaking the
node reference each time either failure triggers.

The same reference is also never released on the success path: it is
kept for the life of the bound device (compared against a later
instance's np_ddr in the duplicate-DDR-geometry check) but
emif_remove() never calls of_node_put() on it, leaking it every time
an EMIF device unbinds. of_node_put() on a NULL pointer is a no-op, so
this is also safe for the non-DT get_device_details() path, where
np_ddr is left NULL by devm_kzalloc().

Fixes: e6b42eb6a66c ("memory: emif: add device tree support to emif driver")
Signed-off-by: Miles Krause <mileskrause5200@gmail.com>
Link: https://patch.msgid.link/20260909-master-v1-1-8800f5647ab2@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/emif.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 434982545be63..22d12d7f86ac7 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -937,6 +937,7 @@ static struct emif_data * __init_or_module of_get_memory_device_details(
 	if (!emif || !pd || !dev_info) {
 		dev_err(dev, "%s: Out of memory!!\n",
 			__func__);
+		of_node_put(np_ddr);
 		goto error;
 	}
 
@@ -961,6 +962,7 @@ static struct emif_data * __init_or_module of_get_memory_device_details(
 			pd->device_info->io_width, pd->phy_type, pd->ip_rev,
 			emif->dev)) {
 		dev_err(dev, "%s: invalid device data!!\n", __func__);
+		of_node_put(np_ddr);
 		goto error;
 	}
 	/*
@@ -1164,6 +1166,7 @@ static void __exit emif_remove(struct platform_device *pdev)
 	struct emif_data *emif = platform_get_drvdata(pdev);
 
 	emif_debugfs_exit(emif);
+	of_node_put(emif->np_ddr);
 }
 
 static void emif_shutdown(struct platform_device *pdev)
-- 
2.53.0



