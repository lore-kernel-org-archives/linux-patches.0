Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCEF399351;
	Sat, 12 Sep 2026 20:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243269; cv=none; b=irndZf/v//+PJwtgjp2QP4Ji0uUXi62n+QG5eXAKfAyk3smUJYtpFUMudfC4qhTWP+TUY1qL9Fhfcg4+Uluxr339DvbQy/2RkeoiCeu+CAiw/VAmvcBEweibZzNBs66iaBikoGNqifKsx7FK/YdR+Hexb/nPdmh4JDlwLGPeewo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243269; c=relaxed/simple;
	bh=kQPaCYhCt2VrM9mi4ISzKJ1J9z0DFhBO4J9bIMfWKAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUFIflRcEtQ0CugqEtRrBHs8UAgogwaYahs3Jc7UF+ROjsgxtlyxba1D6zcMcwGIKfFCMPCQ/eLx6C/LEVDjk4k9Mt4zH0MB+uMoIE3pJmfLHwn7V4Cjb4iKMUeXhdCVI2JVGb3x7tXLbla7WXCq2JH9ffJk9ADGF7a9y/KPxXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOj2wrN5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOj2wrN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFEC1F000FF;
	Sat, 12 Sep 2026 20:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243268;
	bh=33VK7ymarbkAxxkd25yu3kwwqpfllfAclS+D44UH8lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XOj2wrN5rHw9adrLOZ6VYmZpJcmL414e+PZzrmpx353HFfhENUgU9IqIkpEEdY9p7
	 aUHn6GjDJuz6CxDK7/dk1XtyFPpiECjh/yefHOZ/o4tAlk7wVN2bbalE464zzaA683
	 hp2pypomqGGFmmi9y91T6fhDMlXqtj0bo64V+lmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 653/798] iio: light: gp2ap002: re-enable irq if runtime suspend fails
Date: Sat, 12 Sep 2026 09:04:41 +0200
Message-ID: <20260912065532.079673442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil Gautam <nikhilgtr@gmail.com>

[ Upstream commit 5d89e7cbac40057f5241a0832a86ce0fe97e4818 ]

gp2ap002_runtime_suspend() disables the irq before writing OPMOD. If
the write fails, the callback returns an error with the irq still
disabled while the PM core marks the device active again.

re-enable the irq before returning the error so the irq state matches
the active state the PM core restores.

Fixes: 97d642e23037c ("iio: light: Add a driver for Sharp GP2AP002x00F")
Signed-off-by: Nikhil Gautam <nikhilgtr@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/gp2ap002.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/light/gp2ap002.c b/drivers/iio/light/gp2ap002.c
index 3d1ab38799c43..d538cac007014 100644
--- a/drivers/iio/light/gp2ap002.c
+++ b/drivers/iio/light/gp2ap002.c
@@ -659,6 +659,7 @@ static int __maybe_unused gp2ap002_runtime_suspend(struct device *dev)
 	/* Disable chip and IRQ, everything off */
 	ret = regmap_write(gp2ap002->map, GP2AP002_OPMOD, 0x00);
 	if (ret) {
+		enable_irq(gp2ap002->irq);
 		dev_err(gp2ap002->dev, "error setting up operation mode\n");
 		return ret;
 	}
-- 
2.53.0



