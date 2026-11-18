Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060587;
	b=KkhaTAiBFi9gRfOCuaSUh7iFSLq2e9y8KrT77x4aWTTcEHCyRZ1E0R2AE/TaMNk/kW7/
	 NQRkC9B4ZtVAbZptM09bkSjS8+z3xqDCI7dUL7wmz3oZfuDNHv8lysP6Kpcni4eW032Pt
	 9+OvVJVrEWGhrjz5zR7NDjFPZLxsYHs2joWXuVyVY7yl1BZgRWMq3Zp7Y5KYy2HLK/qBK
	 AP8JfsDBXwaAWjVSwF37+dn/Ip5ALWO0F/k9IniNv73zItFaiISrZyRKCAZ2z6LR/04Ch
	 GYXPfyv+n2tsCldGzCfXxYDF1Qrm1yR2XczsGtv1rEEEOddBM4WzoLaC4RofcHnrBWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6ebory/Oh0utktW5AqHuvkII1p8MaQmkbInKhW1KGrw=;
	b=spiZtmxeZ8tkxlfxTnFwRWa4AWOnjvZlFfvJBAVz8Ja/YDyw/9Cqzs11LO6nb/lDmjwX
	 RB8fNQwAv/9nhk8BsVwf+2aToX0LRrZfVI6ohdDC5cjDZZ2nZDqjnmQj+N09QHfNmKle3
	 GIKplWF8T1hI8gP1Cic9uwtoPAm390T3k6ZCiNFJlsEbZYvYFOcfyhgOQYCgaISNlWRo2
	 Rg6hyOT+LksTsgutPeB9dLDhzzmMHFmOq1WLE+RDbZLcCey7sLuBGN8MkImDWOnvOY59c
	 z6JFRy3rlrYCGFdpQYAHk1jqb5COx4Ltoq2LPbePn3vl7aX8faonsarDYaaSzvP1kcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u2vu3Oiz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3320C606A320;
	Thu, 19 Nov 2026 03:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u2vu3Oiz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F821F000C4;
	Thu, 19 Nov 2026 03:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060586;
	bh=6ebory/Oh0utktW5AqHuvkII1p8MaQmkbInKhW1KGrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u2vu3OizWwiRxcecykg/7mOv2LvmfyoCBcLelZQ4QSiv4VUw8MV/FXTYbr2h/N3OQ
	 IsiVYBYWAjzlsaRA2NBnBxPp5to9GOjjDXMp59foYdkec92aHBrVLAuytVJd1qnJrQ
	 OKTZH+K98o4Ifo8YsJNPFlhr21mUW5Amo+3VUI7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miles Krause <mileskrause5200@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1253/1848] memory: emif: fix device_node reference leak on np_ddr
Date: Wed, 18 Nov 2026 15:54:51 +0100
Message-ID: <20261118150012.221485498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 234ffddabfc60..38491b1018c7b 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -1315,6 +1315,7 @@ static struct emif_data * __init_or_module of_get_memory_device_details(
 	if (!emif || !pd || !dev_info) {
 		dev_err(dev, "%s: Out of memory!!\n",
 			__func__);
+		of_node_put(np_ddr);
 		goto error;
 	}
 
@@ -1339,6 +1340,7 @@ static struct emif_data * __init_or_module of_get_memory_device_details(
 			pd->device_info->io_width, pd->phy_type, pd->ip_rev,
 			emif->dev)) {
 		dev_err(dev, "%s: invalid device data!!\n", __func__);
+		of_node_put(np_ddr);
 		goto error;
 	}
 	/*
@@ -1555,6 +1557,7 @@ static void __exit emif_remove(struct platform_device *pdev)
 	struct emif_data *emif = platform_get_drvdata(pdev);
 
 	emif_debugfs_exit(emif);
+	of_node_put(emif->np_ddr);
 }
 
 static void emif_shutdown(struct platform_device *pdev)
-- 
2.53.0



