Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039778;
	b=HtE7ppGj9DMhkEywUncduoHnCsM0d4Q2yZ5dGObRQwXpJmXEi7B9a8iOQtPF9cisn72i
	 YY1EnsMdA0mXMrEvQjnj+yQ/+mwk8KZdOPs7SZ3ue3Eed52zPLaBakJeTEaQo8nolreYB
	 eEEhGEexfZTznxokMBOzxQJLY1zv9LZ02jqwIUu+hlpUwDpTDks7iXNSyivi4rHZw59Y2
	 Yb+dwKn7jvE89VjLxHUUj3/ZS2KilYuxvwOBb+jIYP5sbiHZLaDuhLkkHuCJ6NVHVL2SJ
	 ftPuXGL6r5lE4yh/ftkAK4nYuonp/JulzB0yX/VERHTkuuWHOT+ofGRA7xGfAA9gptw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aW3ViU9EkJfGSPv3MiGO3RLpu1WrYA4DKIGQi743xxo=;
	b=i5ENVXl34uJl5qGPryvgu/opkxVtRe6Po/tkKsym9pwMLKJaaPDfeXUXNiBtKPRGpALM
	 YxQ4PFKt7FeQrvZZrNrzGU3bEk/JMgkYw48QKeJ27wqvu3oTi+wpakC9HZDyb4woHSSP3
	 BhRbp50CkztEfwgoZBzUqOLvTYkNT/m6I+BoqOg92/vboQQL3XZjwZ+VqtyPTgvYN4xr/
	 QBlWK2U2qH68o2iuHJOjPODsVckhEEoYf1ViNPqcS1vnY/JDhrU0UbIARSQ7HhsELvvxr
	 IRz511Hl1wVXV9EA9dgPZ7r0pKSMoudTDTRPzfhsL0iXuTBFcw7L2vXP9Nybsa4//sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vqAyP/YQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BAB606A31C;
	Wed, 18 Nov 2026 22:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vqAyP/YQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3EE1F000C4;
	Wed, 18 Nov 2026 22:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039778;
	bh=aW3ViU9EkJfGSPv3MiGO3RLpu1WrYA4DKIGQi743xxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vqAyP/YQqX+8TmEOkeSaV1ZnxLDrQYqNoFrg8kRBbZ8c9qd8I9aOJDgstGg13a047
	 oTRjg2srdAJmRC1rDBsKHvGtQWW2c+aFX/nyajr+TPfOsXJYuReSppWvGyj1DTuVYZ
	 ol2BZVmoGnrKUzhI+mfeRGaEEl1Sgu+qIVLl8SwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miles Krause <mileskrause5200@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2221/3318] memory: emif: fix device_node reference leak on np_ddr
Date: Wed, 18 Nov 2026 15:47:23 +0100
Message-ID: <20261118150428.523423874@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



