Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055227;
	b=hFBXjEb4cNR1yHG845mOoLNuEeY7NxI6Z2V6jhG7sIczMmZN88HL3b3mCVNp1yob9Lt+
	 9zP3hOYrpyDp0AEMKsLQHDyL9nghykG09otfPNuREIRZQmrFrZf+rEsFYXONVGgRe3iUN
	 QGX0yc4DydnqWTJJFlSuU23ec9YlcBB/rlQslPMYBtViZh4NfdAovCoHklMt0uiBdGbks
	 fzh+NV7NGBp9fjUY/UG/WHHOdXXlyYGY84ENnGBpddyXqjs1FkBN/ZmqfTkTqtrI6MuAO
	 TBpwcrNOcvpAcwROOEgskaAu5N2jEDt4HJ+EWQGTiuEx+xqgEDhfPHwIpF8sXlb2ovQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dyq9dfnlW0ZV9dgNqlZTCNi8/ogos/QLzVgfoMpridM=;
	b=IsGdRp0SgjSA8QMWm4RVWouozeyUSo9XeFxkjC9uJBjWakG47Hashn3J1xNrGRT1b4B7
	 8FlkL2N77Q4oTTWHi0LM4J1tZEUt/+ZJcM7nfUSolknzDJP/GSHTJvn23g57y2j98p45X
	 n/DDnpyoGQUPFGeaTjrReYq8w+3DisUQ3OcMz1I8wLs/FRWImaZvsUcDXZwiivU45vHSs
	 egEtUTUAgcBIlVwE1OmcPXf9TJBfw4OGuWI5LEwFe3w9oDCVa5ybLYSLi6fUqbr0NfLK/
	 VaRwnFkQ6WdXvAGVmJ2SXwYjqAN46IRS0RaQwvGRrq/4I3AoB2LcHPGJZBjgn/6tQDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lBOhkLxx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168EF606A325;
	Thu, 19 Nov 2026 02:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lBOhkLxx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0741F000C4;
	Thu, 19 Nov 2026 02:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055226;
	bh=dyq9dfnlW0ZV9dgNqlZTCNi8/ogos/QLzVgfoMpridM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBOhkLxx0MUl9mIOmbxRvsKb22KUiD1wVsEhS3cyPc9xIY5/9U4YwpLm4orcY2jbd
	 p+rwQWzEaVZ0kk0Hboo+uARcW1uqSV/oDXpHy2BQfqoazQYlbi003r6B4lYSr3+JzU
	 QNUVkznQIqmy9FGFa4N0YpFpeTDmzVtDUI4VCHKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miles Krause <mileskrause5200@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1505/2214] memory: emif: fix device_node reference leak on np_ddr
Date: Wed, 18 Nov 2026 15:53:01 +0100
Message-ID: <20261118150112.157259801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ca800aa3c59df..8a7440b735290 100644
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
@@ -1175,6 +1177,7 @@ static void __exit emif_remove(struct platform_device *pdev)
 	struct emif_data *emif = platform_get_drvdata(pdev);
 
 	emif_debugfs_exit(emif);
+	of_node_put(emif->np_ddr);
 }
 
 static void emif_shutdown(struct platform_device *pdev)
-- 
2.53.0



