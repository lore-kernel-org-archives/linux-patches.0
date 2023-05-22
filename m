Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7648E171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF44FC433EF;
	Mon, 22 May 2023 19:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784466;
	bh=jjQTqmOKNEtS/VKcrSmq1QghYJenfYvKy9UVYjhSXZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPOcNooLKya71BH6ICAEvukPPs/XRTSuhQPMiS/nSv0rBJIIAHVxjntYjuhAejMAl
	 REJ9FpG6/HfL0PUjWuaZI16rrmvKhTkQdySFPQOh5TbVyP/sksIM7orWpm3OwMqfys
	 Fu/cWpyma+AkWDgp38tHk1qctcPaILcJPpWmkvnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Hector Martin <marcan@marcan.st>,
	Julian Calaby <julian.calaby@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 092/364] wifi: brcmfmac: pcie: Provide a buffer of random bytes to the device
Date: Mon, 22 May 2023 20:06:37 +0100
Message-Id: <20230522190415.050451870@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 91918ce88d9fef408bb12c46a27c73d79b604c20 ]

Newer Apple firmwares on chipsets without a hardware RNG require the
host to provide a buffer of 256 random bytes to the device on
initialization. This buffer is present immediately before NVRAM,
suffixed by a footer containing a magic number and the buffer length.

This won't affect chips/firmwares that do not use this feature, so do it
unconditionally for all Apple platforms (those with an Apple OTP).

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230214080034.3828-3-marcan@marcan.st
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index a9b9b2dc62d4f..2835ef4edb18f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -15,6 +15,7 @@
 #include <linux/sched/signal.h>
 #include <linux/kthread.h>
 #include <linux/io.h>
+#include <linux/random.h>
 #include <asm/unaligned.h>
 
 #include <soc.h>
@@ -1653,6 +1654,13 @@ brcmf_pcie_init_share_ram_info(struct brcmf_pciedev_info *devinfo,
 	return 0;
 }
 
+struct brcmf_random_seed_footer {
+	__le32 length;
+	__le32 magic;
+};
+
+#define BRCMF_RANDOM_SEED_MAGIC		0xfeedc0de
+#define BRCMF_RANDOM_SEED_LENGTH	0x100
 
 static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 					const struct firmware *fw, void *nvram,
@@ -1689,6 +1697,30 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 			  nvram_len;
 		memcpy_toio(devinfo->tcm + address, nvram, nvram_len);
 		brcmf_fw_nvram_free(nvram);
+
+		if (devinfo->otp.valid) {
+			size_t rand_len = BRCMF_RANDOM_SEED_LENGTH;
+			struct brcmf_random_seed_footer footer = {
+				.length = cpu_to_le32(rand_len),
+				.magic = cpu_to_le32(BRCMF_RANDOM_SEED_MAGIC),
+			};
+			void *randbuf;
+
+			/* Some Apple chips/firmwares expect a buffer of random
+			 * data to be present before NVRAM
+			 */
+			brcmf_dbg(PCIE, "Download random seed\n");
+
+			address -= sizeof(footer);
+			memcpy_toio(devinfo->tcm + address, &footer,
+				    sizeof(footer));
+
+			address -= rand_len;
+			randbuf = kzalloc(rand_len, GFP_KERNEL);
+			get_random_bytes(randbuf, rand_len);
+			memcpy_toio(devinfo->tcm + address, randbuf, rand_len);
+			kfree(randbuf);
+		}
 	} else {
 		brcmf_dbg(PCIE, "No matching NVRAM file found %s\n",
 			  devinfo->nvram_name);
-- 
2.39.2



