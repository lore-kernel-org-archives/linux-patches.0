Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FBF2FFDF5;
	Tue, 11 Nov 2025 01:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825421; cv=none; b=fm4yHwYHiwQGmwirin0ByY6T7/DVZBYsm8sVs+5kr1xL7FX8idM0xrK+pXgd5boFUAUVCdPP/L+DPccXBOdjecQ3m6uMUJ8AadBSfiHLHR6a53iwZjaRBhWAFcuxVYazB2m3FAcBen0LGbI8RW/yuyMTG413CFH6o5bgSop2OhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825421; c=relaxed/simple;
	bh=BOJ1z+xTlrisEcOMg26FT0XI4XxywW5j1QR5pNIXk1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kW1U7WhZpy9oTqi+UVxAYQiz9pIXf7dT9Nl4NGjFwAlQxSi8UwB3aSquS4eruM40LXqwBetL34b08te6UnfKZo02FmRGVAxaG1cYEQfWs/DaPBypGsdquKx3Cinq0F059ifKEmrjm4JBXO0t8CZl7oZMIhAbBlzvNgdMR2wsyYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDYJnhZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDYJnhZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B29EC4CEF5;
	Tue, 11 Nov 2025 01:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825421;
	bh=BOJ1z+xTlrisEcOMg26FT0XI4XxywW5j1QR5pNIXk1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDYJnhZjMme2W9bh0wQW8XIQS+B9JDamVMEv9FwOoAwyo3dOmEcs6Rf7q+hWIYnpR
	 qvN4TU9Mc82orU59UxS2pKuAnKOnfpALRIW8yZpuhmiUPYG1NQFOwbanYBU7vGn7ny
	 hPCQEBTzp/7I2//KSBgFD/5bpwo4WkIk0ErE1s30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 794/849] net: wan: framer: pef2256: Switch to devm_mfd_add_devices()
Date: Tue, 11 Nov 2025 09:46:04 +0900
Message-ID: <20251111004555.628457518@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 4d6ec3a7932ca5b168426f7b5b40abab2b41d2da ]

The driver calls mfd_add_devices() but fails to call mfd_remove_devices()
in error paths after successful MFD device registration and in the remove
function. This leads to resource leaks where MFD child devices are not
properly unregistered.

Replace mfd_add_devices with devm_mfd_add_devices to automatically
manage the device resources.

Fixes: c96e976d9a05 ("net: wan: framer: Add support for the Lantiq PEF2256 framer")
Suggested-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Acked-by: Herve Codina <herve.codina@bootlin.com>
Link: https://patch.msgid.link/20251105034716.662-1-vulab@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/framer/pef2256/pef2256.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/framer/pef2256/pef2256.c b/drivers/net/wan/framer/pef2256/pef2256.c
index 1e4c8e85d598d..395ac986f4ab2 100644
--- a/drivers/net/wan/framer/pef2256/pef2256.c
+++ b/drivers/net/wan/framer/pef2256/pef2256.c
@@ -637,7 +637,8 @@ static int pef2256_add_audio_devices(struct pef2256 *pef2256)
 		audio_devs[i].id = i;
 	}
 
-	ret = mfd_add_devices(pef2256->dev, 0, audio_devs, count, NULL, 0, NULL);
+	ret = devm_mfd_add_devices(pef2256->dev, 0, audio_devs, count,
+				   NULL, 0, NULL);
 	kfree(audio_devs);
 	return ret;
 }
@@ -812,8 +813,8 @@ static int pef2256_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, pef2256);
 
-	ret = mfd_add_devices(pef2256->dev, 0, pef2256_devs,
-			      ARRAY_SIZE(pef2256_devs), NULL, 0, NULL);
+	ret = devm_mfd_add_devices(pef2256->dev, 0, pef2256_devs,
+				   ARRAY_SIZE(pef2256_devs), NULL, 0, NULL);
 	if (ret) {
 		dev_err(pef2256->dev, "add devices failed (%d)\n", ret);
 		return ret;
-- 
2.51.0



