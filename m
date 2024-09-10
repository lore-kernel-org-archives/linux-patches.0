Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6873913AD09;
	Tue, 10 Sep 2024 09:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962002; cv=none; b=a6IctofWBPQd45jHx9QiZySbiJQzWWu5jJ1fzUJPs+8KFDx4Kb5An8gjqHYGpocnWagmKF3fKxw4eAaF3mvw+3DC4mzf0L/z6jBWiKN+QwJT74yOLCc53WuXfh+RmoKWngMI2s0ngXBve5Xv1W9qCQrAhF/Dga5uY50ra8vLy8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962002; c=relaxed/simple;
	bh=BP8nN0RgORjDB+Co5YwBc+pKtKGtfQar0Lmh0DB2xk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnqNDHbP1DL17ylvuWyqplH4Ue3MBTZh65M7kSASdpbKSfE5pMR26yn7KIe9/LT9IDFiUbt0nATtp/A4AqgxSBSVCCNBTCF5fFSFbC9z43rO4AQXx9zinBTMg3kuXZyvuhu/NYELecta+ZllyQvl7/QlnQTmXN3YJwTHcJnpu94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6yX3orp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6yX3orp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51F3C4CEC3;
	Tue, 10 Sep 2024 09:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962002;
	bh=BP8nN0RgORjDB+Co5YwBc+pKtKGtfQar0Lmh0DB2xk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6yX3orpbiTYSegjhvCYdmZVncqEu9PftT7S/xpLJ2f7MrwmqSZvtvI6sQeOEx12n
	 Ql21VQaIf/QwYcR4mcCS8kf1HmBjPmfwLl1ddD899g2mULcQLeH5j5jew7wizrh295
	 v4Y+rTUGIGFQnoHqJwUkK4yKgaapmfKkFS6b8vA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devyn Liu <liudingyuan@huawei.com>,
	Jay Fang <f.fangjian@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 262/375] spi: hisi-kunpeng: Add verification for the max_frequency provided by the firmware
Date: Tue, 10 Sep 2024 11:30:59 +0200
Message-ID: <20240910092631.359476118@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devyn Liu <liudingyuan@huawei.com>

[ Upstream commit 5127c42c77de18651aa9e8e0a3ced190103b449c ]

If the value of max_speed_hz is 0, it may cause a division by zero
error in hisi_calc_effective_speed().
The value of max_speed_hz is provided by firmware.
Firmware is generally considered as a trusted domain. However, as
division by zero errors can cause system failure, for defense measure,
the value of max_speed is validated here. So 0 is regarded as invalid
and an error code is returned.

Signed-off-by: Devyn Liu <liudingyuan@huawei.com>
Reviewed-by: Jay Fang <f.fangjian@huawei.com>
Link: https://patch.msgid.link/20240730032040.3156393-3-liudingyuan@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-hisi-kunpeng.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-hisi-kunpeng.c b/drivers/spi/spi-hisi-kunpeng.c
index 6910b4d4c427..16054695bdb0 100644
--- a/drivers/spi/spi-hisi-kunpeng.c
+++ b/drivers/spi/spi-hisi-kunpeng.c
@@ -481,6 +481,9 @@ static int hisi_spi_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	if (host->max_speed_hz == 0)
+		return dev_err_probe(dev, -EINVAL, "spi-max-frequency can't be 0\n");
+
 	ret = device_property_read_u16(dev, "num-cs",
 					&host->num_chipselect);
 	if (ret)
-- 
2.43.0



