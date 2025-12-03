Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E58331355B;
	Wed,  3 Dec 2025 16:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777942; cv=none; b=hwV3tzX5HgCfHAXhax6g/PQ+GdBrYHxSrG4Thr0c6H+nM37xKjkzpeVUr8xcEo5bu/pL94OsSHLcRoyS3Hp0OaLB8YzgK4ePXbpFWkob80ylcw54hBbE5VYlQHm9Q/7XjGxvxHKHmy33mP2uLATQVWZqtjGbCvo0zKi8kFc2sQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777942; c=relaxed/simple;
	bh=0NkvnHbMiSHxeDgF2Lyw5V4VVLo5m1Ao/gpjO33dMj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtY7Bk92ZVxzFKGz58tEXDS5cwC71OBF7d1maRXRq97TFy89hYn1LghQ/jh0PdEgr24Tae/MVt8IRYfFWjINn5aSvPNZloca2/Ue5EQEtB2mTap8aOn71x80h95nYddZ5xUCzrYxtxHm+uugB36Rb0a4geJVrRa4uLHmV/bzl0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4ap9zUQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4ap9zUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEF1C116B1;
	Wed,  3 Dec 2025 16:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777942;
	bh=0NkvnHbMiSHxeDgF2Lyw5V4VVLo5m1Ao/gpjO33dMj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4ap9zUQvjnE+PagFk9p0pewlN9ooCcuBT+3MdWVAHk1psw5fTxz9Iv85sVTC+MZz
	 POZw15HBE8vdyaX6GKbsu3vnUOKlfVlYXwHoWLRU27uNGxjybgjLBD1VaL6b6IEOIy
	 d8e9HDnH7GIux7J6QpYM4fIe4orpC0PwIpocYbs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Bruno Thomsen <bruno.thomsen@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 194/392] rtc: pcf2127: clear minute/second interrupt
Date: Wed,  3 Dec 2025 16:25:44 +0100
Message-ID: <20251203152421.213681608@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit a6f1a4f05970664004a9370459c6799c1b2f2dcf ]

PCF2127 can generate interrupt every full second or minute configured
from control and status register 1, bits MI (1) and SI (0).

On interrupt control register 2 bit MSF (7) is set and must be cleared
to continue normal operation.

While the driver never enables this interrupt on its own, users or
firmware may do so - e.g. as an easy way to test the interrupt.

Add preprocessor definition for MSF bit and include it in the irq
bitmask to ensure minute and second interrupts are cleared when fired.

This fixes an issue where the rtc enters a test mode and becomes
unresponsive after a second interrupt has fired and is not cleared in
time. In this state register writes to control registers have no
effect and the interrupt line is kept asserted [1]:

[1] userspace commands to put rtc into unresponsive state:
$ i2cget -f -y 2 0x51 0x00
0x04
$ i2cset -f -y 2 0x51 0x00 0x05 # set bit 0 SI
$ i2cget -f -y 2 0x51 0x00
0x84 # bit 8 EXT_TEST set
$ i2cset -f -y 2 0x51 0x00 0x05 # try overwrite control register
$ i2cget -f -y 2 0x51 0x00
0x84 # no change

Signed-off-by: Josua Mayer <josua@solid-run.com>
Reviewed-by: Bruno Thomsen <bruno.thomsen@gmail.com>
Link: https://lore.kernel.org/r/20250825-rtc-irq-v1-1-0133319406a7@solid-run.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf2127.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf2127.c b/drivers/rtc/rtc-pcf2127.c
index 43f8011070952..f12d854d67b5e 100644
--- a/drivers/rtc/rtc-pcf2127.c
+++ b/drivers/rtc/rtc-pcf2127.c
@@ -35,6 +35,7 @@
 #define PCF2127_BIT_CTRL2_AF			BIT(4)
 #define PCF2127_BIT_CTRL2_TSF2			BIT(5)
 #define PCF2127_BIT_CTRL2_WDTF			BIT(6)
+#define PCF2127_BIT_CTRL2_MSF			BIT(7)
 /* Control register 3 */
 #define PCF2127_REG_CTRL3		0x02
 #define PCF2127_BIT_CTRL3_BLIE			BIT(0)
@@ -99,7 +100,8 @@
 #define PCF2127_CTRL2_IRQ_MASK ( \
 		PCF2127_BIT_CTRL2_AF | \
 		PCF2127_BIT_CTRL2_WDTF | \
-		PCF2127_BIT_CTRL2_TSF2)
+		PCF2127_BIT_CTRL2_TSF2 | \
+		PCF2127_BIT_CTRL2_MSF)
 
 struct pcf2127 {
 	struct rtc_device *rtc;
-- 
2.51.0



