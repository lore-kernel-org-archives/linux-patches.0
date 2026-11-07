Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063414;
	b=puu3pfAHhvkhit4Qe386QK8RtlMbMBmoCC+nOTUx68qTeA/aK+vXo+yN1jDwjjTwuk+g
	 OJD9usgc1c7KCeelkeEAYDMFq3I/lcdhZxLooGY2t7f7nGKzRbmtonbUKgLRyUos+Ou9u
	 yN/jifxhnFbLvrADQMB49sVfEN5rWngFprFqdqcT7pnvwp5FjBNG0rxuuK0Y/QmtWIPfy
	 QmAKeSyprl353Sj/xaioRoCC/HFA9Nf2nrsIrH4q8HOgWkGzWOWbsAIzAukbkx/uUYUKO
	 8qyzVuVgGOiwca7+UuJNbkruAjOLlh6AfI7WzBTfpbzM06/OD8ahBpkFcrt2waHAYXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tpbCCPx5PPzskpo1MFvp3MFScU2WqoI0UHu2JlM6p6w=;
	b=tuZZn6in9TMEAJY8A8eunawo+YTWEWIdJ1efsnr8h5q3t8zQzV07pVm0dStYfxzJjdzk
	 eP9I5rDVr4sJ/dCsANcIGO1B9svOjarc13Hn2q/afL6iwNYx25W1k0s/rZ0lOJ7MMBXL7
	 enudi7LcS/vny+aRx0/vRWbzDl044Egs0WNEPJmWch6Q27vkdf4+NVVhiCanLJr/M/UNz
	 1lMh8/0mVkXaEWcI+G1cA/aciP2o/ZMIEGE0Y6kmDzDQr3uzAp3PELPQIICsnqArIz9tl
	 MJJBOf7Yr9pacbzUpIPKaOgDX9Z2TRR5B5oa7grx51onSs/0dJ88hE1eahK/g7L6jWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e6tK6HOk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B972606A336;
	Sat,  7 Nov 2026 14:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e6tK6HOk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85411F0089F;
	Sat,  7 Nov 2026 14:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063414;
	bh=tpbCCPx5PPzskpo1MFvp3MFScU2WqoI0UHu2JlM6p6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e6tK6HOk9TXWtY1d1Wz/Ous7IUxl8bYA5MMWdOn0Nj7wkFqQC4RWDjPv2OOixU2mv
	 B0ne4qzywf/Cy8iwdGdVyuMSH/+ZoIik/m+s7j6OJHi5qM7Iw5bvh553tOr1B8RUOj
	 MCabJ1ZCYyA8Y2NygTXdiLPHydXcXi30rPBuvJ/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 582/869] spi: jcore: fix divide-by-zero when speed_hz is zero
Date: Sat,  7 Nov 2026 08:54:24 -0500
Message-ID: <20261107134912.905418909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weibin Liu <liuwb@xiaopeng.com>

[ Upstream commit 7db773075501248893c22b11bedc6745d6d0be45 ]

jcore_spi_baudrate() computes hw->clock_freq / 2 / speed without
validating speed. The SPI core fills transfer.speed_hz from
spi->max_speed_hz when it is zero, and jcore_spi_probe() never sets
host->max_speed_hz, so the clamp in __spi_setup() is skipped. A
spi_device created via the sysfs new_device interface (or a DT node
without spi-max-frequency) therefore has max_speed_hz == 0, and any
SPI_IOC_MESSAGE transfer reaches jcore_spi_baudrate() with speed == 0,
causing a division by zero and a kernel panic.

Clamp speed to a minimum of 1 Hz before the division so the divisor is
never zero. The computed divider then truncates to the register field
width and the transfer simply runs at the slowest supported rate.

Verified by inspection of the __spi_setup() clamp and
__spi_validate()'s speed_hz handling; the division-by-zero path
requires the J-Core controller, which was not available.

Reviewed-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Fixes: 2cb1b3b3ac0a ("spi: add driver for J-Core SPI controller")
Cc: stable@vger.kernel.org # 4.9+
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20261014-spi-jcore-divzero-v1-1-a8205d30f2d1@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-jcore.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-jcore.c b/drivers/spi/spi-jcore.c
index e37ca22e04ba6..2bde899eb2b49 100644
--- a/drivers/spi/spi-jcore.c
+++ b/drivers/spi/spi-jcore.c
@@ -84,6 +84,8 @@ static void jcore_spi_baudrate(struct jcore_spi *hw, int speed)
 {
 	if (speed == hw->speed_hz)
 		return;
+	if (speed <= 0)
+		speed = 1;
 	hw->speed_hz = speed;
 	if (speed >= hw->clock_freq / 2)
 		hw->speed_reg = 0;
-- 
2.53.0



