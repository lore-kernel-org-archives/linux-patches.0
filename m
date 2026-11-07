Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062113;
	b=EGsK1KHfAR2FA9+iYpheiHAxJFHiC84dctISI/MFdutZvkvHe6gA7tJVWwiF8z4BQEs+
	 IhpejqhkDYte8+t4l12xVElOF00C6DbY2xE8E+wnd/AlgErahIp/j1HHy/6mHpyqTaToQ
	 TWxaQKZWKrAX5nqtDFMBnw7LBxBLh/5wi0frXx6xVO95uD/wSc2jdGVfmNiHG/nGmeOEr
	 rqvdMh3JMgeNiLkNjArCOLeUUxIqX313z3MXe2ecbqACm6ppriC4F1WAY8diQ8U+ICtS8
	 Dbo4zYfbj23rkqpdhxgjGXGOgw6nqz152Cl9GKGfn6foKgSmX+bxUSuLiaj6XddhJ8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZgoSsom4TQbqXTQqhEnC7gPwYomG2wmaFATASiV/LUk=;
	b=zYAHy00MV8dsHWDaOnTS1aGhfGgFvZIbua+ia0UuTyIod5lbN9o6Vj0Zk2vZkKPp8/D+
	 WR05iia8pUj9jeFDcNl1v5tEKfnXS6n0tAMa3WYNB8TzVUS890bE3DPPkW7jK5/64dVex
	 HknqXE+R+zqabema257nUj9ZPLo2ttAl5Ghaxu0NKfuGXlFXXN+v+c4R0AR02UWaXgqZv
	 aqtNCnwxeoNp31WmasanZsTHa8+tU2Dm0xkmxBbRvI6EqXfAxm0AbA4EdAScHq7PWGO1i
	 xOYjs3XM1WpdwxtOvv/uXijuG8NVa0jpnzzSSPeHEIOrUQjP/W3F21wYxkKa517CfDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CCPqErqT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A3D60A5BC3;
	Sat,  7 Nov 2026 14:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CCPqErqT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0933E1F0089F;
	Sat,  7 Nov 2026 14:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062113;
	bh=ZgoSsom4TQbqXTQqhEnC7gPwYomG2wmaFATASiV/LUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCPqErqTbYSW/nXor6JHyZNF67xJfNaILuC3aoE7ja4Ly4PStJyaSzRUES+T3eE2M
	 ZABmednYwc4Oj6GaziqANYMEx2oSr2EUuZeAOhJvIr/vBYoaH9JX9Hg1MV7/i748sb
	 evNweM8pqj2Q7blgwpYbEL9U5crskZ6Bw68rVbf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1085/1536] ASoC: codecs: wcd9335: Fix SLIM interface device leak in wcd9335_slim_status()
Date: Sat,  7 Nov 2026 08:51:41 -0500
Message-ID: <20261107135028.172311119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 082723fee626532f176727b6438b666a96d5246c ]

of_slim_get_device() returns a device with an elevated reference count,
and wcd->slim_ifc_dev is intentionally kept for the codec lifetime on
success. However, all the failure paths of wcd9335_slim_status() return
without dropping that reference, leaking the SLIM interface device
whenever the register maps cannot be created or the codec fails to come
up.

Put the device on each of those error paths.

Fixes: 20aedafdf492 ("ASoC: wcd9335: add support to wcd9335 codec")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917164853.2163184-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index a1fa5957f6468..6b20a426e87aa 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -5134,25 +5134,32 @@ static int wcd9335_slim_status(struct slim_device *sdev,
 	slim_get_logical_addr(wcd->slim_ifc_dev);
 
 	wcd->regmap = regmap_init_slimbus(sdev, &wcd9335_regmap_config);
-	if (IS_ERR(wcd->regmap))
+	if (IS_ERR(wcd->regmap)) {
+		put_device(&wcd->slim_ifc_dev->dev);
 		return dev_err_probe(dev, PTR_ERR(wcd->regmap),
 				     "Failed to allocate slim register map\n");
+	}
 
 	wcd->if_regmap = regmap_init_slimbus(wcd->slim_ifc_dev,
 						  &wcd9335_ifc_regmap_config);
-	if (IS_ERR(wcd->if_regmap))
+	if (IS_ERR(wcd->if_regmap)) {
+		put_device(&wcd->slim_ifc_dev->dev);
 		return dev_err_probe(dev, PTR_ERR(wcd->if_regmap),
 				     "Failed to allocate ifc register map\n");
+	}
 
 	ret = wcd9335_bring_up(wcd);
 	if (ret) {
 		dev_err(dev, "Failed to bringup WCD9335\n");
+		put_device(&wcd->slim_ifc_dev->dev);
 		return ret;
 	}
 
 	ret = wcd9335_irq_init(wcd);
-	if (ret)
+	if (ret) {
+		put_device(&wcd->slim_ifc_dev->dev);
 		return ret;
+	}
 
 	wcd9335_probe(wcd);
 
-- 
2.53.0



