Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B0F345CD8;
	Tue, 11 Nov 2025 01:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823636; cv=none; b=QVEkVP9luc8vkPVmy2nT13jiX+pGNa3Z9c5SsREVP6RP2AUcwvs6Su+g8+BaX96mOs+NHp+pVkZcJ1QcY4sAWF8eYFpGUyVdCumxZW0XhZz79jse3DYdr983Oew5k3nZYzNxlTO8OC7xJpyFRt2urplca4Iy5hxxvQoNpaeO7BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823636; c=relaxed/simple;
	bh=VxH1kU4/3MP6NU2h5HHDNZ608ZHfM0PYaJ3b5RPyU4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTz4S3tSo5ZEyIV9F3biS5zDhjsZrlKyJhyonorvfsDyFpBeie7nltUE2mifWxfuECp75l05qxuxM+NuyNBIOY5iI2HdcfJTNc0N+21jOD7OIQPZ0JtzMg5a57dFNASO+9lzcpVeHstLmdv/FDXM7l0S+sFRvp89TjfswJQT+ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YyUNN9gu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YyUNN9gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED807C113D0;
	Tue, 11 Nov 2025 01:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823636;
	bh=VxH1kU4/3MP6NU2h5HHDNZ608ZHfM0PYaJ3b5RPyU4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YyUNN9gu8SFQ7nwQ/3VgwJEn18zhYhJ9dhrQ6jZgpJKWKZZ8yNED/I9TCu90yWn5S
	 JKDukp9Yx9tncoyllvd/dbWoBhKKx7zUkDw5XbJCm5f3g5RozCNg8rG5HBCBXQ5fo4
	 Bz9Ytl8D5B4ke/hVxf93r0pypVafvOO77uiJOmqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 340/849] tty: serial: Modify the use of dev_err_probe()
Date: Tue, 11 Nov 2025 09:38:30 +0900
Message-ID: <20251111004544.639599594@linuxfoundation.org>
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

From: Xichao Zhao <zhao.xichao@vivo.com>

[ Upstream commit 706c3c02eecd41dc675e9102b3719661cd3e30e2 ]

The dev_err_probe() doesn't do anything when error is '-ENOMEM'.
Make the following two changes:
(1) Replace -ENOMEM with -ENOSPC in max3100_probe().
(2) Just return -ENOMEM instead in max310x_probe().

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20250819120927.607744-1-zhao.xichao@vivo.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max3100.c | 2 +-
 drivers/tty/serial/max310x.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/max3100.c b/drivers/tty/serial/max3100.c
index 67d80f8f801e9..3faa1b6aa3eed 100644
--- a/drivers/tty/serial/max3100.c
+++ b/drivers/tty/serial/max3100.c
@@ -705,7 +705,7 @@ static int max3100_probe(struct spi_device *spi)
 			break;
 	if (i == MAX_MAX3100) {
 		mutex_unlock(&max3100s_lock);
-		return dev_err_probe(dev, -ENOMEM, "too many MAX3100 chips\n");
+		return dev_err_probe(dev, -ENOSPC, "too many MAX3100 chips\n");
 	}
 
 	max3100s[i] = kzalloc(sizeof(struct max3100_port), GFP_KERNEL);
diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index d9a0100b92d2b..e8749b8629703 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1269,8 +1269,7 @@ static int max310x_probe(struct device *dev, const struct max310x_devtype *devty
 	/* Alloc port structure */
 	s = devm_kzalloc(dev, struct_size(s, p, devtype->nr), GFP_KERNEL);
 	if (!s)
-		return dev_err_probe(dev, -ENOMEM,
-				     "Error allocating port structure\n");
+		return -ENOMEM;
 
 	/* Always ask for fixed clock rate from a property. */
 	device_property_read_u32(dev, "clock-frequency", &uartclk);
-- 
2.51.0



