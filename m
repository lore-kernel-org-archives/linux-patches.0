Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062151;
	b=OwRJuaoGpT3LxzeUYBrekuGWyxaIO8ylDUMKbe1b+SRfAjEF0Zck6bZac1xKhbXWVRF0
	 efhiiBPUg2ksrVYUTsQ05SusbNTnop8AIQqPQMb97B3MrChAXjNxx99KRRAKZKu34XUEq
	 DpMcilbK/oyLWyhs8sTZAI2Fpc2rwY7j6n+mpTk8M8NS9TLwdPGP7Flav0VPLIYFrpxMw
	 4OHkC641t6siuPS82YcUDto5HCwF6nOIsfQljFq4GgJbODBGDSCQNvENE/BB0VxKyvLNH
	 OZpSDJm8lb6uZ26ZhhF6PC9kfusbFuwJ1ootcQCWWkE+xoJE/E7qOB9bTCs7u+B97wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+a1/nSIJyXtSfbJah+VwRbi7lrETFCoN6w8LXpV7hyk=;
	b=cVuAVSRbePi37h/0n4FTLk6K5qIdKE7DVqne0EPGhXusOQT8TYI3XZL2ec6qp12wyI/r
	 5hdB+uxp/xT1/92lCBkhBTrcraX3UKyex4udoo+wdSlnNMGEKeLgF3DssJrf7GhPgDaG9
	 ajW9NO63mzbpDps4lXMbbnSJfgjwZILYycluLPAwJwTy6iJS/L1gXuTvdJ83PTaAPA6pG
	 ZRz/NxtWV7Kyol7whsSjZmzeK72QpSi/OGr58EyRUF1anFBZXf3PpfSFQu8mSZ+cLx9by
	 +f92WZqlpEe2zwAYjgaMR7TgblLc7xJg/KXSWfzppUJSZGaatPpuLpcpKIRRsseJCpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="X2HA/OJF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F1C606A66A;
	Sat,  7 Nov 2026 14:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2HA/OJF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7746A1F008A6;
	Sat,  7 Nov 2026 14:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062150;
	bh=+a1/nSIJyXtSfbJah+VwRbi7lrETFCoN6w8LXpV7hyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2HA/OJFiwY2KS9L0DDL4kEmlVNVOynynb6/6gdN3itYcDFR/R9Aj3LYcI+G6+8PB
	 PDFL8eVsXB+bJuCIPN7NLoWHibqoX+U07RYoJIjOuL2aG10rPfMOVYig+Ii37XFdpg
	 cwxHNwArA70p+KA3SjwnRJHiS2fL1nw+Y/qobsmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1077/1536] ASoC: wcd9335: Fix device reference leak in wcd9335_slim_status()
Date: Sat,  7 Nov 2026 08:51:33 -0500
Message-ID: <20261107135027.945080475@linuxfoundation.org>
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

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit f0cc352be29ba616e0682f66f551d3f3029886fd ]

wcd9335_slim_status() obtains the SLIM interface device with
of_slim_get_device(), which uses device_find_child() internally and
returns the device with a reference held.  As the device_find_child()
documentation says: you will need to drop the reference with
put_device() after use. The reference is stored in wcd->slim_ifc_dev
and never dropped, so the SLIM interface device cannot be released.
Fix it by using devm_add_action_or_reset() or put_device() respectively.

Found by code review.

Fixes: 20aedafdf492 ("ASoC: wcd9335: add support to wcd9335 codec")
Cc: stable@vger.kernel.org
Signed-off-by: Ma Ke <make_ruc2021@163.com>
Link: https://patch.msgid.link/20260914095009.12049-1-make_ruc2021@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 1375ac571fbf3..a1fa5957f6468 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -5095,6 +5095,13 @@ static int wcd9335_slim_probe(struct slim_device *slim)
 	return 0;
 }
 
+static void wcd9335_put_device_action(void *data)
+{
+	struct device *dev = data;
+
+	put_device(dev);
+}
+
 static int wcd9335_slim_status(struct slim_device *sdev,
 			       enum slim_device_status status)
 {
@@ -5119,6 +5126,11 @@ static int wcd9335_slim_status(struct slim_device *sdev,
 		return -EINVAL;
 	}
 
+	ret = devm_add_action_or_reset(dev, wcd9335_put_device_action,
+			&wcd->slim_ifc_dev->dev);
+	if (ret)
+		return ret;
+
 	slim_get_logical_addr(wcd->slim_ifc_dev);
 
 	wcd->regmap = regmap_init_slimbus(sdev, &wcd9335_regmap_config);
-- 
2.53.0



