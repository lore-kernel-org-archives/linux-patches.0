Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB1827D786;
	Tue, 11 Nov 2025 01:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824851; cv=none; b=OnIT8tnSFZTJRab8WZQSFdPvUPHfzlkuSycWv0zIjyYTJB1TeXolxvyA2in8N/o0DQj5zUFZdG1ltHbHQqhRDr5xckiIS+OxYe0XNI096FHRQTSGStcv/gzSiyER/NghmHrRdVx5pBQHl0KmfxkZ/I9MZ3U1ncsKCcyIiyarGKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824851; c=relaxed/simple;
	bh=Xkr3204OYgsOvX83T1ScuoqdqAe+59kpa0Nmi5iSQOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmzSSQmrtVK00h7Z4XC31kjWHbAttqx9HPSDzEWvLMP654CSXY0LhWp4w4j+HyqxSp8rVcJiVQ+CQEXjKxkLDgMDl95FWbqEuowbXIH2cBdfHjPurKSlGT75RxhsWjiSTvnP3dKv5wmm95hNzN9BMAlnwsMhBiycsMCunOYPbbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMyMM913; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMyMM913"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33A9C116D0;
	Tue, 11 Nov 2025 01:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824851;
	bh=Xkr3204OYgsOvX83T1ScuoqdqAe+59kpa0Nmi5iSQOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMyMM913kkUwY5tV6UV5YAf9yoMJlYdxe26edbuAi7SDDO/ltjA3LRt/q0v+UiqrV
	 Le71k0y9AufoVkFb6kXV8/7cos1AgnbVYOvb3VgRbRGkvbTxXwUyf1YBYv2RwKCbrt
	 tSAVw4yMSgJEiogj+0eXEExGWmmoHtibPinfG8mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 537/565] net: wan: framer: pef2256: Switch to devm_mfd_add_devices()
Date: Tue, 11 Nov 2025 09:46:33 +0900
Message-ID: <20251111004539.053242725@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 413a3c1d15bbe..dc6466542e2c0 100644
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



